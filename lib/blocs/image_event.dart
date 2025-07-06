

import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object?> get props => [];
}

class PickImageEvent extends ImageEvent {
  final File imageFile;
  const PickImageEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

// ADD THIS NEW EVENT
class ClearImageEvent extends ImageEvent {}
