import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:capcafe_app/DateHandler/appDate.dart';
import 'package:capcafe_app/Models/directDetails.dart';
import 'package:capcafe_app/allscreens/AboutScreen.dart';
import 'package:capcafe_app/allscreens/SearchScreen.dart';
import 'package:capcafe_app/allscreens/loginscreen.dart';
import 'package:capcafe_app/allwiges/Divider.dart';
import 'package:capcafe_app/allwiges/progressDilog.dart';
import 'package:capcafe_app/assistan/AssistantMethod.dart';
import 'package:capcafe_app/configMap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class mainscreen extends StatefulWidget {
  static const String idscreen = "main" ;


  @override
  _mainscreenState createState() => _mainscreenState();
}

// ignore: camel_case_types
class _mainscreenState extends State<mainscreen> with TickerProviderStateMixin
{
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newgoogleMapController ;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  DirectionDetails tripDirectionDetails;


  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};



  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Set<Marker> markersSet = {};
  Set<Circle> circleSet = {};


  double rideDetailsContainerHeight = 0;
  double requestRideContainerHeight = 0;
  double searchContainerHeight = 300.0;
  double driverDetailsContainerHeight = 0;

  bool drawerOpen = true;
  bool nearbyAvailableDriverKeysLoaded = false;
  DatabaseReference rideRequestRef ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethod.getCurrentOnlineUserInfo();
  }

  void saveRideRequest()
  {
    rideRequestRef = FirebaseDatabase.instance.reference().child("Ride Requests").push();

    var pickUp = Provider.of<appDate>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<appDate>(context, listen: false).dropOffLocation;

    Map pickUpLocMap =
    {
      "latitude": pickUp.latitude.toString(),
      "longitude": pickUp.longitude.toString(),
    };

    Map dropOffLocMap =
    {
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };

    Map rideInfoMap =
    {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userCurrentInfo.name,
      "rider_phone": userCurrentInfo.phone,
      "pickup_address": pickUp.placeName,
      "dropoff_address": dropOff.placeName,
      "ride_type": carRideType,
    };
    rideRequestRef.set(rideInfoMap);

  }


  void cancelRideRequest()
  {
    rideRequestRef.remove();
  }




  void displayRequestRideContainer()
  {
    setState(() {
      requestRideContainerHeight = 250.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230.0;
      drawerOpen = true;
    });

    saveRideRequest();
  }



  resSetApp()
  {
    setState(() {
      drawerOpen=true;
      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      requestRideContainerHeight = 0;
      bottomPaddingOfMap = 260.0;


      polylineSet.clear();
      markersSet.clear();
      circleSet.clear();
      pLineCoordinates.clear();
    });

    locatePosition();
  }


  void displayRideDetailsContainer()async
  {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 340.0;
      bottomPaddingOfMap = 360.0;
      drawerOpen = false;
    });

  }


  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newgoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethod.searchCoordinateAddress(position, context);
    print("This is your Address :: " + address);


  }


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key : scaffoldKey ,
      appBar: AppBar(
        title:Text("main screen"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              //drawer Header
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png", height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("profile name", style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),),
                          SizedBox(height: 6.0,),
                          GestureDetector(
                              onTap: ()
                              {
                              },
                              child: Text("Visit Profile")
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DividerWidget(),

              SizedBox(height: 12.0,),

              //Drawer Body Contrllers
              GestureDetector(
                onTap: ()
                {
                },
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text("History", style: TextStyle(fontSize: 15.0),),
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                },
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Visit Profile", style: TextStyle(fontSize: 15.0),),
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutScreen()));
                },
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About", style: TextStyle(fontSize: 15.0),),
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, Loginscreen.idscreen, (route) => false);
                },
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Sign Out", style: TextStyle(fontSize: 15.0),),
                ),
              ),

            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          GoogleMap (
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap, top: 25.0),
            mapType: MapType.normal,
            myLocationButtonEnabled: true ,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polylineSet,
            markers: markersSet,
            circles: circleSet,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newgoogleMapController = controller ;
              setState(() {
                bottomPaddingOfMap = 300.0;
              });
              locatePosition();

            },


          ),

          Positioned(
            top: 38.0,
            left: 22.0,
            child: GestureDetector(
              onTap: (){
                if (drawerOpen){
                  scaffoldKey.currentState.openDrawer();
                }
                else
                  {
                    resSetApp();
                  }
              },

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon( (drawerOpen)? Icons.menu_open : Icons.close , color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: searchContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white ,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7 , 0.7),

                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0 , vertical: 18.0),
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0,),
                      Text("hi there", style:TextStyle(fontSize: 12.0)),
                      Text("what you need", style:TextStyle(fontSize: 20.0 , fontFamily: "Brand-Bold") ,),
                      SizedBox(height: 10.0,),


                      GestureDetector(
                        onTap: () async
                        {
                          var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                          if (res == "obtainDirection"){
                            displayRideDetailsContainer();
                          }

                        },
                        child: Container (
                          decoration: BoxDecoration(
                            color: Colors.white ,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius:6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7 , 0.7),

                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: Row(
                              children: [
                                Icon(Icons.search , color: Colors.blue,),
                                SizedBox(width:20,height: 10.0,),
                                Text("search Drop off" , style: TextStyle (fontSize: 20.0), ),
                              ],
                            ),
                          ),

                        ),
                      ),




                      SizedBox(width:34.0,height: 15.0,),
                      Row(
                        children: [
                          Icon(Icons.home, color: Colors.green,),
                          SizedBox(width: 19.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<appDate>(context).pickUpLocation != null
                                    ?  Provider.of<appDate>(context).pickUpLocation.placeName : "add home" ,
                              ),
                              SizedBox(width: 24.0,height: 5.0,),
                              Text
                                (" your living home address",style: TextStyle(color: Colors.black , fontSize: 12.0),),

                            ],
                          ),
                        ],
                      ),

                      SizedBox(width:10.0,height: 15.0,),
                      DividerWidget(),
                      SizedBox(width:16.0,height: 15.0,),

                      Row(
                        children: [
                          Icon(Icons.outlined_flag, color: Colors.green,),
                          SizedBox(width: 12.0,height: 15.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("add ur loc "),
                              SizedBox(width: 14.0,height: 5.0,),
                              Text
                                (" your loc you wanna go address",style: TextStyle(color: Colors.black, fontSize: 12.0),),

                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),


              ),
            ),

          ),

          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration:BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),

                child: Padding(
                  padding:EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.tealAccent[100],
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Image.asset("images/delivery-truck.png" , height: 70.0,width: 80.0,),
                              SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "truck" , style: TextStyle(fontSize: 18.0 , fontFamily: "Brand Bold"),
                                  ),
                                  Text(
                                  ((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '') , style: TextStyle(fontSize: 16.0, color: Colors.grey,),
                                     ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                ((tripDirectionDetails != null) ? '\$${(AssistantMethod.calculateFares(tripDirectionDetails))*2}' : ''), style: TextStyle(fontFamily: "Brand Bold",),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 21.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.moneyCheckAlt, size: 18.0, color: Colors.black54,),
                            SizedBox(width: 16.0,),
                            Text("Cash"),
                            SizedBox(width: 6.0,),
                            Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 16.0,),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      onPressed: () { displayRequestRideContainer(); },
                      child: Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Request", style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold , color: Colors.white),),
                            Icon(FontAwesomeIcons.truck , color: Colors.white , size: 26.0,),

                          ],
                        ),
                      ),
                    ),

                  )





                    ],

                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 16.0,
                        color: Colors.black54,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                    height: requestRideContainerHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                      children: [
                        SizedBox(height: 12.0,),
                       SizedBox(
                        width: double.infinity,
                        child: TextLiquidFill(
                        text: ' Please wait ',
                         waveColor: Colors.blueAccent,
                         boxBackgroundColor: Colors.redAccent,
                         textStyle: TextStyle(
                         fontSize: 50.0,
                         fontWeight: FontWeight.bold,
                              ),
                             boxHeight: 300.0,
                            ),
                          ),

                        SizedBox(height: 22.0,),

                        GestureDetector(
                          onTap: ()
                          {
                            cancelRideRequest();
                            resSetApp();
                          },
                          child: Container(
                            height: 60.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26.0),
                              border: Border.all(width: 2.0, color: Colors.grey[300]),
                            ),
                            child: Icon(Icons.close, size: 26.0,),
                          ),
                        ),
                        SizedBox(height: 10.0,),

                        Container(
                          width: double.infinity,
                          child: Text("Cancel Ride", textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0),),
                        ),

                      ],
                   ),
                    ),

                )
            ),
        ],

      ),


    );
  }

  Future<void> getPlaceDirection() async
  {
    var initialPos = Provider
        .of<appDate>(context, listen: false)
        .pickUpLocation;
    var finalPos = Provider
        .of<appDate>(context, listen: false)
        .dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            progressDilog(massage: "Please wait...",));
    var details = await AssistantMethod.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });




    Navigator.pop(context);
    print("This is Encoded :: ");
    print(details.encodedPoints);


    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if(decodedPolyLinePointsResult.isNotEmpty)
    {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if(pickUpLatLng.latitude > dropOffLatLng.latitude  &&  pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else if(pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    }
    else if(pickUpLatLng.latitude > dropOffLatLng.latitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    else
    {
      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newgoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));


    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(title: initialPos.placeName, snippet: "my Location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "DropOff Location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });


  }
}
