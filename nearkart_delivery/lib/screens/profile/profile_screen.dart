import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_delivery/core/theme/app_colors.dart';
import 'package:nearkart_delivery/core/state/delivery_provider.dart';
import 'package:nearkart_delivery/widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            title: const Text('Profile'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            children: [
              _AgentCard(provider: provider),
              const SizedBox(height: 12),
              _Section(title: 'Vehicle Details', items: const [
                _InfoTile(icon: Icons.two_wheeler, label: 'Vehicle Type', value: 'Motorcycle'),
                _InfoTile(icon: Icons.confirmation_number_outlined, label: 'Vehicle Number', value: 'KA 05 AB 1234'),
                _InfoTile(icon: Icons.local_gas_station_outlined, label: 'Fuel Type', value: 'Petrol'),
              ]),
              const SizedBox(height: 12),
              _Section(title: 'Documents', items: const [
                _DocTile(label: 'Driving License', status: 'Verified'),
                _DocTile(label: 'Vehicle RC', status: 'Verified'),
                _DocTile(label: 'Insurance', status: 'Expiring Soon'),
              ]),
              const SizedBox(height: 12),
              _Section(title: 'Account', items: [
                _ActionTile(icon: Icons.help_outline, label: 'Help & Support', onTap: () {}),
                _ActionTile(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () {}),
                _ActionTile(
                  icon: Icons.logout,
                  label: 'Logout',
                  color: AppColors.error,
                  onTap: () => _confirmLogout(context),
                ),
              ]),
              const SizedBox(height: 24),
            ],
          ),
          bottomNavigationBar: const DeliveryBottomNav(index: 3),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
            child: const Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _AgentCard extends StatelessWidget {
  final DeliveryProvider provider;
  const _AgentCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.white,
            child: Icon(Icons.person, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          const Text('Ravi Kumar',
              style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('+91 98765 43210',
              style: TextStyle(color: AppColors.white, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AgentStat(label: 'Deliveries', value: '${provider.todayDeliveries}'),
              _AgentStat(label: 'Rating', value: '4.8 ★'),
              _AgentStat(label: 'Earned', value: '₹${provider.totalEarnings.toStringAsFixed(0)}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AgentStat extends StatelessWidget {
  final String label, value;
  const _AgentStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: AppColors.white.withValues(alpha: 0.8), fontSize: 11)),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(title,
                style: const TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.w600)),
          ),
          ...items,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}

class _DocTile extends StatelessWidget {
  final String label, status;
  const _DocTile({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    final isVerified = status == 'Verified';
    return ListTile(
      leading: const Icon(Icons.description_outlined, color: AppColors.primary, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: (isVerified ? AppColors.success : AppColors.secondary).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isVerified ? AppColors.success : Colors.orange[800],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label, style: TextStyle(color: color, fontSize: 14)),
      trailing: color == AppColors.error
          ? null
          : const Icon(Icons.chevron_right, color: AppColors.textLight),
      onTap: onTap,
    );
  }
}
