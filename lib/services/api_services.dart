import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/models/open_apimodel_model.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "https://api.openai.com/v1";
const String apiKey = "";

class ApiServices {
  static Future<List<OpenApiModel>> getModel() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/models"),
        headers: {"Authorization": "Bearer $apiKey"},
      );
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse["error"] != null) {
        throw HttpException(jsonResponse["error"]["message"]);
      }
      List temp = [];
      for (var value in jsonResponse["data"]) {
        log("fdsadfasdf $value");
        temp.add(value);
        //log("model: $value");
      }
      return OpenApiModel.modelsFromSnapshot(temp);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage(
      {required String msg, required String modelId}) async {
    try {
      var response = await http.post(Uri.parse("$baseUrl/completions"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $apiKey"
          },
          body:
              jsonEncode({"model": modelId, "prompt": msg, "max_tokens": 100}));

      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse["error"] != null) {
        throw HttpException(jsonResponse["error"]["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        //log("Message: ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
