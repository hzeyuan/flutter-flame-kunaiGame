import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'game.dart';
import 'stats/bloc/game_stats_bloc.dart';

class LevelBox extends ShapeComponent
    with
        HasGameRef<KuaiGame>,
        FlameBlocListenable<GameStatsBloc, GameStatsState> {
  late TextComponent levelTextComponent;

  @override
  void onNewState(state) {
    levelTextComponent.text = 'Level: ${state.level}';
  }

  @override
  Future<void> onLoad() async {
    var style = TextStyle(color: BasicPalette.white.color, fontSize: 14);
    var regular = TextPaint(style: style);

    levelTextComponent = TextComponent(
        text: 'Level: ${gameRef.statsBloc.state.level}', textRenderer: regular)
      ..x = 12
      ..y = 60;
    await add(levelTextComponent);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(-10, 52, 80, 30);
    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(10.0));
    canvas.drawRRect(rrect, paint..color = Color.fromRGBO(47, 24, 16, 0.8));
    super.render(canvas);
  }
}

//得分绘制
class ScoreBox extends ShapeComponent
    with
        HasGameRef<KuaiGame>,
        FlameBlocListenable<GameStatsBloc, GameStatsState> {
  late TextComponent scoreTextComponent;

  @override
  void onNewState(state) {
    scoreTextComponent.text = state.score.toString();
  }

  @override
  Future<void> onLoad() async {
    var style = TextStyle(
        color: BasicPalette.black.color,
        fontSize: 16,
        fontWeight: FontWeight.bold);
    var regular = TextPaint(style: style);

    await add(TextComponent(
        anchor: Anchor.center, text: 'Score', textRenderer: regular)
      ..x = gameRef.windowWidth / 2
      ..y = 60);
    scoreTextComponent = TextComponent(
        anchor: Anchor.center,
        text: '${gameRef.statsBloc.state.score}',
        textRenderer: regular)
      ..x = gameRef.windowWidth / 2
      ..y = 85;
    await add(scoreTextComponent);
  }

  @override
  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(gameRef.windowWidth / 2 - 50, 40, 100, 60);
    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(5.0));
    canvas.drawRRect(rrect, paint..color = Color.fromRGBO(255, 255, 255, 0.8));
    super.render(canvas);
  }
}

// kunai
class KunaiNumBox extends SpriteComponent
    with
        HasGameRef<KuaiGame>,
        FlameBlocListenable<GameStatsBloc, GameStatsState> {
  late TextComponent kunaiNumTextComponent;

  @override
  void onNewState(state) {
    kunaiNumTextComponent.text = 'x ${state.kunaiNum}';
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      'layers/kunai.png',
    );
    size = Vector2(10, 50);
    x = 30;
    y = gameRef.windowHeight - 100;
    var style = TextStyle(color: BasicPalette.white.color, fontSize: 14);
    var regular = TextPaint(style: style);

    kunaiNumTextComponent =
        TextComponent(text: 'x $kunaiNum', textRenderer: regular)
          ..x = 20
          ..y = 18;
    await add(kunaiNumTextComponent);

    return super.onLoad();
  }
}

class SoundIcon extends SpriteComponent with HasGameRef<KuaiGame>, Tappable {
  late Sprite soundSprite;
  late Sprite muteSprite;
  bool isMute;

  SoundIcon(this.isMute);

  @override
  bool onTapDown(_) {
    gameRef.toggleMuted();
    if (isMute) {
      sprite = soundSprite;
    } else {
      sprite = muteSprite;
    }
    isMute = !isMute;
    return false;
  }

  @override
  Future<void> onLoad() async {
    soundSprite = await Sprite.load(
      'sound-filling.png',
    );
    muteSprite = await Sprite.load(
      'nosound-filling.png',
    );
    sprite = !isMute ? soundSprite : muteSprite;
    size = Vector2(36, 36);
    priority = 999;
    x = gameRef.windowWidth - 48;
    y = 44;

    return super.onLoad();
  }
}

class BackIcon extends SpriteComponent with HasGameRef<KuaiGame>, Tappable {
  late Sprite soundSprite;
  late Sprite muteSprite;

  BackIcon();

  @override
  bool onTapDown(_) {
    gameRef.back();
    return false;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      'back.png',
    );
    size = Vector2(36, 36);
    priority = 999;
    x = gameRef.windowWidth - 48;

    y = 82 + 36 + 6;
    return super.onLoad();
  }
}

class ResetIcon extends SpriteComponent with HasGameRef<KuaiGame>, Tappable {
  late Sprite soundSprite;
  late Sprite muteSprite;

  ResetIcon();

  @override
  bool onTapDown(_) {
    gameRef.reset();
    return false;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      'restart.png',
    );
    size = Vector2(36, 36);
    priority = 999;
    x = gameRef.windowWidth - 48;
    y = 44 + 36 + 6;

    return super.onLoad();
  }
}
