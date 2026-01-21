import 'package:flutter/material.dart';
import 'package:try_my_tracker/core/routes/app_routes.dart';
import 'package:try_my_tracker/core/theme/app_colors.dart';

class WeeklyScheduleScreen extends StatelessWidget {
  const WeeklyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Schedule')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (context, index) {
          final days = [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday',
          ];
          final day = days[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: AppColors.surface,
                child: Text(
                  day[0],
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                day,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Rest Day', // Placeholder
                style: TextStyle(color: AppColors.textHint),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textHint,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.trainingDayDetail,
                  arguments: {
                    'dayName': day,
                    'dayId': 'temp_id_${index}', // Placeholder ID
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
