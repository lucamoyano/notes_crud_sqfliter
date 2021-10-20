import 'package:flutter/material.dart';

import 'package:notes_crud/db/operation.dart';
import 'package:notes_crud/models/note.dart';


class SavePage extends StatefulWidget {
  const SavePage({ Key? key }) : super(key: key);

  @override
  State<SavePage> createState() => _SavePageState();
}


class _SavePageState extends State<SavePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Recibir argumentos desde otra page
    final Note note = ModalRoute.of(context)!.settings.arguments as Note;
    _init(note);

    return WillPopScope(
      onWillPop: () async => _onWillPopScope(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Crear Nota')),
        body: _formSave(note)
      ),
    );
  }

  _init(Note note){
    _titleController.text = note.title;
    _contentController.text = note.content;
  }

  Widget _formSave(Note note) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _titleController, //Para poder obtener los valores del input
              validator: (value) =>( (value!.isEmpty) ? "Ingrese titulo" : null ),
              decoration: InputDecoration(
                labelText: 'Titulo',
                hintText: 'Titulo',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _contentController, //Para poder obtener los valores del input
              validator: (value) => ((value!.isEmpty) ? "Ingrese contenido" : null),
              maxLines: 7,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: 'Contenido',
                hintText: 'Contenido',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            ElevatedButton(
              child: const Text('Guardar'), 
              onPressed: () {
                if(_formKey.currentState!.validate()){//Validaciones de campos al presionar boton
                  if(note.id != null){
                    //Actualizar notas
                    note.title = _titleController.text;
                    note.content = _contentController.text;
                    Operation().updateNote(note);
                  } else {
                    //Crear nueva nota
                    Operation().insertNote(Note(title:_titleController.text, content:_contentController.text));
                  }
                }
              }
            )
          ],
        )
      ),
    );
  }


  Future<bool> _onWillPopScope(BuildContext context){
    return showDialog(
      context: context, 
      builder: (context) { 
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          title: Text('Estas seguro que deseas salir?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[Text('Tiene datos sin guardar')],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Si'),
                onPressed: () => Navigator.of(context).pop(true)),
            TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                }),
          ]);
        }).then((value) => value ?? false);
  }

}



