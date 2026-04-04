import 'package:flutter/material.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/home/widgets/Home_Screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: HomeScreenBody(),
      ),
    );
  }
}
