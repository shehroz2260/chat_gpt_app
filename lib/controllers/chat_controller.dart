import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat_model.dart';
import '../services/api_services.dart';
import '../view/widgets/custom_text_widget.dart';
import 'model_controller.dart';

class ChatController extends GetxController {
  List<ChatModel> chatList = [];
  FocusNode focusNode = FocusNode();
  List<ChatModel> get getchatList => chatList;
  final _chatController = TextEditingController();
  TextEditingController get chatController => _chatController;
  ScrollController scrollController = ScrollController();
  bool isTyping = false;
  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    update();
  }

  Future<void> botMessage(
      {required String msg, required String modelID}) async {
    chatList.addAll(await ApiServices.sendMessage(
      msg: msg,
      modelId: modelID,
    ));
    update();
  }

  @override
  void onClose() {
    _chatController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessages({
    required ModelController modelController,
  }) async {
    if (isTyping) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: CustomTextWidget(
            label: "You can't send multiple messages.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_chatController.text.isEmpty) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: CustomTextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String sendMsg = _chatController.text;

      isTyping = true;
      addUserMessage(msg: sendMsg);
      _chatController.clear();
      focusNode.unfocus();

      await botMessage(
        msg: sendMsg,
        modelID: modelController.currentModel,
      );
      update();
    } catch (e) {
      log("error is: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: CustomTextWidget(
          label: e.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      scrollToEnd();
      isTyping = false;
      update();
    }
  }
}
