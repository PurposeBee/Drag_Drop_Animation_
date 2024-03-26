import 'package:black_jet_mb/constants/colors.dart';
import 'package:black_jet_mb/constants/icons.dart';
import 'package:black_jet_mb/core/extensions/list.dart';
import 'package:black_jet_mb/models/guest.dart';
import 'package:black_jet_mb/widgets/bj_icon.dart';
import 'package:black_jet_mb/widgets/large_button.dart';
import 'package:flutter/material.dart';

class AddPetDialog extends StatefulWidget {
  final int index;
  final Person person;
  const AddPetDialog({super.key, required this.person, required this.index});

  @override
  State<AddPetDialog> createState() => _AddPetDialogState();
}

class _AddPetDialogState extends State<AddPetDialog> {
  final pets = <Pet>[
    Pet(name: "Banjo", type: 'Dog', breed: "Jack Russel"),
    Pet(name: "Bruce", type: "Dog", breed: "Poodle")
  ];

  final selectedPets = <Pet>[];

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        backgroundColor: BJColors.dialogBackgroundColor,
        surfaceTintColor: BJColors.dialogBackgroundColor,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const BJIcon(icon: BJIcons.petTicket, size: 24),
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
          const Text('Select Pets',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: BJColors.textColor)),
          SizedBox(
              width: 350,
              height: 150,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: pets.length,
                  itemBuilder: (BuildContext context, int index) {
                    final pet = pets[index];

                    return Container(
                        height: 150,
                        width: 150,
                        margin: const EdgeInsets.only(top: 8, right: 28),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: selectedPets.contains(pet)
                                    ? BJColors.toggleButtonActive
                                    : BJColors.toggleButtonInactive,
                                foregroundColor: BJColors.textColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: () {
                              setState(() {
                                selectedPets.addOrRemove(pet);
                              });
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 150),
                                  CircleAvatar(
                                      radius: 32,
                                      backgroundColor: const Color(0xFFB3B3B3),
                                      child: Text(
                                          pet.name.characters.first
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.black))),
                                  const SizedBox(height: 8),
                                  Text(pet.name,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)),
                                  Text(pet.breed,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400))
                                ])));
                  })),
          const SizedBox(height: 24),
          const Text(
              'Owners are welcome to hold one pet weighing up to 9kg on their lap. For pets exceeding this weight, the purchase of a Pet Pass is required, reserving a dedicated seat beside their guardian for the entire trip. Additionally, all pets must wear a harness secured by a quick-release leash.',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: BJColors.fadedTextColor, fontWeight: FontWeight.w400)),
          const SizedBox(height: 15),
          RichText(
              text: const TextSpan(children: [
            TextSpan(
                style: TextStyle(
                    color: BJColors.fadedTextColor,
                    fontWeight: FontWeight.w400),
                text:
                    "To respect current reservations, we'll check with existing members about having pets on this flight. If there are no objections within "),
            TextSpan(
                text: '1 hour of your booking request',
                style: TextStyle(
                    color: Color(0xFFFDA3FF), fontWeight: FontWeight.w400)),
            TextSpan(
                style: TextStyle(
                    color: BJColors.fadedTextColor,
                    fontWeight: FontWeight.w400),
                text: ''', we'll confirm your pet-accommodated 
        booking. Assistance Animals bypass this step and are confirmed immediately.''')
          ])),
          const SizedBox(height: 25),
          Align(
              alignment: Alignment.centerRight,
              child: RichText(
                  text: const TextSpan(children: [
                TextSpan(
                  text: "You may refer to our ",
                  style: TextStyle(
                      color: BJColors.fadedTextColor,
                      fontWeight: FontWeight.w400),
                ),
                TextSpan(
                    text: "Animal Policy",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: BJColors.fadedTextColor,
                        fontWeight: FontWeight.w400))
              ]))),
          LargeButton(
              label: 'Select',
              enabled: selectedPets.isNotEmpty,
              onPressed: () {
                String name = '';
                for (var element in selectedPets) {
                  name += element.name +
                      (selectedPets.indexOf(element) == selectedPets.length - 1
                          ? ''
                          : ', ');
                }
                Navigator.pop(
                    context,
                    Pets(
                        name: name,
                        owner: widget.person,
                        index: widget.index,
                        pets: selectedPets,
                        updateable: true));
              }),
          const SizedBox(height: 25)
        ]);
  }
}
