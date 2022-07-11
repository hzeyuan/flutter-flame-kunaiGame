import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kunai_game/src/ads/banner_ad_widget.dart';
import 'package:kunai_game/src/settings/settings.dart';
import 'package:kunai_game/src/style/responsive_screen.dart';
import 'package:provider/provider.dart';

class GameOverDialog extends StatelessWidget {
  final Animation<double> animation;
  final int score;
  const GameOverDialog(
      {required this.animation, super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // if (adsControllerAvailable) ...[BannerAdWidget()],
            Text(
              'Score: ${score}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Permanent Marker',
                fontSize: 40,
                decoration: TextDecoration.none,
                height: 1,
              ),
            ),
            SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: settings.bestScore,
              builder: (context, bestScore, child) => Text(
                'Best: $bestScore',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Permanent Marker',
                  decoration: TextDecoration.none,
                  fontSize: 40,
                  height: 1,
                ),
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all(CircleBorder(
                          side: BorderSide(
                        //设置 界面效果
                        width: 300.0,
                        style: BorderStyle.none,
                      ))), //圆
                    ),
                    onPressed: () => GoRouter.of(context).go('/'),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 60,
                      ),
                    )),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all(CircleBorder(
                          side: BorderSide(
                        //设置 界面效果
                        width: 300.0,
                        style: BorderStyle.none,
                      ))), //圆
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      GoRouter.of(context).refresh();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.refresh,
                        size: 60,
                      ),
                    )),
              ],
            )
          ],
        ),
        rectangularMenuArea: BannerAdWidget());
  }
}
