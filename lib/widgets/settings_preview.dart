import 'package:flutter/material.dart';
import 'package:mrumru/mrumru.dart';

class SettingsPreview extends StatelessWidget {
  final AudioSettingsModel audioSettingsModel;

  const SettingsPreview({required this.audioSettingsModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('First Frequency: ${audioSettingsModel.firstFrequency}'),
          Text('Channels: ${audioSettingsModel.channels}'),
          Text('Bits Per Frequency: ${audioSettingsModel.bitsPerFrequency}'),
          Text('Subband Count: ${audioSettingsModel.subbandCount}'),
        ],
      ),
    );
  }
}
