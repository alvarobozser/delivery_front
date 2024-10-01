import 'package:delivery/src/models/user.dart';
import 'package:delivery/src/pages/cliente/address/create/cliente_create_address_page.dart';
import 'package:delivery/src/pages/cliente/address/list/cliente_list_address_page.dart';
import 'package:delivery/src/pages/cliente/home/cliente_home_page.dart';
import 'package:delivery/src/pages/cliente/orders/create/cliente_orders_create_page.dart';
import 'package:delivery/src/pages/cliente/orders/detail/client_orders_detail_page.dart';
import 'package:delivery/src/pages/cliente/orders/map/client_orders_map_page.dart';
import 'package:delivery/src/pages/cliente/payments/create/cliente_payments_create_page.dart';
import 'package:delivery/src/pages/cliente/productos/list/cliente_productos_list_page.dart';
import 'package:delivery/src/pages/cliente/profile/info/cliente_profile_info_page.dart';
import 'package:delivery/src/pages/cliente/profile/update/cliente_profile_update_page.dart';
import 'package:delivery/src/pages/home/home_page.dart';
import 'package:delivery/src/pages/login/login_page.dart';
import 'package:delivery/src/pages/register/register_page.dart';
import 'package:delivery/src/pages/repartidor/home/delivery_home_page.dart';
import 'package:delivery/src/pages/repartidor/orders/detail/delivery_orders_detail_page.dart';
import 'package:delivery/src/pages/repartidor/orders/list/delivery_orders_list_page.dart';
import 'package:delivery/src/pages/repartidor/orders/map/delivery_orders_map_page.dart';
import 'package:delivery/src/pages/restaurante/home/restaurante_home_page.dart';
import 'package:delivery/src/pages/restaurante/orders/detail/restaurant_orders_detail_page.dart';
import 'package:delivery/src/pages/roles/roles_page.dart';
import 'package:delivery/src/providers/push_notifications_provider.dart';
import 'package:delivery/src/utils/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

User userSession = User.fromJson(GetStorage().read('user')??{});
PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  print('Recibiendo notificacion en segundo plano ${message.messageId}');
  //pushNotificationsProvider.showNotification(message);
}

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey='pk_test_51Q586tJM7CBfXVFiAtGzjRsjgGaCwnOJOa492yLv84ZOTyA1AQLdrxLvjBPA6rzH2xRQNAPUgmEVQ3yuL3okg8dA00mOY7wswe';
  await Stripe.instance.applySettings();

  await Firebase.initializeApp(
    options: FirebaseConfig.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationsProvider.initPushNotifications();
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
    pushNotificationsProvider.onMessageListener();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Delivery App',
      debugShowCheckedModeBanner: false,
      //initialRoute:'/client/payments/create',
      initialRoute:userSession.id!=null ? userSession.roles!.length > 1 ? '/roles' : '/client/home' : '/',
      getPages: [
        GetPage(name: '/', page: ()=>LoginPage()),
        GetPage(name: '/register', page: ()=>RegisterPage()),
        GetPage(name: '/home', page: ()=>HomePage()),
        GetPage(name: '/roles', page: ()=>RolesPage()),
        GetPage(name: '/restaurant/home', page: ()=>RestauranteHomePage()),
        GetPage(name: '/delivery/home', page: ()=>DeliveryHomePage()),
        GetPage(name: '/delivery/orders/list', page: ()=>DeliveryOrdersListPage()),
        GetPage(name: '/delivery/orders/detail', page: ()=>DeliveryOrdersDetailPage()),
        GetPage(name: '/delivery/orders/map', page: ()=>DeliveryOrdersMapPage()),
        GetPage(name: '/client/home', page: ()=>ClienteHomePage()),
        GetPage(name: '/client/products/list', page: ()=>ClienteProductosListPage()),
        GetPage(name: '/client/profile/info', page: ()=>ClienteProfileInfoPage()),
        GetPage(name: '/client/profile/update', page: ()=>ClienteProfileUpdatePage()),
        GetPage(name: '/client/orders/create', page: ()=>ClienteOrdersCreatePage()),
        GetPage(name: '/client/orders/detail', page: ()=>ClientOrdersDetailPage()),
        GetPage(name: '/client/orders/map', page: ()=>ClientOrdersMapPage()),
        GetPage(name: '/client/address/create', page: ()=>ClienteAddressCreatePage()),
        GetPage(name: '/client/address/list', page: ()=>ClienteListAddressPage()),
        GetPage(name: '/client/payments/create', page: ()=>ClientePaymentsCreatePage()),
        GetPage(name: '/restaurant/orders/detail', page: ()=>RestaurantOrdersDetailPage())
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
