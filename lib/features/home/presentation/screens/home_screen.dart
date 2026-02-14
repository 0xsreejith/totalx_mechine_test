import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/auth_service.dart';
import '../../../auth/presentation/providers/otp_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../providers/user_provider.dart';
import '../widgets/add_user_dialog.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/home_header.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/sort_menu_bottom_sheet.dart';
import '../widgets/user_list_item.dart';

class HomeScreen extends StatefulWidget {
  final String phoneNumber;

  const HomeScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final provider = context.read<UserProvider>();
    provider.loadUsers();

    // Lazy loading
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        provider.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    final authService = di.sl<AuthService>();
    await authService.logout();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => di.sl<OTPProvider>(),
          child: const LoginScreen(),
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: Column(
        children: [
          HomeHeader(onLogout: _handleLogout),
          SearchBarWidget(
            controller: _searchController,
            onChanged: provider.search,
            onMenuTap: () => SortMenuBottomSheet.show(context, provider),
          ),
          Expanded(
            child: provider.users.isEmpty
                ? const EmptyStateWidget()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.users.length,
                    itemBuilder: (context, index) {
                      return UserListItem(user: provider.users[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
        onPressed: () => AddUserDialog.show(context, provider),
      ),
    );
  }
}
