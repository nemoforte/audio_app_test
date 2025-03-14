import 'package:audio_app_test/cubit/receive_tab_cubit/a_receive_tab_state.dart';

class ReceiveTabResultState extends AReceiveTabState {
  final List<String> decodedMessageParts;
  final List<int> brokenMessageIndexes;

  ReceiveTabResultState({required this.decodedMessageParts, required this.brokenMessageIndexes});

  @override
  List<Object?> get props => <Object>[decodedMessageParts, brokenMessageIndexes];
}
