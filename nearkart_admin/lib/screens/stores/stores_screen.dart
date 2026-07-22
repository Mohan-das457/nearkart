import 'package:flutter/material.dart';
import 'package:nearkart_admin/core/theme/app_colors.dart';
import 'package:nearkart_admin/core/models/dummy_data.dart';
import 'package:nearkart_admin/screens/dashboard/admin_scaffold.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Stores',
      selectedIndex: 2,
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: DummyData.stores.length,
        itemBuilder: (context, i) => _StoreCard(store: DummyData.stores[i]),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final AdminStore store;
  const _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.store, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(store.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(width: 8),
                    _Badge(label: store.category, color: Colors.teal),
                  ]),
                  const SizedBox(height: 4),
                  Text(store.address, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                  Text('Owner: ${store.owner}', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _Badge(
                  label: store.isActive ? 'Active' : 'Inactive',
                  color: store.isActive ? AppColors.success : AppColors.error,
                ),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.star, size: 14, color: AppColors.warning),
                  const SizedBox(width: 2),
                  Text(store.rating.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
