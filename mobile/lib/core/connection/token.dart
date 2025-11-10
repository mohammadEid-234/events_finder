import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:finder/core/logging/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
typedef TokenPair = ({String accessToken, String refreshToken});

class TokenManager{
  static final TokenManager _instance = TokenManager._internal();
  late final FlutterSecureStorage secureStorage;
  static TokenManager get  instance => _instance;

  Future<bool> get isAccessTokenValid async {
    final tokenPair = await getTokenPair();

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

  Future<void> clearTokenPair()async{
    try{
      await secureStorage.delete(key: 'accessToken');
      await secureStorage.delete(key: 'refreshToken');
    }catch(e){
      Logger.log("error while clearing token pair: $e");
    }

  }

  Future<void> saveTokenPair(TokenPair tokenPair)async{
    try{
      await secureStorage.write(key: 'accessToken', value: tokenPair.accessToken);
      await secureStorage.write(key: 'refreshToken', value: tokenPair.refreshToken);
    }catch(e){
      Logger.log("error while saving token pair: $e");

    }

  }
  Future<TokenPair?> getTokenPair() async{
    try{
      final access = await secureStorage.read(key: 'accessToken');
      final refresh = await secureStorage.read(key: 'refreshToken',);
      if(access!=null && refresh!=null){
        return (refreshToken: refresh,accessToken: access);
      }
      return null;
    }catch(e){
      Logger.log("error while fetching token pair: $e");
      return null;
    }

  }
  TokenManager._internal(){
    secureStorage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  }

}