import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/Constants.dart';

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../modules/home-page/workers.dart';
import '../shared/network/position.dart';
import 'FetchData.dart';

class Tracking extends StatefulWidget {
  String? index;
  Tracking({required this.index});
  @override
  State<Tracking> createState() => _TrackingState();
}


class _TrackingState extends State<Tracking> with TickerProviderStateMixin {
  var myMarkers = HashSet<Marker>(); //collection
  List<Polyline> myPolyline = [];
  late BitmapDescriptor myIcon;
final dataBase = FirebaseDatabase.instance.ref();
Map<Object?, Object?> gpsTable = {};
Map<String, List<String>> tab = {
  "gps": [
    'latitude1',
    'longitude1',

    'latitude2',
    'longitude2',

    'latitude3',
    'longitude3',

    'latitude4',
    'longitude4',
  ],
};
void readData() async {
  tab.forEach((key, value) async {
    Query dbRef = FirebaseDatabase.instance.ref().child(key);
    await dbRef.onValue.listen((event) {
      if (key == "gps") {
        gpsTable = event.snapshot.value as Map<Object?, Object?>;
        // positions.add(new position(
        //     latitude: double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0,
        //     longitude:
        //         double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0));
        positions[0].latitude =
            double.tryParse('${gpsTable['latitude1']}' ?? '') ?? 0.0;
        positions[0].longitude =
            double.tryParse('${gpsTable['longitude1']}' ?? '') ?? 0.0;
        pos[i].latitude = positions[0].latitude;
        pos[i].longitude = positions[0].longitude;
        print("-------------++++++----------------------------");
        print('${pos[i].latitude}');
        i++;

        positions[1].latitude =
            double.tryParse('${gpsTable['latitude2']}' ?? '') ?? 0.0;
        positions[1].longitude =
            double.tryParse('${gpsTable['longitude2']}' ?? '') ?? 0.0;
        pos[i].latitude = positions[1].latitude;
        pos[i].longitude = positions[1].longitude;
        print("-------------++++++----------------------------");
        print('${pos[i].latitude}');
        i++;

        positions[2].latitude =
            double.tryParse('${gpsTable['latitude3']}' ?? '') ?? 0.0;
        positions[2].longitude =
            double.tryParse('${gpsTable['longitude3']}' ?? '') ?? 0.0;
        pos[i].latitude = positions[2].latitude;
        pos[i].longitude = positions[2].longitude;
        print("-------------++++++----------------------------");
        print('${pos[i].latitude}');
        i++;

        positions[3].latitude =
            double.tryParse('${gpsTable['latitude4']}' ?? '') ?? 0.0;
        positions[3].longitude =
            double.tryParse('${gpsTable['longitude4']}' ?? '') ?? 0.0;
        pos[i].latitude = positions[3].latitude;
        pos[i].longitude = positions[3].longitude;
        print("-------------++++++----------------------------");
        print('${pos[i].latitude}');
        i++;


       setState(() {});
      }
    });
  });
}
  @override
  void initState() {
    readData();
    //readRealTimeDatabase();

    super.initState();
    createPloyLine();

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(28, 28)),
      map[widget.index]!.imgpath,
    ).then((onValue) {
      myIcon = onValue;
    });
  }

  createPloyLine() {
    myPolyline.add(
      Polyline(
          polylineId: PolylineId('1'),
          color: Colors.blue,
          width: 3,
          points: [
            // LatLng(positions[0].latitude1, positions[0].longitude1),
            //  LatLng(positions[1].latitude1, positions[1].longitude1),
            //   LatLng(positions[2].latitude1, positions[2].longitude1),
            //   LatLng(positions[3].latitude1, positions[3].longitude1),

            for (int i = 0; i < pos.length; i++)
              LatLng(pos[i].latitude, pos[i].longitude),

            // LatLng(31.205700607192632, 29.925107233350353),
            // LatLng(31.20589419729555, 29.922933804084426),
            // LatLng(31.206428979996314, 29.921243671893173),
            // LatLng(31.205200646477095, 29.919690313405248),
          ],
          patterns: [
            PatternItem.dash(20),
            PatternItem.gap(10),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tracking By Google Maps',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
              fontFamily: 'Ubuntu',
            ),
          ),
          backgroundColor: navBarColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(31.205200646477095, 29.919690313405248),
                  zoom: 14),
              onMapCreated: (GoogleMapController googleMapController) {
                setState(() {
                  myMarkers.add(
                    Marker(
                      markerId: MarkerId('1'),
                      position: LatLng(31.205200646477095, 29.919690313405248),
                      infoWindow: InfoWindow(
                          title: 'khloud mousad',
                          snippet: 'temp:50  co level:40 '),
                      icon: myIcon,
                    ),
                  );
                });
              },
              markers: myMarkers,
              polylines: myPolyline.toSet(),
            ),
            Container(
              child: Text(
                map[widget.index]!.workername,
                style: TextStyle(fontSize: 50),
              ),
              alignment: Alignment.bottomCenter,
            )
          ],
        ));
  }
}
