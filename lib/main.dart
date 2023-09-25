import 'package:flutter/material.dart';
import 'package:project/login/login_page.dart';
import 'package:project/register/register_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/utils/utils.dart';
import 'package:project/splash/splash_page.dart';
import 'package:project/root/root_page.dart';
import 'package:project/complete_profile/complete_profile.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  final supabase = await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_KEY'),
  );
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingleton(supabase.client);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 52, 23, 133)),
          useMaterial3: true,
        ),
        initialRoute: '/splash',
        routes: {
          '/': (ctx) => const RootPage(),
          '/splash': (context) => const SplashPage(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/completeProfile': (context) => const CompleteProfile(),
        });
  }
}