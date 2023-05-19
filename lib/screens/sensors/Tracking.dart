
import 'package:flutter/material.dart';
// import 'package:smarthelmet/shared/constants/Constants.dart';

import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/network/position.dart';

// import '../modules/home-page/workers.dart';
// import '../shared/network/position.dart';
// import 'FetchData.dart';

class Tracking extends StatefulWidget {
  late AsyncSnapshot<dynamic> snapshot;
  late int index;
  Tracking({required this.snapshot, required this.index});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> with TickerProviderStateMixin {
  var myMarkers = HashSet<Marker>(); //collection
  List<Polyline> myPolyline = [];
  late BitmapDescriptor myIcon;
  // loadImage() async {
  //   final http.Response response = await http.get(widget.snapshot.data!.docs[widget.index]["imgurl"],);
  //   myIcon = BitmapDescriptor.fromBytes(response.bodyBytes);
  // setState(() {});
  // }
  @override
  void initState() {
    //loadImage();
     createPloyLine();

     BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size(28, 28)),
      "assets\images\icons\worker_locator_mapMarker.png",
    )
    .then((onValue) {
      myIcon = onValue;
    });
    super.initState();

  }

  createPloyLine() {
    myPolyline.add(
      Polyline(
          polylineId: PolylineId('1'),
          color: Colors.blue,
          width: 3,
          points: [
            for (int i = 0; i < positions.length; i++)
              LatLng(positions[i].latitude, positions[i].longitude),
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
                          title: 'khloud & Asmaa',
                          ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan), //myIcon,
                    ),
                  );
                });
              },
              markers: myMarkers,
              polylines: myPolyline.toSet(),
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
