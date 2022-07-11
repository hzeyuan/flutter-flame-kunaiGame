import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        mainAreaProminence: 0.45,
        squarishMainArea: Stack(
          children: [
            Center(
                child: Image.asset(
              'assets/images/logo.png',
              width: 320,
              height: 320,
            )),
            Center(
              child: Transform.rotate(
                angle: -0.1,
                child: const Text(
                  'Ninja Kunai',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 60,
                    height: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/play');
                },
                child: Text(
                  'Play',
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 55,
                    height: 1,
                  ),
                )),
            _gap,
            TextButton(
                onPressed: () => GoRouter.of(context).go('/settings'),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 55,
                    height: 1,
                  ),
                )),
            _gap,
            // TextButton(
            //     onPressed: () => GoRouter.of(context).go('/ranking'),
            //     child: Text(
            //       'Ranking',
            //       style: TextStyle(
            //         fontFamily: 'Permanent Marker',
            //         fontSize: 55,
            //         height: 1,
            //       ),
            //     )),
            // _gap,
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleMuted(),
                    icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                  );
                },
              ),
            ),
            _gap,
            // const Text('Author:你就像只铁甲小宝 '),
            const Text('Email:yixotieq@mgail.com '),

            InkWell(
              onTap: () {
                launchUrl(Uri(
                    scheme: 'https',
                    path:
                        'www.privacypolicies.com/live/6d6302b5-d8ff-4827-9ac6-fe9e43b4fd1e'));
              },
              child: Text('Privacy Policy'),
            ),

            _gap,
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}
