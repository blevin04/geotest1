import 'package:flutter/material.dart';
import 'package:geotest1/models.dart';
import 'package:geotest1/pages/homepage.dart';

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
                controller: controller,
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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child:
                    IconButton(onPressed: () {}, icon: Icon(Icons.attachment)),
              ),
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
              onTap: () {},
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
