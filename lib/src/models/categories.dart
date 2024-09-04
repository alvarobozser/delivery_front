// To parse this JSON data, do
//
//     final categorias = categoriasFromJson(jsonString);

import 'dart:convert';

Categorias categoriasFromJson(String str) => Categorias.fromJson(json.decode(str));

String categoriasToJson(Categorias data) => json.encode(data.toJson());

class Categorias {
  String? id;
  String? name;
  String? description;

  Categorias({
     this.id,
     this.name,
     this.description,
  });

  factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  static List<Categorias> fromJsonList(List<dynamic> jsonList) {
    List<Categorias> toList=[];
    jsonList.forEach((item){
      Categorias categoria = Categorias.fromJson(item);
      toList.add(categoria);
    });

    return toList;
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}
