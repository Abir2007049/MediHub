import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';
import 'models/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);

  runApp(const MediHubApp());
}

class MediHubApp extends StatelessWidget {
  const MediHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MediHub',
      theme: getAppTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
