import 'package:flutter/material.dart';
import 'package:nearkart_admin/core/theme/app_colors.dart';
import 'package:nearkart_admin/core/models/dummy_data.dart';
import 'package:nearkart_admin/screens/dashboard/admin_scaffold.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Users',
      selectedIndex: 4,
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: DummyData.users.length,
        itemBuilder: (context, i) => _UserCard(user: DummyData.users[i]),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final AdminUser user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(user.name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(user.phone, style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (user.isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.isActive ? 'Active' : 'Blocked',
                    style: TextStyle(
                        fontSize: 11,
                        color: user.isActive ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${user.orderCount} orders',
                    style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
