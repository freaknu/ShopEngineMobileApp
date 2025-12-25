import 'package:ecommerce_app/core/bloc/auth_gate.dart';
import 'package:ecommerce_app/core/constants/theme/app_theme.dart';
import 'package:ecommerce_app/core/constants/widgets/navbar_widget.dart';
import 'package:ecommerce_app/core/di/injection.dart';
import 'package:ecommerce_app/core/bloc/auth_status_bloc.dart';
import 'package:ecommerce_app/core/bloc/auth_status_event.dart';
import 'package:ecommerce_app/core/bloc/auth_status_state.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/forgetpassword_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/newpassword_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/signin_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/signup_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/verification_page.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce_app/features/homepage/presentation/pages/all_categories_page.dart';
import 'package:ecommerce_app/features/homepage/presentation/pages/all_products_page.dart';
import 'package:ecommerce_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:ecommerce_app/features/notification/presentation/pages/notification_page.dart';
import 'package:ecommerce_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:ecommerce_app/features/order/presentation/pages/order_page.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart'
    as pd;
import 'package:ecommerce_app/features/product/presentation/pages/product_page.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_bloc.dart';
import 'package:ecommerce_app/features/review/presentation/page/review_page.dart';
import 'package:ecommerce_app/features/review/presentation/page/all_reviews_page.dart';
import 'package:ecommerce_app/features/userdetails/presentation/bloc/address_bloc.dart';
import 'package:ecommerce_app/features/userdetails/presentation/pages/addresscreate_page.dart';
import 'package:ecommerce_app/features/userdetails/presentation/pages/userdetails_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Optionally handle background message
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Local notification initialization
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      // Handle notification tap - navigate to notification page
      Get.toNamed('/notifications');
    },
  );

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request notification permissions (iOS)
  await FirebaseMessaging.instance.requestPermission();

  // Listen for foreground messages and show notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
            enableVibration: true,
            playSound: true,
          ),
        ),
      );
    }
  });

  setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthStatusBloc>(
          create: (_) => getIt<AuthStatusBloc>()..add(AppStarted()),
        ),

        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<ProductBloc>(create: (_) => getIt<ProductBloc>()),
        BlocProvider<CategoryBloc>(create: (_) => getIt<CategoryBloc>()),
        BlocProvider<pd.ProductBloc>(create: (_) => getIt<pd.ProductBloc>()),
        BlocProvider<CartBloc>(create: (context) => getIt<CartBloc>()),
        BlocProvider<AddressBloc>(create: (context) => getIt<AddressBloc>()),
        BlocProvider<ReviewBloc>(create: (context) => getIt<ReviewBloc>()),
        BlocProvider<OrderBloc>(create: (context) => getIt<OrderBloc>()),
        BlocProvider<NotificationBloc>(create: (context) => getIt<NotificationBloc>()),
      ],
      child: BlocListener<AuthStatusBloc, AuthStatusState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Get.offAllNamed('/home');
          } else if (state is Unauthenticated) {
            Get.offAllNamed('/signin');
          }
        },
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ShopEngine',
          theme: customThemeData(),

          home: AuthGate(),

          getPages: [
            GetPage(
              name: '/signin',
              page: () => const SigninPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/signup',
              page: () => SignupPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/home',
              page: () => NavbarWidget(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/forgetpassword',
              page: () => ForgetpasswordPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/verify',
              page: () => VerificationPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/reset',
              page: () => NewpasswordPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/product',
              page: () => ProductPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/userdetails',
              page: () => UserdetailsPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/addresscreate',
              page: () => AddresscreatePage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/review',
              page: () => ReviewPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/all-reviews',
              page: () => AllReviewsPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(name: '/orders', page: ()=>OrderPage()),
            GetPage(
              name: '/notifications',
              page: () => NotificationPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/all-categories',
              page: () => AllCategoriesPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/all-products',
              page: () => AllProductsPage(),
              transition: Transition.rightToLeft,
            ),
          ],
        ),
      ),
    );
  }
}
