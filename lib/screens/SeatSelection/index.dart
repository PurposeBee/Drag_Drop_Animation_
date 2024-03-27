import 'package:black_jet_mb/constants/colors.dart';
import 'package:black_jet_mb/screens/SeatSelection/widgets/seat_panel.dart';
import 'package:black_jet_mb/widgets/large_button.dart';
import 'package:flutter/material.dart';

class SeatSelection extends StatelessWidget {
  const SeatSelection({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: BJColors.backgroundColor,
        appBar: AppBar(
            backgroundColor: BJColors.backgroundColor,
            leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back_ios,
                    color: BJColors.iconColor)),
            title: const Text('Seat Selection',
                style: TextStyle(color: BJColors.textColor)),
            centerTitle: true),
        body: SingleChildScrollView(
            child: Column(children: [
          SeatPanel(
              id: 1,
              screenWidth: screenWidth,
              journey: "Sydney to Melbourne",
              departureDate: "Mon, 21st Nov",
              takeOffTime: "11:15 AM",
              landingTime: "1:15 PM"),
          const Divider(color: BJColors.dividerColor),
          SeatPanel(
              id: 2,
              screenWidth: screenWidth,
              journey: "Melbourne to Sydney",
              departureDate: "Mon, 28st Nov",
              takeOffTime: "11:15 AM",
              landingTime: "1:15 PM")
        ])),
        bottomNavigationBar: const LargeButton(label: "Continue"));
  }
}
