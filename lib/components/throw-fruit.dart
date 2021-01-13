import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_fruits/fruit-game.dart';
import 'package:flutter_fruits/view.dart';

import '../bgm.dart';
import '../fruit-game.dart';

class ThrowFruit {
  final FruitGame game;
  List<Sprite> flyingSprite;
  Sprite deadSprite;
  Sprite deadSprite2;
  Sprite splash;
  double flyingSpriteIndex = 0;
  Rect fruitRect;
  Rect deadZone;
  bool isDead = false;
  bool isOffScreen = false;
  Offset targetLocation;

  bool isBomb = false;

  double get speed => game.tileSize * 10;

  double rotate = 0;

  bool destroy = false;

  ThrowFruit(this.game) {
    targetLocation = Offset( game.rnd.nextDouble() * (game.screenSize.width - (game.tileSize * 1.35)), game.screenSize.height - (game.screenSize.height / 0.8));
  }

  void setTargetLocation() {
    targetLocation = Offset( game.rnd.nextDouble() * (game.screenSize.width - (game.tileSize * 1.35)), game.screenSize.height);
    destroy = true;
  }

  void render(Canvas c) {
    // print(game.screenSize.height);
    if (isDead) {
      if( deadZone == null ) {
        deadZone = fruitRect;
      }
      if( !isBomb ) {
        splash.renderPosition(c, Position(deadZone.left, deadZone.top));
        deadSprite.renderPosition(c, Position(fruitRect.center.dx, fruitRect.center.dy).rotateDeg(5), size: Position( fruitRect.width*1.5, fruitRect.height*1.5));
        deadSprite2.renderPosition(c, Position(fruitRect.center.dx, fruitRect.center.dy).rotateDeg(-5), size: Position( fruitRect.width*1.5, fruitRect.height*1.5));
      }

    } else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, fruitRect.inflate(fruitRect.width / 4));
    }
  }

  void update(double t) {
    if (isDead) {
      // make the fly fall

      rotate += 2* t;
      fruitRect = fruitRect.translate(0, game.tileSize * 12 * t);
      if (fruitRect.top > game.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      // flap the wings
      flyingSpriteIndex += 30 * t;
      while (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }

      // move the fly
      double stepDistance = speed * t;
      Offset toTarget = targetLocation - Offset(fruitRect.left, fruitRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        fruitRect = fruitRect.shift(stepToTarget);


      } else {
        fruitRect = fruitRect.shift(toTarget);

        if( destroy  ) {

          if (game.activeView == View.playing && !isBomb ) {
            if (game.soundButton.isEnabled) {
              Flame.audio.play(
                  'sfx/haha2.ogg');
            }
            BGM.play(BGMType.home);
            game.activeView = View.lost;
          }
          isDead =  true;
        } else {
          setTargetLocation();
        }
      }
      // callout
      // callout.update(t);
    }
  }

  void resize() {}

  void onTapDown() {
    if (!isDead) {
      isDead = true;

      if (game.activeView == View.playing) {

        if( isBomb ) {
            if (game.soundButton.isEnabled) {
              Flame.audio.play(
                  'sfx/bomb_explode.wav');
            }
            BGM.play(BGMType.home);
            game.activeView = View.lost;
        } else {
          game.score += 1;

          if (game.soundButton.isEnabled) {
            Flame.audio.play('sfx/swipe.wav');
          }

          if (game.score > (game.storage.getInt('highscore') ?? 0)) {
            game.storage.setInt('highscore', game.score);
            game.highscoreDisplay.updateHighscore();
          }
        }

      }
    }
  }
}
