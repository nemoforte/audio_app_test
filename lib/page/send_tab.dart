import 'package:audio_app_test/cubit/send_tab_cubit/a_send_tab_state.dart';
import 'package:audio_app_test/cubit/send_tab_cubit/send_tab_cubit.dart';
import 'package:audio_app_test/cubit/send_tab_cubit/states/send_tab_emitting_state.dart';
import 'package:audio_app_test/shared/utils/predefined_messages.dart';
import 'package:audio_app_test/widgets/settings_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendTab extends StatefulWidget {
  final SendTabCubit sendTabCubit;
  final TextEditingController messageTextController;

  const SendTab({required this.sendTabCubit, required this.messageTextController, super.key});

  @override
  State<StatefulWidget> createState() => _SendTabState();
}

class _SendTabState extends State<SendTab> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<SendTabCubit, ASendTabState>(
        bloc: widget.sendTabCubit,
        builder: (BuildContext context, ASendTabState state) {
          bool emittingInProgressBool = state is SendTabEmittingState;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8),
                TextFormField(
                  controller: widget.messageTextController,
                  enabled: emittingInProgressBool == false,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Enter a message',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.messageTextController,
                  builder: (BuildContext context, TextEditingValue textEditingValue, _) {
                    return Row(
                      children: <Widget>[
                        InkWell(
                          onTap: emittingInProgressBool ? null : widget.messageTextController.clear,
                          child: const Text('Clear', style: TextStyle(color: Colors.blue, fontSize: 18)),
                        ),
                        const Spacer(),
                        Text('Message length: ${textEditingValue.text.length}'),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Text('Or use a predefined one:'),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: emittingInProgressBool ? null : () => widget.messageTextController.text = PredefinedMessages.loremIpsum,
                        child: const Text('Lorem Ipsum'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: emittingInProgressBool ? null : () => widget.messageTextController.text = PredefinedMessages.humanReadableAscii,
                        child: const Text('ASCII'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Opacity(
                        opacity: emittingInProgressBool ? 0.5 : 1.0,
                        child: OutlinedButton(
                          onPressed: emittingInProgressBool
                              ? null
                              : () {
                                  widget.sendTabCubit.playSound(widget.messageTextController.text);
                                },
                          child: const Text('Emit message', style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Opacity(
                        opacity: emittingInProgressBool ? 1.0 : 0.5,
                        child: OutlinedButton(
                          onPressed: emittingInProgressBool ? widget.sendTabCubit.stopSound : null,
                          child: const Text('Stop emission', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SettingsPreview(audioSettingsModel: widget.sendTabCubit.audioSettingsModel),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
