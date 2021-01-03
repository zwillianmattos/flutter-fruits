import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter_fruits/components/throw-fruit.dart';
import 'package:flutter_fruits/fruit-game.dart';

class Bomb extends ThrowFruit {
  double get speed => game.tileSize * 10;

  Bomb(FruitGame game, double x, double y) : super(game) {
    resize(x: x, y: y);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/bomb.png'));
    flyingSprite.add(Sprite('flies/bomb.png'));
    deadSprite = Sprite('flies/bomb.png');
    splash = Sprite('flies/banana_splash.png');
    isBomb = true;
  }

  void resize({double x, double y}) {
    x ??= (flyRect?.left) ?? 0;
    y ??= (flyRect?.top) ?? 0;
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1.5, game.tileSize * 1.5);
    super.resize();
  }
}
