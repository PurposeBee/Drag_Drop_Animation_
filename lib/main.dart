import 'package:black_jet_mb/screens/SeatSelection/seat_selection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BlackJet());
}

class BlackJet extends StatelessWidget {
  const BlackJet({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Black Jet',
        home: SeatSelection());
  }
}
