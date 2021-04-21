import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class mainscreen extends StatefulWidget {
  static const String idscreen = "main" ;


  @override
  _mainscreenState createState() => _mainscreenState();
}

class _mainscreenState extends State<mainscreen>
{
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newgoogleMapController ;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("main screen"),
      ),

       body: Stack(
        children: [
          GoogleMap (
            mapType: MapType.normal,
            myLocationButtonEnabled: true ,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newgoogleMapController = controller ;

            },


          ),
      ],

    ),


    );
  }
}
