import 'package:flutter/material.dart';
import '../widgets/drink_card.dart';
import '../widgets/cafe_card.dart';
import '../models/cafe.dart';
import '../models/drink.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';

class DrinksPage extends StatefulWidget {
  @override
  _DrinksPageState createState() => _DrinksPageState();
}

class _DrinksPageState extends State<DrinksPage> {
  late Future<List<Cafe>> _cafes;
  late Future<List<Drink>> _drinks;
  String _searchQuery = '';
  String _selectedFilter = 'sugar_asc';

  @override
  void initState() {
    super.initState();
    final apiService = Provider.of<ApiService>(context, listen: false);
    _cafes = apiService.fetchCafes();
    _drinks = apiService.fetchFilteredDrinks(_selectedFilter);
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      final apiService = Provider.of<ApiService>(context, listen: false);
      _drinks = apiService.fetchFilteredDrinks(filter);
    });
  }

  void _searchDrinks(String query) {
    setState(() {
      _searchQuery = query;
      final apiService = Provider.of<ApiService>(context, listen: false);
      _drinks = apiService.searchDrinks(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('음료'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _applyFilter,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'sugar_asc', child: Text('당 함량 낮은 순')),
                PopupMenuItem(value: 'sugar_desc', child: Text('당 함량 높은 순')),
                PopupMenuItem(value: 'calories_asc', child: Text('칼로리 낮은 순')),
                PopupMenuItem(value: 'calories_desc', child: Text('칼로리 높은 순')),
              ];
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: '음료 이름 검색',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: _searchDrinks,
          ),
          Expanded(
            child: FutureBuilder<List<Cafe>>(
              future: _cafes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No cafes found'));
                } else {
                  return ListView(
                    children: snapshot.data!
                        .map((cafe) => CafeCard(cafe: cafe))
                        .toList(),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Drink>>(
              future: _drinks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No drinks found'));
                } else {
                  return ListView(
                    children: snapshot.data!.map((drink) =>
                        DrinkCard(drink: drink)).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
