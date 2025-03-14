import 'package:audio_app_test/cubit/settings_tab_cubit/settings_tab_cubit.dart';
import 'package:audio_app_test/cubit/settings_tab_cubit/settings_tab_state.dart';
import 'package:audio_app_test/widgets/numeric_field.dart';
import 'package:audio_app_test/widgets/subbands_count_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsTab extends StatefulWidget {
  final SettingsTabCubit settingsTabCubit;
  final VoidCallback onSaveSettings;

  const SettingsTab({
    required this.settingsTabCubit,
    required this.onSaveSettings,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<SettingsTabCubit, SettingsTabState>(
        bloc: widget.settingsTabCubit,
        builder: (BuildContext context, SettingsTabState state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                NumericField(
                  fieldName: 'firstFrequency',
                  textController: widget.settingsTabCubit.firstFrequencyController,
                ),
                NumericField(
                  fieldName: 'baseFrequencyGap',
                  textController: widget.settingsTabCubit.baseFrequencyGapController,
                ),
                NumericField(
                  fieldName: 'bitsPerFrequency',
                  textController: widget.settingsTabCubit.bitsPerFrequencyController,
                ),
                SubbandsCountTextField(
                  textController: widget.settingsTabCubit.subbandCountController,
                ),
                const SizedBox(height: 32),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _resetToDefaults,
                      child: const Text('Reset to Defaults'),
                    ),
                    const SizedBox(width: 32),
                    ElevatedButton(
                      onPressed: widget.onSaveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.valuesChangedBool ? Colors.redAccent : null,
                      ),
                      child: const Text('Save Settings'),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _resetToDefaults() {
    widget.settingsTabCubit.resetToDefaults();
    widget.onSaveSettings();
  }
}
