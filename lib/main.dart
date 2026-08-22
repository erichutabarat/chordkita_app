import 'package:chordkita/features/auth/data/repositories/auth_repository.dart';
import 'package:chordkita/features/auth/domain/entities/user.dart';
import 'package:chordkita/features/auth/presentation/auth_layout.dart';
import 'package:chordkita/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chordkita/features/chord/presentation/chord_layout.dart';
import 'package:chordkita/features/home/domain/entities/chordsong_item.dart';
import 'package:chordkita/features/home/presentation/home_layout.dart';
import 'package:chordkita/features/loading/presentation/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GuitarChordApp());
}

class GuitarChordApp extends StatelessWidget {
  const GuitarChordApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisiasi repo
    final authRepository = AuthRepository();

    return MultiRepositoryProvider(
      providers: [
        // Menyediakan Repository ke dalam widget tree
        RepositoryProvider<AuthRepository>.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          // 2. Inisialisasi BLoC dan menyuntikkan (inject) AuthRepository ke dalamnya
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: authRepository),
          ),
        ],
        child: MaterialApp(
          title: 'ChordKita', // Or whatever brand name you choose!
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amber,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amber,
              brightness: Brightness.dark,
            ),
          ),

          // Starting screen
          initialRoute: '/loading',
          routes: {
            '/loading': (context) => LoadingScreen(),
            '/auth': (context) => const AuthLayout(),
            '/home': (context) {
              final user = ModalRoute.of(context)?.settings.arguments as User?;
              return HomeLayout(user: user);
            },
            "/chord": (context) {
              final data =
                  ModalRoute.of(context)!.settings.arguments
                      as ChordSongItemData;
              return ChordLayout(data: data);
            },
          },
        ),
      ),
    );
  }
}
