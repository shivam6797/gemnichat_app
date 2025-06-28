import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemnichat_app/core/constant/app_colors.dart';
import 'package:gemnichat_app/core/theme/theme_cubit.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_bloc.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_event.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_state.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_bloc.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_event.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_state.dart';
import 'package:gemnichat_app/features/chat/models/chat_model.dart';
import 'package:gemnichat_app/features/chat/widget/chat_message_list.dart';
import 'package:gemnichat_app/features/chat/widget/chat_typing_box.dart';
import 'package:gemnichat_app/features/chat/widget/chat_error_view.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(FetchUserDetails());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 800;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              current is Unauthenticated || current is AuthFailure,
          listener: (context, state) {
            if (state is Unauthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Logout successful'),
                  duration: Duration(seconds: 2),
                ),
              );
              context.go('/login');
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.message),
                ),
              );
            }
          },
        ),

        BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatInitial || state is ChatLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // ✅ Handle Error UI
          if (state is ChatError) {
            return Scaffold(
              body: ChatErrorView(
                errorMessage: state.message,
                onRetry: () {
                  context.read<ChatBloc>().add(RetryLastEvent());
                },
              ),
            );
          }

          if (state is ChatLoaded) {
            final user = state.user;
            final selectedChatId = state.selectedChatId;

            final sidebar = ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    gradient: Theme.of(context).brightness == Brightness.light
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.3),
                            ],
                          )
                        : null,
                    color: Theme.of(context).brightness == Brightness.light
                        ? null
                        : Colors.black.withOpacity(0.1),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: Theme.of(context).brightness == Brightness.light
                        ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),

                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(user.photoUrl),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black87
                              : Colors.white,
                        ),
                      ),

                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black54
                              : Colors.white60,
                        ),
                      ),

                      const Divider(height: 24),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor:
                            Theme.of(context).brightness == Brightness.light
                            ? Colors.white.withOpacity(0.6)
                            : Colors.white.withOpacity(0.05),
                        leading: const Icon(Icons.add),
                        title: Text(
                          "New Chat",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black87
                                    : Colors.white,
                              ),
                        ),
                        onTap: () {
                          myController.clear();
                          context.read<ChatBloc>().add(StartNewChatEvent());
                        },
                      ),

                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Recent Chat",
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black87
                                    : Colors.white70,
                              ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: BlocBuilder<ChatBloc, ChatState>(
                          builder: (context, state) {
                            if (state is ChatLoaded) {
                              final chatHistory = state.chatHistory;
                              return ListView.builder(
                                itemCount: chatHistory.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final chat = chatHistory[index];
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    tileColor:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.white.withOpacity(0.05),
                                    dense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    leading: const Icon(
                                      Icons.chat_bubble_outline,
                                      size: 20,
                                    ),
                                    title: Text(
                                      chat.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Colors.black87
                                                : Colors.white,
                                          ),
                                    ),
                                    subtitle: Text(
                                      chat.createdAt.toLocal().toString().split(
                                        '.',
                                      )[0],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 11,
                                            color:
                                                Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Colors.black54
                                                : Colors.white60,
                                          ),
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      icon: Icon(Icons.more_vert),
                                      onSelected: (value) {
                                        if (value == 'rename') {
                                          _showRenameDialog(context, chat);
                                        } else if (value == 'delete') {
                                          context.read<ChatBloc>().add(
                                            DeleteChatEvent(chat.chatId),
                                          );
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'rename',
                                          child: Text('Rename'),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      context.read<ChatBloc>().add(
                                        FetchChatByIdEvent(chat.chatId),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                      const Divider(height: 24),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor:
                            Theme.of(context).brightness == Brightness.light
                            ? Colors.white.withOpacity(0.6)
                            : Colors.white.withOpacity(0.05),
                        leading: const Icon(Icons.logout),
                        title: Text(
                          "Logout",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black87
                                    : Colors.white,
                              ),
                        ),
                        onTap: () =>
                            context.read<AuthBloc>().add(SignOutPressed()),
                      ),
                    ],
                  ),
                ),
              ),
            );

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: isDark ? const Color(0xFF121212) : null,
              appBar: isDesktop
                  ? null
                  : AppBar(
                      title: const Text("GemniChat"),
                      backgroundColor: isDark
                          ? Colors.black
                          : AppColors.primary,
                      actions: [
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.wb_sunny : Icons.nightlight_round,
                            size: 20,
                          ),
                          tooltip: "Toggle Theme",
                          onPressed: () {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                        ),
                      ],
                    ),
              drawer: isDesktop ? null : sidebar,
              body: Row(
                children: [
                  if (isDesktop) sidebar,
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (user.isFirstTime && selectedChatId == null) {
                          return Center(
                            child: Card(
                              elevation: 6,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: isDark ? Colors.grey[900] : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_rounded,
                                      size: 64,
                                      color: isDark
                                          ? Colors.tealAccent[200]
                                          : Colors.teal,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Welcome to GemniChat!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Start a conversation with AI or view your recent chats.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        myController.clear();
                                        context.read<ChatBloc>().add(
                                          StartNewChatEvent(),
                                        );
                                      },
                                      icon: const Icon(Icons.play_arrow),
                                      label: const Text("Start Chat"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.tealAccent[700],
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Stack(
                            children: [
                              if (selectedChatId == null)
                                const Center(
                                  child: Text(
                                    "What can I help with?",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              else
                                const ChatMessageList(),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: ChatTypingBox(
                                  controller: myController,
                                  chatId: selectedChatId ?? '',
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const Scaffold(
            body: Center(child: Text("Something went wrong")),
          );
        },
      ),
    );
  }

  void _showRenameDialog(BuildContext context, ChatModel chat) {
    final controller = TextEditingController(text: chat.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rename Chat"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter new title"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ChatBloc>().add(
                  RenameChatEvent(
                    chatId: chat.chatId,
                    newTitle: controller.text.trim(),
                  ),
                );
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
