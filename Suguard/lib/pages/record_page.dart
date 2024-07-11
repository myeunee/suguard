import 'package:flutter/material.dart';
import '../widgets/consumption_stats.dart';
import '../services/api_service.dart';
import '../models/drink.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('기록'),
          bottom: TabBar(
            tabs: [
              Tab(text: '오늘'),
              Tab(text: '주간'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TodayConsumption(),
            WeeklyConsumption(),
          ],
        ),
      ),
    );
  }
}

class TodayConsumption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConsumptionStats(),
        Expanded(child: DrinksList(date: 'today')),
      ],
    );
  }
}

class WeeklyConsumption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: WeeklyStatsChart(),
        ),
        Expanded(
          child: WeeklySummaryStats(),
        ),
      ],
    );
  }
}

class DrinksList extends StatelessWidget {
  final String date;

  DrinksList({required this.date});

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final userId = Provider.of<AuthService>(context, listen: false).user!.id;

    return FutureBuilder<List<Drink>>(
      future: apiService.fetchDrinksByDate(userId, date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No drinks found'));
        } else {
          return ListView(
            children: snapshot.data!.map((drink) {
              return ListTile(
                leading: Image.network(drink.imageUrl),
                title: Text(drink.name),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class ConsumptionStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final userId = auth.user?.id ?? 0;
    final ApiService _apiService = Provider.of<ApiService>(context);

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

class WeeklyStatsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final userId = Provider.of<AuthService>(context, listen: false).user!.id;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: apiService.fetchWeeklySugarIntake(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No stats available'));
        } else {
          final data = snapshot.data!;
          final chartData = data.map((dayData) {
            return BarData(dayData['day'], dayData['sugar_intake']);
          }).toList();

          List<charts.Series<BarData, String>> series = [
            charts.Series(
              id: 'Sugar Intake',
              data: chartData,
              domainFn: (BarData bar, _) => bar.day,
              measureFn: (BarData bar, _) => bar.sugar,
            ),
          ];

          return Container(
            height: 300, // 차트의 높이를 명확히 지정합니다.
            child: charts.BarChart(
              series,
              animate: true,
            ),
          );
        }
      },
    );
  }
}

class WeeklySummaryStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final userId = Provider.of<AuthService>(context, listen: false).user!.id;

    return FutureBuilder<Map<String, dynamic>>(
      future: apiService.fetchConsumptionStats(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No stats available'));
        } else {
          final stats = snapshot.data!;
          return Column(
            children: [
              Text("Total Sugar Intake: ${stats['total_sugar_intake'] ?? 'N/A'}g"),
              Text("Daily Average Sugar Intake: ${stats['daily_average_sugar_intake'] ?? 'N/A'}g"),
              Text("Daily Average Drinks: ${stats['daily_average_drinks'] ?? 'N/A'}"),
              Text("Total Calories Intake: ${stats['total_calorie_intake'] ?? 'N/A'}kcal"),
              Text("Total Sodium Intake: ${stats['total_sodium_intake'] ?? 'N/A'}mg"),
            ],
          );
        }
      },
    );
  }
}

class BarData {
  final String day;
  final double sugar;

  BarData(this.day, this.sugar);
}
