import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geotest1/models.dart';
import 'package:geotest1/pages/homepage.dart';
import 'package:geotest1/utils.dart';
import 'package:uuid/uuid.dart';

List<Attachment> attachments = List.empty(growable: true);

ValueNotifier newStuff = ValueNotifier(0);

TextEditingController messageController = TextEditingController();

class Addpage extends StatelessWidget {
  final locAlarm localarm;
  const Addpage({super.key, required this.localarm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Add Message"),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                // expands: true,
                controller: messageController,
                maxLines: null,
                // minLines: null,
                decoration: InputDecoration(
                    labelText: "Alart Message",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 3))),
              ),
            ),
            Text("Attachments"),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ListenableBuilder(
                  listenable: newStuff,
                  builder: (context, child) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 2),
                            itemCount: attachments.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(attachments.last.path);
                              print(attachments.first.fileType);
                              if (attachments[index].fileType ==
                                  FileType.image) {
                                return Image(
                                    image: FileImage(
                                        File(attachments[index].path)));
                              }
                              if (attachments[index].fileType ==
                                  FileType.video) {
                                return Container();
                              }
                              return Container();
                            },
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: IconButton(
                                onPressed: () async {
                                  attachments.add(
                                      await getContent(context, FileType.any));
                                  newStuff.value++;
                                },
                                icon: Icon(
                                  Icons.attachment,
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(92, 0, 0, 0)),
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
              onTap: () async {
                int completed = 104;
                locAlarm newLoc = locAlarm(
                    attachments: attachments,
                    id: Uuid().v1(),
                    isCircle: localarm.isCircle,
                    message: messageController.text,
                    points: localarm.points,
                    radius: localarm.radius);
                showcircularProgressIndicator(context);
                while (completed == 104) {
                  completed = await addLocAlarm(newLoc);
                }
                Navigator.pop(context);
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
                child: Text(
                  "Finish",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
