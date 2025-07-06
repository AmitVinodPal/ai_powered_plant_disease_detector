import 'dart:io';
import 'package:equatable/equatable.dart';

class ImageState extends Equatable {
  final File? imageFile;
  final bool isLoading;
  final String? result;
  final String? error;

  const ImageState({
    this.imageFile,
    this.isLoading = false,
    this.result,
    this.error,
  });

  ImageState copyWith({
    File? imageFile,
    bool? isLoading,
    String? result,
    String? error,
    bool clearImage = false,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return ImageState(
      imageFile: clearImage ? null : imageFile ?? this.imageFile,
      isLoading: isLoading ?? this.isLoading,
      result: clearResult ? null : result ?? this.result,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [imageFile, isLoading, result, error];
}
