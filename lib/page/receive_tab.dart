import 'package:audio_app_test/cubit/receive_tab_cubit/a_receive_tab_state.dart';
import 'package:audio_app_test/cubit/receive_tab_cubit/receive_tab_cubit.dart';
import 'package:audio_app_test/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:audio_app_test/cubit/receive_tab_cubit/states/receive_tab_result_state.dart';
import 'package:audio_app_test/widgets/decoded_message_field.dart';
import 'package:audio_app_test/widgets/settings_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiveTab extends StatefulWidget {
  final ReceiveTabCubit receiveTabCubit;

  const ReceiveTab({required this.receiveTabCubit, super.key});

  @override
  State<StatefulWidget> createState() => _ReceiveTabState();
}

class _ReceiveTabState extends State<ReceiveTab> {
  final ScrollController _scrollController = ScrollController();
  bool _scrolledBottomBool = true;

  @override
  void initState() {
    super.initState();
    widget.receiveTabCubit.consoleNotifier.addListener(_scrollToBottom);
    _scrollController.addListener(_handleUserScroll);
  }

  @override
  void dispose() {
    widget.receiveTabCubit.consoleNotifier.removeListener(_scrollToBottom);
    _scrollController
      ..removeListener(_handleUserScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<ReceiveTabCubit, AReceiveTabState>(
        bloc: widget.receiveTabCubit,
        builder: (BuildContext context, AReceiveTabState state) {
          bool recordingInProgressBool = state is ReceiveTabRecordingState;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: recordingInProgressBool ? null : widget.receiveTabCubit.startRecording,
                        child: const Text('Start recording'),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: recordingInProgressBool ? widget.receiveTabCubit.stopRecording : null,
                        child: const Text('Stop recording'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (state is ReceiveTabResultState)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DecodedMessageField(
                      decodedMessageParts: state.decodedMessageParts,
                      brokenMessageIndexes: state.brokenMessageIndexes,
                    ),
                  ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SettingsPreview(audioSettingsModel: widget.receiveTabCubit.audioSettingsModel),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 380,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ValueListenableBuilder<String>(
                        valueListenable: widget.receiveTabCubit.consoleNotifier,
                        builder: (BuildContext context, String logs, _) {
                          return SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            child: Text(
                              logs,
                              style: const TextStyle(fontSize: 11),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _scrolledBottomBool) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleUserScroll() {
    if (_scrollController.hasClients) {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;

      _scrolledBottomBool = (maxScroll - currentScroll) < 20;
    }
  }
}
