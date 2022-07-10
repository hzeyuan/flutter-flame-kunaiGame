import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'game.dart';

double generateRandom(double start, double end) {
  return math.Random().nextDouble() * (end - start) + start;
}

class TimberMaskSprite extends SpriteComponent with HasGameRef<KuaiGame> {
  double r;
  double startAngle;
  double endAngle;
  TimberMaskSprite(this.r, this.startAngle, this.endAngle)
      : super(position: Vector2(0, 0), anchor: Anchor.center, priority: 999);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(
      'layers/timber.png',
    );
    size = Vector2(200, 200);
  }

  @override
  void render(Canvas canvas) {
    var point1 =
        Offset(r + r * math.cos(startAngle), r + r * math.sin(startAngle));
    var point2 = Offset(r + r * math.cos(endAngle), r + r * math.sin(endAngle));
    Path path = Path();
    path.moveTo(r, r);
    path.lineTo(point1.dx, point1.dy);
    // 圆弧上点的坐标
    path.arcToPoint(point2, radius: Radius.circular(r), largeArc: true);
    path.close();
    canvas.clipPath(path);
    super.render(canvas);
    // 画辅助线
    // canvas.drawPath(
    //     path,
    //     Paint()
    //       ..style = PaintingStyle.stroke
    //       ..color = Colors.blue
    //       ..strokeWidth = 3);
  }
}

class TimberMask extends PositionComponent with HasGameRef<KuaiGame> {
  List<TimberMaskSprite> ary = [];

  TimberMask() {
    List<double> randomAry = [0 * math.pi, 2 * math.pi];
    randomAry.add(generateRandom(math.pi / 3, math.pi * 35 / 18));
    randomAry.add(generateRandom(math.pi / 3, math.pi * 35 / 18));
    randomAry.add(generateRandom(math.pi / 3, math.pi * 35 / 18));
    randomAry.sort((a, b) => a.compareTo(b));
    print(randomAry);
    for (var i = 0; i < randomAry.length - 1; i++) {
      double r = 100;
      var next = i + 1;
      double startAngle = randomAry[i];
      double endAngle = next > randomAry.length ? 360 : randomAry[next];
      print('r:$r, startAngle:$startAngle, endAngle:$endAngle');
      var m = TimberMaskSprite(r, startAngle, endAngle);
      // m.x += generateRandom(30, 90);
      // m.y += generateRandom(30, 90);
      // m.angle += generateRandom(30, 90);
      ary.add(m);
    }
    addAll(ary);
  }

  void startAnimation() {
    print('now Angle:${gameRef.timberComponent.angle}');
    for (var item in ary) {
      // item.add()
      double x =
          generateRandom(-1 * gameRef.windowWidth / 2, gameRef.windowWidth / 2);
      double y = gameRef.windowHeight;
      print('x:$x, y:$y');
      item.add(MoveEffect.to(
        Vector2(x, y),
        EffectController(
          duration: 1,
        ),
        onComplete: () {
          remove(item);
        },
      ));
      item.x += generateRandom(30, 90);
      item.y += generateRandom(30, 90);
      item.angle += generateRandom(30, 90);
    }
  }
}
