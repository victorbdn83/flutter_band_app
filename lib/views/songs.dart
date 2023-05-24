import 'package:flutter/material.dart';

import '../connections/firebase_db.dart';

class SongsView extends StatefulWidget {
  const SongsView({super.key});

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FirestoreItemList(),
    );
  }
}
