import 'package:flutter_fruits/components/throw-fruit.dart';
import 'package:flutter_fruits/fruit-game.dart';

class FlySpawner {
  final FruitGame game;
  final int maxSpawnInterval = 3000;
  final int minSpawnInterval = 250;
  final int intervalChange = 3;
  final int maxFruitsOnScreen = 7;
  int currentInterval;
  int nextSpawn;

  FlySpawner(this.game) {
    start();
    game.spawnFruit();
  }

  void start() {
    cutAll();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void cutAll() {
    game.fruits.forEach((ThrowFruit fruit) => fruit.isDead = true);
  }

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    int fruitsSpawned = 0;
    game.fruits.forEach((ThrowFruit fruit) {
      if (!fruit.isDead) fruitsSpawned += 1;
    });

    if (nowTimestamp >= nextSpawn && fruitsSpawned < maxFruitsOnScreen) {
      game.spawnFruit();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }
}
