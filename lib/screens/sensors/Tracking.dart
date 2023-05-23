import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/network/position.dart';

class Tracking extends StatefulWidget {
  late AsyncSnapshot<dynamic> snapshot;
  late int index;
  Tracking({required this.snapshot, required this.index});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> with TickerProviderStateMixin {
  late GoogleMapController _mapController;
  Map<MarkerId, Marker> _markers = {};
  var _center = LatLng(positions[0].latitude, positions[0].longitude);
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Add a marker to the map at the center location
    final MarkerId markerId = MarkerId('center');
    final Marker marker = Marker(
      markerId: markerId,
      position: _center,
      infoWindow: InfoWindow(
        title: 'Center',
        snippet: 'The center of the map',
      ),
    );

    setState(() {
      _markers[markerId] = marker;
    });
  }
  void _listenForChanges() {
     tables.forEach((key, value) async {
      Query dbRef = FirebaseDatabase.instance.ref().child(key);
      await dbRef.onValue.listen((event) {
        print(event.snapshot.value);
        setState(() {
          if (key == "gps") {
            gpsTable = event.snapshot.value as Map<Object?, Object?>;
            positions[0].latitude = double.parse('${gpsTable['latitude1']}');
            positions[0].longitude = double.parse('${gpsTable['longitude1']}');
            print("GGGGGGGG---------PPPPPPPPPP---------SSSSSSSSSSSSSSSSSSSSS");
            print(positions[0].latitude);
          }
        });
      });
    });
  }

  var myMarkers = HashSet<Marker>(); //collection
  Map<String, List<String>> tables = {
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP', 'fall', 'object'],
    "sensors": [
      'CO PPM value',
      'Humdity',
      'LPG PPM value',
      'temp',
      'underGround'
    ],
    "gps": [
      'latitude1',
      'longitude1',
    ],
  };
  Map<Object?, Object?> gpsTable = {};
  void readGPSDatabase() async {
   
  }

  // final Map<String, Marker> _markers = {};
  // Future<void> _onMap(GoogleMapController mapController) async {
  //   setState(() {
  //     myMarkers.add(
  //       Marker(
  //         markerId: MarkerId('1'),
  //         position: LatLng(positions[0].latitude, positions[0].longitude),

  //         infoWindow: InfoWindow(
  //           title: 'khloud & Asmaa & Salah',
  //         ),
  //         icon: BitmapDescriptor.defaultMarkerWithHue(
  //             BitmapDescriptor.hueCyan), //myIcon,
  //       ),
  //     );
  //   });
  // }

  @override
  void initState() {
    _listenForChanges();
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
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 14),
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(_markers.values),
            ),
            Container(
              child: Text(
                "${widget.snapshot.data!.docs[widget.index]["firstName"]} ${widget.snapshot.data!.docs[widget.index]["lastName"]}",
                style: TextStyle(fontSize: 50),
              ),
              alignment: Alignment.bottomCenter,
            )
          ],
        ));
  }
}
