import 'package:audio_app_test/cubit/receive_tab_cubit/receive_tab_cubit.dart';
import 'package:audio_app_test/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:audio_app_test/cubit/send_tab_cubit/send_tab_cubit.dart';
import 'package:audio_app_test/cubit/settings_tab_cubit/settings_tab_cubit.dart';
import 'package:audio_app_test/page/receive_tab.dart';
import 'package:audio_app_test/page/send_tab.dart';
import 'package:audio_app_test/page/settings_tab.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  final SettingsTabCubit settingsTabCubit = SettingsTabCubit();
  final SendTabCubit sendTabCubit = SendTabCubit();
  final ReceiveTabCubit receiveTabCubit = ReceiveTabCubit();
  final TextEditingController messageTextController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    settingsTabCubit.close();
    sendTabCubit.close();
    receiveTabCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mru Mru Example App'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Tab>[
              Tab(text: 'Settings'),
              Tab(text: 'Send'),
              Tab(text: 'Receive'),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              SettingsTab(
                settingsTabCubit: settingsTabCubit,
                onSaveSettings: _saveSettings,
              ),
              SendTab(
                sendTabCubit: sendTabCubit,
                messageTextController: messageTextController,
              ),
              ReceiveTab(receiveTabCubit: receiveTabCubit),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging == false) {
      FocusScope.of(context).unfocus();
    }

    _autoSaveSettings();
    _autoStopRecording();
  }

  void _autoSaveSettings() {
    if (_tabController.previousIndex == 0 && _tabController.index != 0 && settingsTabCubit.state.valuesChangedBool) {
      _saveSettings();
    }
  }

  void _autoStopRecording() {
    if (_tabController.previousIndex == 2 && _tabController.index != 2 && receiveTabCubit.state is ReceiveTabRecordingState) {
      receiveTabCubit.stopRecording();
    }
  }

  void _saveSettings() {
    receiveTabCubit.audioSettingsModel = settingsTabCubit.getCurrentAudioSettingsModel();
    sendTabCubit.audioSettingsModel = settingsTabCubit.getCurrentAudioSettingsModel();
    settingsTabCubit.updateInitialValuesAfterSave();
    FocusScope.of(context).unfocus();
  }
}
