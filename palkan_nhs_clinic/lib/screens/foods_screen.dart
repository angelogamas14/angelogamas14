import 'package:flutter/material.dart';
import '../models/food.dart';

class FoodsScreen extends StatefulWidget {
  const FoodsScreen({super.key});

  @override
  State<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen> {
  final List<FoodItem> _foods = const [
    FoodItem(
      id: '1',
      name: 'Apple',
      category: 'Fruits',
      imageUrl: 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce',
      calories: 95,
    ),
    FoodItem(
      id: '2',
      name: 'Salmon',
      category: 'Protein',
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141',
      calories: 208,
    ),
    FoodItem(
      id: '3',
      name: 'Broccoli',
      category: 'Vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999',
      calories: 55,
    ),
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _foods
        .where((f) => f.name.toLowerCase().contains(_query.toLowerCase()) ||
            f.category.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Foods Library')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search foods'),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.9),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final f = filtered[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(f.imageUrl, fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${f.category} • ${f.calories} kcal'),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
