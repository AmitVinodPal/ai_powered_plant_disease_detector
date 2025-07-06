import 'package:ai_powered_plant_disease_detector/blocs/image_event.dart';
import 'package:ai_powered_plant_disease_detector/blocs/image_state.dart';
import 'package:ai_powered_plant_disease_detector/services/ai_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final AIService aiService;

  ImageBloc({required this.aiService}) : super(const ImageState()) {
    on<PickImageEvent>(_onPickImage);
    on<ClearImageEvent>(_onClearImage); // HANDLE THE NEW EVENT
  }

  Future<void> _onPickImage(
      PickImageEvent event, Emitter<ImageState> emit) async {
    // Set loading state
    emit(state.copyWith(
      imageFile: event.imageFile,
      isLoading: true,
      clearResult: true, // Clear previous results
      clearError: true,
    ));

    try {
      // Simulate AI processing
      final result = await aiService.predictDisease(event.imageFile);
      emit(state.copyWith(isLoading: false, result: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // ADD THIS HANDLER
  void _onClearImage(ClearImageEvent event, Emitter<ImageState> emit) {
    // Reset to the initial state
    emit(const ImageState());
  }
}