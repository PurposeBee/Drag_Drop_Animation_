import 'package:black_jet_mb/models/guest.dart';
import 'package:black_jet_mb/screens/SeatSelection/widgets/chosen_seat.dart';
import 'package:black_jet_mb/screens/SeatSelection/widgets/lines.dart';
import 'package:black_jet_mb/utils/seat_functions.dart';
import 'package:flutter/material.dart';

class DragFeedback extends StatefulWidget {
  final int id;
  final Guest guest;
  final List<Guest?> guests;
  final Offset position;
  final double lineLength;
  final int? draggingChildIndex;
  const DragFeedback(
      {super.key,
      required this.id,
      required this.guest,
      required this.guests,
      required this.lineLength,
      required this.position,
      this.draggingChildIndex});

  @override
  State<DragFeedback> createState() => DragFeedbackState();
}

class DragFeedbackState extends State<DragFeedback> {
  Person? person;
  Pets? pets;

  late Offset position = widget.position;

  @override
  void initState() {
    super.initState();

    if (widget.guest is Person) {
      person = widget.guest as Person;
    }

    if (widget.guest is Pets) {
      pets = widget.guest as Pets;
    }
  }

  void refresh(Offset offset) {
    setState(() {
      position = offset;
    });
  }

  Offset snapItemPosition(
      int parentIndex, int childIndex, double screenWidth, bool isEnd) {
    bool isVertical = checkVertical(parentIndex, childIndex);

    if (!isVertical && isEnd) {
      return Offset(
          parentIndex > childIndex
              ? -(widget.lineLength - 50)
              : (widget.lineLength - 40),
          20);
    }

    if (isVertical && isEnd) {
      return Offset(-16,
          parentIndex > childIndex ? -widget.lineLength : widget.lineLength);
    }

    if (!isVertical && !isEnd) {
      return Offset(parentIndex > childIndex ? 25 : 0, 20);
    }

    if (isVertical && !isEnd) {
      return const Offset(-16, 40);
    }

    return const Offset(20, 20);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int parentIndex = determineIndex(position, screenWidth, widget.id);
    int childIndex = determineChildIndex(
        widget.guests, parentIndex, widget.draggingChildIndex ?? -1);

    return SizedBox(
        height: 150,
        width: 500,
        child: Stack(children: [
          if (person != null && person!.pets != null)
            Positioned(
                left: widget.lineLength - 39,
                child: Lines(
                    start: snapItemPosition(
                        parentIndex, childIndex, screenWidth, false),
                    end: snapItemPosition(
                        parentIndex, childIndex, screenWidth, true),
                    color: Colors.white)),
          if (person != null && person!.pets != null)
            Positioned(
                top: checkVertical(parentIndex, childIndex)
                    ? parentIndex > childIndex
                        ? -(widget.lineLength - 30)
                        : (widget.lineLength - 30)
                    : 0,
                left: checkVertical(parentIndex, childIndex)
                    ? 0
                    : parentIndex > childIndex
                        ? -(widget.lineLength - 80)
                        : (widget.lineLength - 10),
                child: ChosenSeat(
                    guest: widget.guests[person?.pets?.index ?? -1]!,
                    index: person?.pets?.index ?? -1,
                    isVisible: true)),
          Container(
            margin: parentIndex > childIndex
                ? const EdgeInsets.only(left: 60)
                : null,
            child: ChosenSeat(
                guest: widget.guest,
                index: widget.guest.index ?? -1,
                isVisible: true),
          )
        ]));
  }
}
