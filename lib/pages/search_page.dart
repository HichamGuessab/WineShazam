import 'package:flutter/material.dart';
import 'package:wine_shazam/models/wine_model.dart';
import 'package:wine_shazam/pages/wine_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  List<Wine> wines = allWines;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Nom du vin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white)
                ),
              ),
            onChanged: searchWine,
            ),
          ),
          Expanded(child: ListView.builder(
            itemCount: wines.length,
            itemBuilder: (context, index) {
              final wine = wines[index];

              return ListTile(
                title: Text(wine.name),
                subtitle: Text(wine.description),
                trailing: Text(wine.price.toString() + "€"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WineDetailsPage(wine: wine)
                    )
                  );
                }
              );
            }
          ))
        ],
    );
  }
  void searchWine(String query) {
    final suggestions = allWines.where((wine) {
      final wineName = wine.name.toLowerCase();
      final input = query.toLowerCase();

      return wineName.contains(input);
    }).toList();

    setState(() => wines = suggestions);
  }
}