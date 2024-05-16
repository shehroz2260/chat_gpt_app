import 'package:get/get.dart';

import '../models/open_apimodel_model.dart';
import '../services/api_services.dart';

class ModelController extends GetxController {
  String currentModel = "gpt-3.5-turbo-0125";
  String get getCurrentModel => currentModel;

  List<OpenApiModel> modelList = [];
  List<OpenApiModel> get getModelList => modelList;

  void setCurrentModel(String model) {
    currentModel = model;
    update();
  }

  Future<List<OpenApiModel>> getAllModels() async {
    modelList = await ApiServices.getModel();
    return modelList;
  }
}
