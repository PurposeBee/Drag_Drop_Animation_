import 'package:black_jet_mb/constants/colors.dart';
import 'package:black_jet_mb/constants/icons.dart';
import 'package:black_jet_mb/models/guest.dart';
import 'package:black_jet_mb/widgets/bj_icon.dart';
import 'package:flutter/material.dart';

class ChosenSeat extends StatelessWidget {
  final Guest guest;
  final int index;
  final bool isVisible;
  final Function()? onPressed;
  final Function()? onLongPress;

  const ChosenSeat(
      {super.key,
      required this.guest,
      required this.index,
      this.onPressed,
      this.onLongPress,
      this.isVisible = false});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isVisible,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        maintainSemantics: true,
        maintainInteractivity: true,
        child: Stack(children: [
          OutlinedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: guest.updateable
                      ? BJColors.buttonColorActive
                      : BJColors.buttonColorInactive,
                  shape: const CircleBorder(),
                  side: const BorderSide(style: BorderStyle.none)),
              onPressed: onPressed ?? () {},
              onLongPress: guest.updateable ? onLongPress : null,
              child: Text(guest.name.characters.first.toUpperCase(),
                  style: const TextStyle(
                      color: BJColors.buttonTextColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w400))),
          Positioned(
              top: 0,
              right: 0,
              child: CircleAvatar(
                  radius: 7,
                  backgroundColor: BJColors.chipBadgeColor,
                  child: guest is Pets
                      ? const BJIcon(icon: BJIcons.petDark, size: 7)
                      : const Icon(Icons.person, size: 7)))
        ]));
  }
}
