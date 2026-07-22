import 'package:flutter/material.dart';
import 'package:nearkart_admin/core/theme/app_colors.dart';
import 'package:nearkart_admin/core/models/dummy_data.dart';
import 'package:nearkart_admin/screens/dashboard/admin_scaffold.dart';

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Delivery Agents',
      selectedIndex: 3,
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: DummyData.agents.length,
        itemBuilder: (context, i) => _AgentCard(agent: DummyData.agents[i]),
      ),
    );
  }
}

class _AgentCard extends StatelessWidget {
  final AdminAgent agent;
  const _AgentCard({required this.agent});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.background,
                  child: Icon(Icons.person, color: AppColors.textLight, size: 28),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(
                      color: agent.isOnline ? AppColors.success : AppColors.textLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(agent.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(agent.phone, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                  Text(agent.vehicleNumber, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _Badge(
                  label: agent.isActive ? 'Active' : 'Inactive',
                  color: agent.isActive ? AppColors.success : AppColors.error,
                ),
                const SizedBox(height: 6),
                Text('${agent.deliveries} deliveries',
                    style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                Text('₹${agent.earnings.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
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
