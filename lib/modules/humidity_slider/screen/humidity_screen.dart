import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/humidity.dart';
import '../widget/humidity_congfig.dart';
import '../widget/humidity_info.dart';
import '../widget/scaffold.dart';
import '../widget/slider.dart';

class HumidityScr extends StatefulWidget {
  const HumidityScr({Key? key}) : super(key: key);

  @override
  State<HumidityScr> createState() => _HumidityScrState();
}

class _HumidityScrState extends State<HumidityScr> with TickerProviderStateMixin{
  final dataBase = FirebaseDatabase.instance.ref();
  Map<Object?, Object?> sensorsTable = {};
  void read() async {
    tables.forEach((key, value) async {
      Query dbRef = FirebaseDatabase.instance.ref().child(key);
      await dbRef.onValue.listen((event) {
        print(event.snapshot.value);
        if (key == "sensors")
          sensorsTable = event.snapshot.value as Map<Object?, Object?>;
  
        setState(() {



        });
      });
    });
  }

  Map<String, List<String>> tables = {
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP'],
    "sensors": ['CO PPM value', 'Humdity', 'LPG PPM value', 'temp']
  };

  @override
  void initState() {
    read();
    super.initState();
  }

 
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => HumidityConfig()),
        ChangeNotifierProvider(create: (_) => Humidity(hum: int.parse('${sensorsTable['Humdity']}')))
      ],
      child: const HumiditySliderScaffold(
        activeIndex: 1,
        body: HumiditySliderPage(),
      ),
    );
  }
}

class HumiditySliderPage extends StatelessWidget {
  const HumiditySliderPage({Key? key}) : super(key: key);

  final bool kShowBack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: kShowBack
            ? const DecorationImage(
                image: AssetImage("assets/design.png"),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          SizedBox(
            width: 180,
            child: HumiditySlider(),
          ),
          Expanded(
            child: HumidityInfo(),
          ),
        ],
      ),
    );
  }
}
