import 'package:flutter/material.dart';
import 'package:notes_crud/db/operation.dart';
import 'package:notes_crud/models/note.dart';



class ListPage extends StatelessWidget {

  const ListPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MyList();

  }
}
class _MyList extends StatefulWidget {
  @override
  __MyListState createState() => __MyListState();
}

class __MyListState extends State<_MyList> {
  List<Note> notes = [];

  @override
  void initState() {
    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(title: const Text('Lista'),
      ),
      floatingActionButton: 
        FloatingActionButton(
          child: const Icon(Icons.add), 
          onPressed: () { 
            Navigator.pushNamed(context, 'newnote', arguments: Note.empty()).then((value) => setState(() {_loadData();}));
          }),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, i) => _createItem(i),
      ),
    );
  }
    
  _loadData() async {
    List<Note> auxNote = await Operation().notes();
    setState(() {
      notes = auxNote;
    });
  }

  _createItem(int i) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 5),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (direction) {
        Operation().deleteNote(notes[i].id);
        setState(() {
          notes.removeAt(i);
        });
      },
      child: ListTile(
        title: Text(notes[i].title),
        trailing: MaterialButton(
          onPressed: (){
            Navigator.pushNamed(context, 'newnote', arguments: notes[i]).then((value) => setState(() {_loadData();}) );
          },
          child: const Icon(Icons.edit)),
      ),
    );
  }



}