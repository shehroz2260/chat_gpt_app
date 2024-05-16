import 'dart:math';

class OpenApiModel {
  final String id;
  final int created;
  final String root;

  OpenApiModel({
    required this.id,
    required this.root,
    required this.created,
  });

  factory OpenApiModel.fromJson(Map<String, dynamic> json) => OpenApiModel(
        id: json["id"],
        root: json["owned_by"],
        created: json["created"],
      );

  static List<OpenApiModel> modelsFromSnapshot(List modelSnapshot) {
    log(modelSnapshot.length);
    return modelSnapshot.map((data) => OpenApiModel.fromJson(data)).toList();
  }
}
