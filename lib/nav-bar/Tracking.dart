import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/Constants.dart';

import 'dart:collection';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tracking extends StatefulWidget {
  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  var myMarkers = HashSet<Marker>(); //collection

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
          leading:
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 14),
              onMapCreated: (GoogleMapController googleMapController) {
                setState(() {
                  myMarkers.add(
                    Marker(
                      markerId: MarkerId('1'),
                      position: LatLng(30.0444, 31.2357),
                    ),
                  );
                });
              },
              markers: myMarkers,
            ),
            Container(
                // height: 300,
                // width: double.infinity,
                // child: Image.asset('assets/images/googleTracking.png'),
                // alignment: Alignment.topCenter,
                ),
            Container(
              // child: Text(
              //   'showing Where the worker now using Google Maps ',
              //   style: TextStyle(fontSize: 50),
              // ),
              // alignment: Alignment.bottomCenter,
            )
          ],
        ));
  }
}
