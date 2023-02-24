// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:note_take/Models/model.dart';
import 'Utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Model note;
  NoteDetail(this.note, this.appBarTitle);

  @override
  State<NoteDetail> createState() {
    return _NoteDetailState(this.note, appBarTitle);
  }
}

class _NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Model note;
  static final _proirities = ["High", "Low"];

  TextEditingController titleControl = TextEditingController();
  TextEditingController despControl = TextEditingController();
  DatabaseHelper helper = DatabaseHelper();

  _NoteDetailState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    titleControl.text = note.title;
    despControl.text = note.description;
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 30),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                controller: titleControl,
                style: TextStyle(fontStyle: FontStyle.normal),
                onChanged: (value) {
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: despControl,
              style: TextStyle(fontStyle: FontStyle.normal),
              onChanged: (value) {
                updateDesp();
              },
              decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
            SizedBox(height: 20),
            ListTile(
              title: DropdownButtonHideUnderline(
                child: DropdownButton(
                    items: _proirities.map((String dropDownStringItem) {
                      return DropdownMenuItem(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    // value: updatePriorityToString(note.priority),
                    onChanged: (valueselectedByUser) {
                      setState(() {
                        // updatPriorityToInt(valueselectedByUser);
                      });
                    }),
              ),

              //           DropdownButton<String>(
              //   value: dropdownValue,
              //   icon: const Icon(Icons.arrow_downward),
              //   elevation: 16,
              //   style: const TextStyle(color: Colors.deepPurple),
              //   underline: Container(
              //     height: 2,
              //     color: Colors.deepPurpleAccent,
              //   ),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       dropdownValue = newValue!;
              //     });
              //   },
              //   items: <String>['One', 'Two', 'Free', 'Four']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // );
            ),
            SizedBox(height: 30),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.black),
                      textScaleFactor: 1.25,
                    ),
                    onPressed: () {
                      setState(() {
                        _save();
                      });
                    }),
              ),
              SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.black),
                      textScaleFactor: 1.25,
                    ),
                    onPressed: () {
                      setState(() {
                        _delete();
                      });
                    }),
              ),
            ])
          ],
        ),
      ),
    );
  }

  //Convet the string priority to Integer before saving to database
  // void updatPriorityToInt(String prior) {
  //   if (prior == "High") {
  //     note.priority = 1;
  //   }
  //   if (prior == "Low") {
  //     note.priority = 0;
  //   }
  // }

  // //Convet the integer priority to string before saving to database
  // String updatePriorityToString(int value) {
  //   String str = " ";
  //   if (value == 1) {
  //     str = _proirities[0];
  //   }
  //   if (value == 0) {
  //     str = _proirities[1];
  //   }
  //   return str;
  // }

  void updateDesp() {
    note.description = despControl.text;
  }

  void updateTitle() {
    note.title = titleControl.text;
  }
  // save button operation

  void _save() async {
    // Update operation
    Navigator.pop(context, true);

    note.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    }
    // Insert operation
    else {
      result = await helper.insertNode(note);
    }
    // success
    if (result != 0) {
      _showAlert('Status', 'Saved Successfully');
    } else {
      _showAlert('Status', 'Not Saved');
    }
  }

  void _showAlert(String title, String msg) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void _delete() async {
    Navigator.pop(context, true);
    // case1 : If user want to delete New Note
    if (note.id == null) {
      _showAlert('Status', 'No Note Deleted');
      return;
    }
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlert('Status', 'Note Deleted');
    } else {
      _showAlert('Status', 'Error Occured');
    }
    // case2 : If user want to delete old note having ID
  }
}
