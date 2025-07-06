import 'dart:io';
import 'package:ai_powered_plant_disease_detector/blocs/image_bloc.dart';
import 'package:ai_powered_plant_disease_detector/blocs/image_event.dart';
import 'package:ai_powered_plant_disease_detector/blocs/image_state.dart';
import 'package:ai_powered_plant_disease_detector/services/ai_service.dart';
import 'package:ai_powered_plant_disease_detector/widgets/image_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      context.read<ImageBloc>().add(PickImageEvent(file));
    }
  }

  @override
  Widget build(BuildContext context) {
    // It's often better to provide Blocs higher up the widget tree,
    // but for a single screen app, this is fine.
    return BlocProvider(
      create: (_) => ImageBloc(aiService: AIService()),
      child: BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Plant Disease Detector"),
              centerTitle: true,
              actions: [
                // Show a reset button only if an image has been picked
                if (state.imageFile != null)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () =>
                        context.read<ImageBloc>().add(ClearImageEvent()),
                    tooltip: 'Start Over',
                  ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Image Display Area ---
                    ImageDisplay(imageFile: state.imageFile),
                    const SizedBox(height: 24),

                    // --- Analysis Results Area ---
                    _buildAnalysisSection(context, state),
                    const SizedBox(height: 32),

                    // --- Action Buttons Area ---
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalysisSection(BuildContext context, ImageState state) {
    // AnimatedSwitcher provides a smooth transition between states
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: state.isLoading
          ? _buildLoadingIndicator()
          : state.error != null
              ? _buildErrorWidget(state.error!)
              : state.result != null
                  ? _buildResultCard(state.result!,context)
                  : const SizedBox.shrink(),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Column(
      key: ValueKey('loading'),
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text(
          'Analyzing image...',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    return Card(
      key: const ValueKey('error'),
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 40),
            const SizedBox(height: 8),
            const Text(
              'An Error Occurred',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String result, BuildContext context) {
    return Card(
      key: const ValueKey('result'),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analysis Result:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              result,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () => _pickImage(context, ImageSource.camera),
          icon: const Icon(Icons.camera_alt),
          label: const Text("Take a Photo"),
          style: buttonStyle,
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _pickImage(context, ImageSource.gallery),
          icon: const Icon(Icons.image),
          label: const Text("Choose from Gallery"),
          style: buttonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(Colors.green[600]),
          ),
        ),
      ],
    );
  }
}