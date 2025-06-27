import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_bloc.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_state.dart';
import 'package:gemnichat_app/features/chat/widget/message_bubble.dart';

class ChatMessageList extends StatefulWidget {
  const ChatMessageList({super.key});

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> with WidgetsBindingObserver{
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
     WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

   @override
  void didChangeMetrics() {
    // Called when keyboard opens/closes
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatInitial || state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatLoaded) {
          final messages = state.messages;

          // Auto-scroll after frame renders
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

          // Dummy message
          if (messages.length == 1 && !messages[0].isUser) {
            return Center(
              child: Text(
                messages[0].msg,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
            );
          }

          // Chat message list
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 140, top: 24),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final m = messages[index];
              return ChatMessageBubble(
                message: m.msg,
                isUser: m.isUser,
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
