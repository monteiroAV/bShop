import 'package:bhop/models/admin_orders_manager.dart';
import 'package:bhop/models/admin_users_manager.dart';
import 'package:bhop/models/admin_visit_manager.dart';
import 'package:bhop/models/cart_manager.dart';
import 'package:bhop/models/cart_product.dart';
import 'package:bhop/models/home_manager.dart';
import 'package:bhop/models/order.dart';
import 'package:bhop/models/orders_manager.dart';
import 'package:bhop/models/product_manager.dart';
import 'package:bhop/models/user_manager.dart';
import 'package:bhop/screens/base/base_screen.dart';
import 'package:bhop/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
    
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => CartProduct(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
              ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) => adminOrdersManager
            ..updateAdmin(adminEnabled: userManager.adminEnabled),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminVisitManager>(
          create: (_) => AdminVisitManager(),
          lazy: true,
          update: (_, userManager, adminVisitManager) =>
              adminVisitManager..updateVisit(userManager),
        ),
      ],
      child: MaterialApp(
        title: 'BShop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink[100],
          scaffoldBackgroundColor: Colors.pink[100],
          appBarTheme: const AppBarTheme(
            elevation: 0,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Splash(),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  UserManager userManager = UserManager();
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = Tween<double>(begin: 0, end: 400).animate(controller);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
        if (userManager.isLoggedIn) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => BaseScreen()));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        }
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedLogo(animation);
  }
}

class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo(Animation<double> animation)
      : super(listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: Container(
          height: animation.value,
          width: animation.value,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: const DecorationImage(
                image: AssetImage('assets/logo1.png'), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
