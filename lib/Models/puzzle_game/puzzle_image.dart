import 'package:equatable/equatable.dart';

class PuzzleImage extends Equatable {
  final String name;
  final String assetPath;

  const PuzzleImage({
    required this.name,
    required this.assetPath,
  });

  @override
  List<Object?> get props => [
        name,
        assetPath,
      ];
}
