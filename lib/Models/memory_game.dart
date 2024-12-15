class MemoryGame {
  String id;
  int score;
  int level;
  String difficulty;
  String user;
  bool completed;

  MemoryGame({
    this.id='',
    required this.score,
    required this.level,
    required this.difficulty,
    required this.user,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
    'id':id,
    'score':score,
    'level':level,
    'difficulty':difficulty,
    'user':user,
    'completed':completed,
  };

  static MemoryGame fromJson(Map<String,dynamic> json) => MemoryGame (
    id: json['id'],
    score: json['score'],
    level: json['level'],
    difficulty: json['difficulty'],
    user: json['user'],
    completed: json['completed'],
  );
}