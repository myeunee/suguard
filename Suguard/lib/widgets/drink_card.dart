import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../pages/drink_detail_page.dart';

class DrinkCard extends StatefulWidget {
  final Drink drink;

  DrinkCard({required this.drink});

  @override
  _DrinkCardState createState() => _DrinkCardState();
}

class _DrinkCardState extends State<DrinkCard> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    final apiService = Provider.of<ApiService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    // 서버에서 좋아요 상태를 가져오는 로직을 추가
    isLiked = false;
    apiService.checkIfLiked(authService.user!.id, widget.drink.id).then((liked) {
      setState(() {
        isLiked = liked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Card(
      child: Column(
        children: [
          Image.network(widget.drink.imageUrl),
          ListTile(
            title: Text(widget.drink.name),
            subtitle: Text('Sugar: ${widget.drink.sugarContent}g, Calories: ${widget.drink.calories}kcal'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrinkDetailPage(drinkId: widget.drink.id),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
                onPressed: () async {
                  try {
                    if (isLiked) {
                      await apiService.unlikeDrink(authService.user!.id, widget.drink.id);
                    } else {
                      await apiService.likeDrink(authService.user!.id, widget.drink.id);
                    }
                    setState(() {
                      isLiked = !isLiked;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isLiked ? 'Liked!' : 'Unliked!')));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update like status')));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
