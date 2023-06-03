import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;
  final String baseFileName;

  const AudioRecorder(
      {Key? key, required this.onStop, required this.baseFileName})
      : super(key: key);

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) => setState(() => _amplitude = amp));

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();
        // final isRecording = await _audioRecorder.isRecording();
        final path = await _localPath;
        var timestamp = DateTime.timestamp(); // 31/12/2000, 22:00
        final fileName = '$path/$timestamp-${widget.baseFileName}.m4a';
        await _audioRecorder.start(
          path: fileName,
          encoder: AudioEncoder.aacLc, // by default
          bitRate: 128000, // by default
          samplingRate: 44100, // by default
        );
        _recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _recordDuration = 0;

    final path = await _audioRecorder.stop();

    if (path != null) {
      debugPrint('Recording stopped: $path');
      //saveFile("test.wav");
      widget.onStop(path);
    }
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildRecordStopControl(),
            const SizedBox(width: 20),
            _buildPauseResumeControl(),
            const SizedBox(width: 20),
            _buildText(),
          ],
        ),
        if (_amplitude != null) ...[
          const SizedBox(height: 40),
          //Text('Current: ${_amplitude?.current ?? 0.0}'),
          //Text('Max: ${_amplitude?.max ?? 0.0}'),
          SfLinearGauge(
            minimum: -80.0,
            maximum: 10.0,
            showTicks: true,
            showLabels: true,
            showAxisTrack: true,
            barPointers: [
              LinearBarPointer(
                value: _amplitude!.current,
                thickness: 10,
                color: Colors.red,
              ),
            ],
            ranges: [
              LinearGaugeRange(
                startValue: -80,
                endValue: -6,
                color: Colors.green.shade100,
                //label: 'Low',
                position: LinearElementPosition.outside,
                //thickness: 10,
                //sizeUnit: GaugeSizeUnit.factor,
              ),
              LinearGaugeRange(
                startValue: -6,
                endValue: -3,
                color: Colors.green.shade700,
                //label: 'Medium',
                position: LinearElementPosition.outside,
                //thickness: 10,
                //sizeUnit: GaugeSizeUnit.factor,
              ),
              LinearGaugeRange(
                startValue: -3,
                endValue: 0,
                color: Colors.orange,
                //label: 'High',
                position: LinearElementPosition.outside,
                //thickness: 10,
                //sizeUnit: GaugeSizeUnit.factor,
              ),
              LinearGaugeRange(
                startValue: 0,
                endValue: 10,
                color: Colors.red,
                //label: 'Very High',
                position: LinearElementPosition.outside,
                //thickness: 10,
                //sizeUnit: GaugeSizeUnit.factor,
              ),
            ],
          ),

          /*LinearPercentIndicator(
            width: 140.0,
            lineHeight: 20.0,
            percent: min(1, 1 - (_amplitude!.current / -100)),
            backgroundColor: Colors.grey.shade300,
            //progressColor: _getDbColor(),
            alignment: MainAxisAlignment.center,
            barRadius: const Radius.circular(5.0),
            clipLinearGradient: true,
            linearGradient: LinearGradient(
              colors: [
                Colors.green.shade100,
                Colors.green.shade700,
                Colors.orange,
                Colors.red,
              ],
              stops: const [
                0.0,
                0.94,
                0.97,
                1.0
              ], //swetspot between -6 and -3 dbFS
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            center: Text(
              '${_amplitude?.current.round() ?? 0}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (_amplitude!.max >= 0) ...[
            const SizedBox(height: 10),
            Text(
              'CLIP',
              style: TextStyle(
                color: colors.error,
                fontWeight: FontWeight.bold,
                backgroundColor: colors.error.withOpacity(0.1),
              ),
            ),
          ],*/
        ],
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    final colors = Theme.of(context).colorScheme;
    late Icon icon;
    late Color color;

    if (_recordState != RecordState.stop) {
      icon = Icon(Icons.stop, color: colors.error, size: 30);
      color = colors.error.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState != RecordState.stop) ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    final colors = Theme.of(context).colorScheme;
    if (_recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (_recordState == RecordState.record) {
      icon = Icon(Icons.pause, color: colors.error, size: 30);
      color = colors.error.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: colors.error, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const Text("Waiting to record");
  }

  Widget _buildTimer() {
    final colors = Theme.of(context).colorScheme;
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(color: colors.error),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<String> getFilePath(String fileName) async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;
  String filePath = '$appDocumentsPath/$fileName';

  return filePath;
}

void saveFile(String fileName) async {
  File file = File(await getFilePath(fileName));
  file.writeAsString(
      "This is my demo text that will be saved to : demoTextFile.txt"); // 2
}
