import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

typedef TokenPair = ({String accessToken, String refreshToken});

class RevokeTokenException extends DioException {
  RevokeTokenException({required super.requestOptions});
}

class AuthInterceptor extends QueuedInterceptor {
  /// Create an Auth interceptor
  AuthInterceptor({
    required this.dio,
    required this.secureStorage,
    this.shouldClearBeforeReset = true,
  }) {
    refreshClient = Dio();
    refreshClient.options = BaseOptions(baseUrl: dio.options.baseUrl);

    retryClient = Dio();
    retryClient.options = BaseOptions(baseUrl: dio.options.baseUrl);
  }

  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final bool shouldClearBeforeReset;
  late final Dio refreshClient;
  late final Dio retryClient;

  Future<String?> get _accessToken => secureStorage.read(key: 'accessToken');

  Future<String?> get _refreshToken => secureStorage.read(key: 'refreshToken');

  Future<TokenPair?> _getTokenPair() async {
    final accessToken = await _accessToken;
    final refreshToken = await _refreshToken;

    if (accessToken != null && refreshToken != null) {
      return (accessToken: accessToken, refreshToken: refreshToken);
    }
    return null;
  }

  Future<void> _saveTokenPair(TokenPair tokenPair) async {
    await secureStorage.write(key: 'accessToken', value: tokenPair.accessToken);
    await secureStorage.write(
      key: 'refreshToken',
      value: tokenPair.refreshToken,
    );
  }

  Future<void> _clearTokenPair() async {
    await secureStorage.delete(key: 'accessToken');
    await secureStorage.delete(key: 'refreshToken');
  }

  Future<Map<String, dynamic>> _buildHeaders() async {
    final tokenPair = await _getTokenPair();

    return {'Authorization': 'Bearer ${tokenPair!.accessToken}'};
  }

  /// Check if the token pair should be refreshed
  @visibleForTesting
  @pragma('vm:prefer-inline')
  bool shouldRefresh<R>(Response<R>? response) => response?.statusCode == 401;

  Future<bool> get _isAccessTokenValid async {
    final tokenPair = await _getTokenPair();

    if (tokenPair == null) {
      return false;
    }

    final decodedJwt = JWT.decode(tokenPair.accessToken);
    final expirationTimeEpoch = decodedJwt.payload['exp'];
    final expirationDateTime = DateTime.fromMillisecondsSinceEpoch(
      expirationTimeEpoch * 1000,
    );

    final marginOfErrorInMilliseconds = 1000; // appr 1 seconds
    final addedMarginTime = Duration(milliseconds: marginOfErrorInMilliseconds);

    return DateTime.now().add(addedMarginTime).isBefore(expirationDateTime);
  }

  Future<TokenPair?> _refresh({
    required RequestOptions options,
    TokenPair? tokenPair,
  }) async {
    if (tokenPair == null) {
      throw RevokeTokenException(requestOptions: options);
    }

    try {
      refreshClient.options = refreshClient.options.copyWith(
        headers: {'refresh-Token': tokenPair.refreshToken},
      );

      /// it will be changed based on your project
      final response = await refreshClient.post(
        '/endpoint-to-send-refresh-request',
      );

      final TokenPair newTokenPair = (
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );

      if (shouldClearBeforeReset) {
        await _clearTokenPair();
      }

      await _saveTokenPair(newTokenPair);
      return newTokenPair;
    } catch (_) {
      await _clearTokenPair();
      throw RevokeTokenException(requestOptions: options);
    }
  }

  Future<Response<R>> _retry<R>(RequestOptions requestOptions) async {
    return retryClient.request<R>(
      requestOptions.path,
      cancelToken: requestOptions.cancelToken,
      data: requestOptions.data is FormData
          ? (requestOptions.data as FormData).clone()
          : requestOptions.data,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: requestOptions.extra,
        headers: requestOptions.headers..addAll(await _buildHeaders()),
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        validateStatus: requestOptions.validateStatus,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        followRedirects: requestOptions.followRedirects,
        maxRedirects: requestOptions.maxRedirects,
        requestEncoder: requestOptions.requestEncoder,
        responseDecoder: requestOptions.responseDecoder,
        listFormat: requestOptions.listFormat,
      ),
    );
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final tokenPair = await _getTokenPair();

      if (tokenPair == null) {
        return handler.next(options);
      }

      final isAccessTokenValid = await _isAccessTokenValid;

      if (isAccessTokenValid) {
        options.headers.addAll(await _buildHeaders());
        return handler.next(options);
      } else {
        final newTokenPair = await _refresh(
          options: options,
          tokenPair: tokenPair,
        );

        if (newTokenPair == null) {
          return handler.reject(
            RevokeTokenException(requestOptions: options),
            true,
          );
        }

        options.headers.addAll(await _buildHeaders());
        return handler.next(options);
      }
    } catch (_) {
      return handler.reject(
        RevokeTokenException(requestOptions: options),
        true,
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err is RevokeTokenException) {
      /// call the session expire logic for your state management
      return handler.reject(err);
    }

    if (!shouldRefresh(err.response)) {
      return handler.next(err);
    }

    final isAccessValid = await _isAccessTokenValid;
    final tokenPair = await _getTokenPair();

    if (tokenPair == null) {
      return handler.reject(err);
    }

    try {
      if (isAccessValid) {
        final previousRequest = await _retry(err.requestOptions);
        return handler.resolve(previousRequest);
      } else {
        await _refresh(options: err.requestOptions, tokenPair: tokenPair);
        final previousRequest = await _retry(err.requestOptions);
        return handler.resolve(previousRequest);
      }
    } on RevokeTokenException {
      /// call the session expire logic for your state management
      return handler.reject(err);
    } on DioException catch (err) {
      return handler.next(err);
    }
  }
}
