import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewSongScreen extends StatefulWidget {
  final DocumentReference reference;

  const ViewSongScreen({super.key, required this.reference});

  @override
  State<ViewSongScreen> createState() => _ViewSongScreenState();
}

class _ViewSongScreenState extends State<ViewSongScreen> {
  String _name = '';
  String _description = '';
  String _key = '';
  String _lyrics = '';
  int _seconds = 0;
  int _tempo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.vpn_key),
                const Text('Key: '),
                Text(_key),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.local_fire_department),
                const Text('Tempo: '),
                Text(_tempo.toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.timer),
                const Text('Seconds: '),
                Text(_seconds.toString()),
              ],
            ),
            Text(_description),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSongData();
  }

  void _loadSongData() {
    widget.reference.get().then((snapshot) {
      if (snapshot.exists) {
        final item = snapshot.data() as Map<String, dynamic>;
        setState(() {
          debugPrint(item.toString());
          _name = item['name'] ?? '';
          _description = item['description'] ?? '';
          _key = item['key'] ?? '';
          _lyrics = item['lyrics'] ?? '';
          _seconds = item['seconds'] ?? '';
          _tempo = item['tempo'] ?? '';
        });
      }
    });
  }
}
