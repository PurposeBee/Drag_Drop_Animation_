import 'package:black_jet_mb/models/guest.dart';
import 'package:flutter/material.dart';

const neighborMap = {
    0: {1, 4},
    1: {0, 2, 5},
    2: {1, 3, 6},
    3: {2, 7},
    4: {0, 5},
    5: {4, 6, 1},
    6: {5, 2, 7},
    7: {3, 6}
  };

bool checkVertical(int parentIndex, int childIndex) {
  return [0, 1, 2, 3].contains(parentIndex) &&
      [4, 5, 6, 7].contains(childIndex);
}

int determineChildIndex(List<Guest?> guests, int parentIndex, int draggingChildIndex) {
  for (int potentialIndex in neighborMap[parentIndex] ?? {}) {
    if (guests[potentialIndex] == null ||
        draggingChildIndex == potentialIndex) {
      return potentialIndex;
    }
  }

  return -1;
}

int determineIndex(Offset position, double screenWidth, int widgetId) {
  double averageWidth = screenWidth / 4;
  double dx = position.dx;
  double dy = position.dy;
  List<double> intervals = [
    screenWidth * .3,
    averageWidth * 2,
    averageWidth * 3,
    averageWidth * 4
  ];

  bool isTop = (widgetId == 1) ? dy > 240 && dy < 286 : dy > 550 && dy < 620;
  bool isFirst = dx < intervals[0];
  bool isSecond = dx < intervals[1] && dx >= intervals[0];
  bool isThird = dx < intervals[2] && dx >= intervals[1];
  bool isFourth = dx > intervals[2];

  int index = -1;

  if (isTop) {
    if (isFirst) index = 0;
    if (isSecond) index = 1;
    if (isThird) index = 2;
    if (isFourth) index = 3;
  } else {
    if (isFirst) index = 4;
    if (isSecond) index = 5;
    if (isThird) index = 6;
    if (isFourth) index = 7;
  }

  return index;
}
