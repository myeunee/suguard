import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../models/cafe.dart';
import '../services/api_service.dart';
import '../widgets/drink_card.dart';
import 'package:provider/provider.dart';

class CafeHomePage extends StatefulWidget {
  final int cafeId;

  CafeHomePage({required this.cafeId});

  @override
  _CafeHomePageState createState() => _CafeHomePageState();
}

class _CafeHomePageState extends State<CafeHomePage> {
  late Future<List<Drink>> _drinks;
  late Future<List<Drink>> _likedDrinks;
  late Future<Cafe> _cafe;

  @override
  void initState() {
    super.initState();
    final apiService = Provider.of<ApiService>(context, listen: false);
    _drinks = apiService.fetchDrinksByCafe(widget.cafeId);
    _likedDrinks = apiService.fetchLikedDrinksByCafe(widget.cafeId); // 좋아요한 음료를 불러오는 로직 추가
    _cafe = apiService.fetchCafe(widget.cafeId);
  }

  void _searchDrinks(String query) {
    setState(() {
      final apiService = Provider.of<ApiService>(context, listen: false);
      _drinks = apiService.searchDrinksByCafe(widget.cafeId, query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Drinks'),
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
            child: FutureBuilder<Cafe>(
              future: _cafe,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('Cafe not found'));
                } else {
                  return Column(
                    children: [
                      Text(snapshot.data!.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('좋아요한 음료', style: TextStyle(fontSize: 20)),
                      Expanded(
                        child: FutureBuilder<List<Drink>>(
                          future: _likedDrinks,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child: Text('No liked drinks found'));
                            } else {
                              return ListView(
                                children: snapshot.data!.map((drink) => DrinkCard(drink: drink)).toList(),
                              );
                            }
                          },
                        ),
                      ),
                      Text('전체 음료', style: TextStyle(fontSize: 20)),
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
                                children: snapshot.data!.map((drink) => DrinkCard(drink: drink)).toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
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
