import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:newone/controllers/app_ctrl.dart' as ctrl;
import 'controllers/app_ctrl.dart';
import 'screens/agent_screen.dart';
import 'ui/color_pallette.dart' show LKColorPaletteLight, LKColorPaletteDark;

final appCtrl = AppCtrl();

class VoiceAssistantApp extends StatefulWidget {
  const VoiceAssistantApp({super.key});

  @override
  State<VoiceAssistantApp> createState() => _VoiceAssistantAppState();
}

class _VoiceAssistantAppState extends State<VoiceAssistantApp> {
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      setState(() => _permissionsGranted = true);
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Permissions Required"),
          content: const Text(
              "This app needs access to the microphone and camera to function properly."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
    });
  }

  ThemeData buildTheme({required bool isLight}) {
    final colorPallete = isLight ? LKColorPaletteLight() : LKColorPaletteDark();

    return ThemeData(
      useMaterial3: true,
      cardColor: colorPallete.bg2,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorPallete.bg2,
        hintStyle: TextStyle(
          color: colorPallete.fg4,
          fontSize: 14,
        ),
      ),
      buttonTheme: ButtonThemeData(
        disabledColor: Colors.red,
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
          surface: colorPallete.fgAccent,
        ),
      ),
      colorScheme: isLight
          ? const ColorScheme.light(
        primary: Colors.black,
        secondary: Colors.black,
        surface: Colors.white,
      )
          : const ColorScheme.dark(
        primary: Colors.white,
        secondary: Colors.white,
        surface: Colors.black,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appCtrl),
        ChangeNotifierProvider.value(value: appCtrl.roomContext),
      ],
      child: !_permissionsGranted
          ? const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
          : Builder(
        builder: (ctx) {
          // Trigger connect once
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final appCtrl = ctx.read<ctrl.AppCtrl>();
            if (appCtrl.connectionState ==
                ctrl.ConnectionState.disconnected) {
              appCtrl.connect();
            }
          });

          // Show loader until connected
          return Selector<ctrl.AppCtrl, ctrl.ConnectionState>(
            selector: (_, appCtrl) => appCtrl.connectionState,
            builder: (ctx, state, _) {
              if (state == ctrl.ConnectionState.connected) {
                // Force dark theme for this screen
                return Theme(
                  data: buildTheme(isLight: false),
                  child: const Scaffold(
                    body: AgentScreen(),
                  ),
                );
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
