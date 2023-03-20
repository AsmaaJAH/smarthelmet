import 'package:firebase_database/firebase_database.dart';



class position {
  double latitude;
  double longitude;
  position({required this.latitude, required this.longitude});
}


List<position> positions = [
   position(latitude: 0.0    , longitude: 0.0 ),
   position(latitude: 0.0    , longitude: 0.0 ),
   position(latitude: 0.0    , longitude: 0.0 ),
   position(latitude: 0.0    , longitude: 0.0 ),
];
