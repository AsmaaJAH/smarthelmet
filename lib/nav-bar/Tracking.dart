import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/Constants.dart';

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../modules/home-page/workers.dart';
import '../shared/network/position.dart';

class Tracking extends StatefulWidget {
  String? index;
  Tracking({required this.index});
  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  var myMarkers = HashSet<Marker>(); //collection
  List<Polyline> myPolyline = [];
  late BitmapDescriptor myIcon;

  @override
  void initState() {
    super.initState();
    createPloyLine();

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(28, 28)),
      map[widget.index]!.imgpath,
    ).then((onValue) {
      myIcon = onValue;
    });
  }

  List<LatLng> list_positions() {
   for (int i = 0; i < pos.length +1 ; i++){
    
            LatLng(31.205700607192632, 29.925107233350353),
            LatLng(31.20589419729555, 29.922933804084426),
            LatLng(31.206428979996314, 29.921243671893173),
            LatLng(31.205200646477095, 29.919690313405248),
        print(pos[i].toString());
   }

    return pos;
  }

  createPloyLine() {
    myPolyline.add(
      Polyline(
          polylineId: PolylineId('1'),
          color: Colors.blue,
          width: 3,
          points: list_positions,
              

            //LatLng(31.205700607192632, 29.925107233350353),
            //LatLng(31.20589419729555, 29.922933804084426),
            //LatLng(31.206428979996314, 29.921243671893173),
            //LatLng(31.205200646477095, 29.919690313405248),
          
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
