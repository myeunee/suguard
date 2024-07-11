import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../pages/cafe_home_page.dart';

class CafeCard extends StatelessWidget {
  final Cafe cafe;

  CafeCard({required this.cafe});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(cafe.name[0]),
      ),
      title: Text(cafe.name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CafeHomePage(cafeId: cafe.id)),
        );
      },
    );
  }
}
