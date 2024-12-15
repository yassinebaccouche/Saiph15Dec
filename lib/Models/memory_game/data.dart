import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';

List<String> imageSource() {
  return [
    'assets/images/image_1.png',
    'assets/images/image_2.png',
    'assets/images/image_3.png',
    'assets/images/image_4.png',
    'assets/images/image_5.png',
    'assets/images/image_6.png',
    'assets/images/image_7.png',
    'assets/images/image_8.png',
    'assets/images/image_9.png',
    'assets/images/image_10.png',
    'assets/images/image_11.png',
    'assets/images/image_12.png',
  ];
}

List<String> createShuffledListFromImageSource(int i) {
  List<String> shuffledImages = [];
  List<String> sourceArray = imageSource();

  int count = 0;
  int limit = (i * 4) ~/ 2;
  for (var element in sourceArray) {
    if (count < limit) {
      shuffledImages.add(element);
      shuffledImages.add(element);
      count++;
    } else {
      break;
    }
  }

  shuffledImages.shuffle();
  return shuffledImages;
}


List<bool> getInitialItemStateList(int i) {
  List<bool> initialItem = <bool>[];
  int limit=4*i;
  for (int i = 0; i < limit; i++) {
    initialItem.add(true);
  }
  return initialItem;
}

List<GlobalKey<FlipCardState>> createFlipCardStateKeysList(int i) {
  List<GlobalKey<FlipCardState>> cardStateKeys = <GlobalKey<FlipCardState>>[];
  int limit=4*i;
  for (int i = 0; i < limit; i++) {
    cardStateKeys.add(GlobalKey<FlipCardState>());
  }
  return cardStateKeys;
}
