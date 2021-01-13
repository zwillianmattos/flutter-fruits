import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_fruits/bgm.dart';
import 'package:flutter_fruits/components/Banana.dart';
import 'package:flutter_fruits/components/background.dart';
import 'package:flutter_fruits/components/Bomb.dart';
import 'package:flutter_fruits/components/throw-fruit.dart';
import 'package:flutter_fruits/components/highscore-display.dart';
import 'package:flutter_fruits/components/Watermelon.dart';
import 'package:flutter_fruits/components/Pineaple.dart';
import 'package:flutter_fruits/components/music-button.dart';
import 'package:flutter_fruits/components/score-display.dart';
import 'package:flutter_fruits/components/sound-button.dart';
import 'package:flutter_fruits/components/start-button.dart';
import 'package:flutter_fruits/controllers/spawner.dart';
import 'package:flutter_fruits/view.dart';
import 'package:flutter_fruits/views/home-view.dart';
import 'package:flutter_fruits/views/lost-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FruitGame extends Game {
  final SharedPreferences storage;
  Size screenSize;
  double tileSize;
  Random rnd;

  BackgroundGame background;
  List<ThrowFruit> fruits;
  StartButton startButton;
  MusicButton musicButton;
  SoundButton soundButton;
  ScoreDisplay scoreDisplay;
  HighscoreDisplay highscoreDisplay;

  FlySpawner spawner;

  View activeView = View.home;
  HomeView homeView;
  LostView lostView;

  int score;

  FruitGame(this.storage) {
    initialize();
  }

  Future<void> initialize() async {
    rnd = Random();
    fruits = List<ThrowFruit>();
    score = 0;
    resize(Size.zero);

    background = BackgroundGame(this);
    startButton = StartButton(this);
    musicButton = MusicButton(this);
    soundButton = SoundButton(this);
    scoreDisplay = ScoreDisplay(this);
    highscoreDisplay = HighscoreDisplay(this);

    spawner = FlySpawner(this);
    homeView = HomeView(this);
    lostView = LostView(this);

    BGM.play(BGMType.home);
  }

  void spawnFruit() {
    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 2.025));
    double y = screenSize.height - (tileSize * 2.025);

    switch (rnd.nextInt(4)) {
      case 0:
        fruits.add(Watermelon(this, x, y));
        break;
      case 1:
        fruits.add(Bomb(this, x, y));
        break;
      case 2:
        fruits.add(Banana(this, x, y));
        break;
      case 3:
        fruits.add(Pineaple(this, x, y));
        break;
    }
  }

  void render(Canvas canvas) {
    background.render(canvas);

    highscoreDisplay.render(canvas);
    if (activeView == View.playing || activeView == View.lost) scoreDisplay.render(canvas);

    fruits.forEach((ThrowFruit fly) => fly.render(canvas));

    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
    }
    musicButton.render(canvas);
    soundButton.render(canvas);
  }

  void update(double t) {
    spawner.update(t);
    fruits.forEach((ThrowFruit fly) => fly.update(t));
    fruits.removeWhere((ThrowFruit fly) => fly.isOffScreen);
    if (activeView == View.playing) scoreDisplay.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;

    background?.resize();

    highscoreDisplay?.resize();
    scoreDisplay?.resize();
    fruits.forEach((ThrowFruit fly) => fly?.resize());

    homeView?.resize();
    lostView?.resize();

    startButton?.resize();
    musicButton?.resize();
    soundButton?.resize();

  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;

    // dialog boxes
    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }

    // music button
    if (!isHandled && musicButton.rect.contains(d.globalPosition)) {
      musicButton.onTapDown();
      isHandled = true;
    }

    // sound button
    if (!isHandled && soundButton.rect.contains(d.globalPosition)) {
      soundButton.onTapDown();
      isHandled = true;
    }

    // start button
    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    // fruits
    if (!isHandled) {
      bool didHitAFruit = false;
      fruits.forEach((ThrowFruit fruit) {
        if (fruit.fruitRect.contains(d.globalPosition)) {
          fruit.onTapDown();
          isHandled = true;
          didHitAFruit = true;
        }
      });

    }
  }
}
