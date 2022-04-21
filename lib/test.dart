import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water_app/widgets/circular_indicator.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final Stream<int> _bids = (() {
    late final StreamController<int> controller;
    controller = StreamController<int>(
      onListen: () async {
        int n1 = 2;
        while (true) {
          var db = await Mongo.Db.create(
              "mongodb+srv://Vinod:PLraOmofL8zFe2yr@cluster0.gbcff.mongodb.net/myFirstDatabase?retryWrites=true&w=majority");

          await db.open();

          var collection = db.collection('water_info');
          var lev = null;
          var user = await collection.findOne();
          user!.forEach((key, value) {
            if (key == "water_level") {
              lev = value;
            }
          });
          print(lev);

          await Future<void>.delayed(const Duration(seconds: 1));
          controller.add(lev);
          n1++;
          await Future<void>.delayed(const Duration(seconds: 1));
        }
        // await Future<void>.delayed(const Duration(seconds: 3));
        // controller.add(1);
        // await Future<void>.delayed(const Duration(seconds: 3));
        await controller.close();
      },
    );
    return controller.stream;
  })();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: Container(
        alignment: FractionalOffset.center,
        color: Colors.white,
        child: StreamBuilder<int>(
          stream: _bids,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            List<Widget> children;
            if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Stack trace: ${snapshot.stackTrace}'),
                ),
              ];
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  children = const <Widget>[
                    Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Select a lot'),
                    )
                  ];
                  break;
                case ConnectionState.waiting:
                  children = const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting bids...'),
                    )
                  ];
                  break;
                case ConnectionState.active:
                  children = <Widget>[
                    CircIndicator(leve: snapshot.data!.ceilToDouble())
                  ];
                  break;
                case ConnectionState.done:
                  children = <Widget>[
                    const Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Tank is fulled',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    CircIndicator(leve: 100)
                  ];
                  break;
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            );
          },
        ),
      ),
    );
  }
}
