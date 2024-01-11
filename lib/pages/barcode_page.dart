import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wine_shazam/models/wine_model.dart';
import 'package:wine_shazam/models/winery_model.dart';
import 'package:wine_shazam/pages/wine_details_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BarCodePage extends StatefulWidget {
  const BarCodePage({super.key});

  @override
  State<BarCodePage> createState() => _BarCodePageState();
}

class _BarCodePageState extends State<BarCodePage> {
  bool enableScan = true;

  @override
  Widget build(BuildContext context) {
    enableScan = true;
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        allowDuplicates: true,
        controller: MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        onDetect: (barcode, args) {
          if(!enableScan) {
            return;
          }
          if (barcode.rawValue == null) {
            debugPrint('Failed to scan Barcode');
          } else {
            enableScan = false;
            _requestWineWithBarCode(barcode.rawValue!).then((wine) => {
              if(wine == null) {
                _displayBarCodeDetected('Aucun vin trouvé...', () {
                  enableScan = true;
                  Navigator.of(context).pop(); // Close the dialog
                })
              } else {
                _requestAverageRating(wine.id).then((average) => {
                  _displayBarCodeDetected('Un vin a été trouvé !', () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WineDetailsPage(wine: wine, averageRating: average)
                        )
                    );
                  })
                })
              }

            });
          }
        },
      ),
    );
  }

  void _displayBarCodeDetected(String text, void Function() function) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Code barre détecté !'),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: function,
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<Wine?> _requestWineWithBarCode(String code) async {
    final url = 'http://${dotenv.env['SHAZVINCORE_HOST']}:3000/api/wine?barCode=$code';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Handle the successful response if needed
        debugPrint('HTTP Request Successful: ${response.body}');

        return _jsonToWine(response.body);
      }
      debugPrint('HTTP Request Failed: ${response.statusCode}');
      return null;
    } catch (e) {
      // Handle potential errors during the request
      debugPrint('HTTP Request Error: $e');
      return null;
    }
  }

  Future<double> _requestAverageRating(int wineId) async {
    final url = 'http://${dotenv.env['SHAZVINCORE_HOST']}:3000/api/note/average/$wineId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Handle the successful response if needed
        debugPrint('HTTP Request Successful: ${response.body}');
        Map<String, dynamic> mapAverage = json.decode(response.body);
        return double.tryParse(mapAverage['average']) ?? 0.0;
      }
      debugPrint('HTTP Request Failed: ${response.statusCode}');
      return 0.0;
    } catch (e) {
      // Handle potential errors during the request
      debugPrint('HTTP Request Error: $e');
      return 0.0;
    }
  }

  Wine? _jsonToWine(String jsonString) {
    final List<dynamic> wineList = json.decode(jsonString);
    if(wineList.isEmpty) {
      return null;
    }

    String harvestingDate = wineList[0]['harvestingDate'] ?? '';
    String bottlingDate = wineList[0]['bottlingDate'] ?? '';
    String createdAt = wineList[0]['createdAt'] ?? '';
    String updatedAt = wineList[0]['updatedAt'] ?? '';
    var price = wineList[0]['price'];

    return Wine(
        id: wineList[0]['id'] ?? -1,
        name: wineList[0]['name'] ?? '',
        description: wineList[0]['description'] ?? '',
        harvestingDate: DateTime.tryParse(harvestingDate),
        bottlingDate: DateTime.tryParse(bottlingDate),
        price: price == null ? -1.0 : price is double ? price : double.parse(price.toString()),
        winery: _mapToWinery(wineList[0]['winery']),
        vintageName: wineList[0]['vintageName'] ?? -1,
        barCode: wineList[0]['barCode'] ?? '',
        enabled: true,
        createdAt: DateTime.tryParse(createdAt),
        updatedAt: DateTime.tryParse(updatedAt)
    );
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

Widget button(IconData icon, Alignment alignment) {
  return Align(
    alignment: alignment,
    child: Container(
        margin: const EdgeInsets.only(
            left: 20,
            bottom: 20
        ),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 10
              )
            ]
        ),
        child: Center(
            child: Icon(
              icon,
              color: Colors.black87,
            )
        )
    ),
  );
}
