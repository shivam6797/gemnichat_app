import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_bloc.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_state.dart';
import 'package:gemnichat_app/features/chat/widget/message_bubble.dart';
import 'package:gemnichat_app/features/chat/widget/typing_indicator.dart';

class ChatMessageList extends StatefulWidget {
  const ChatMessageList({super.key});

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  int _previousMessageCount = 0;

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
    Future.delayed(const Duration(milliseconds: 200), _scrollToBottom);
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

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (messages.length > _previousMessageCount) {
              _scrollToBottom();
            }
            _previousMessageCount = messages.length;
          });

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
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 140, top: 24),
            itemCount: messages.length + (state.isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == messages.length && state.isTyping) {
                return const TypingIndicator();
              }

              final m = messages[index];
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: ChatMessageBubble(
                  key: ValueKey('${m.isUser}-${m.createdAt}'),
                  message: m.msg,
                  isUser: m.isUser,
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
