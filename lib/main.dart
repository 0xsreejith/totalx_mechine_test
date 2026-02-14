import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/auth_service.dart';
import 'core/theme/app_colors.dart';
import 'features/auth/presentation/providers/otp_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");
  
  // Initialize dependencies
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOTAL X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        
      ),
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: di.sl<AuthService>().isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final isLoggedIn = snapshot.data ?? false;

        if (isLoggedIn) {
          return FutureBuilder<String?>(
            future: di.sl<AuthService>().getCurrentPhoneNumber(),
            builder: (context, phoneSnapshot) {
              if (phoneSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final phoneNumber = phoneSnapshot.data;

              if (phoneNumber != null) {
                return ChangeNotifierProvider(
                  create: (_) => di.getUserProvider(phoneNumber)..loadUsers(),
                  child: HomeScreen(phoneNumber: phoneNumber),
                );
              }

              // If no phone number, go to login
              return ChangeNotifierProvider(
                create: (_) => di.sl<OTPProvider>(),
                child: const LoginScreen(),
              );
            },
          );
        }

        // Not logged in, show login screen
        return ChangeNotifierProvider(
          create: (_) => di.sl<OTPProvider>(),
          child: const LoginScreen(),
        );
      },
    );
  }
}