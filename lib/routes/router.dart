import 'package:flutter/material.dart';
import 'package:navigator/db/AuthRepository.dart';
import 'package:navigator/model/page_configuration.dart';
import 'package:navigator/model/quote.dart';
// import 'package:navigator/screen/from_screen.dart';
import 'package:navigator/screen/loginscreen.dart';
import 'package:navigator/screen/quotes_detail.dart';
import 'package:navigator/screen/quotes_list.dart';
import 'package:navigator/screen/registerscreen.dart';
import 'package:navigator/screen/splashscreen.dart';

class MyRouterDelegate extends RouterDelegate <PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
      
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(this.authRepository)
    : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }
  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedQuote;
  bool isForm = false;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool? isUnknown;
  

  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      // pages: [
      //   MaterialPage(
      //     key: const ValueKey("QuotesListScreen"),
      //     child: QuotesListScreen(
      //       quotes: quotes,
      //       onTapped: (String quoteId) {
      //         selectedQuote = quoteId;
      //         notifyListeners();
      //       },
      //       toFormScreen: () {
      //         isForm = true;
      //         notifyListeners();
      //       },
      //     ),
      //   ),
      //   if (selectedQuote != null)
      //     MaterialPage(
      //       key: ValueKey("QuoteDetailsScreen-$selectedQuote"),
      //       child: QuoteDetailsScreen(quoteId: selectedQuote!),
      //     ),
      //   if (isForm)
      //     MaterialPage(
      //       key: ValueKey("FormScreen"),
      //       child: FormScreen(
      //         onSend: () {
      //           isForm = false;
      //           notifyListeners();
      //         },
      //       ),
      //     ),
      // ],
      onDidRemovePage: (page) {
        if (page.key == ValueKey("QuoteDetailsPage-$selectedQuote")) {
          selectedQuote = null;
          notifyListeners();
        }
        if (page.key == const ValueKey("FormScreen")) {
          isForm = false;
          notifyListeners();
        }
        if (page.key == const ValueKey("RegisterPage")) {
          isRegister = false;
          notifyListeners();
        }
      },
    );
  }

  @override
Future<void> setNewRoutePath(PageConfiguration configuration) async {
  switch (configuration) {
      case UnknownPageConfiguration():
        isUnknown = true;
        isRegister = false;
        break;
      case RegisterPageConfiguration():
        isRegister = true;
        break;
      case HomePageConfiguration() ||
          LoginPageConfiguration() ||
          SplashPageConfiguration():
        isUnknown = false;
        selectedQuote = null;
        isRegister = false;
        break;
      case DetailQuotePageConfiguration():
        isUnknown = false;
        isRegister = false;
        selectedQuote = configuration.quoteId.toString();
        break;
    }
    notifyListeners();
}

  @override
  PageConfiguration? get currentConfiguration {
     if (isLoggedIn == null) {
      return SplashPageConfiguration();
    } else if (isRegister == true) {
      return RegisterPageConfiguration();
    } else if (isLoggedIn == false) {
      return LoginPageConfiguration();
    } else if (isUnknown == true) {
      return UnknownPageConfiguration();
    } else if (selectedQuote == null) {
      return HomePageConfiguration();
    } else if (selectedQuote != null) {
      return DetailQuotePageConfiguration(selectedQuote!);
    } else {
      return null;
    }
  }

  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey("SplashPage"), child: SplashScreen()),
  ];
  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey("LoginPage"),
      child: LoginScreen(
        onLogin: () {
          isLoggedIn = true;
          notifyListeners();
        },
        onRegister: () {
          isRegister = true;
          notifyListeners();
        },
      ),
    ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey("RegisterPage"),
        child: RegisterScreen(
          onRegister: () {
            isRegister = false;
            notifyListeners();
          },
          onLogin: () {
            isRegister = false;
            notifyListeners();
          },
        ),
      ),
  ];
  List<Page> get _loggedInStack => [
    MaterialPage(
      key: const ValueKey("QuotesListPage"),
      child: QuotesListScreen(
        quotes: quotes,
        onTapped: (String quoteId) {
          selectedQuote = quoteId;
          notifyListeners();
        },
        onLogout: () {
          isLoggedIn = false;
          notifyListeners();
        },
        toFormScreen: () {
          isForm = true;
          notifyListeners();
        },
      ),
    ),
    if (selectedQuote != null)
      MaterialPage(
        key: ValueKey(selectedQuote),
        child: QuoteDetailsScreen(quoteId: selectedQuote!),
      ),
  ];

  
}
