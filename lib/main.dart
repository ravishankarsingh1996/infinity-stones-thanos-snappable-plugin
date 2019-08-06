
import 'package:flutter/material.dart';
import 'package:snappable/snappable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GemCollectorPage(),
    );
  }
}

class GemCollectorPage extends StatefulWidget {
  @override
  _GemCollectorPageState createState() => _GemCollectorPageState();
}

class _GemCollectorPageState extends State<GemCollectorPage> {
  List<Color> stoneColors = [
    Colors.red,
    Colors.blue,
    Colors.purpleAccent,
    Colors.yellow,
    Colors.green,
    Colors.deepOrangeAccent
  ];
  List<String> stoneName = [
    "Reality Stone",
    "Space Stone",
    "Power Stone",
    "Mind Stone",
    "Time Stone",
    "Soul Stone"
  ];
  List<Widget> stonesList = [];
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  bool _snapAll = false;

  @override
  void initState() {
    super.initState();
    onPrepareStoneList();
  }

  onPrepareStoneList() {
    for (int i = 0; i < stoneName.length; i++) {
      stonesList.add(getStone(stoneColors[i], stoneName[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white70),
          child: Center(
            child: _snapAll
                ? MyHomePage()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Center(child: Text('Infinity Stones', textScaleFactor: 2,))),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.black),
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.spaceAround,
                            children: stonesList,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height* 0.4,
                        width: double.infinity,
                        child: Center(
                          child: getStoneDropTargetWidget(),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  getStoneDropTargetWidget() {
    return Container(
      width: 120.0,
      height: 120.0,
      color: Colors.green,
      child: DragTarget(
        builder: (context, List<String> candidateData, rejectedData) {
          print(candidateData);
          return Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
            "Collect all stones here",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
              ));
        },
        onWillAccept: (data) {
          return true;
        },
        onAccept: (data) {
          for (int i = 0; i < stoneName.length; i++) {
            if (stoneName[i].contains(RegExp(data.toString()))) {
              print(data);
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("You got the " + data + "!"),
                duration: Duration(milliseconds: 1000),
              ));
              setState(() {
                stonesList.removeAt(i);
                stoneName.removeAt(i);
                if (stonesList.length == 0) _snapAll = true;
              });
            }
          }
        },
      ),
    );
  }

  getStone(Color color, String data) {
    return Draggable(
      data: data,
      child: Container(
        width: 100.0,
        height: 100.0,
        child: Center(
          child: Text(
            data,
            style: TextStyle(color: Colors.white, fontSize: 22.0),
            textAlign: TextAlign.center,
          ),
        ),
        color: color,
      ),
      feedback: Container(
        width: 100.0,
        height: 100.0,
        child: Center(
          child: Text(
            data,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        color: color,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _snappableKey = GlobalKey<SnappableState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Snappable(
          key: _snappableKey,
          snapOnTap: true,
          child: Card(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: Image.network(
                'https://live.staticflickr.com/1900/30467788398_96d448446b_b.jpg',
                height: double.maxFinite,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: RawMaterialButton(
              shape: StadiumBorder(),
              fillColor: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Snap / Reverse',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: onSnapAndReverse,
            ),
          ),
        ),
      ],
    );
  }

  onSnapAndReverse() {
    SnappableState state = _snappableKey.currentState;
    if (state.isGone) {
      state.reset();
    } else {
      state.snap();
    }
  }
}
