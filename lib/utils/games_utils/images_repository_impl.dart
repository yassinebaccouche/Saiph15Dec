import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import '../../Models/puzzle_game/puzzle_image.dart';
import 'images_repository.dart';
const puzzleOptions = <PuzzleImage>[

  PuzzleImage(
    name: 'medical',
    assetPath: 'assets/images/adol1.png',
  ),
  PuzzleImage(
    name: 'first',
    assetPath: 'assets/images/adol2.png',
  ),PuzzleImage(
    name: 'drugs',
    assetPath: 'assets/images/adol3.png',
  ),PuzzleImage(
    name: 'medicine',
    assetPath: 'assets/images/adol4.png',
  )

];

Future<Image> decodeAsset(ByteData bytes) async {
  return decodeImage(
    bytes.buffer.asUint8List(),
  )!;
}

class SPlitData {
  final Image image;
  final int crossAxisCount;

  SPlitData(this.image, this.crossAxisCount);
}

Future<List<Uint8List>> splitImage(SPlitData data) {
  final image = data.image;
  final crossAxisCount = data.crossAxisCount;
  final int length = (image.width / crossAxisCount).round();
  List<Uint8List> pieceList = [];

  for (int y = 0; y < crossAxisCount; y++) {
    for (int x = 0; x < crossAxisCount; x++) {
      pieceList.add(
        Uint8List.fromList(
          encodePng(
            copyCrop(
              image,
              x: x * length,
              y: y * length,
              width: length,
              height: length,
            ),
          ),
        ),
      );
    }
  }
  return Future.value(pieceList);
}

class ImagesRepositoryImpl implements ImagesRepository {
  Map<String, Image> cache = {};

  @override
  Future<List<Uint8List>> split(String asset, int crossAxisCount) async {
    late Image image;
    if (cache.containsKey(asset)) {
      image = cache[asset]!;
    } else {
      final bytes = await rootBundle.load(asset);

      /// use compute because theimage package is a pure dart package
      /// so to avoid bad ui performance we do this task in a different
      /// isolate
      image = await compute(decodeAsset, bytes);

      final width = math.min(image.width, image.height);

      /// convert to square
      image = copyResizeCropSquare(image, size: width);
      cache[asset] = image;
    }

    final pieces = await compute(
      splitImage,
      SPlitData(image, crossAxisCount),
    );

    return pieces;
  }
}
