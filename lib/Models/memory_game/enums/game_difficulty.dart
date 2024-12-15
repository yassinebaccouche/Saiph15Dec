enum GameDifficulty {
  FACILE, MOYEN, DIFFICILE
}

extension GameDifficultyExtension on GameDifficulty {
  String get displayName {
    switch (this) {
      case GameDifficulty.FACILE:
        return 'Facile';
      case GameDifficulty.MOYEN:
        return 'Moyen';
      case GameDifficulty.DIFFICILE:
        return 'Difficile';
      default:
        throw Exception('Invalid difficulty level');
    }
  }
}
