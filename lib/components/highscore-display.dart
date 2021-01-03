import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter_fruits/fruit-game.dart';

class HighscoreDisplay {
  final FruitGame game;
  TextPainter painter;
  Offset position;

  HighscoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    position = Offset.zero;

    updateHighscore();
  }

  void updateHighscore() {
    resize();
  }

  void resize() {
    int highscore = game.storage.getInt('highscore') ?? 0;

    Shadow shadow = Shadow(
      blurRadius: game.tileSize * .0625,
      color: Color(0xff000000),
      offset: Offset.zero,
    );

    painter.text = TextSpan(
      text: 'Recorde Máximo: ' + highscore.toString(),
      style: TextStyle(
        color: Color(0xffffffff),
        fontSize: game.tileSize * .6,
        shadows: <Shadow>[shadow, shadow, shadow, shadow, shadow, shadow, shadow, shadow],
      ),
    );

    if (painter.text == null) return;
    painter.layout();
    position = Offset(
      game.screenSize.width - (game.tileSize * .25) - painter.width,
      game.tileSize * .25,
    );
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }
}
