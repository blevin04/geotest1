import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geotest1/models.dart';
import 'package:geotest1/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

TextEditingController controller = TextEditingController();

BottomDrawerController drawerController = BottomDrawerController();
bool isDrawerOpen = false;
final Completer<GoogleMapController> _controller =
    Completer<GoogleMapController>();
Future<void> _goTo(CameraPosition NewPos) async {
  final GoogleMapController controller = await _controller.future;
  await controller.animateCamera(CameraUpdate.newCameraPosition(NewPos));
}

Map infantAlarm = {};

class _HomepageState extends State<Homepage> {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  ValueNotifier<bool> searchBarVisible = ValueNotifier(false);
  List<locAlarm> _locAlarms = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LocAlarm"),
        actions: [
          ListenableBuilder(
              listenable: searchBarVisible,
              builder: (context, child) {
                return IconButton(
                    onPressed: () {
                      searchBarVisible.value == false
                          ? searchBarVisible.value = true
                          : searchBarVisible.value = false;
                    },
                    icon: searchBarVisible.value
                        ? Icon(Icons.cancel)
                        : Icon(Icons.search));
              })
        ],
      ),
      drawer: Drawer(),
      body: FutureBuilder(
          future: currentLocation(),
          // initialData: LatLng(Angle.degree(0), Angle.degree(0)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Stack(
              children: [
                GoogleMap(
                    polylines:
                        Set.from(List.generate(infantAlarm.length, (index) {
                      return Polyline(
                          points: infantAlarm["points"],
                          polylineId: PolylineId(infantAlarm["id"]));
                    })),
                    polygons: Set.from(List.generate(
                        _locAlarms.where((x) => x.isCircle == false).length,
                        (index) {})),
                    circles: Set.from(List.generate(
                        _locAlarms.where((x) => x.isCircle == true).length,
                        (index) {})),
                    onLongPress: (point) {
                      drawerController.open();
                      if (!infantAlarm.containsKey("points")) {
                        infantAlarm.addAll({
                          "points": [point]
                        });
                      }
                    },
                    onTap: (point) {
                      infantAlarm.update(
                          "points", (update) => update.add(point));
                    },
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                        zoom: 18,
                        target:
                            LatLng(snapshot.data!.first, snapshot.data!.last))),
                ListenableBuilder(
                  listenable: searchBarVisible,
                  builder: (context, child) {
                    if (searchBarVisible.value == false) {
                      return Container();
                    }
                    return Container(
                        margin: EdgeInsets.all(10.0),
                        height: 60,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.black),
                            // color: const Color.fromARGB(255, 225, 225, 219),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                            padding: EdgeInsets.only(right: 45),
                            child: GooglePlaceAutoCompleteTextField(
                              textEditingController: controller,
                              googleAPIKey:
                                  "AIzaSyAk7em-eBmLFVPAvmolh1N7ueRcCmE3MfM",
                              inputDecoration: InputDecoration(),
                              debounceTime: 800, // default 600 ms,
                              // countries: ["in","fr"],// optional by default null is set

                              isLatLngRequired:
                                  true, // if you required coordinates from place detail
                              getPlaceDetailWithLatLng:
                                  (Prediction prediction) async {
                                // this method will return latlng with place detail
                                print(
                                    "${prediction.lat}:${prediction.lng}:nnnnnnnnnnnnnnnnnn");
                                if (_controller.isCompleted) {
                                  print("..........................");
                                } else {
                                  print("shiiiittttttttt");
                                }
                                await _controller.future.then((onValue) async {
                                  await onValue.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              zoom: 18,
                                              tilt: 59.8890,
                                              bearing: 0,
                                              target: LatLng(
                                                  -1.3106691, 36.8250274))));
                                });
                                // showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return Dialog(
                                //         child: Text(prediction.lat.toString()),
                                //       );
                                //     });
                                // print(
                                //     "placeDetails" + prediction.lng.toString());
                              }, // this callback is called when isLatLngRequired is true
                              itemClick: (Prediction prediction) {
                                controller.text = prediction.description!;
                              },
                              // if we want to make custom list item builder
                              itemBuilder:
                                  (context, index, Prediction prediction) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Expanded(
                                          child: Text(
                                              "${prediction.description ?? ""}"))
                                    ],
                                  ),
                                );
                              },
                              // if you want to add seperator between list items
                              seperatedBuilder: Divider(),
                              // want to show close icon
                              isCrossBtnShown: true,
                              // optional container padding
                              containerHorizontalPadding: 10,
                              // place type
                              placeType: PlaceType.geocode,
                            )));
                  },
                ),
                bottomDrawer(context)
              ],
            );
          }),
      floatingActionButton: IconButton(
          onPressed: () {
            if (isDrawerOpen) {
              drawerController.close();
              isDrawerOpen = false;
            } else {
              drawerController.open();
              isDrawerOpen = true;
            }
          },
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.amber,
                overlayColor: WidgetStatePropertyAll(Colors.blueAccent),
                child: Icon(
                  Icons.add,
                  size: 30,
                )),
          )),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
    );
  }
}

Widget bottomDrawer(BuildContext context) {
  return BottomDrawer(
    header: SizedBox(
      height: 40,
    ),
    body: Container(
      // decoration: BoxDecoration(color: Colors.grey),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Select Boundery",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              // tileColor: Colors.amber[100],
              onTap: () {
                drawerController.close();
                infantAlarm.addAll({"isCircle": true});
              },
              leading: Icon(
                Icons.circle,
                size: 40,
              ),
              title: Text("Circlular Area"),
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              onTap: () {
                drawerController.close();
                infantAlarm.addAll({"isCircle": false});
              },
              leading: Icon(
                Icons.polyline_outlined,
                size: 40,
              ),
              title: Text("Custom Area"),
            ),
          )
        ],
      ),
    ),
    headerHeight: 0,
    drawerHeight: MediaQuery.of(context).size.height / 2.5,
    color: const Color.fromARGB(117, 158, 158, 158),
    controller: drawerController,
  );
}
