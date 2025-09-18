import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newone/controllers/app_ctrl.dart' as ctrl;
import 'package:newone/widgets/button.dart' as buttons;

class VoiceAssistantScreen extends StatelessWidget {
  const VoiceAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ctrl.AppCtrl(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("AI Voice Assistant"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 30,
            children: [
              Image.asset(
                'assets/images/dmuh.png',
                width: 80,
                height: 80,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              Builder(
                builder: (ctx) {
                  final isProgressing = [
                    ctrl.ConnectionState.connecting,
                    ctrl.ConnectionState.connected,
                  ].contains(ctx.watch<ctrl.AppCtrl>().connectionState);

                  return buttons.Button(
                    text: isProgressing ? 'Connecting...' : 'Talk To Me',
                    isProgressing: isProgressing,
                    onPressed: () => ctx.read<ctrl.AppCtrl>().connect(),

                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
