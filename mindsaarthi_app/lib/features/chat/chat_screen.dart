import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/colors.dart';
import 'chat_controller.dart';
import 'chat_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatControllerProvider);
    final notifier = ref.read(chatControllerProvider.notifier);

    scrollToBottom();

    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.secondary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/mental_health.png", height: 28),
            const SizedBox(width: 8),
            const Text(
              "Mindsaarthi",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 140),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      ChatMessage msg = state.messages[index];
                      bool isUser = msg.role == "user";

                      return Row(
                        mainAxisAlignment:
                            isUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 5,
                              ),
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primary,
                                child: Image.asset(
                                  "assets/images/mental_health.png",
                                  height: 18,
                                ),
                              ),
                            ),
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 6,
                              ),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color:
                                    isUser
                                        ? AppColors.primary
                                        : msg.role == "action"
                                        ? Colors.blue.withOpacity(0.2)
                                        : msg.role == "suggestion"
                                        ? Colors.green.withOpacity(0.2)
                                        : const Color(0xFF1E1F20),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.white70,
                                ),
                              ),
                            ),
                          ),
                          if (isUser) const SizedBox(width: 10),
                        ],
                      );
                    },
                  ),
                ),

                if (state.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Text(
                      "Mindsaarthi is typing...",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 80,
            child: _chatInput(controller, notifier),
          ),
        ],
      ),
    );
  }

  Widget _chatInput(TextEditingController controller, notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F20),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Share your thoughts...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Image.asset("assets/images/send.png", width: 18),
            onPressed: () {
              notifier.sendMessage(controller.text);
              controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
