import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/oder_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/routes/app_routes.dart';
import 'package:shop/screen/auth_or_home_page.dart';
import 'package:shop/screen/cart_page.dart';
import 'package:shop/screen/oders_page.dart';
import 'package:shop/screen/product_detail_page.dart';
import 'package:shop/screen/product_form_page.dart';
import 'package:shop/screen/products_page.dart';
import 'package:shop/utils/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) => ProductList(
            auth.token ?? '',
            auth.userId ?? '',
            previous?.items ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) => OrderList(
            auth.token ?? '',
            auth.userId ?? '',
            previous?.items ?? [],
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: CustomPageTransitionsThemeBuilder(),
              TargetPlatform.android: CustomPageTransitionsThemeBuilder(),
            },
          ),
        ),
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
          AppRoutes.CART: (ctx) => CartPage(),
          AppRoutes.ORDERS: (ctx) => OrdersPages(),
          AppRoutes.MANAGER_PRODUCTS: (ctx) => ProductsPage(),
          AppRoutes.FORM_PRODUCTS: (ctx) => ProductFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
