import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geotest1/models.dart';
import 'package:geotest1/pages/addPage.dart';
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
// Future<void> _goTo(CameraPosition NewPos) async {
//   final GoogleMapController controller = await _controller.future;
//   await controller.animateCamera(CameraUpdate.newCameraPosition(NewPos));
// }

Map infantAlarm = {};
List<locAlarm> _locAlarms = [];
ValueNotifier newPoint = ValueNotifier(0);
ValueNotifier<bool> editing_ = ValueNotifier(false);

class _HomepageState extends State<Homepage> {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  ValueNotifier<bool> searchBarVisible = ValueNotifier(false);

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
              // alignment: Alignment.bottomCenter,
              children: [
                ListenableBuilder(
                    listenable: newPoint,
                    builder: (context, child) {
                      return GoogleMap(
                          polylines: infantAlarm["isCircle"] != true
                              ? Set.from(
                                  List.generate(infantAlarm.length, (index) {
                                  if (infantAlarm["isCircle"] != true &&
                                      infantAlarm["points"] != null) {
                                    return Polyline(
                                        points: infantAlarm["points"],
                                        polylineId: PolylineId("00"));
                                  }
                                  return Polyline(polylineId: PolylineId("pp"));
                                }))
                              : {},
                          polygons: Set.from(List.generate(
                              _locAlarms
                                  .where((x) => x.isCircle == false)
                                  .length,
                              (index) {})),
                          circles: Set.from(List.generate(
                              _locAlarms
                                  .where((x) => x.isCircle == true)
                                  .where((y) => y.points.isNotEmpty)
                                  .length, (index) {
                            // print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
                            return Circle(
                                consumeTapEvents: true,
                                onTap: () {},
                                center: _locAlarms[index].points.last,
                                radius: 20,
                                circleId: CircleId(
                                  _locAlarms[index].id,
                                ));
                          })),
                          onLongPress: (point) {
                            drawerController.open();
                            if (!infantAlarm.containsKey("points")) {
                              infantAlarm.addAll({
                                "points": [point]
                              });
                            }
                            print(infantAlarm);
                          },
                          onTap: (point) {
                            if (infantAlarm["isCircle"] != true) {
                              List prev = infantAlarm["points"];
                              // List prev = [];
                              prev.add(point);
                              // print(prev);
                              infantAlarm["points"] = prev;
                            } else {
                              if (!infantAlarm.containsKey("points")) {
                                _locAlarms.last.points = [point];
                                // newPoint.value++;
                              } else {
                                _locAlarms.last.points = [point];
                              }
                            }
                            newPoint.value++;
                            print(infantAlarm);
                          },
                          onMapCreated: (controller) {
                            _controller.complete(controller);
                          },
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                              zoom: 18,
                              target: LatLng(
                                  snapshot.data!.first, snapshot.data!.last)));
                    }),
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
                bottomDrawer(context),
                ListenableBuilder(
                    listenable: editing_,
                    builder: (context, child) {
                      return Visibility(
                          visible: editing_.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        _locAlarms.removeLast();
                                        infantAlarm.clear();
                                        editing_.value = false;
                                        newPoint.value++;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            bottom: 5,
                                            top: 5),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                92, 0, 0, 0)),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            (MaterialPageRoute(
                                                builder: (context) => Addpage(
                                                    localarm:
                                                        _locAlarms.last))));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            bottom: 5,
                                            top: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.blue),
                                        child: Text(
                                          "Next",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ));
                    })
              ],
            );
          }),
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                (MaterialPageRoute(
                    builder: (context) => Addpage(
                        localarm: locAlarm(
                            attachments: [],
                            id: "ld",
                            isCircle: true,
                            message: "mesafeas",
                            points: [],
                            radius: 10)))));
            // if (isDrawerOpen) {
            //   drawerController.close();
            //   isDrawerOpen = false;
            // } else {
            //   drawerController.open();
            //   isDrawerOpen = true;
            // }
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
                _locAlarms.add(locAlarm(
                    attachments: [],
                    id: "pp",
                    isCircle: true,
                    message: "",
                    points: infantAlarm.containsKey("points")
                        ? infantAlarm["points"]
                        : [],
                    radius: 10));
                infantAlarm.addAll({"isCircle": true});
                newPoint.value++;
                editing_.value = true;
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
                editing_.value = true;
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
