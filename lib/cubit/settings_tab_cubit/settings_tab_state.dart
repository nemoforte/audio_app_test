import 'package:equatable/equatable.dart';

class SettingsTabState extends Equatable {
  final bool valuesChangedBool;

  const SettingsTabState({required this.valuesChangedBool});

  @override
  List<Object?> get props => <Object>[valuesChangedBool];
}
