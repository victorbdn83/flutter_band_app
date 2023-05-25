import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentDetailsPage extends StatefulWidget {
  final String documentId;

  const DocumentDetailsPage({super.key, required this.documentId});

  @override
  State<DocumentDetailsPage> createState() => _DocumentDetailsPageState();
}

class _DocumentDetailsPageState extends State<DocumentDetailsPage> {
  late DocumentSnapshot _documentSnapshot;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDocumentDetails();
  }

  Future<void> fetchDocumentDetails() async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('your_collection')
          .doc(widget.documentId)
          .get();
      setState(() {
        _documentSnapshot = documentSnapshot;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      print('Error fetching document: $e');
    }
  }

  Future<void> updateDocumentData(Map<String, dynamic> newData) async {
    try {
      await FirebaseFirestore.instance
          .collection('your_collection')
          .doc(widget.documentId)
          .update(newData);
      // Document updated successfully
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Document updated successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle error
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Field 1: ${_documentSnapshot['field1']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Field 2: ${_documentSnapshot['field2']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 16.0),
                  // Add more Text widgets for each field you want to display

                  // Edit button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDocumentPage(
                            documentId: widget.documentId,
                            initialData: _documentSnapshot.data(),
                            onUpdate: (newData) {
                              // Update the document details on save
                              updateDocumentData(newData);
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),
    );
  }
}

class EditDocumentPage extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onUpdate;

  const EditDocumentPage({
    super.key,
    required this.documentId,
    required this.initialData,
    required this.onUpdate,
  });

  @override
  State<EditDocumentPage> createState() => _EditDocumentPageState();
}

class _EditDocumentPageState extends State<EditDocumentPage> {
  late Map<String, dynamic> _updatedData;

  @override
  void initState() {
    super.initState();
    _updatedData =
        widget.initialData ?? {}; // Set initialData to an empty map if null
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Field 1',
              ),
              onChanged: (value) {
                setState(() {
                  _updatedData['field1'] = value;
                });
              },
              controller: TextEditingController(
                text: _updatedData['field1'],
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Field 2',
              ),
              onChanged: (value) {
                setState(() {
                  _updatedData['field2'] = value;
                });
              },
              controller: TextEditingController(
                text: _updatedData['field2'],
              ),
            ),
            const SizedBox(height: 16.0),
            // Add more TextFields for each field you want to edit

            // Save button
            ElevatedButton(
              onPressed: () {
                widget.onUpdate(_updatedData);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
