import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/app_shell.dart';
import 'screens/login_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'models/studio_settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFAF7F0),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ApertureTubeApp());
}


/// Root app — StatefulWidget so we can safely listen to AppState
/// without wrapping MaterialApp in AnimatedBuilder (causes mouse_tracker assertion on Web).
class ApertureTubeApp extends StatefulWidget {
  const ApertureTubeApp({super.key});

  @override
  State<ApertureTubeApp> createState() => _ApertureTubeAppState();
}

class _ApertureTubeAppState extends State<ApertureTubeApp> {
  @override
  void initState() {
    super.initState();
    AppState().addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    AppState().removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    // Only rebuild when called from a safe (post-frame) context
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDaylight = AppState().lutMode == DisplayLutMode.daylightStudio;
    return MaterialApp(
      title: 'ApertureTube • Capturing Memories',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDaylight ? ThemeMode.light : ThemeMode.dark,
      home: const AuthGate(),
    );
  }
}

/// Sits at the root and decides whether to show Login or the main shell.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoggedIn = false;

  void _onLoginSuccess() {
    setState(() => _isLoggedIn = true);
  }

  void _onLogout() {
    setState(() => _isLoggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: _isLoggedIn
          ? AppShell(
              key: const ValueKey('shell'),
              onLogout: _onLogout,
            )
          : LoginScreen(
              key: const ValueKey('login'),
              onLoginSuccess: _onLoginSuccess,
            ),
    );
  }
}
