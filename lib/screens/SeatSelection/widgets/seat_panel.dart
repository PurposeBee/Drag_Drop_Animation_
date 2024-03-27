import 'package:avatar_glow/avatar_glow.dart';
import "dart:math" as math;
import 'package:black_jet_mb/constants/colors.dart';
import 'package:black_jet_mb/constants/icons.dart';
import 'package:black_jet_mb/constants/images.dart';
import 'package:black_jet_mb/core/extensions/list.dart';
import 'package:black_jet_mb/models/guest.dart';
import 'package:black_jet_mb/screens/SeatSelection/widgets/add_person_dialog.dart';
import 'package:black_jet_mb/screens/SeatSelection/widgets/add_pet_dialog.dart';
import 'package:black_jet_mb/screens/SeatSelection/widgets/chosen_seat.dart';
import 'package:black_jet_mb/screens/SeatSelection/widgets/drag_feedback.dart';
import 'package:black_jet_mb/screens/SeatSelection/widgets/lines.dart';
import 'package:black_jet_mb/utils/seat_functions.dart';
import 'package:black_jet_mb/widgets/bj_icon.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class SeatPanel extends StatefulWidget {
  final String journey;
  final String departureDate;
  final String takeOffTime;
  final String landingTime;
  final double screenWidth;
  final int id;
  const SeatPanel(
      {super.key,
      required this.id,
      required this.journey,
      required this.departureDate,
      required this.takeOffTime,
      required this.landingTime,
      required this.screenWidth});

  @override
  State<SeatPanel> createState() => _SeatPanelState();
}

class _SeatPanelState extends State<SeatPanel> with TickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 20))
        ..repeat();
  final GlobalKey _seatingsKey = GlobalKey();
  final GlobalKey _dragFeedbackKey = GlobalKey();
  late final List<GlobalObjectKey> keys = [
    GlobalObjectKey(widget.screenWidth * 0.65 + widget.id),
    GlobalObjectKey(widget.screenWidth * 0.4 + widget.id),
    GlobalObjectKey(widget.screenWidth * 0.23 + widget.id),
    GlobalObjectKey(widget.screenWidth * 0.05 + widget.id),
    GlobalObjectKey(widget.screenWidth * 0.6501 + widget.id),
    GlobalObjectKey(widget.screenWidth * 0.401 + widget.id),
    GlobalObjectKey(widget.screenWidth * 0.2301 + widget.id),
    GlobalObjectKey(widget.screenWidth * 0.0501 + widget.id)
  ];
  late final double lineLength =
      (widget.screenWidth * 0.65 - widget.screenWidth * 0.4);
  static const double seatSize = 35;

  final List<Guest?> guests = <Guest?>[
    null,
    Person(name: 'Michael', phone: '+911234567899', index: 1),
    Person(name: 'Michael', phone: '+911234567899', index: 2),
    Person(name: 'Michael', phone: '+911234567899', index: 3),
    null,
    Person(name: 'Michael', phone: '+911234567899', index: 5),
    null,
    null
  ];
  final persons = <Person>[];
  final pets = <Pets>[];
  final lines = <Widget>[];

  bool isMoving = false;
  bool isAddingPerson = false;
  bool isAddingPet = false;
  bool isDragging = false;
  bool isInitialLoad = true;
  int movingIndex = -1;
  int draggingIndex = -1;
  int draggingChildIndex = -1;
  Offset? dragPosition;
  Guest? selectedPerson;
  Guest? selectedPet;

  void swap(int itemIndex, int swappingIndex,
      {bool isPet = false, int? ownerIndex}) {
    guests[swappingIndex]?.index = itemIndex;
    guests[itemIndex]?.index = swappingIndex;

    final temp = guests[swappingIndex];
    guests[swappingIndex] = guests[itemIndex];
    guests[itemIndex] = temp;

    if (isPet) {
      if (guests[swappingIndex] is Pets && ownerIndex != null) {
        (guests[swappingIndex] as Pets).owner.index = ownerIndex;
      }
      if (guests[ownerIndex ?? -1] is Person) {
        (guests[ownerIndex ?? -1] as Person).pets?.index = swappingIndex;
      }
    }
  }

  void swapItems(int index,
      {bool isDragging = false, int draggingChildIndex = -1}) {
    int updatingIndex = isDragging ? draggingIndex : movingIndex;

    if (guests[index]?.updateable ?? true) {
      
      swap(updatingIndex, index);

      if (draggingChildIndex != -1) {
        Set<int> potentialIndexes =
            neighborMap[guests[index]?.index ?? -1] ?? {};

        for (int potentialIndex in potentialIndexes) {
          if ((guests[potentialIndex] == null ||
                  draggingChildIndex == potentialIndex) &&
              index != potentialIndex) {
            
            swap(draggingChildIndex, potentialIndex,
                isPet: true, ownerIndex: index);

            break;
          }
        }
      }
    }
  }

  void addPerson(int index) async {
    final result = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return AddPersonDialog(index: index);
        });

    if (result is Person) {
      setState(() {
        persons.add(result);
        guests[index] = result;
      });
    }
  }

  void addPet(int index) async {
    final result = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return AddPetDialog(index: index, person: (selectedPerson as Person));
        });

    if (result is Pets) {
      setState(() {
        (selectedPerson as Person).pets = result;
        pets.add(result);
        guests[index] = result;
      });
    }
  }

  void drawLines(Duration duration) {
    Future.delayed(Duration(milliseconds: isInitialLoad ? 900 : 0), () {
      for (Guest? pet in guests) {
        if (pet != null && pet is Pets) {
          final petKey = keys[pet.index ?? -1];
          final ownerKey = keys[pet.owner.index ?? -1];

          var petRenderBox = petKey.currentContext?.findRenderObject();
          var ownerRenderBox = ownerKey.currentContext?.findRenderObject();
          final seatingsRenderBox =
              _seatingsKey.currentContext?.findRenderObject();

          if (petRenderBox != null && ownerRenderBox != null) {
            petRenderBox = petRenderBox as RenderBox;
            ownerRenderBox = ownerRenderBox as RenderBox;
            Offset start = ownerRenderBox.localToGlobal(Offset.zero,
                ancestor: seatingsRenderBox);

            Offset end = petRenderBox.localToGlobal(Offset.zero,
                ancestor: seatingsRenderBox);

            String id = '${pet.owner.name}${pet.name}';

            bool exists =
                lines.any((element) => (element.key as ValueKey).value == id);

            if (!exists) {
              setState(() {
                if (isInitialLoad) {
                  isInitialLoad = false;
                }

                lines.addOrReplace(Lines(
                    key: ValueKey(id),
                    start: Offset(start.dx.abs() + (seatSize / 2),
                        start.dy.abs() + (seatSize / 2)),
                    end: Offset(
                        end.dx.abs() + (seatSize / 2), end.dy + (seatSize / 2)),
                    color: draggingIndex == (pet.owner.index ?? -1)
                        ? Colors.transparent
                        : Colors.white));
              });
            }
          }
        }
      }
    });
  }

  void selectAssignedSeat(Guest guest) {
    if (guest.updateable) {
      if (isMoving && movingIndex == guest.index) {
        setState(() {
          isMoving = false;
          movingIndex = -1;
        });
      } else {
        if (guest is Person) {
          if (selectedPerson == null) {
            setState(() {
              selectedPerson = guest;
              movingIndex = guest.index ?? -1;
            });
          } else {
            setState(() {
              selectedPerson = null;
              movingIndex = -1;
            });
          }
        } else {
          if (selectedPet == null) {
            setState(() {
              selectedPet = guest;
              movingIndex = guest.index ?? -1;
            });
          } else {
            setState(() {
              selectedPet = null;
              movingIndex = -1;
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(drawLines);

    Widget seat(Guest? guest, int index) {
      return Positioned(
          top: isDragging && (draggingIndex == index)
              ? dragPosition?.dy ?? 0
              : index > 3
                  ? 84
                  : 24,
          right: isDragging && (draggingIndex == index)
              ? dragPosition?.dx ?? 0
              : keys[index].value as double,
          child: AnimatedScale(
              scale: movingIndex == (guest?.index ?? -2) ? 1.35 : 1,
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                  key: keys[index],
                  height: seatSize,
                  width: seatSize,
                  child: guest == null ||
                          (isDragging && index == draggingChildIndex)
                      ? !isMoving
                          ? Visibility(
                              visible: isAddingPerson || isAddingPet,
                              maintainState: true,
                              maintainAnimation: true,
                              maintainSize: true,
                              maintainSemantics: true,
                              maintainInteractivity: true,
                              child: DottedBorder(
                                  strokeWidth: 1.5,
                                  borderType: BorderType.Circle,
                                  color: BJColors.buttonBorderLight,
                                  dashPattern: const [3, 3],
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          foregroundColor:
                                              BJColors.buttonColorLight,
                                          shape: const CircleBorder(),
                                          side: const BorderSide(
                                              style: BorderStyle.none)),
                                      onPressed: () => isAddingPerson
                                          ? addPerson(index)
                                          : addPet(index),
                                      child: const Icon(Icons.add))))
                          : AnimatedBuilder(
                              animation: _animationController,
                              builder: (BuildContext context, Widget? child) =>
                                  Transform.rotate(
                                      angle: _animationController.value *
                                          2 *
                                          math.pi,
                                      child: GestureDetector(
                                          onTap: () => swapItems(index),
                                          child: DottedBorder(
                                              strokeWidth: 1.5,
                                              borderType: BorderType.Circle,
                                              color: BJColors.buttonBorderLight,
                                              dashPattern: const [3, 3],
                                              child: Center(
                                                  child:
                                                      AvatarGlow(child: CircleAvatar(backgroundColor: BJColors.buttonColorActive.withOpacity(0.1), radius: 10.0)))))))
                      : Draggable(
                          feedback: guest.updateable ? DragFeedback(key: _dragFeedbackKey, guest: guest, lineLength: lineLength, id: widget.id, guests: guests, position: dragPosition ?? const Offset(0, 0)) : const SizedBox(),
                          onDragStarted: guest.updateable
                              ? () => setState(() {
                                    isMoving = true;
                                    isDragging = true;
                                    draggingIndex = index;
                                    lines.removeWhere((line) =>
                                        ((line.key as ValueKey).value as String)
                                            .contains(guest.name));

                                    if ((guest is Person) &&
                                        guest.pets != null) {
                                      draggingChildIndex =
                                          guest.pets?.index ?? -1;
                                    }
                                  })
                              : null,
                          onDraggableCanceled: (velocity, offset) {
                            setState(() {
                              draggingChildIndex = -1;
                              draggingIndex = -1;
                              movingIndex = -1;
                              isMoving = false;
                              isDragging = false;
                            });

                            lines.clear();
                          },
                          onDragEnd: guest.updateable ? (details) => swapItems(determineIndex(details.offset, widget.screenWidth, widget.id), isDragging: true, draggingChildIndex: draggingChildIndex) : null,
                          onDragUpdate: guest.updateable
                              ? (details) {
                                  setState(() {
                                    dragPosition = details.globalPosition;
                                    if (_dragFeedbackKey.currentState != null) {
                                      (_dragFeedbackKey.currentState
                                              as DragFeedbackState)
                                          .refresh(details.globalPosition);
                                    }
                                  });
                                }
                              : null,
                          child: ChosenSeat(
                              guest: guest,
                              index: index,
                              onPressed: () => selectAssignedSeat(guest),
                              isVisible: !isDragging || (isDragging && draggingChildIndex != index),
                              onLongPress: () {
                                setState(() {
                                  isMoving = true;
                                  movingIndex = guest.index ?? -1;
                                });
                              })))));
    }

    //Travell Details
    final Widget travelDetails = Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.journey,
                    style: const TextStyle(
                        fontSize: 16,
                        color: BJColors.textColor,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Row(children: [
                  const BJIcon(icon: BJIcons.plane, size: 14),
                  const SizedBox(width: 3),
                  Text(widget.takeOffTime,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: BJColors.textColor)),
                  const SizedBox(width: 10),
                  const BJIcon(icon: BJIcons.plane, size: 14),
                  const SizedBox(width: 3),
                  Text(widget.landingTime,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: BJColors.textColor))
                ]),
                Container(
                    width: 40,
                    height: 1,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        color: BJColors.dividerColor,
                        borderRadius: BorderRadius.circular(5)))
              ]),
              Text(widget.departureDate,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: BJColors.fadedTextColor))
            ]));

    //Passenger Chips
    final Widget passengerChips = Row(children: [
      Container(
          width: 110,
          height: 30,
          margin: const EdgeInsets.only(left: 16, right: 8),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: BJColors.buttonColorLight),
                  foregroundColor: isAddingPerson
                      ? BJColors.buttonColorDark
                      : BJColors.buttonColorLight,
                  backgroundColor:
                      isAddingPerson ? BJColors.buttonColorLight : null,
                  padding: EdgeInsets.zero),
              onPressed: () {
                if (selectedPerson == null) {
                  setState(() {
                    isAddingPerson = !isAddingPerson;
                    isAddingPet = false;
                  });
                } else {
                  setState(() {
                    guests[selectedPerson?.index ?? -1] = null;
                    lines.clear();
                    persons.remove(selectedPerson);
                    selectedPerson = null;
                  });
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: 60,
                        child: Text(
                            selectedPerson != null
                                ? selectedPerson?.name ?? ''
                                : 'Add Guest',
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis)),
                    selectedPerson == null
                        ? isAddingPerson || persons.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: isAddingPerson
                                        ? BJColors.chipActiveBadgeColor
                                        : BJColors.chipInactiveBadgeColor,
                                    shape: BoxShape.circle),
                                child: Text(persons.length.toString(),
                                    style: const TextStyle(fontSize: 12)))
                            : const Icon(Icons.add, size: 12)
                        : Icon(Icons.close,
                            size: 12,
                            color: isAddingPerson ? Colors.black : Colors.white)
                  ]))),
      SizedBox(
          width: 110,
          height: 30,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: BJColors.buttonColorLight),
                  foregroundColor: isAddingPet
                      ? BJColors.buttonColorDark
                      : BJColors.buttonColorLight,
                  backgroundColor:
                      isAddingPet ? BJColors.buttonColorLight : null,
                  padding: EdgeInsets.zero),
              onPressed: () {
                if (selectedPet == null) {
                  if (selectedPerson != null) {
                    setState(() {
                      isAddingPet = !isAddingPet;
                      isAddingPerson = false;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Row(children: [
                          Icon(Icons.info, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Select a person')
                        ]),
                        backgroundColor: Colors.red.withOpacity(0.5)));
                  }
                } else {
                  setState(() {
                    guests[selectedPet?.index ?? -1] = null;
                    pets.remove(selectedPet);
                    lines.clear();
                    selectedPet = null;
                  });
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(children: [
                      BJIcon(
                          icon: isAddingPet ? BJIcons.petDark : BJIcons.petIcon,
                          size: 16),
                      const SizedBox(width: 5),
                      Text(
                          selectedPet != null
                              ? selectedPet?.name ?? ''
                              : 'Add Pet',
                          style: const TextStyle(fontSize: 12))
                    ]),
                    selectedPet == null
                        ? isAddingPet || pets.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: isAddingPet
                                        ? BJColors.chipActiveBadgeColor
                                        : BJColors.chipInactiveBadgeColor,
                                    shape: BoxShape.circle),
                                child: Text(pets.length.toString()))
                            : const Icon(Icons.add, size: 12)
                        : const Icon(Icons.close, size: 12, color: Colors.black)
                  ])))
    ]);

    //Seatings UI
    final Widget seatings = SizedBox(
        key: _seatingsKey,
        height: 145,
        child: Stack(children: [
          Image.asset(BJImages.seats, height: 145),
          ...lines,
          seat(guests[0], 0),
          seat(guests[1], 1),
          seat(guests[2], 2),
          seat(guests[3], 3),
          seat(guests[4], 4),
          seat(guests[5], 5),
          seat(guests[6], 6),
          seat(guests[7], 7)
        ]));

    return SizedBox(
        child: Column(children: [
      travelDetails,
      const SizedBox(height: 25),
      passengerChips,
      const SizedBox(height: 16),
      seatings,
      const SizedBox(height: 16)
    ]));
  }
}
