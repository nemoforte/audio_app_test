import 'package:audio_app_test/cubit/settings_tab_cubit/settings_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';

class SettingsTabCubit extends Cubit<SettingsTabState> {
  final TextEditingController firstFrequencyController = TextEditingController();
  final TextEditingController baseFrequencyGapController = TextEditingController();
  final TextEditingController bitsPerFrequencyController = TextEditingController();
  final TextEditingController subbandCountController = TextEditingController();

  late AudioSettingsModel actualAudioSettingsModel;

  SettingsTabCubit() : super(const SettingsTabState(valuesChangedBool: false)) {
    firstFrequencyController.addListener(_handleTextFieldUpdated);
    baseFrequencyGapController.addListener(_handleTextFieldUpdated);
    bitsPerFrequencyController.addListener(_handleTextFieldUpdated);
    subbandCountController.addListener(_handleTextFieldUpdated);

    resetToDefaults();
  }

  void resetToDefaults() {
    actualAudioSettingsModel = AudioSettingsModel();

    firstFrequencyController.text = actualAudioSettingsModel.firstFrequency.toString();
    bitsPerFrequencyController.text = actualAudioSettingsModel.bitsPerFrequency.toString();
    subbandCountController.text = actualAudioSettingsModel.subbandCount.toString();
  }

  void updateInitialValuesAfterSave() {
    actualAudioSettingsModel = getCurrentAudioSettingsModel();
    emit(const SettingsTabState(valuesChangedBool: false));
  }

  AudioSettingsModel getCurrentAudioSettingsModel() {
    return AudioSettingsModel(
      firstFrequency: 0,
      bitsPerFrequency: int.tryParse(bitsPerFrequencyController.text) ?? 0,
      subbandCount: int.tryParse(subbandCountController.text) ?? 0,
    );
  }

  void _handleTextFieldUpdated() {
    emit(SettingsTabState(valuesChangedBool: _isValueChanged()));
  }

  bool _isValueChanged() {
    AudioSettingsModel currentSettingsModel = getCurrentAudioSettingsModel();
    return currentSettingsModel != actualAudioSettingsModel;
  }
}
