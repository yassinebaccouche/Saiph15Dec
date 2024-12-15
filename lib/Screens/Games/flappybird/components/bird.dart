import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:mysaiph/Screens/Games/flappybird/game/bird_movement.dart';
import 'package:mysaiph/Screens/Games/flappybird/game/assets.dart';
import 'package:mysaiph/Screens/Games/flappybird/game/configuration.dart';
import 'package:mysaiph/Screens/Games/flappybird/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;

  @override
  Future<void> onLoad() async {
    // Ensure proper initialization of sprites
    sprites = {
      BirdMovement.middle: await gameRef.loadSprite(Assets.birdMidFlap),
      BirdMovement.up: await gameRef.loadSprite(Assets.birdUpFlap),
      BirdMovement.down: await gameRef.loadSprite(Assets.birdDownFlap),
    };

    // Set initial position and state
    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    current = BirdMovement.middle;

    // Add a collision hitbox
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity effect
    position.y += Config.birdVelocity * dt;

    // Check if the bird is flying too high
    if (position.y < 1) {
      gameOver();
    }
  }

  void fly() {
    if (sprites != null && current != null) {
      // Apply a flying effect with movement and audio
      add(
        MoveByEffect(
          Vector2(0, Config.gravity),
          EffectController(duration: 0.2, curve: Curves.decelerate),
          onComplete: () => current = BirdMovement.down,
        ),
      );
      FlameAudio.play(Assets.flying);
      current = BirdMovement.up;
    } else {
      debugPrint('Sprites not initialized or current state is null.');
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);

    // Handle collisions with obstacles
    gameOver();
  }

  void reset() {
    // Reset bird position and score
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    score = 0;
    current = BirdMovement.middle;
  }

  void gameOver() {
    // Play collision sound and show game over screen
    FlameAudio.play(Assets.collision);
    game.isHit = true;
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
  }
}
