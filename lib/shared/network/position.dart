import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

double lat = 0.0;
double long = 0.0;
int len=4;

class position {
  double latitude1;
  double longitude1;
  position({required this.latitude1, required this.longitude1});
}

final dataBase = FirebaseDatabase.instance.ref();
Map<Object?, Object?> gpsTable = {};
Map<String, List<String>> table = {
  "gps": [
    'latitude1',
    'longitude1',
  ],
};
void readRealTimeDatabase() async {
  table.forEach((key, value) async {
    Query dbRef = FirebaseDatabase.instance.ref().child(key);
    await dbRef.onValue.listen((event) {
      if (key == "gps") {
        gpsTable = event.snapshot.value as Map<Object?, Object?>;
        // positions.add(new position(
        //     latitude1:
        //         double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0,
        //     longitude1:
        //         double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0));
        
        
        //lat = double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0;
        //long = double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0;


        positions[0].latitude1 = double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0;
        positions[0].longitude1 = double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0;


        positions[1].latitude1 = double.tryParse('${gpsTable['latitude2']}' ?? '') ?? 0.0;
        positions[1].longitude1 = double.tryParse('${gpsTable['longitude2']}' ?? '') ?? 0.0;

        positions[2].latitude1 = double.tryParse('${gpsTable['latitude3']}' ?? '') ?? 0.0;
        positions[2].longitude1 = double.tryParse('${gpsTable['longitude3']}' ?? '') ?? 0.0;

        positions[3].latitude1 = double.tryParse('${gpsTable['latitude4']}' ?? '') ?? 0.0;
        positions[3].longitude1 = double.tryParse('${gpsTable['longitude4']}' ?? '') ?? 0.0;


      }
    });
  });
}
// void checkDatabaseValues() {
//   Timer.periodic(
//       const Duration(seconds: 1), (Timer t) => readRealTimeDatabase());
// for (int i = 0; i <= len; i++){
//  positions[i].latitude1=lat;
//  positions[i].longitude1=long;
// }
// }
List<position> positions = [
  //position(latitude1: double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0    , longitude1: double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0 ),
  // position(latitude1: 0.0    , longitude1: 0.0 ),
];
