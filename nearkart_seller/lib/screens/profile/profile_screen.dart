import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearkart_seller/core/theme/app_colors.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textDark, size: 20),
          onPressed: () => context.go('/dashboard'),
        ),
        title: const Text('Profile',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStoreCard(),
          const SizedBox(height: 16),
          _buildSection('Store Settings', [
            _Tile(Icons.storefront_rounded,        'Store Information',  AppColors.primary,        () {}),
            _Tile(Icons.access_time_rounded,       'Opening Hours',      const Color(0xFF03A9F4),  () {}),
            _Tile(Icons.delivery_dining_rounded,   'Delivery Settings',  const Color(0xFF9C27B0),  () {}),
            _Tile(Icons.local_offer_rounded,       'Offers & Discounts', AppColors.secondary,      () {}),
          ]),
          const SizedBox(height: 12),
          _buildSection('Account', [
            _Tile(Icons.person_outline_rounded,    'Personal Details',   AppColors.primary,        () {}),
            _Tile(Icons.account_balance_rounded,   'Bank Account',       AppColors.success,        () {}),
            _Tile(Icons.notifications_outlined,    'Notifications',      const Color(0xFFFF9800),  () {}),
          ]),
          const SizedBox(height: 12),
          _buildSection('Support', [
            _Tile(Icons.help_outline_rounded,      'Help & Support',     const Color(0xFF03A9F4),  () {}),
            _Tile(Icons.policy_outlined,           'Terms & Policies',   AppColors.textLight,      () {}),
          ]),
          const SizedBox(height: 12),
          _buildLogout(context),
          const SizedBox(height: 24),
          Center(
            child: Text('NearKart Seller v1.0.0',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight.withValues(alpha: 0.6))),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStoreCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.storefront_rounded,
                color: AppColors.white, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fresh Mart',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text('Koramangala, Bengaluru',
                    style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.85),
                        fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle,
                              size: 8, color: AppColors.white),
                          SizedBox(width: 4),
                          Text('Open',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star_rounded,
                        color: AppColors.secondary, size: 14),
                    const SizedBox(width: 3),
                    Text('4.5',
                        style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.9),
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<_Tile> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                  letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: tiles.asMap().entries.map((e) {
              final tile = e.value;
              final last = e.key == tiles.length - 1;
              return Column(
                children: [
                  ListTile(
                    onTap: tile.onTap,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 2),
                    leading: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: tile.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(tile.icon, color: tile.color, size: 20),
                    ),
                    title: Text(tile.label,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: AppColors.textLight),
                  ),
                  if (!last)
                    const Divider(
                        height: 1, indent: 68, color: Color(0xFFF0F0F0)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLogout(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: const Text('Logout',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textLight)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded,
                  color: Colors.red, size: 20),
            ),
            const SizedBox(width: 14),
            const Text('Logout',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

class _Tile {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Tile(this.icon, this.label, this.color, this.onTap);
}
