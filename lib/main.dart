import 'package:flutter/material.dart';
import 'package:movie_app/core/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/core/view_model/search_model.dart';
import 'package:movie_app/http/http_service.dart';
import 'package:movie_app/theme/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  HttpService.configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SearchModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: MovieAppTheme.themeData,
        home: const App(),
      ),
    );
  }
}
