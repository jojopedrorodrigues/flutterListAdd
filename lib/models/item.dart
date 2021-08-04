class Item {
  String title;
  bool done;
  Item({this.title, this.done}); //construtor
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
        new Map<String, dynamic>(); //criando um novo map data
    data['title'] = this.title; //passando o valor do title para a data
    data['done'] = this.done;

    return data; //retornando esses valores
  }
}
