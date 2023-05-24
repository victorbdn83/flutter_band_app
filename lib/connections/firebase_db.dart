import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreItemList extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('songs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final items = snapshot.data!.docs;

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index].data() as Map<String, dynamic>;

            return ListTile(
              title: Text(item['name']),
              subtitle: Text(item['key']),
              onTap: () {
                _editItem(context, items[index].reference);
              },
            );
          },
        );
      },
    );
  }

  void _editItem(BuildContext context, DocumentReference reference) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditItemScreen(reference: reference)),
    );
  }
}

class EditItemScreen extends StatefulWidget {
  final DocumentReference reference;

  EditItemScreen({required this.reference});

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
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
