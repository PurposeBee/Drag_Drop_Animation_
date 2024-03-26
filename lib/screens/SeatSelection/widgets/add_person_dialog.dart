import 'package:black_jet_mb/constants/colors.dart';
import 'package:black_jet_mb/constants/icons.dart';
import 'package:black_jet_mb/models/guest.dart';
import 'package:black_jet_mb/widgets/bj_icon.dart';
import 'package:black_jet_mb/widgets/large_button.dart';
import 'package:flutter/material.dart';

class AddPersonDialog extends StatefulWidget {
  final int index;
  const AddPersonDialog({super.key, required this.index});

  @override
  State<AddPersonDialog> createState() => _AddPersonDialogState();
}

class _AddPersonDialogState extends State<AddPersonDialog> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        backgroundColor: BJColors.dialogBackgroundColor,
        surfaceTintColor: BJColors.dialogBackgroundColor,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const BJIcon(icon: BJIcons.personTicket, size: 24),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: IconButton.styleFrom(padding: EdgeInsets.zero),
              icon: const Icon(Icons.close, color: BJColors.iconColor))
        ]),
        titlePadding: const EdgeInsets.all(14.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        insetPadding: const EdgeInsets.all(20),
        children: [
          const Text('Guest Name',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: BJColors.textColor)),
          Container(
              margin: const EdgeInsets.only(top: 4, bottom: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: BJColors.textFieldColor),
              child: TextField(
                  controller: nameController,
                  onChanged: (value) => setState(() {}),
                  style:
                      const TextStyle(color: BJColors.textColor, fontSize: 14),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(13, 10, 13, 10),
                      hintText: "Enter your guest's full name",
                      hintStyle: TextStyle(
                          color: BJColors.textFieldHintColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      border: InputBorder.none))),
          const Text('Mobile Phone',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: BJColors.textColor)),
          Container(
              margin: const EdgeInsets.only(top: 4, bottom: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: BJColors.textFieldColor),
              child: TextField(
                  controller: phoneController,
                  onChanged: (value) => setState(() {}),
                  style:
                      const TextStyle(color: BJColors.textColor, fontSize: 14),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(13, 10, 13, 10),
                      hintText: "Enter your guest's phone number",
                      hintStyle: TextStyle(
                          color: BJColors.textFieldHintColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      border: InputBorder.none))),
          LargeButton(
              label: 'Add Guest',
              enabled: nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty,
              onPressed: () {
                Navigator.pop(
                    context,
                    Person(
                        name: nameController.text,
                        phone: phoneController.text,
                        index: widget.index,
                        updateable: true));
              }),
          const SizedBox(height: 25)
        ]);
  }
}
