import '../Models/memory_game.dart';
import '../services/memory_game_service.dart';

class MemoryGameController {
  final MemoryGameService _gameService = MemoryGameService();

  Future<void> createUserGame(String user) async {
    await _gameService.createUserGame(user);
  }

  Stream<List<MemoryGame>> fetchGames() {
    return _gameService.fetchGames();
  }

  Stream<MemoryGame?> getGameByUser(String user) {
    return _gameService.fetchGameByUser(user);
  }


  Future<void> setGameCompleted(String userEmail) {
    return _gameService.setGameCompleted(userEmail);
  }

  Future<void> updateGame(String userEmail, int score, int level, String difficulty) async {
    await _gameService.updateGame(userEmail, score, level, difficulty);
  }

  Future<void> updateTotalScore(String userEmail, int pointsToAdd) async {
    await _gameService.updateTotalScore(userEmail, pointsToAdd);
  }

  Future<void> resetGame (String id) async {
    await _gameService.resetGame(id);
  }

}