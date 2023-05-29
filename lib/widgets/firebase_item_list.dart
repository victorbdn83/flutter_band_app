import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_audio_flutter/screens/song_detail_screen.dart';

class FirestoreItemList extends StatelessWidget {
  FirestoreItemList(this.collection, {super.key});

  final String collection;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final items = snapshot.data!.docs;

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index].data() as Map<String, dynamic>;
            return Card(
              color: colors.primary.withOpacity(0.9),
              child: ListTile(
                title: Text(item['name']),
                trailing: Column(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        _viewItem(context, items[index].reference);
                      },
                    )
                  ],
                ),
              ),
            );
            /*return ListTile(
              title: Text(item['name']),
              //subtitle: Text(item['key']),
              trailing: Column(
                children: <Widget>[
                  //const Text('inside column'),
                  IconButton(
                      icon: const Icon(Icons.chevron_right_outlined),
                      onPressed: () {})
                ],
              ),
              onTap: () {
                _editItem(context, items[index].reference);
              },
            );*/
          },
        );
      },
    );
  }

  // void _editItem(BuildContext context, DocumentReference reference) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => EditItemScreen(reference: reference)),
  //   );
  // }

  void _viewItem(BuildContext context, DocumentReference reference) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewSongScreen(reference: reference)),
    );
  }
}

class EditItemScreen extends StatefulWidget {
  final DocumentReference reference;

  const EditItemScreen({super.key, required this.reference});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadItemData();
  }

  void _loadItemData() {
    widget.reference.get().then((snapshot) {
      if (snapshot.exists) {
        final item = snapshot.data() as Map<String, dynamic>;
        _nameController.text = item['name'];
        _descriptionController.text = item['description'];
      }
    });
  }

  void _saveChanges() {
    final name = _nameController.text;
    final description = _descriptionController.text;

    widget.reference.update({
      'name': name,
      'description': description,
    });
  }
}
