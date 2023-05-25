import 'package:flutter/material.dart';
import '../widgets/firebase_item_list.dart';

// ignore: constant_identifier_names
const String FIREBASE_COLLECTION_NAME = 'songs';

class SongsView extends StatefulWidget {
  const SongsView({super.key});

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FirestoreItemList(FIREBASE_COLLECTION_NAME),
    );
  }
}
