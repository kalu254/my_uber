import 'package:auto2_comp/home_screen.dart';
import 'package:auto2_comp/location_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  var currentLocationCamera = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    final googleMapWidget = GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: currentLocationCamera,
      onMapCreated: onMapCreate,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      padding: const EdgeInsets.only(top: 300),
    );

    return Scaffold(
      body: Stack(
        children: [
          googleMapWidget,
        ],
      ),
    );
  }

  onMapCreate(GoogleMapController controller) {
    _controller = controller;
  }
}
