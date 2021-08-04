import 'dart:convert';

import 'package:aula/models/item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Aplicacao',
      theme: ThemeData(primaryColor: Colors.black),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  var items =
      new List<Item>(); //criei uma lista da minha classe criada item.dart
  homePage() {
    // construtor vazio para impementar as mudan;as e manter-las
    items = [];
    // items.add(Item(title: 'Amarok', done: true));
    // items.add(Item(title: 'Camaro', done: false));
    // items.add(Item(title: 'Azera', done: true));
    // items.add(Item(title: 'Veloster', done: false));
  }
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  var newTextController = TextEditingController(); // aaa
  void add() {
    setState(() {
      if (newTextController.text.isEmpty) return;
      widget.items.add(Item(title: newTextController.text, done: false));
      newTextController.text = "";
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    //future vai ler as informacoes pedidas e se tiver algo vai retornar pra mim
    var prefs =
        await SharedPreferences.getInstance(); // await vem do async AGUARDE
    var data = prefs.getString('data');
    if (data != null) {
      Iterable decode = jsonDecode(data); // transforma data string em data json
      List<Item> result = decode.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  } //QUANDO SE ACESSA UMA BIBLIOTECA DE FORA ASYNC
  // future e uma promessa
  // pertence a biblioteca

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller:
              newTextController, // para limpar  use newTextController.clear
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 18,
          ),
          decoration: InputDecoration(
              labelText: "Digite algo...",
              labelStyle: TextStyle(color: Colors.amberAccent, fontSize: 18)),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.items[index];
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
            key: Key(item.title),
            background: Container(
              color: Colors.red.withOpacity(0.3),
            ),
            onDismissed: (direction) {
              remove(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.amberAccent[200],
        onPressed: () {
          add();
        },
      ),
    );
  }
}
