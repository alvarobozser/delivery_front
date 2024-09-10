import 'package:delivery/src/models/user.dart';
import 'package:delivery/src/pages/cliente/address/create/cliente_create_address_page.dart';
import 'package:delivery/src/pages/cliente/address/list/cliente_list_address_page.dart';
import 'package:delivery/src/pages/cliente/home/cliente_home_page.dart';
import 'package:delivery/src/pages/cliente/orders/create/cliente_orders_create_page.dart';
import 'package:delivery/src/pages/cliente/productos/list/cliente_productos_list_page.dart';
import 'package:delivery/src/pages/cliente/profile/info/cliente_profile_info_page.dart';
import 'package:delivery/src/pages/cliente/profile/update/cliente_profile_update_page.dart';
import 'package:delivery/src/pages/home/home_page.dart';
import 'package:delivery/src/pages/login/login_page.dart';
import 'package:delivery/src/pages/register/register_page.dart';
import 'package:delivery/src/pages/repartidor/orders/list/repartidor_orders_list_page.dart';
import 'package:delivery/src/pages/restaurante/home/restaurante_home_page.dart';
import 'package:delivery/src/pages/roles/roles_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

User userSession = User.fromJson(GetStorage().read('user')??{});

void main() async{
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('TOKEN ${userSession.sessionToken}');
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Delivery App',
      debugShowCheckedModeBanner: false,
      initialRoute:userSession.id!=null ? userSession.roles!.length > 1 ? '/roles' : '/client/home' : '/',
      getPages: [
        GetPage(name: '/', page: ()=>LoginPage()),
        GetPage(name: '/register', page: ()=>RegisterPage()),
        GetPage(name: '/home', page: ()=>HomePage()),
        GetPage(name: '/roles', page: ()=>RolesPage()),
        GetPage(name: '/restaurant/home', page: ()=>RestauranteHomePage()),
        GetPage(name: '/delivery/orders/list', page: ()=>RepartidorOrdersListPage()),
        GetPage(name: '/client/home', page: ()=>ClienteHomePage()),
        GetPage(name: '/client/products/list', page: ()=>ClienteProductosListPage()),
        GetPage(name: '/client/profile/info', page: ()=>ClienteProfileInfoPage()),
        GetPage(name: '/client/profile/update', page: ()=>ClienteProfileUpdatePage()),
        GetPage(name: '/client/orders/create', page: ()=>ClienteOrdersCreatePage()),
        GetPage(name: '/client/address/create', page: ()=>ClienteAddressCreatePage()),
        GetPage(name: '/client/address/list', page: ()=>ClienteListAddressPage())
      ],
      theme: ThemeData(
        primaryColor: Colors.amber,
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.amber,
            secondary: Colors.amberAccent,
            onPrimary: Colors.grey,
            onSecondary: Colors.grey,
            error: Colors.red,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Colors.grey,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber, // Fondo de los botones
          textTheme: ButtonTextTheme.primary, // Texto en los botones
        ),
      ),
      navigatorKey: Get.key,
    );
  }
}
