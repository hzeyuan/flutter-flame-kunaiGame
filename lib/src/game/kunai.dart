import 'dart:math' show Random, pi;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:kunai_game/src/game/timber.dart';

import 'game.dart';

class KunaiComponet extends SpriteAnimationComponent
    with HasGameRef<KuaiGame>, CollisionCallbacks {
  bool destroyed = false;
  CollisionType collisionType; // 碰撞类型
  bool canUpdate;
  String symbol = '';
  Anchor anchor;
  late RectangleHitbox _kunaiHitbox;
  static const kunaiSpeed = -2000; //苦无的速度
  KunaiComponet(double x, double y, double angle,
      {this.symbol = '',
      this.collisionType = CollisionType.active,
      this.anchor = Anchor.center,
      this.canUpdate = true})
      : super(
            position: Vector2(x, y),
            angle: angle,
            priority: 3,
            anchor: anchor) {
    size = Vector2(21, 100);
    _kunaiHitbox = RectangleHitbox()..collisionType = collisionType;
    add(_kunaiHitbox);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    animation = await gameRef.loadSpriteAnimation(
      'layers/kunai.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.1,
        amount: 1,
        loop: false,
        textureSize: Vector2(50, 255),
      ),
    );
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    if (symbol == 'launch') {
      print(canvasSize);
      x = canvasSize.x / 2;
      y = canvasSize.y - 120;
      super.onGameResize(canvasSize);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);

    // 木桩上的苦无
    if (other is TimberComponet && symbol == 'launch') {
      // print('$symbol:碰撞到了$other');
      other.takeHit();
      return;
    }
    if (symbol != 'inTimber' && other is KunaiComponet) {
      if (other.symbol == 'inTimber') {
        bounceAnimation();

        gameRef.gameOver();
        return;
      }
    }
  }

  // 苦无弹飞动画
  void bounceAnimation() {
    canUpdate = false;
    symbol = 'bounce';
    collisionType = CollisionType.inactive;
    add(MoveToEffect(Vector2(gameRef.windowWidth, gameRef.windowHeight),
        EffectController(duration: 1), onComplete: () {
      removeOnFinish = true;
    }));
    add(RotateEffect.by(
        pi * 2, EffectController(duration: 0.6, repeatCount: 10)));

    if (!gameRef.isMute) FlameAudio.play('bounce.mp3');
  }

  // 苦无掉落动画
  void dropAnimation() {
    double x = -1 * gameRef.windowWidth / 2 +
        Random().nextDouble() * gameRef.windowWidth / 2;
    add(MoveByEffect(
        Vector2(x, gameRef.windowHeight), EffectController(duration: 1),
        onComplete: () {
      removeOnFinish = true;
    }));
  }

  // 取消碰撞
  void cancelCollision() {
    _kunaiHitbox.collisionType = CollisionType.inactive;
  }

  // 重置苦无
  void reset() {
    // 在苦无碰撞到木桩前，不能射击
    gameRef.isShooting = false;
    y = kunaiHeight;
    canUpdate = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (destroyed) {
      removeFromParent();
    }

    // 发生碰撞后，苦无不再移动
    if (!canUpdate) {
      return;
    }

    //碰撞到木桩
    // if (symbol == 'inTimber') {
    //   return;
    // }

    ;
    y += kunaiSpeed * dt;
  }
}
