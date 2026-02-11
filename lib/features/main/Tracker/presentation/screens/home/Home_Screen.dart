import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_my_tracker/core/di/injection_container.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/blocs/home/home_bloc.dart';
import 'package:try_my_tracker/features/main/Tracker/presentation/screens/home/widgets/Home_Screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => sl<HomeBloc>()..add(LoadHomeData()),
          child: const HomeScreenBody(),
        ),
      ),
    );
  }
}
