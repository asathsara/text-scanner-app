import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_extractor_app/firebase_options.dart';
import 'package:text_extractor_app/home_screen.dart';
import 'package:text_extractor_app/providers/note_provider.dart';
import 'package:text_extractor_app/providers/theme_provider.dart';
import 'package:text_extractor_app/screens/settings_screen.dart';
import 'package:text_extractor_app/utils/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final providers = [
    GoogleProvider(
      clientId:
          '', // Required for iOS and web only
    ),
  ];

    void _onSignedIn(BuildContext context) {
      Navigator.pushReplacementNamed(context, '/home');
    }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);


    return MaterialApp(
      title: 'Image to Text App',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.currentThemeMode,
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/sign-in'
          : '/home',
      routes: {
        '/sign-in': (context) => SignInScreen(
          providers: providers,
          actions: [
            AuthStateChangeAction<UserCreated>((context, state) {
              _onSignedIn(context);
            }),
            AuthStateChangeAction<SignedIn>((context, state) {
              _onSignedIn(context);
            }),
          ],
        ),
        '/home': (context) => const MyHomePage(),
        '/profile': (context) => ProfileScreen(
          providers: providers,
          actions: [
            SignedOutAction((context) {
              Navigator.pushReplacementNamed(context, '/sign-in');
            }),
          ],
        ),
        '/settings': (context) => const SettingsScreen(),
      },

    );
  }
}
