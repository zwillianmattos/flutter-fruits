import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter_fruits/bgm.dart';
import 'package:flutter_fruits/fruit-game.dart';
import 'package:flutter_fruits/view.dart';

class StartButton {
  final FruitGame game;
  Rect rect;
  Sprite sprite;

  StartButton(this.game) {
    resize();
    sprite = Sprite('ui/start-button.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void resize() {
    rect = Rect.fromLTWH(
      game.tileSize * 1.5,
      (game.screenSize.height * .75) - (game.tileSize * 1.5),
      game.tileSize * 6,
      game.tileSize * 3,
    );
  }

  void onTapDown() {
    game.score = 0;
    game.activeView = View.playing;
    game.spawner.start();
    BGM.play(BGMType.playing);
  }
}
