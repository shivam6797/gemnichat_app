import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_bloc.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_event.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_state.dart';

class ChatTypingBox extends StatefulWidget {
  final TextEditingController controller;
  final String chatId;

  const ChatTypingBox({
    super.key,
    required this.controller,
    required this.chatId,
  });

  @override
  State<ChatTypingBox> createState() => _ChatTypingBoxState();
}

class _ChatTypingBoxState extends State<ChatTypingBox> {
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkTyping);
  }

  void _checkTyping() {
    final typing = widget.controller.text.trim().isNotEmpty;
    if (isTyping != typing) {
      setState(() => isTyping = typing);
    }
  }

  void _handleSend(BuildContext context) {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(
        SendMessageEvent(chatId: widget.chatId, message: text),
      );
      widget.controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _handleStop(BuildContext context) {
    context.read<ChatBloc>().add(StopGenerationEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            final isLoading = state is ChatLoading;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[200],
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: widget.controller,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    maxLines: null, // 👈 This allows multi-line
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: "Ask anything",
                      hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.add, color: isDark ? Colors.white : Colors.black, size: 22),
                      const SizedBox(width: 16),
                      Icon(Icons.tune, color: isDark ? Colors.white : Colors.black, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "Tools",
                        style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 14),
                      ),
                      const Spacer(),
                      Icon(Icons.mic_none, color: isDark ? Colors.white : Colors.black, size: 22),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => isLoading ? _handleStop(context) : _handleSend(context),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isTyping || isLoading ? Colors.black : Colors.grey,
                          ),
                          child: Icon(
                            isLoading ? Icons.stop : Icons.arrow_upward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkTyping);
    super.dispose();
  }
}
