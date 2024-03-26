import 'package:black_jet_mb/constants/colors.dart';
import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final Function()? onPressed;
  final String label;
  final bool? enabled;
  const LargeButton(
      {super.key, required this.label, this.onPressed, this.enabled});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        height: 52,
        width: screenWidth * .8,
        margin: const EdgeInsets.fromLTRB(8, 12, 8, 12),
        child: ElevatedButton(
            onPressed: (enabled ?? true) ? onPressed ?? () {} : () {},
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                backgroundColor: BJColors.buttonColorLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
            child: Text(label,
                style: TextStyle(
                    color: (enabled ?? true)
                        ? BJColors.buttonTextColorDark
                        : BJColors.buttonTextColorInactive))));
  }
}
