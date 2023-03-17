import 'package:firebase_database/firebase_database.dart';

int i = 0;

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
void readData() async {
  table.forEach((key, value) async {
    Query dbRef = FirebaseDatabase.instance.ref().child(key);
    await dbRef.onValue.listen((event) {
      if (key == "gps") {
        gpsTable = event.snapshot.value as Map<Object?, Object?>;
        positions.add(new position(
            latitude1: double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0,
            longitude1:
                double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0));
        positions[0].latitude1 =
            double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0;
        positions[0].longitude1 =
            double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0;
        pos[i].latitude1 = positions[0].latitude1;
        pos[i].longitude1 = positions[0].longitude1;
        print("-------------++++++----------------------------");
        print('${pos[i].latitude1}');
        i++;

        positions[1].latitude1 =
            double.tryParse('${gpsTable['latitude2']}' ?? '') ?? 0.0;
        positions[1].longitude1 =
            double.tryParse('${gpsTable['longitude2']}' ?? '') ?? 0.0;
        pos[i].latitude1 = positions[1].latitude1;
        pos[i].longitude1 = positions[1].longitude1;
        print("-------------++++++----------------------------");
        print('${pos[i].latitude1}');
        i++;

        positions[2].latitude1 =
            double.tryParse('${gpsTable['latitude3']}' ?? '') ?? 0.0;
        positions[2].longitude1 =
            double.tryParse('${gpsTable['longitude3']}' ?? '') ?? 0.0;
        pos[i].latitude1 = positions[2].latitude1;
        pos[i].longitude1 = positions[2].longitude1;
        print("-------------++++++----------------------------");
        print('${pos[i].latitude1}');
        i++;

        positions[3].latitude1 =
            double.tryParse('${gpsTable['latitude4']}' ?? '') ?? 0.0;
        positions[3].longitude1 =
            double.tryParse('${gpsTable['longitude4']}' ?? '') ?? 0.0;
        pos[i].latitude1 = positions[3].latitude1;
        pos[i].longitude1 = positions[3].longitude1;
        print("-------------++++++----------------------------");
        print('${pos[i].latitude1}');
        i++;

      
      }
    });
  });
}

List<position> positions = [
  //position(latitude1: double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0    , longitude1: double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0 ),
  // position(latitude1: 0.0    , longitude1: 0.0 ),
];

List<position> pos = [
  // position(latitude1:31.205700607192632, longitude1:29.925107233350353),
  // position(latitude1:31.20589419729555, longitude1:29.922933804084426),
  // position(latitude1:31.206428979996314, longitude1:29.921243671893173),
  // position(latitude1:31.205200646477095, longitude1:29.919690313405248),
];
