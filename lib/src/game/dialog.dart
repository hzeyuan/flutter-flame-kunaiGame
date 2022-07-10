import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kunai_game/src/ads/ads_controller.dart';
import 'package:kunai_game/src/ads/banner_ad_widget.dart';
import 'package:kunai_game/src/settings/settings.dart';
import 'package:kunai_game/src/style/responsive_screen.dart';
import 'package:provider/provider.dart';

class GameOverDialog extends StatefulWidget {
  final Animation<double> animation;
  final int score;
  const GameOverDialog(
      {required this.animation, super.key, required this.score});

  @override
  State<GameOverDialog> createState() => _CustomNameDialogState();
}

class _CustomNameDialogState extends State<GameOverDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final adsControllerAvailable = context.watch<AdsController?>() != null;
    return ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // if (adsControllerAvailable) ...[BannerAdWidget()],
            Text(
              'Score: ${widget.score}',
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
                      GoRouter.of(context).go('/play');
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
            // Center(
            //   child: Text(
            //     'Score: ${score.score}\n'
            //     'Time: ${score.formattedTime}',
            //     style:
            //         const TextStyle(fontFamily: 'Permanent Marker', fontSize: 20),
            //   ),
            // ),
          ],
        ),
        rectangularMenuArea: BannerAdWidget());

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: widget.animation,
        curve: Curves.easeOutCubic,
      ),
      child: SimpleDialog(
        children: [
          Text(
            'Score: ${widget.score}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Permanent Marker',
              fontSize: 40,
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
                fontFamily: 'Permanent Marker',
                fontSize: 40,
                height: 1,
              ),
            ),
          ),
          SizedBox(height: 16),
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
                    GoRouter.of(context).go('/play');
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
    );
  }

  @override
  void didChangeDependencies() {
    _controller.text = context.read<SettingsController>().playerName.value;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
