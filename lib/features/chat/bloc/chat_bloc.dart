import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemnichat_app/core/error/api_exception.dart';
import 'package:gemnichat_app/features/auth/models/user_model.dart';
import 'package:gemnichat_app/features/chat/data/chat_repository.dart';
import 'package:gemnichat_app/features/chat/models/chat_model.dart';
import 'package:gemnichat_app/features/chat/models/message_model.dart';
import 'package:uuid/uuid.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  UserModel? _currentUser;
  String? _currentChatId;
  ChatEvent? _lastChatEvent;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
    on<SendMessageEvent>(_onSendMessage);
    on<LoadUserChatHistory>(_onLoadUserChatHistory);
    on<FetchChatByIdEvent>(_onFetchChatByIdEvent);
    on<StartNewChatEvent>(_onStartNewChat);
    on<RenameChatEvent>(_onRenameChat);
    on<DeleteChatEvent>(_onDeleteChat);
    on<RetryLastEvent>((event, emit) {
      if (_lastChatEvent != null) {
        add(_lastChatEvent!);
      }
    });
  }

  Future<void> _onFetchUserDetails(
    FetchUserDetails event,
    Emitter<ChatState> emit,
  ) async {
    _lastChatEvent = event;
    emit(ChatLoading());
    try {
      final user = await chatRepository.getUserDetails();
      _currentUser = user;
      final chatHistory = await chatRepository.fetchChatHistory(user.uid);
      List<MessageModel> initialMessages = [];
      if (user.isFirstTime) {
        initialMessages.add(
          MessageModel(
            msg:
                "Hi ${user.name.split(' ').first}, how can I assist you today?",
            isUser: false,
            createdAt: DateTime.now(),
          ),
        );
      }
      emit(
        ChatLoaded(
          user: user,
          chatHistory: chatHistory,
          messages: initialMessages,
          selectedChatId: null,
        ),
      );
    } on AppException catch (e) {
      emit(ChatError(message: e.toString()));
    } catch (e) {
      emit(ChatError(message: "Failed to fetch user details."));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    _lastChatEvent = event;
    if (event.message.trim().isEmpty) {
      emit(ChatError(message: "Please enter a message."));
      return;
    }
    try {
      final userMessage = MessageModel(
        msg: event.message,
        isUser: true,
        createdAt: DateTime.now(),
      );
      final botReply = MessageModel(
        msg: await chatRepository.sendMessageToGemini(event.message),
        isUser: false,
        createdAt: DateTime.now(),
      );
      _currentChatId ??= const Uuid().v4();
      final alreadyExists = _currentUser!.chatHistory.any(
        (chat) => chat.chatId == _currentChatId,
      );
      if (!alreadyExists) {
        final newChat = ChatModel(
          chatId: _currentChatId!,
          title: "New Chat",
          createdAt: DateTime.now(),
        );
        await chatRepository.addChatToHistory(newChat);
        _currentUser = _currentUser!.copyWith(
          chatHistory: [..._currentUser!.chatHistory, newChat],
        );
      }
      if (_currentUser != null && _currentUser!.isFirstTime) {
        await chatRepository.updateIsFirstTime(false);
        _currentUser = _currentUser!.copyWith(isFirstTime: false);
      }
      await chatRepository.saveMessage(_currentChatId!, userMessage);
      await chatRepository.saveMessage(_currentChatId!, botReply);
      if (_currentUser != null) {
        final index = _currentUser!.chatHistory.indexWhere(
          (chat) => chat.chatId == _currentChatId,
        );
        if (index != -1 &&
            _currentUser!.chatHistory[index].title == "New Chat") {
          final updatedChat = _currentUser!.chatHistory[index].copyWith(
            title: userMessage.msg.length > 30
                ? '${userMessage.msg.substring(0, 30)}...'
                : userMessage.msg,
          );
          _currentUser!.chatHistory[index] = updatedChat;
          await chatRepository.updateChatHistory(_currentUser!.chatHistory);
        }
      }
      if (state is ChatLoaded) {
        final current = state as ChatLoaded;
        emit(
          current.copyWith(
            messages: [...current.messages, userMessage, botReply],
            chatHistory: _currentUser!.chatHistory,
            selectedChatId: _currentChatId,
          ),
        );
      }
    } on AppException catch (e) {
      emit(ChatError(message: e.toString()));
    } catch (e) {
      emit(ChatError(message: "Failed to send message."));
    }
  }

  Future<void> _onLoadUserChatHistory(
    LoadUserChatHistory event,
    Emitter<ChatState> emit,
  ) async {
    _lastChatEvent = event;
    emit(ChatLoading());
    try {
      final chatList = await chatRepository.fetchChatHistory(event.userId);
      if (state is ChatLoaded) {
        final current = state as ChatLoaded;
        emit(current.copyWith(chatHistory: chatList));
      }
    } on AppException catch (e) {
      emit(ChatError(message: e.toString()));
    } catch (e) {
      emit(ChatError(message: "Failed to load chat history."));
    }
  }

  Future<void> _onFetchChatByIdEvent(
    FetchChatByIdEvent event,
    Emitter<ChatState> emit,
  ) async {
    _lastChatEvent = event;
    if (state is ChatLoaded) {
      final current = state as ChatLoaded;
      try {
        final messages = await chatRepository.fetchMessages(event.chatId);
        _currentChatId = event.chatId;
        emit(
          current.copyWith(selectedChatId: event.chatId, messages: messages),
        );
      } on AppException catch (e) {
        emit(ChatError(message: e.toString()));
      } catch (e) {
        emit(ChatError(message: "Failed to load messages."));
      }
    }
  }

  Future<void> _onStartNewChat(
    StartNewChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    _lastChatEvent = event;
    try {
      if (_currentUser == null) return;
      _currentChatId = const Uuid().v4();
      if (_currentUser!.isFirstTime) {
        await chatRepository.updateIsFirstTime(false);
        _currentUser = _currentUser!.copyWith(isFirstTime: false);
      }
      final dummyMessage = MessageModel(
        msg: "What can I help with?",
        isUser: false,
        createdAt: DateTime.now(),
      );
      emit(
        ChatLoaded(
          user: _currentUser!,
          chatHistory: _currentUser!.chatHistory,
          messages: [dummyMessage],
          selectedChatId: _currentChatId,
        ),
      );
    } on AppException catch (e) {
      emit(ChatError(message: e.toString()));
    } catch (e) {
      emit(ChatError(message: "Failed to start new chat."));
    }
  }

  Future<void> _onRenameChat(
    RenameChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    _lastChatEvent = event;
    try {
      final index = _currentUser!.chatHistory.indexWhere(
        (c) => c.chatId == event.chatId,
      );
      if (index == -1) return;
      final updatedChat = _currentUser!.chatHistory[index].copyWith(
        title: event.newTitle,
      );
      _currentUser!.chatHistory[index] = updatedChat;
      await chatRepository.updateChatHistory(_currentUser!.chatHistory);

      if (state is ChatLoaded) {
        final current = state as ChatLoaded;
        emit(current.copyWith(chatHistory: _currentUser!.chatHistory));
      }
    } on AppException catch (e) {
      emit(ChatError(message: e.toString()));
    } catch (e) {
      emit(ChatError(message: "Failed to rename chat."));
    }
  }

  Future<void> _onDeleteChat(
    DeleteChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    _lastChatEvent = event;
    try {
      final updatedChatList = _currentUser!.chatHistory
          .where((c) => c.chatId != event.chatId)
          .toList();
      await chatRepository.deleteChat(
        userId: _currentUser!.uid,
        chatId: event.chatId,
        updatedChatHistory: updatedChatList,
      );
      _currentUser = _currentUser!.copyWith(chatHistory: updatedChatList);
      if (state is ChatLoaded) {
        final current = state as ChatLoaded;
        emit(current.copyWith(chatHistory: updatedChatList));
      }
    } on AppException catch (e) {
      emit(ChatError(message: e.toString()));
    } catch (e) {
      emit(ChatError(message: "Failed to delete chat."));
    }
  }
}
