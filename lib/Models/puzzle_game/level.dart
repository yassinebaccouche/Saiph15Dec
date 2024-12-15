import 'package:equatable/equatable.dart';

class Level   {
  final String? title; // column
  final int? score; // row

  const Level({
     this.title,
     this.score,
  });
@override
  String toString() {
    // TODO: implement toString
    return title??"";
  }
  @override
  List<Object?> get props => [title, score];

List<Level> getLevels(){
  return [const Level(title: "Niveau: 1", score: 0),
    const Level(title: "Niveau: 2", score: 200),
    const Level(title: "Niveau: 3", score: 300)];
}
}
