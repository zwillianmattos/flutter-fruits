import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter_fruits/components/throw-fruit.dart';
import 'package:flutter_fruits/fruit-game.dart';

class Bomb extends ThrowFruit {
  double get speed => game.tileSize * 5;

  Bomb(FruitGame game, double x, double y) : super(game) {
    resize(x: x, y: y);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('fruits/bomb.png'));
    flyingSprite.add(Sprite('fruits/bomb.png'));
    deadSprite = Sprite('fruits/bomb.png');
    splash = Sprite('fruits/banana_splash.png');
    isBomb = true;
  }

  void resize({double x, double y}) {
    x ??= (fruitRect?.left) ?? 0;
    y ??= (fruitRect?.top) ?? 0;
    fruitRect = Rect.fromLTWH(x, y, game.tileSize * 1.5, game.tileSize * 1.5);
    super.resize();
  }
}
