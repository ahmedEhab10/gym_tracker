import 'package:flutter/material.dart';
import 'package:try_my_tracker/features/Tracker/presentation/screens/home/widgets/Home_Screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: HomeScreenBody()));
  }
}
