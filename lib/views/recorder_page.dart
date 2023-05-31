import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/audio_player.dart';
import '../widgets/audio_recorder.dart';

class RecorderView extends StatefulWidget {
  const RecorderView({super.key});

  @override
  State<RecorderView> createState() => _RecorderViewState();
}

class _RecorderViewState extends State<RecorderView> {
  bool showPlayer = false;
  String? audioPath;
  List<String> audioPaths = [];

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: showPlayer
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: AudioPlayer(
                source: audioPath!,
                onDelete: () {
                  setState(() => showPlayer = false);
                },
              ),
            )
          : AudioRecorder(
              onStop: (path) {
                if (kDebugMode) print('Recorded file path: $path');
                setState(() {
                  audioPath = path;
                  showPlayer = true;
                  audioPaths.add(path);
                });
                if (kDebugMode) print('List of recordings: $audioPaths');
              },
              baseFileName: 'xxx.m4a',
            ),
    );
  }
}
