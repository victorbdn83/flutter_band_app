import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewSongScreen extends StatefulWidget {
  final DocumentReference reference;

  const ViewSongScreen({super.key, required this.reference});

  @override
  State<ViewSongScreen> createState() => _ViewSongScreenState();
}

class _ViewSongScreenState extends State<ViewSongScreen>
    with SingleTickerProviderStateMixin {
  String _name = '';
  String _key = '';
  String _lyrics = '';
  String _duration = '';
  int _seconds = 0;
  final int _tempo = 0;

  late TabController _tabController;
  final _tabs = [
    const Tab(text: 'Lyrics'),
    const Tab(text: 'Recordings'),
    const Tab(text: 'Chords'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 2,
        shadowColor: colors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            /*Expanded(
              flex: 3,
              child: Container(
                color: Colors.green,
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.yellow,
              ),
            ),
            */
            NewSectionCard(
              "sfsfs",
              "Chords",
              colors.secondaryContainer,
              Icons.music_note,
            ),
            NewSectionCard(
              _lyrics,
              'Lyrics',
              colors.primaryContainer,
              Icons.abc,
            ),
            NewSectionCard(
              "sefsrfewrwer",
              "Recordings",
              colors.tertiaryContainer,
              Icons.mic,
            ),
          ],

          /*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Key
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shadowColor: colors.primary,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: FaIcon(
                            FontAwesomeIcons.hashtag,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Tempo
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shadowColor: colors.primary,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: FaIcon(FontAwesomeIcons.drum),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _tempo.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Duration
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shadowColor: colors.primary,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: FaIcon(FontAwesomeIcons.clock),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _duration,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Column(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.music_note_rounded),
                    title: Text('Chords'),
                    // subtitle:
                    //     Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text('BUY TICKETS'),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('LISTEN'),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            */
          //   Container(
          //     height: kToolbarHeight - 8.0,
          //     decoration: BoxDecoration(
          //       color: colors.primary.withOpacity(0.4),
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //     child: TabBar(
          //       controller: _tabController,
          //       indicator: BoxDecoration(
          //           borderRadius: BorderRadius.circular(8.0),
          //           color: colors.primary),
          //       labelColor: colors.surface,
          //       unselectedLabelColor: colors.surface,
          //       tabs: _tabs,
          //     ),
          //   ),
          //   Card(
          //     shadowColor: colors.primary,
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text(
          //         _lyrics,
          //         style: const TextStyle(
          //           fontWeight: FontWeight.normal,
          //           fontSize: 20,
          //         ),
          //       ),
          //     ),
          //   ),
          //],
        ),
      ),
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
          _key = item['key'] ?? '';
          _lyrics = item['lyrics'] ?? '';
          _seconds = item['seconds'] ?? '';
          _duration = formatedTime(timeInSeconds: _seconds);
          //_tempo = item['tempo'] ?? '';
        });
      }
    });
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required String body,
    required String sectionName,
    required Color bgColor,
    required IconData icon,
  })  : _body = body,
        _sectionName = sectionName,
        _bgColor = bgColor,
        _icon = icon;

  final String _body;
  final String _sectionName;
  final Color _bgColor;
  final IconData _icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      //flex: 7,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: _bgColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: colors.inversePrimary.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  debugPrint("Tapped {$_sectionName}}");
                },
                child: Container(
                  color: colors.inversePrimary.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(
                        _icon,
                        color: colors.onPrimary,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _sectionName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: colors.onPrimary),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _body,
                        overflow: TextOverflow.fade,
                        style: TextStyle(color: colors.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewSectionCard extends StatefulWidget {
  final String body;
  final String sectionName;
  final Color bgColor;
  final IconData icon;

  const NewSectionCard(this.body, this.sectionName, this.bgColor, this.icon,
      {super.key});

  @override
  State<NewSectionCard> createState() => _NewSectionCardState();
}

class _NewSectionCardState extends State<NewSectionCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      flex: isExpanded ? 6 : 1,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: widget.bgColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: colors.surfaceVariant,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  debugPrint("Tapped {$widget.sectionName}}");
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Container(
                  color: colors.inversePrimary.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(
                        widget.icon,
                        color: colors.onSurfaceVariant,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.sectionName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.body,
                        overflow: TextOverflow.fade,
                        style: TextStyle(color: colors.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

formatedTime({required int timeInSeconds}) {
  int sec = timeInSeconds % 60;
  int min = (timeInSeconds / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute:$second";
}
