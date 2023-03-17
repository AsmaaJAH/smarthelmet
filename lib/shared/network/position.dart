import 'dart:math';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
List<LatLng> latlong = [
  // LatLng(double.tryParse('${gpsTable['latitude1']}') ?? 0.0,
  //     double.tryParse('${gpsTable['longitude1']}') ?? 0.0),
  // LatLng(double.tryParse('${gpsTable['latitude1']}') ?? 0.0,
  //     double.tryParse('${gpsTable['longitude1']}') ?? 0.0),
];
void readRealTimeDatabase() async {
  table.forEach((key, value) async {
    Query dbRef = FirebaseDatabase.instance.ref().child(key);
    await dbRef.onValue.listen((event) {
      if (key == "gps") {
        gpsTable = event.snapshot.value as Map<Object?, Object?>;
        positions.add(new position(
            latitude1: double.tryParse('${gpsTable['latitude1']}') ?? 0.0,
            longitude1: double.tryParse('${gpsTable['longitude1']}') ?? 0.0));
        positions[1] = position(
            latitude1: double.tryParse('${gpsTable['latitude1']}') ?? 0.0,
            longitude1: double.tryParse('${gpsTable['longitude1']}') ?? 0.0);

        for (int i = 0; i < 10; i++) {
          latlong[i] = LatLng(
              double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0,
              double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0);
        }
        print(positions[1].toString());
      }
    });
  });
}

List<position> positions = [
  position(
      latitude1: double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0,
      longitude1: double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0),
  // position(latitude1: 0.0    , longitude1: 0.0 ),
];
