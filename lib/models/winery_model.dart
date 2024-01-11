class Winery {
  final int id;
  final String name;
  final String address;
  final bool enabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Winery({
    required this.id,
    required this.name,
    required this.address,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });
}

final allWineries = [
  Winery(
    id: 1,
    name: 'Winery 1',
    address: 'Address 1',
    enabled: true,
    createdAt: DateTime(2021, 1, 1),
    updatedAt: DateTime(2021, 1, 1),
  ),
  Winery(
    id: 2,
    name: 'Winery 2',
    address: 'Address 2',
    enabled: true,
    createdAt: DateTime(2021, 1, 1),
    updatedAt: DateTime(2021, 1, 1),
  ),
  Winery(
    id: 3,
    name: 'Winery 3',
    address: 'Address 3',
    enabled: true,
    createdAt: DateTime(2021, 1, 1),
    updatedAt: DateTime(2021, 1, 1),
  ),
];