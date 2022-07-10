import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/layers.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kunai_game/src/game/box.dart';
import 'package:kunai_game/src/settings/persistence/local_storage_settings_persistence.dart';

import 'package:provider/provider.dart';

import '../settings/settings.dart';
import 'dialog.dart';
import 'kunai.dart';
import 'stats/bloc/game_stats_bloc.dart';
import 'stats/bloc/game_stats_event.dart';
import 'timber.dart';
import 'timberMask.dart';

double kunaiHeight =
    window.physicalSize.height / window.devicePixelRatio - 120; // 苦无位置
double kunaiWidth =
    window.physicalSize.width / window.devicePixelRatio / 2; // 苦无位置
double timberHeight = 180 + 36;
double timberWidth = window.physicalSize.width / window.devicePixelRatio / 2;
int kunaiNum = 9;

class KuaiGame extends FlameGame with HasTappables, HasCollisionDetection {
  BuildContext context;

  KuaiGame(this.context);

  bool isShooting = false;
  final GameStatsBloc statsBloc = GameStatsBloc();
  late TimberComponet timberComponent;
  late double windowHeight;
  late double windowWidth;
  late TimberMask timberMask;
  late KunaiComponet kunaiComponet;
  late FlameMultiBlocProvider flameMultiBlocProvider;
  late LevelBox levelBox;
  late ScoreBox scoreBox;
  late KunaiNumBox kunaiNumBox;
  late Layer backgroundLayer;
  late bool isMute;
  // @override
  bool debugMode = false;

  @override
  void onGameResize(Vector2 canvasSize) {
    windowHeight = canvasSize.y;
    windowWidth = canvasSize.x;
    super.onGameResize(canvasSize);
  }

  @override
  Future<void> onLoad() async {
    print(children.length);

    isMute =
        await LocalStorageSettingsPersistence().getMuted(defaultValue: true);
    // 加载背景
    await add(BackgroundCompoent());
    await add(SoundIcon(isMute));
    await add(ResetIcon());
    await add(BackIcon());
    kunaiComponet = KunaiComponet(
      kunaiWidth,
      kunaiHeight,
      0,
      symbol: 'launch',
      canUpdate: false,
    );
    await add(kunaiComponet);

    // 加载木桩碎裂图层
    timberMask = TimberMask()
      ..anchor = Anchor.center
      ..x = timberWidth
      ..y = timberHeight;

    timberComponent = TimberComponet(timberWidth, timberHeight);

    levelBox = LevelBox();
    scoreBox = ScoreBox();
    kunaiNumBox = KunaiNumBox();

    flameMultiBlocProvider = FlameMultiBlocProvider(providers: [
      FlameBlocProvider<GameStatsBloc, GameStatsState>(create: () => statsBloc),
    ], children: [
      //木桩组件
      timberComponent,
      levelBox,
      scoreBox,
      kunaiNumBox,
    ]);

    await add(flameMultiBlocProvider);
    FlameAudio.bgm.initialize();
    return super.onLoad();
  }

  // 射击
  void shoot() {
    if (isShooting || statsBloc.state.kunaiNum <= 0) return;
    // print('发射苦无');
    isShooting = true;
    // shooting
    kunaiComponet.canUpdate = true;
  }

  // 增加分数
  void increaseScore() {
    // print('增加分数');
    statsBloc.add(ScoreEventAdded(1));
    statsBloc.add(KunaiNumEvent(statsBloc.state.kunaiNum - 1));
  }

  //游戏结束
  Future<void> gameOver() async {
    // print('游戏结束');
    statsBloc.add(PlayerDied());
    int score = await LocalStorageSettingsPersistence().getBestScore();
    // 历史最高分 上传到服务器 排名

    context
        .read<SettingsController>()
        .setBesetScore(max(statsBloc.state.score, score));
    Future.delayed(Duration(milliseconds: 500), () {
      showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) =>
              GameOverDialog(
                  animation: animation, score: statsBloc.state.score));
    });
  }

  // 返回
  void back() {
    Navigator.pop(context);
  }

  // 重新游戏
  void reset() {
    GoRouter.of(context).go('/play');
  }

  // 切换声音
  void toggleMuted() {
    context.read<SettingsController>().toggleMuted();
    isMute = !isMute;
  }

  // 下一关
  void nextLevel(int count) {
    // 条件
    if (9 == count) {
      timberComponent.broke();
      // 关数加1
      Future.delayed(Duration(seconds: 1), () {
        // 复原
        timberComponent.children.clear();
        timberComponent.onLoad();
        timberComponent.canUpdate = true;
        int rotations =
            statsBloc.state.level % 3 == 0 && Random().nextDouble() < 0.1
                ? 1
                : -1;
        if (timberComponent.speed > 0) {
          timberComponent.speed +=
              0.1 * Random().nextDouble() * statsBloc.state.level; // 该变速度
        } else {
          timberComponent.speed -=
              0.1 * Random().nextDouble() * statsBloc.state.level; // 该变速度
        }

        print('速度:${timberComponent.speed}');
        timberComponent.speed *= rotations; // 改变方向
        statsBloc.add(KunaiNumEvent(kunaiNum));
        statsBloc.add(LevelEventAdded(statsBloc.state.level + 1));
        //
      });
    }
  }
}

class BackgroundCompoent extends SpriteComponent
    with Tappable, HasGameRef<KuaiGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2(gameRef.windowWidth, gameRef.windowHeight);
    sprite = await Sprite.load(
      'layers/background.jpg',
    );
    size = size;
    await super.onLoad();
  }

  @override
  bool onTapDown(_) {
    gameRef.shoot();
    return false;
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    size = canvasSize;
    super.onGameResize(size);
  }
}
