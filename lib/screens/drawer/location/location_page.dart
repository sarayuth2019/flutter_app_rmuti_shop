import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LocationPage();
  }
}

class _LocationPage extends State {

  Completer<GoogleMapController> _controller = Completer();
  LocationData _locationData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Text("Location"),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on_outlined),
            onPressed: _myLocation,
          )
        ],
      ),
      body: Container(
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          mapType: MapType.hybrid,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
              target: LatLng(16.4306698, 102.8639935), zoom: 16.5),
          markers: {

            Marker(
                markerId: MarkerId("12"),
                position: LatLng(16.4301599, 102.8622626),
                infoWindow: InfoWindow(title: "ตึก 12")),
            Marker(
                markerId: MarkerId("7"),
                position: LatLng(16.4288955, 102.8637418),
                infoWindow: InfoWindow(title: "ตึก 7")),
            Marker(
                markerId: MarkerId("5"),
                position: LatLng(16.4285666, 102.8636997),
                infoWindow: InfoWindow(title: "ตึก 5")),
          },
        ),
      ),
    );
  }

  Future<LocationData> getMyLocation() async {
    Location location = Location();
    return await location.getLocation();
  }

  Future _myLocation() async {
    GoogleMapController controller = await _controller.future;
    _locationData = await getMyLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_locationData.latitude, _locationData.longitude),
        zoom: 18)));
  }
}
