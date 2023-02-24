// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_this, dead_code
import 'package:sqflite/sqflite.dart';
import 'Utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'note_detail.dart';
import 'Models/model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Model>? noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    noteList ??= <Model>[];
    updateList();
    // if (noteList == null) {
    //   noteList = List<Model>();
    //   updateList();
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Note Take",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Model(' ', ' ', 2, ' '), "Add Note");
        },
        child: Icon(Icons.add_card_rounded),
      ),
    );
  }

  ListView getListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white38,
            elevation: 4.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    getPriorityColor(this.noteList![position].priority),
                child: getPriorityIcon(this.noteList![position].priority),
              ),
              title: Text(
                "Notes",
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              subtitle: Text(this.noteList![position].date),
              trailing: GestureDetector(
                child: Icon(Icons.delete_outline),
                onTap: () {
                  _delete(context, noteList![position]);
                },
              ),
              onTap: () {
                navigateToDetail(noteList![position], "Edit Note");
              },
            ),
          );
        });
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.keyboard_arrow_up_outlined);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_down_outlined);
        break;
      default:
        return Icon(Icons.keyboard_arrow_down_outlined);
    }
  }

  Future _delete(BuildContext context, Model note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      __showSnackBar(context, "Note Deleted");
      updateList();
    }
  }

  void __showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Model>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void navigateToDetail(Model note, String appBarTitle) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetail(note, appBarTitle)),
    );
    if (result == true) {
      updateList();
    }
  }
}
