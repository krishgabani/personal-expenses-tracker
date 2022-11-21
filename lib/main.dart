import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/transaction.dart';
import './screens/home_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './models/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Transactions>(
            create: (_) => Transactions('', '', []), //-----------------------
            update: (context, auth, previousTransactions) => Transactions(
              auth.token ?? '',
              auth.userId ?? '',
              previousTransactions == null
                  ? []
                  : previousTransactions.userTransaction,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Personal Expenses',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.amber,
              fontFamily: 'Quicksand',
              errorColor: Colors.red,
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            // routes: {},
          ),
        ));
  }
}
