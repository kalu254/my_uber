import 'dart:async';

import 'package:auto2_comp/location_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const id = "HOME_SCREEN";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentLocationCamera = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late GoogleMapController _controller;

  final _pickUpLocationSC = StreamController<PlaceDetail>.broadcast();
  StreamSink<PlaceDetail> get pickUpLocationSink => _pickUpLocationSC.sink;
  Stream<PlaceDetail> get pickUpLocationStream => _pickUpLocationSC.stream;

  final _dropUpLocationSC = StreamController<PlaceDetail>.broadcast();
  StreamSink<PlaceDetail> get dropLocationSink => _dropUpLocationSC.sink;
  Stream<PlaceDetail> get dropLocationStream => _dropUpLocationSC.stream;

  onMapCreate(GoogleMapController controller) {
    _controller = controller;
  }

  Route fadeScreenTransition(Widget destination) {
    print('appear');
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

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

    final pickupDropIconWidget = Column(
      children: [
        SizedBox(height: 8),
        const Icon(
          Icons.trip_origin_rounded,
          color: Colors.blue,
          size: 28,
        ),
        Container(
          height: 54,
          child: CustomPaint(
              size: Size(1, double.infinity),
              painter: DashedLineVerticalPainter()),
        ),
        const Icon(
          Icons.place_rounded,
          color: Colors.blue,
          size: 32,
        ),
      ],
    );

    final tvPickupAddress = ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.black,
        primary: Colors.grey[200],
        fixedSize: Size(getScreenWidth(context) - 88, 42),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(21))),
      ),
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<PlaceDetail>(
                stream: pickUpLocationStream,
                builder: (context, snapshot) {
                  final address = snapshot.data == null
                      ? "Enter pickup location"
                      : snapshot.data!.address ?? "Enter pickup location";
                  return Text(
                    address,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                  );
                }),
          ),
        ],
      ),
      onPressed: () {
        Navigator.of(context).push(fadeScreenTransition(LocationSearchScreen(
            title: "Enter Pickup Location", sink: pickUpLocationSink)));
      },
    );

    final tvDropAddress = ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.black,
        primary: Colors.grey[200],
        fixedSize: Size(getScreenWidth(context) - 88, 42),
        textStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(21))),
      ),
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<PlaceDetail>(
                stream: dropLocationStream,
                builder: (context, snapshot) {
                  final address = snapshot.data == null
                      ? "Enter drop location"
                      : snapshot.data!.address ?? "Enter drop location";
                  return Text(
                    address,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                  );
                }),
          ),
        ],
      ),
      onPressed: () {
        print('move to');
        Navigator.of(context).push(fadeScreenTransition(LocationSearchScreen(
            title: "Enter drop Location", sink: dropLocationSink)));
      },
    );

    final pickupDropWidget = Container(
      height: 300,
      width: getScreenWidth(context),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 8),
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 32),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 18, top: 48, bottom: 4),
                child: Text(
                  "Where would you like to go?",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 16),
                  pickupDropIconWidget,
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 0, top: 8, bottom: 4),
                        child: Text(
                          "From",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      tvPickupAddress,
                      Container(
                        padding:
                            const EdgeInsets.only(left: 0, top: 8, bottom: 4),
                        child: Text(
                          "To",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      tvDropAddress,
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
    return Scaffold(
      body: Stack(
        children: [
          googleMapWidget,
          pickupDropWidget,
        ],
      ),
    );
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
