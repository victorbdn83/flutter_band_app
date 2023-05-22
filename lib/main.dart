import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'src/audio_player.dart';
import 'src/audio_recorder.dart';

void main() => runApp(const MyFlutterAudio());

class MyFlutterAudio extends StatefulWidget {
  const MyFlutterAudio({Key? key}) : super(key: key);

  @override
  State<MyFlutterAudio> createState() => _MyFlutterAudioState();
}

class _MyFlutterAudioState extends State<MyFlutterAudio> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
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
                ),
        ),
      ),
    );
  }
}
