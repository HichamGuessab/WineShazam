import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wine_shazam/models/wine_model.dart';
import 'package:wine_shazam/models/winery_model.dart';
import 'package:wine_shazam/pages/wine_details_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  late Future<List<Wine>> wines;

  @override
  void initState() {
    super.initState();
    wines = _requestWinesFromName('');
  }

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

          FutureBuilder<List<Wine>>(
            future: wines, // Assuming wines is a Future<List<Wine>>
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<Wine> wines = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
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
                              builder: (context) => WineDetailsPage(wine: wine, averageRating: 5.0),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              } else {
                return Text("No wines available.");
              }
            },
          )
        ],
    );
  }

  void searchWine(String query) {
    setState(() {
      wines = _requestWinesFromName(query);
    });
  }

  Future<List<Wine>> _requestWinesFromName(String query) async {
    final url = 'http://${dotenv.env['SHAZVINCORE_HOST']}:3000/api/wine?name=$query';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Handle the successful response if needed
        debugPrint('HTTP Request Successful: ${response.body}');

        return _jsonToWineList(response.body);
      }
      debugPrint('HTTP Request Failed: ${response.statusCode}');
    } catch (e) {
      // Handle potential errors during the request
      debugPrint('HTTP Request Error: $e');
    }

    return [];
  }

  List<Wine> _jsonToWineList(String jsonString) {
    final List<dynamic> wineList = json.decode(jsonString);
    if(wineList.isEmpty) {
      return [];
    }

    List<Wine> wines = [];

    for(final wine in wineList) {
      String harvestingDate = wine['harvestingDate'] ?? '';
      String bottlingDate = wine['bottlingDate'] ?? '';
      String createdAt = wine['createdAt'] ?? '';
      String updatedAt = wine['updatedAt'] ?? '';
      var price = wine['price'];

      wines.add(Wine(
          id: wine['id'] ?? -1,
          name: wine['name'] ?? '',
          description: wine['description'] ?? '',
          harvestingDate: DateTime.tryParse(harvestingDate),
          bottlingDate: DateTime.tryParse(bottlingDate),
          price: price == null ? -1.0 : price is double ? price : double.parse(price.toString()),
          winery: _mapToWinery(wine['winery']),
          vintageName: wine['vintageName'] ?? -1,
          barCode: wine['barCode'] ?? '',
          enabled: true,
          createdAt: DateTime.tryParse(createdAt),
          updatedAt: DateTime.tryParse(updatedAt)
      ));
    }
    return wines;
  }

  Winery? _mapToWinery(Map<String, dynamic> map) {
    String createdAt = map['createdAt'] ?? '';
    String updatedAt = map['updatedAt'] ?? '';

    return Winery(
        id: map['id'] ?? -1,
        name: map['name'] ?? '',
        address: map['address'] ?? '',
        enabled: true,
        createdAt: DateTime.tryParse(createdAt),
        updatedAt: DateTime.tryParse(updatedAt)
    );
  }
}