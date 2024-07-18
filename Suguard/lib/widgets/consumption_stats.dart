import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ConsumptionStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final userId = auth.user?.id ?? 0;
    final String baseUrl = "http://192.168.35.223:8000"; // 로컬 baseUrl
    final ApiService _apiService = ApiService(baseUrl: baseUrl);

    return FutureBuilder<Map<String, dynamic>>(
      future: _apiService.fetchConsumptionStats(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No stats available'));
        } else {
          final stats = snapshot.data!;
          return Column(
            children: [
              Text("Today's Sugar Intake: ${stats['total_sugar_intake'] ?? 'N/A'}g"),
              Text("Today's Sodium Intake: ${stats['total_sodium_intake'] ?? 'N/A'}mg"),
              Text("Today's Calories Intake: ${stats['total_calorie_intake'] ?? 'N/A'}kcal"),
            ],
          );
        }
      },
    );
  }
}
