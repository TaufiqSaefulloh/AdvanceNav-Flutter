import 'package:flutter/material.dart';
import 'package:navigator/db/AuthRepository.dart';
import 'package:navigator/provider/auth_provider.dart';
import 'package:navigator/routes/routeinformation.dart';
// import 'package:navigator/routes/page_manager.dart';
import 'package:navigator/routes/router.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;

void main() {
  runApp(const QuotesApp());
}

class QuotesApp extends StatefulWidget {
  const QuotesApp({Key? key}) : super(key: key);

  @override
  State<QuotesApp> createState() => _QuotesAppState();
}

class _QuotesAppState extends State<QuotesApp> {
  String? selectedQuote;
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;
   late MyRouteInformationParser myRouteInformationParser;

  @override
    void initState() {
    super.initState();
        final authRepository = AuthRepository();

    authProvider = AuthProvider(authRepository);
    myRouterDelegate = MyRouterDelegate(authRepository);
     myRouteInformationParser = MyRouteInformationParser();
  }
  Widget build(BuildContext context) {
     return ChangeNotifierProvider(
       create: (context) => authProvider,
      // create: (context) => PageManager(),
      child: MaterialApp.router(
        title: 'Quotes App',
          routerDelegate: myRouterDelegate,
          routeInformationParser: myRouteInformationParser,
          backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
