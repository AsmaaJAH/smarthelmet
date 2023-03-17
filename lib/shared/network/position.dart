import 'package:firebase_database/firebase_database.dart';
class position {
  double latitude1;
  double longitude1;
  position({required this.latitude1, required this.longitude1});
}

final dataBase = FirebaseDatabase.instance.ref();
Map<Object?, Object?> gpsTable = {};
Map<String, List<String>> table = {
  "gps": [
    'latitude1', 'longitude1',
  ],
};
void readRealTimeDatabase() async {
  table.forEach((key, value) async {
    Query dbRef = FirebaseDatabase.instance.ref().child(key);
    await dbRef.onValue.listen((event) {
      if (key == "gps") {
        gpsTable = event.snapshot.value as Map<Object?, Object?>;
          positions.add(new position(
              latitude1:
                  double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0,
              longitude1:
                  double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0)); 
      }
    });
  });
}
List<position> positions = [
  //position(latitude1: double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0    , longitude1: double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0 ),
  // position(latitude1: 0.0    , longitude1: 0.0 ),
];
