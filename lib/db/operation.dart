import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:notes_crud/models/note.dart';

// Crear base de datos
// O abrir base de datos si ya existe
class Operation {
  Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes1.db'),
      onCreate: (db, version){
        return db.execute(
          'CREATE TABLE notes1(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, content TEXT)',
        );
      }, version: 1
    );
  }

  // Definimos la funcion para insertar notas en la base de datos
  Future<void> insertNote(Note note) async {
    // Obtener referencia de bd
    final Database db = await _openDB();

    // Insertar note en la tabla
    // `conflictAlgorithm` se utiliza para el caso de ingresar dos veces la misma nota
    // En ese caso reemplaza los datos anteriores
    await db.insert(
      'notes1',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  // Definimos la funcion para obtener las notas
  Future<List<Note>> notes() async {
    // Obtener referencia de bd
    final Database db = await _openDB();

    // Consultar la tabla para obtener las Notas
    final List<Map<String, dynamic>> notesMap = await db.query('notes1');

    // Convertir List<Map<String, dynamic> en List<Note>
    return List.generate(notesMap.length, (i) =>
      Note(
        id: notesMap[i]['id'],
        title: notesMap[i]['title'],
        content:notesMap[i]['content'],
      )
    );

  }

  Future<void> deleteNote(int? id) async {
  // Get a reference to the database.
  final Database db = await _openDB();

  // Remove the Dog from the database.
  await db.delete(
    'notes1',
    // Use a `where` clause to delete a specific dog.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}


  Future<void> updateNote(Note note) async {
    // Get a reference to the database.
    final db = await _openDB();
    print(note);
    // Update the given Dog.
    await db.update(
      'notes1',
      note.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [note.id],
    );
  }

}