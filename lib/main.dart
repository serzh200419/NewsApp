import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/di/injection_container.dart' as di;
import 'presentation/bloc/news_bloc.dart';
import 'presentation/pages/news_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<NewsBloc>()..add(FetchNewsEvent()),
      child: MaterialApp(
        title: 'News',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B365D),
            primary: const Color(0xFF1B365D),
            surface: const Color(0xFFF5F7FA),
          ),
          textTheme: GoogleFonts.sourceSans3TextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF1B365D),
            foregroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.sourceSans3(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        ),
        home: const NewsListPage(),
      ),
    );
  }
}

