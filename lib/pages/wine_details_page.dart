import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/wine_model.dart';
import '../models/note_model.dart';

class WineDetailsPage extends StatefulWidget {
  final Wine wine;
  final double averageRating;

  const WineDetailsPage({
    Key? key,
    required this.wine,
    required this.averageRating,
  }) : super(key: key);

  @override
  _WineDetailsPageState createState() => _WineDetailsPageState();
}

class _WineDetailsPageState extends State<WineDetailsPage> {
  final TextEditingController commentController = TextEditingController();
  int selectedRating = 0;

  late Future<List<Note>> notesFutures;

  @override
  void initState() {
    super.initState();
    // Fetch notes when the widget is initialized
    notesFutures = _requestComment(widget.wine.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.wine.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Vin"),
                _buildInfoSection("Nom", widget.wine.name),
                _buildInfoSection("Description", widget.wine.description),
                _buildInfoSection("Cuvée", widget.wine.vintageName),
                _buildInfoSection(
                    "Date de récolte", widget.wine.harvestingDate.toString()),
                _buildInfoSection(
                    "Date de mise en bouteille", widget.wine.bottlingDate.toString()),
                _buildInfoSection("Prix", "${widget.wine.price}€"),
                _buildStarRating(widget.averageRating),

                const SizedBox(height: 30),

                _buildSectionTitle("Vignoble"),
                _buildInfoSection("Nom", widget.wine.winery?.name ?? ''),
                _buildInfoSection("Adresse", widget.wine.winery?.address ?? ''),

                const SizedBox(height: 30),

                _buildSectionTitle("Notez ce vin"),
                _buildRatingForm(),

                const SizedBox(height: 30),

                _buildCommentsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: commentController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Votre commentaire',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(
            5,
                (index) => IconButton(
              onPressed: () {
                setState(() {
                  selectedRating = index + 1;
                });
              },
              icon: Icon(
                index < selectedRating.floor() ? Icons.star : Icons.star_border,
                color: Colors.yellow,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Submit Rating'),
        ),
      ],
    );
  }

  void _submitForm() {
    final String comment = commentController.text;
    _sendComment(comment, selectedRating, widget.wine.id);
    print('User Rating: $comment, Stars Selected: $selectedRating');
  }

  Future<void> _sendComment(String comment, int rating, int wineId) async {
    final url = 'http://${dotenv.env['SHAZVINCORE_HOST']}:3000/api/note';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "rating": rating,
            "wine": wineId,
            "user": prefs.getInt('user_id') ?? -1,
            "comment": comment,
            "enabled": true
          }));

      if (response.statusCode == 201) {
        // Handle the successful response if needed
        debugPrint('HTTP Request Successful: ${response.body}');

        return;
      }

      debugPrint('HTTP Request Failed: ${response.statusCode}');
    } catch (e) {
      // Handle potential errors during the request
      debugPrint('HTTP Request Error: $e');
    }
  }

  Future<List<Note>> _requestComment(int wineId) async {
    final url = 'http://${dotenv.env['SHAZVINCORE_HOST']}:3000/api/note?wine=$wineId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Handle the successful response if needed
        debugPrint('HTTP Request Successful: ${response.body}');

        return _jsonToNotes(response.body);
      }

      debugPrint('HTTP Request Failed: ${response.statusCode}');
    } catch (e) {
      // Handle potential errors during the request
      debugPrint('HTTP Request Error: $e');
    }
    return [];
  }

  List<Note> _jsonToNotes(String jsonString) {
    final List<dynamic> noteList = json.decode(jsonString);
    if(noteList.isEmpty) {
      return [];
    }

    List<Note> notes = [];

    for(final noteMap in noteList) {
      String createdAt = noteMap['createdAt'] ?? '';
      String updatedAt = noteMap['updatedAt'] ?? '';
      var rating = noteMap['rating'];

      Note note = Note(
          id: noteMap['id'] ?? -1,
          comment: noteMap['comment'] ?? '',
          rating: rating == null ? -1.0 : rating is double ? rating : double.parse(rating.toString()),
          wine: noteMap['wine']?['id'] ?? -1,
          user: noteMap['user']?['id'] ?? -1,
          enabled: true,
          createdAt: DateTime.tryParse(createdAt),
          updatedAt: DateTime.tryParse(updatedAt)
      );

      notes.add(note);
    }

    return notes;
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Commentaires"),
        FutureBuilder<List<Note>>(
          future: notesFutures,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<Note> notes = snapshot.data!;
              return Column(
                children: notes
                    .map(
                      (note) => Column(
                    children: [
                      _buildStarRating(note.rating),
                      Text(note.comment),
                      const SizedBox(height: 16),
                    ],
                  ),
                )
                    .toList(),
              );
            } else {
              return Text("Sans commentaires");
            }
          },
        ),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(
        5,
            (index) => Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.yellow,
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
// Existing helper methods (like _buildInfoSection and _buildSectionTitle)
}