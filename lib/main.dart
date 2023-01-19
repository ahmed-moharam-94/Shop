import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp2/helpers/custom_route.dart';
import './screens/splash_screen.dart';
import './providers/auth_provider.dart';
import './screens/auth_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/edit_screen_2.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/product_provider.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            create: (_) => ProductsProvider(),
            update: (_, authData, productsData) =>
                productsData..update(authData)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            create: (_) => OrdersProvider(),
            update: (_, authData, ordersData) => ordersData..update(authData)),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authData, ch) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              appBarTheme: AppBarTheme(color: Colors.deepPurple),
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
              fontFamily: 'Lato',
              primaryColor: Colors.deepPurple,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Colors.deepPurpleAccent),
            ),
            home: authData.isAuthenticate == true
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: Provider.of<AuthProvider>(context, listen: false)
                        .isLoggedIn(),
                    builder: (context, authSnapShot) {
                      if (authSnapShot.connectionState ==
                          ConnectionState.waiting)
                        return SplashScreen();
                      else
                        return AuthScreen();
                    },
                  ),
            routes: {
              SplashScreen.routeName: (context) => SplashScreen(),
              ProductOverviewScreen.routeName: (context) =>
                  ProductOverviewScreen(),
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              EditScreen2.routeName: (context) => EditScreen2(),
              AuthScreen.routeName: (context) => AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
