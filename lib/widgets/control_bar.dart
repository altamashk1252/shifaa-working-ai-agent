import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart' as sf;
import 'package:livekit_components/livekit_components.dart' as components;
import 'package:provider/provider.dart';

import '../app.dart';
import '../controllers/app_ctrl.dart' show AppCtrl, AgentScreenState;
import '../ui/color_pallette.dart' show LKColorPaletteLight;
import 'floating_glass.dart';

class ControlBar extends StatelessWidget {
  const ControlBar({super.key});

  @override
  Widget build(BuildContext ctx) {
    return FloatingGlassView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 🎤 Microphone button
            components.MediaDeviceContextBuilder(
              builder: (context, roomCtx, mediaDeviceCtx) => FloatingGlassButton(
                sfIcon: mediaDeviceCtx.microphoneOpened
                    ? sf.SFIcons.sf_microphone_fill
                    : sf.SFIcons.sf_microphone_slash_fill,
                subWidget: components.ParticipantSelector(
                  filter: (identifier) => identifier.isAudio && identifier.isLocal,
                  builder: (context, identifier) => const SizedBox(
                    width: 16,
                    height: 16,
                    child: components.AudioVisualizerWidget(
                      options: components.AudioVisualizerWidgetOptions(
                        barCount: 5,
                        spacing: 1,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  mediaDeviceCtx.microphoneOpened
                      ? mediaDeviceCtx.disableMicrophone()
                      : mediaDeviceCtx.enableMicrophone();
                },
              ),
            ),

            // 📷 Camera button
            components.MediaDeviceContextBuilder(
              builder: (context, roomCtx, mediaDeviceCtx) => FloatingGlassButton(
                sfIcon: mediaDeviceCtx.cameraOpened
                    ? sf.SFIcons.sf_video_fill
                    : sf.SFIcons.sf_video_slash_fill,
                onTap: () => appCtrl.toggleUserCamera(mediaDeviceCtx),
              ),
            ),

            // 💬 Chat / Transcription toggle
            Selector<AppCtrl, AgentScreenState>(
              selector: (ctx, appCtx) => appCtx.agentScreenState,
              builder: (context, agentScreenState, child) => FloatingGlassButton(
                isActive: agentScreenState == AgentScreenState.transcription,
                sfIcon: sf.SFIcons.sf_ellipsis_message_fill,
                onTap: () => ctx.read<AppCtrl>().toggleAgentScreenMode(),
              ),
            ),

            // 📞 End Call button
            FloatingGlassButton(
              iconColor: LKColorPaletteLight().fgModerate,
              sfIcon: sf.SFIcons.sf_phone_down_fill,
              onTap: () => ctx.read<AppCtrl>().disconnect(ctx),
            ),
          ],
        ),
      ),
    );
  }
}
