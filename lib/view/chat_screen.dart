import 'package:chat_gpt/provider/chat_controller.dart';
import 'package:chat_gpt/provider/model_controller.dart';
import 'package:chat_gpt/services/services.dart';
import 'package:chat_gpt/utils/app_colors.dart';
import 'package:chat_gpt/view/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ModelController());
    final chatController = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Image.asset("assets/images/openai_logo.jpg"),
        ),
        title: const Text(
          "ChatGPT",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showBottomSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: GetBuilder<ChatController>(builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: chatController.getchatList.length,
                  controller: chatController.scrollController,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatController.getchatList[index].msg,
                      index: chatController.getchatList[index].chatIndex,
                    );
                  },
                ),
              ),
              if (chatController.isTyping) ...[
                const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 18,
                ),
              ],
              const SizedBox(height: 15),
              Container(
                color: AppColors.cardColor,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: chatController.focusNode,
                        controller: chatController.chatController,
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: (value) async {
                          await chatController.sendMessages(
                            modelController: controller,
                          );
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can i help you",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          chatController.sendMessages(
                            modelController: controller,
                          );
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
