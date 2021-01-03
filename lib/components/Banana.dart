import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter_fruits/components/throw-fruit.dart';
import 'package:flutter_fruits/fruit-game.dart';

class Banana extends ThrowFruit {
  double get speed => game.tileSize * 10;

  Banana(FruitGame game, double x, double y) : super(game) {
    resize(x: x, y: y);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/banana.png'));
    flyingSprite.add(Sprite('flies/banana.png'));
    deadSprite = Sprite('flies/banana-cut-1.png');
    deadSprite2 = Sprite('flies/banana-cut-2.png');
    splash = Sprite('flies/banana_splash.png');
  }

  void resize({double x, double y}) {
    x ??= (flyRect?.left) ?? 0;
    y ??= (flyRect?.top) ?? 0;
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1 , game.tileSize * 1);
    super.resize();
  }
}
