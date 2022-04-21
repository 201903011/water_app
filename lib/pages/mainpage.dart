import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:water_app/test.dart';

import 'package:water_app/widgets/circular_indicator.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import 'dart:io' show Platform;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool start = true;

  moveToHome(BuildContext context) async {
    var db = await Mongo.Db.create(
        "mongodb+srv://Vinod:PLraOmofL8zFe2yr@cluster0.gbcff.mongodb.net/myFirstDatabase?retryWrites=true&w=majority");

    await db.open();

    var collection = db.collection('water_info');

    var res = await collection.updateOne(
      Mongo.where.eq('name', 'rasberryPiMachine0'),
      Mongo.ModifierBuilder().set('motor_status', start),
    );

    var user = await collection.findOne();
    var stat;
    user!.forEach((key, value) {
      if (key == "motor_status") {
        stat = value;
      }
    });
    setState(() {
      start = stat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Water App"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            MyStatefulWidget(),
            ElevatedButton(
                style: ButtonStyle(),
                onPressed: () => moveToHome(context),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: start
                      ? Text(
                          "Start",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                        )
                      : Text(
                          "Stop",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                        ),
                )),
          ],
        ),
      ),
    );
  }
}
