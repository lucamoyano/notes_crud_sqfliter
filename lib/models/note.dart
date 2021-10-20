class Note {
  final int? id;
  String title;
  String content;

  Note({this.id, required this.title, required this.content});
  
  Note.empty({this.id, this.title='',this.content=''});

  //Convertir Nota a Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'content': content
    };
  }


  //Convertr a String para ver la informacion mas facil
  @override
  String toString() {
    return 'Note{id: $id, name: $title, age: $content}';
  }
  
}