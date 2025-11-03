import 'package:flutter/material.dart';

class EmptyFavorites extends StatefulWidget {
  const EmptyFavorites({super.key});

  @override
  State<EmptyFavorites> createState() => _EmptyFavoritesState();
}

class _EmptyFavoritesState extends State<EmptyFavorites> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.asset(
          'assets/images/favorites.jpg',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
