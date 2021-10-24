import 'dart:async';
import 'package:auto2_comp/place_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

//Model classes that will be used for auto complete
class Suggestion {
  final String placeId;
  final String description;
  final String title;

  Suggestion(this.placeId, this.description, this.title);
}

class PlaceDetail {
  String? address;
  double? latitude;
  double? longitude;
  String? name;

  PlaceDetail({
    this.address,
    this.latitude,
    this.longitude,
    this.name,
  });
}

class LocationSearchScreen extends StatefulWidget {
  final title;
  final StreamSink<PlaceDetail> sink;

  const LocationSearchScreen({Key? key, required this.title, required this.sink}) : super(key: key);

  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final _controller = TextEditingController();
  final sessionToken = Uuid().v4();
  final provider = PlaceApiProvider(Uuid().v4());
  List<Suggestion> suggestion = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() async {
      if (_controller.text.length > 1)
        suggestion = await provider.fetchSuggestions(_controller.text);
      else {
        suggestion.clear();
      }
      setState(() {});
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => onBackPressed(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  iconSize: 32,
                  padding: EdgeInsets.only(left: 16, top: 8),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16, top: 16, bottom: 4),
                  child: Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 18, top: 8, right: 18),
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.start,
                autocorrect: false,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 12),
                    width: 32,
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                  hintText: "Enter location",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 4),
                        child: Text(
                          (suggestion[index]).title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          (suggestion[index]).description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  leading: Container(
                    child: Icon(
                      Icons.place_rounded,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                  onTap: () async {
                    final placeDetail =
                        await provider.getPlaceDetailFromId(suggestion[index].placeId);
                    widget.sink.add(placeDetail);
                    onBackPressed(context);
                  },
                ),
                itemCount: suggestion.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

onBackPressed(BuildContext context) => Navigator.of(context).pop();

