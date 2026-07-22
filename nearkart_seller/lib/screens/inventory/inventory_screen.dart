import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearkart_seller/core/models/dummy_data.dart';
import 'package:nearkart_seller/core/models/product_model.dart';
import 'package:nearkart_seller/core/theme/app_colors.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<SellerProduct> _products =
      List.from(SellerDummyData.products);

  int get _outOfStock =>
      _products.where((p) => p.isOutOfStock).length;
  int get _lowStock =>
      _products.where((p) => p.isLowStock).length;

  void _updateStock(int idx, int delta) {
    final p = _products[idx];
    final newStock = (p.stock + delta).clamp(0, 999);
    setState(() {
      _products[idx] = SellerProduct(
        id: p.id, name: p.name, category: p.category,
        price: p.price, originalPrice: p.originalPrice,
        unit: p.unit, stock: newStock,
        isActive: newStock > 0 ? p.isActive : false,
        image: p.image,
      );
    });
  }

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
        title: const Text('Inventory',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary cards
          Row(
            children: [
              _SummaryCard(
                label: 'Total Items',
                value: '${_products.length}',
                icon: Icons.inventory_2_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              _SummaryCard(
                label: 'Low Stock',
                value: '$_lowStock',
                icon: Icons.warning_amber_rounded,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 10),
              _SummaryCard(
                label: 'Out of Stock',
                value: '$_outOfStock',
                icon: Icons.remove_circle_outline_rounded,
                color: AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_outOfStock > 0 || _lowStock > 0)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.secondary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$_lowStock item${_lowStock == 1 ? '' : 's'} low on stock, '
                      '$_outOfStock out of stock. Update inventory now.',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
          ...List.generate(
            _products.length,
            (i) => _InventoryTile(
              product: _products[i],
              onAdd: () => _updateStock(i, 10),
              onDecrement: () => _updateStock(i, -1),
              onIncrement: () => _updateStock(i, 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _SummaryCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textLight),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _InventoryTile extends StatelessWidget {
  final SellerProduct product;
  final VoidCallback onAdd;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  const _InventoryTile(
      {required this.product,
      required this.onAdd,
      required this.onDecrement,
      required this.onIncrement});

  Color get _stockColor {
    if (product.isOutOfStock) return AppColors.error;
    if (product.isLowStock) return AppColors.secondary;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product.image,
              width: 56, height: 56, fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                width: 56, height: 56,
                color: AppColors.background,
                child: const Icon(Icons.image_rounded,
                    color: AppColors.textLight),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(product.category,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textLight)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: _stockColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.isOutOfStock
                            ? 'Out of Stock'
                            : '${product.stock} left',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _stockColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppColors.primary
                                  .withValues(alpha: 0.3)),
                        ),
                        child: const Text('+10',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Qty stepper
          Row(
            children: [
              _StepBtn(Icons.remove, onDecrement),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('${product.stock}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark)),
              ),
              _StepBtn(Icons.add, onIncrement),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, size: 15, color: AppColors.primary),
      ),
    );
  }
}
