import 'package:flutter/material.dart';

import '../models/wine_model.dart';

class WineDetailsPage extends StatelessWidget {
  final Wine wine;

  const WineDetailsPage({
    Key? key,
    required this.wine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(wine.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Vin"),
              _buildInfoSection("Nom", wine.name),
              _buildInfoSection("Description", wine.description),
              _buildInfoSection("Cuvée", wine.vintageName),
              _buildInfoSection(
                  "Date de récolte", wine.harvestingDate.toString()),
              _buildInfoSection(
                  "Date de mise en bouteille", wine.bottlingDate.toString()),
              _buildInfoSection("Prix", "${wine.price}€"),

              const SizedBox(height: 30),

              _buildSectionTitle("Vignoble"),
              _buildInfoSection("Nom", wine.winery?.name ?? ''),
              _buildInfoSection("Adresse", wine.winery?.address ?? ''),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Text(content, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }
}
