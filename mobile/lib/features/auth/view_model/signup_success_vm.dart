import 'package:finder/core/logging/logger.dart';
import 'package:finder/features/auth/model/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupSuccessVM extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  final AuthRepository _authRepository = AuthRepository();

  XFile? _selectedImage;
  bool _isUploading = false;
  String? _errorMessage;
  bool _uploadSuccess = false;

  XFile? get selectedImage => _selectedImage;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;
  bool get uploadSuccess => _uploadSuccess;

  Future<void> pickImage() async {
    try {
      _errorMessage = null;
      notifyListeners();

      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;

      _selectedImage = picked;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      Logger.log("Error picking image: $e");
      _errorMessage = 'Unable to pick photo: $e';
      notifyListeners();
    }
  }

  Future<void> uploadImage() async {
    if (_selectedImage == null) {
      await pickImage();
      if (_selectedImage == null) return;
    }

    _isUploading = true;
    _errorMessage = null;
    _uploadSuccess = false;
    notifyListeners();

    try {
      await _authRepository.uploadImg(filePath: _selectedImage!.path);
      _uploadSuccess = true;
      _errorMessage = null;
    } catch (e) {
      Logger.log("Error uploading image: $e");
      _errorMessage = 'Upload failed: $e';
      _uploadSuccess = false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSuccess() {
    _uploadSuccess = false;
    notifyListeners();
  }
}

