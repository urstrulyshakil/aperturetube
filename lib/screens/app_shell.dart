import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav.dart';
import 'community_screen.dart';
import 'invoices_screen.dart';
import 'profile_screen.dart';
import 'projects_screen.dart';

class AppShell extends StatefulWidget {
  final VoidCallback? onLogout;
  final int initialIndex;

  const AppShell({super.key, this.onLogout, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onIndexChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _goToProfile() => setState(() => _currentIndex = 3);
  void _goToProjects() => setState(() => _currentIndex = 0);

  @override
  Widget build(BuildContext context) {
    final screens = [
      ProjectsScreen(
        onAvatarTap: _goToProfile,
        onLogoTap: _goToProjects,
      ),
      CommunityScreen(
        onAvatarTap: _goToProfile,
        onLogoTap: _goToProjects,
      ),
      InvoicesScreen(
        onAvatarTap: _goToProfile,
        onLogoTap: _goToProjects,
      ),
      ProfileScreen(
        onLogout: widget.onLogout,
        onAvatarTap: _goToProfile,
        onLogoTap: _goToProjects,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }
}
