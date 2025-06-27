import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_bloc.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_event.dart';
import 'package:gemnichat_app/features/auth/repository/auth_repository.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_bloc.dart';
import 'package:gemnichat_app/features/chat/bloc/chat_event.dart';
import 'package:gemnichat_app/features/chat/data/chat_api_services.dart';
import 'package:gemnichat_app/features/chat/data/chat_repository.dart';
import 'package:gemnichat_app/core/theme/theme_cubit.dart';
import 'themes/app_theme.dart';
import 'router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<ChatRepository>(
          create: (_) => ChatRepository(
            firestore: FirebaseFirestore.instance,
            auth: FirebaseAuth.instance,
            apiService: ChatApiService(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>())
                  ..add(AppStarted()),
          ),
          BlocProvider<ChatBloc>(
            create: (context) =>
                ChatBloc(chatRepository: context.read<ChatRepository>())
                  ..add(FetchUserDetails()),
          ),
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: "GemniChat App",
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}
