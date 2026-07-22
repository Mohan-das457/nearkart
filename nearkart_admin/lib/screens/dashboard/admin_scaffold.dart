import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearkart_admin/core/theme/app_colors.dart';

class AdminScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int selectedIndex;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.selectedIndex,
  });

  static const _navItems = [
    (Icons.dashboard_outlined, Icons.dashboard, 'Dashboard', '/dashboard'),
    (Icons.receipt_long_outlined, Icons.receipt_long, 'Orders', '/orders'),
    (Icons.store_outlined, Icons.store, 'Stores', '/stores'),
    (Icons.delivery_dining_outlined, Icons.delivery_dining, 'Agents', '/agents'),
    (Icons.people_outline, Icons.people, 'Users', '/users'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isWide
          ? null
          : AppBar(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              title: Text(title),
            ),
      drawer: isWide ? null : _Sidebar(selectedIndex: selectedIndex),
      body: isWide
          ? Row(
              children: [
                _Sidebar(selectedIndex: selectedIndex),
                Expanded(child: _Content(title: title, body: body)),
              ],
            )
          : _Content(title: title, body: body),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  const _Sidebar({required this.selectedIndex});

  static const _navItems = AdminScaffold._navItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: AppColors.sidebar,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.admin_panel_settings, color: AppColors.white, size: 36),
          const SizedBox(height: 8),
          const Text('NearKart Admin',
              style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 32),
          ...List.generate(_navItems.length, (i) {
            final (outlinedIcon, filledIcon, label, route) = _navItems[i];
            final selected = i == selectedIndex;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: selected ? AppColors.white.withValues(alpha: 0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(selected ? filledIcon : outlinedIcon,
                    color: AppColors.white, size: 20),
                title: Text(label,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    )),
                onTap: () => context.go(route),
                dense: true,
              ),
            );
          }),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.white, size: 20),
            title: const Text('Logout', style: TextStyle(color: AppColors.white, fontSize: 14)),
            onTap: () => context.go('/'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String title;
  final Widget body;
  const _Content({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          color: AppColors.white,
          child: Text(title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ),
        Expanded(child: body),
      ],
    );
  }
}
