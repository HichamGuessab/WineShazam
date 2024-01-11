import 'package:wine_shazam/models/winery_model.dart';

class Wine {
  final int id;
  final String name;
  final String description;
  final DateTime? harvestingDate;
  final DateTime? bottlingDate;
  final double price;
  final Winery? winery;
  final String vintageName;
  final String barCode;
  final bool enabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Wine( {
    required this.id,
    required this.name,
    required this.description,
    required this.harvestingDate,
    required this.bottlingDate,
    required this.price,
    required this.winery,
    required this.vintageName,
    required this.barCode,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });
}

final allWines = [
  Wine(
    id: 1,
    name: 'Château de Beaucastel',
    description: 'Châteauneuf-du-Pape',
    harvestingDate: DateTime(2018, 10, 1),
    bottlingDate: DateTime(2019, 10, 1),
    price: 89.99,
    winery: allWineries[0],
    vintageName: 'Cuvee 1',
    barCode: '1234567890123',
    enabled: true,
    createdAt: DateTime(2021, 1, 1),
    updatedAt: DateTime(2021, 1, 1),
  ),
  Wine(
    id: 2,
    name: 'Château de Bellefont-Belcier',
    description: 'Châteauneuf-du-Pape',
    harvestingDate: DateTime(2018, 10, 1),
    bottlingDate: DateTime(2019, 10, 1),
    price: 14.99,
    winery: allWineries[1],
    vintageName: 'Cuvee 2',
    barCode: '1234567890123',
    enabled: true,
    createdAt: DateTime(2021, 1, 1),
    updatedAt: DateTime(2021, 1, 1),
  ),
  Wine(
    id: 3,
    name: 'Château de Ducru-Beaucaillou',
    description: 'Ralston Purina Company',
    harvestingDate: DateTime(2018, 10, 1),
    bottlingDate: DateTime(2019, 10, 1),
    price: 50.99,
    winery: allWineries[2],
    vintageName: 'Cuvee 3',
    barCode: '1234567890123',
    enabled: true,
    createdAt: DateTime(2021, 1, 1),
    updatedAt: DateTime(2021, 1, 1),
  ),
  Wine(
    id: 4,
    name: 'Château de Figeac',
    description: 'La dame de Figeac',
    harvestingDate: DateTime(2018, 10, 1),
    bottlingDate: DateTime(2019, 10, 1),
    price: 89.99,
    winery: allWineries[0],
    vintageName: 'Cuvee 457414',
    barCode: '1234567890123',
    enabled: true,
    createdAt: DateTime(2021, 1, 1),
    updatedAt: DateTime(2021, 1, 1),
  ),
];