import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'chat_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sendbird Demo',
      initialRoute: "/chat",
      routes: <String, WidgetBuilder>{
        '/chat': (context) => const ChatScreen(),
      },
      theme: AppTheme.theme,
    );
  }
}
