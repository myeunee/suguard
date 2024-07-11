import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class DrinkDetailPage extends StatelessWidget {
  final int drinkId;

  DrinkDetailPage({required this.drinkId});

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder<Drink>(
      future: apiService.fetchDrink(drinkId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Drink Details'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Drink Details'),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Drink Details'),
            ),
            body: Center(child: Text('No drink found')),
          );
        } else {
          final drink = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(drink.name),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.network(drink.imageUrl)),
                  SizedBox(height: 16),
                  Text('Name: ${drink.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Cafe ID: ${drink.cafeId}', style: TextStyle(fontSize: 16)),
                  Text('Sugar: ${drink.sugarContent}g', style: TextStyle(fontSize: 16)),
                  Text('Sodium: ${drink.sodiumContent}mg', style: TextStyle(fontSize: 16)),
                  Text('Calories: ${drink.calories}kcal', style: TextStyle(fontSize: 16)),
                  Text('Volume: ${drink.volume}ml', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await apiService.recordConsumption(authService.user!.id, drink.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recorded consumption!')));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to record consumption')));
                        }
                      },
                      child: Text('Drink Today'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
