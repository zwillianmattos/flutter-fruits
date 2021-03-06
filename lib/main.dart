import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fruits/bgm.dart';
import 'package:flutter_fruits/fruit-game.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  SharedPreferences storage = await SharedPreferences.getInstance();

  await Flame.images.loadAll(<String>[
    'bg/backyard.png',
    'bg/lose-splash.png',
    'branding/title.png',
    'fruits/melancia.png',
    'fruits/melancia-cut-2.png',
    'fruits/melancia-cut-1.png',
    'ui/icon-music-disabled.png',
    'ui/icon-music-enabled.png',
    'ui/icon-sound-disabled.png',
    'ui/icon-sound-enabled.png',
    'ui/start-button.png',
  ]);

  Flame.audio.disableLog();
  await BGM.preload();

  await Flame.audio.loadAll(<String>[
    'sfx/bomb_explode.wav',
    'sfx/swipe.wav',
    'sfx/haha2.ogg',
  ]);

  FruitGame game = FruitGame(storage);
  runApp(game.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);

  WidgetsBinding.instance.addObserver(BGMHandler());
}
