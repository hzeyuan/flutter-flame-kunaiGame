import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(body: GameWidget(game: KuaiGame(context)));
    // Padding(
    //     padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    //     child: GameWidget(game: KuaiGame(context))));
  }
}
