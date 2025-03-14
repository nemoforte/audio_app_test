import 'package:audio_app_test/cubit/receive_tab_cubit/a_receive_tab_state.dart';
import 'package:audio_app_test/cubit/receive_tab_cubit/states/receive_tab_empty_state.dart';
import 'package:audio_app_test/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:audio_app_test/cubit/receive_tab_cubit/states/receive_tab_result_state.dart';
import 'package:audio_app_test/shared/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';
import 'package:permission_handler/permission_handler.dart';

class ReceiveTabCubit extends Cubit<AReceiveTabState> {
  final ValueNotifier<String> consoleNotifier = ValueNotifier<String>('');
  late AudioSettingsModel audioSettingsModel = AudioSettingsModel();
  late AudioDecoder _audioDecoder;
  bool _transferIssueBool = false;

  ReceiveTabCubit() : super(AudioRecordingEmptyState()) {
    _requestMicPermission();
  }

  void startRecording() {
    _transferIssueBool = false;
    try {
      _audioDecoder = AudioDecoder(
        audioSettingsModel: audioSettingsModel,
        onRecordingCompleted: _handleRecordingCompleted,
        onMetadataFrameReceived: _handleMetadataFrameReceived,
        onDataFrameReceived: _handleDataFrameReceived,
      );
      emit(ReceiveTabRecordingState(
        decodedMessageParts: const <String>[],
        brokenMessageIndexes: const <int>[],
      ));
      consoleNotifier.value = '';
      _audioDecoder.startRecording();
    } catch (e) {
      AppLogger().log(message: 'Cannot start recording: $e');
      emit(AudioRecordingEmptyState());
    }
  }

  void stopRecording() {
    _audioDecoder.stopRecording();
    emit(AudioRecordingEmptyState());
  }

  Future<void> _requestMicPermission() async {
    Permission micPermission = Permission.microphone;
    if (await micPermission.isGranted == false) {
      PermissionStatus permissionStatus = await micPermission.request();
      assert(permissionStatus.isGranted, 'Permission ${micPermission.toString()} must be granted to use application');
    }
  }

  void _handleRecordingCompleted(FrameCollectionModel frameCollectionModel) {
    if (_transferIssueBool) {
      emit(ReceiveTabResultState(
          decodedMessageParts: const <String>['TRANSFER FAILED!', '\nPlease reduce the environment noise or use different transfer parameters.'],
          brokenMessageIndexes: const <int>[]));
    } else {
      List<String> decodedParts = frameCollectionModel.getMessageParts();
      emit(ReceiveTabResultState(
        decodedMessageParts: decodedParts,
        brokenMessageIndexes: frameCollectionModel.getBrokenDataFrameIndexes(),
      ));
    }
  }

  void _handleMetadataFrameReceived(MetadataFrameModel metadataFrameModel) {
    if (metadataFrameModel.isChecksumCorrect() == false) {
      _handleBrokenMetadataFrame();
    } else {
      consoleNotifier.value += 'MetadataFrameModel: total frames: ${metadataFrameModel.dataFramesCount}\n';
    }
  }

  void _handleBrokenMetadataFrame() {
    _transferIssueBool = true;
    stopRecording();
  }

  void _handleDataFrameReceived(DataFrameModel dataFrameModel) {
    consoleNotifier.value += '\nDataFrameModel (${dataFrameModel.frameIndex}): ${dataFrameModel.data}\n';
  }
}
