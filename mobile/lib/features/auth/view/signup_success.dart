import 'dart:io';

import 'package:finder/features/auth/view_model/signup_success_vm.dart';
import 'package:finder/features/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadyProfileScreen extends StatelessWidget {
  const ReadyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF22C55E);
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider<SignupSuccessVM>(
      create: (_) => SignupSuccessVM(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: accent, size: 32),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Everything is Ready!',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Would you like to upload a profile image?',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Selector<SignupSuccessVM, String?>(
                    selector: (_, vm) => vm.selectedImage?.path,
                    builder: (context, imagePath, __) {
                      return CircleAvatar(
                        radius: 68,
                        backgroundColor: const Color(0xFFF2F4F7),
                        backgroundImage:
                            imagePath != null ? FileImage(File(imagePath)) : null,
                        child: imagePath == null
                            ? const Icon(
                                Icons.person,
                                size: 56,
                                color: Colors.black26,
                              )
                            : null,
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  Consumer<SignupSuccessVM>(
                    builder: (context, vm, __) {
                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            foregroundColor: Colors.black87,
                          ),
                          onPressed: vm.isUploading ? null : () => vm.pickImage(),
                          icon: const Icon(Icons.upload_rounded, size: 20),
                          label: Text(
                            vm.selectedImage == null
                                ? 'Choose Photo'
                                : 'Choose Another Photo',
                          ),
                        ),
                      );
                    },
                  ),
                  Selector<SignupSuccessVM, bool>(
                    selector: (_, vm) => vm.selectedImage != null,
                    builder: (context, hasImage, __) {
                      if (!hasImage) return const SizedBox.shrink();
                      return Column(
                        children: [
                          const SizedBox(height: 12),
                          Consumer<SignupSuccessVM>(
                            builder: (context, vm, __) {
                              return SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: vm.isUploading ? null : () => vm.uploadImage(),
                                  child: vm.isUploading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('Upload Photo'),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Consumer<SignupSuccessVM>(
                    builder: (context, vm, __) {
                      return TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black54,
                        ),
                        onPressed: vm.isUploading
                            ? null
                            : () {
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return HomePage();
                                }));
                              },
                        child: const Text('Skip for now'),
                      );
                    },
                  ),
                  Consumer<SignupSuccessVM>(
                    builder: (context, vm, __) {
                      if (vm.errorMessage != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(vm.errorMessage!)),
                          );
                          vm.clearError();
                        });
                      }
                      if (vm.uploadSuccess) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {

                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return HomePage();
                          }));
                          vm.clearSuccess();
                        });
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

