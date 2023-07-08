// ignore_for_file: must_be_immutable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/network/position.dart';

class Tracking extends StatefulWidget {
  late AsyncSnapshot<dynamic> snapshot;
  late int index;
  Tracking({super.key, required this.snapshot, required this.index});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> with TickerProviderStateMixin {
  var myMarkers = HashSet<Marker>(); //collection
  Map<String, List<String>> tables = {
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP', 'fall', 'object','uid','medicalAssistance'],
    "sensors": [
      'CO PPM value',
      'Humdity',
      'LPG PPM value',
      'temp',
      'undergroundX',
      'undergroundY',
    ],
    "gps": [
      'latitude1',
      'longitude1',
    ],
  };
  Map<Object?, Object?> gpsTable = {};
  void readGPSDatabase() async {

    tables.forEach((key, value) async {
      Query dbRef = FirebaseDatabase.instance.ref().child(key);
      dbRef.onValue.listen((event) {
        print(event.snapshot.value);
        setState(() { 
          if (key == "gps") {
          gpsTable = event.snapshot.value as Map<Object?, Object?>;
          positions[0].latitude = double.parse('${gpsTable['latitude1']}');
          positions[0].longitude = double.parse('${gpsTable['longitude1']}');
        }});
      });
    });
  }
 final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController googleMapController) async {
                
                setState(() {
                  myMarkers.add(
                    Marker(
                      markerId: const MarkerId('1'),
                      position:
                          LatLng(positions[0].latitude, positions[0].longitude),

                      infoWindow: const InfoWindow(
                        title: 'khloud & Asmaa',
                      ),
                      icon: BitmapDescriptor.defaultMarker, //myIcon,
                    ),
                  );
                }
                );
        
            
      }

  @override
  void initState() {
    readGPSDatabase();
    super.initState();
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
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body:
          Stack(
          children: [
           
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(positions[0].latitude, positions[0].longitude),
                  zoom: 14),
              onMapCreated: _onMapCreated,
              markers: myMarkers,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                "${widget.snapshot.data!.docs[widget.index]["firstName"]} ${widget.snapshot.data!.docs[widget.index]["lastName"]}",
                style: const TextStyle(fontSize: 30 , fontFamily: 'Ubuntu',   fontWeight: FontWeight.bold,),
              ),
            )
          ],
        )
        );
  }
}
