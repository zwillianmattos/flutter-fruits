import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter_fruits/components/throw-fruit.dart';
import 'package:flutter_fruits/fruit-game.dart';

class Watermelon extends ThrowFruit {
  double get speed => game.tileSize * 5;

  Watermelon(FruitGame game, double x, double y) : super(game) {
    resize(x: x, y: y);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('fruits/melancia.png'));
    flyingSprite.add(Sprite('fruits/melancia.png'));
    deadSprite = Sprite('fruits/melancia-cut-1.png');
    deadSprite2 = Sprite('fruits/melancia-cut-2.png');
    splash = Sprite('fruits/melon_splash.png');
  }

  void resize({double x, double y}) {
    x ??= (fruitRect?.left) ?? 0;
    y ??= (fruitRect?.top) ?? 0;
    fruitRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    super.resize();
  }
}
