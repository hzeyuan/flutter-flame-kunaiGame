import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';

import 'game.dart';
import 'kunai.dart';
import 'stats/bloc/game_stats_bloc.dart';
import 'timberMask.dart';

class TimberComponet extends SpriteComponent
    with
        HasGameRef<KuaiGame>,
        CollisionCallbacks,
        FlameBlocReader<GameStatsBloc, GameStatsState> {
  bool canUpdate = true;
  final double _radius = 200;
  late TimberMask _timberMask;
  int _count = 0;
  double speed = 1.2; //旋转的速度
  TimberComponet(double x, double y, {double angle = math.pi / 2})
      : super(
          position: Vector2(x, y),
          anchor: Anchor.center,
          angle: angle,
          priority: 4,
        ) {
    var circleHitBox = CircleHitbox(radius: _radius / 2)
      ..collisionType = CollisionType.passive;
    add(circleHitBox);
    size = Vector2.all(_radius);
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('layers/timber.png');
    size = Vector2(_radius, _radius);
    await super.onLoad();
    _timberMask = TimberMask()
      ..anchor = Anchor.center
      ..position = Vector2(100, 100)
      ..priority = 3;
    await add(_timberMask);
    FlameAudio.bgm.initialize();
  }

  @override
  void onGameResize(Vector2 size) {
    x = size.x / 2;
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    // 更新命中苦无的数量
    int hitKuanNum = children.whereType<KunaiComponet>().length;
    if (hitKuanNum != _count) {
      _count = hitKuanNum;
      gameRef.nextLevel(_count);
    }
    if (!canUpdate) return;
    angle = (angle + speed * dt) % 360;
    super.update(dt);
  }

  //苦无击中木桩
  void takeHit() {
    double x = _radius / 2 + _radius / 2 * math.cos(math.pi / 2 - angle);
    double y = _radius / 2 + _radius / 2 * math.sin(math.pi / 2 - angle);
    KunaiComponet kunaiComponet = KunaiComponet(x, y, -1 * angle,
        symbol: 'inTimber', anchor: Anchor.center)
      ..collisionType = CollisionType.passive
      ..canUpdate = false
      ..priority = 1;
    // 添加抖动效果
    add(MoveEffect.by(
      Vector2(0, 10),
      NoiseEffectController(duration: 0.3, frequency: 1),
      onComplete: () {
        RemoveEffect();
      },
    ));
    if (!gameRef.isMute) FlameAudio.play('kunaiHit.mp3');
    // 重置苦无
    gameRef.kunaiComponet.reset();
    add(kunaiComponet);
    gameRef.increaseScore();
  }

  // 木桩碎裂
  void broke() {
    canUpdate = false;
    angle = 0;
    setOpacity(0);
    if (!gameRef.isMute) FlameAudio.play('burst.mp3');
    _timberMask.startAnimation();
    print('下一关');
    // 木桩碎裂
    var kunaiComponets =
        gameRef.timberComponent.children.whereType<KunaiComponet>().toList();

    for (var child in kunaiComponets) {
      if (child is KunaiComponet) {
        child.cancelCollision();
        child.dropAnimation();
      }
    }
  }
}
