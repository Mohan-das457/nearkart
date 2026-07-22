import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_customer/core/state/app_state.dart';
import 'package:nearkart_customer/core/state/cart_provider.dart';
import 'package:nearkart_customer/core/theme/app_colors.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const double _minOrder = 99;

  int _selectedAddress = 0;
  int _selectedPayment = 0;
  bool _placing = false;

  final List<Map<String, String>> _addresses = [
    {
      'label': 'Home',
      'address': '12, MG Road, Koramangala',
      'city': 'Bengaluru - 560034',
    },
    {
      'label': 'Work',
      'address': 'Prestige Tech Park, Outer Ring Road',
      'city': 'Bengaluru - 560103',
    },
  ];

  final List<Map<String, dynamic>> _payments = [
    {'label': 'Cash on Delivery', 'icon': Icons.money_rounded},
    {'label': 'UPI / GPay / PhonePe', 'icon': Icons.account_balance_wallet_rounded},
    {'label': 'Credit / Debit Card', 'icon': Icons.credit_card_rounded},
  ];

  void _showAddAddressSheet(BuildContext context) {
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add New Address',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 16),
            TextField(
              controller: streetCtrl,
              decoration: InputDecoration(
                labelText: 'Street / Area',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cityCtrl,
              decoration: InputDecoration(
                labelText: 'City & Pincode',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (streetCtrl.text.isNotEmpty && cityCtrl.text.isNotEmpty) {
                    setState(() {
                      _addresses.add({
                        'label': 'Other',
                        'address': streetCtrl.text,
                        'city': cityCtrl.text,
                      });
                      _selectedAddress = _addresses.length - 1;
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: const Text('Save Address',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder(CartProvider cart) async {
    setState(() => _placing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final addr = _addresses[_selectedAddress];
    final address = '${addr['address']}, ${addr['city']}';
    final payment = _payments[_selectedPayment]['label'] as String;
    final appState = context.read<AppState>();
    appState.setOrder(address: address, payment: payment);
    await appState.addOrder(
      orderId: '#NK${10000 + (DateTime.now().millisecondsSinceEpoch % 90000)}',
      products: cart.items.map((i) => i.product).toList(),
      quantities: cart.items.map((i) => i.qty).toList(),
      units: cart.items.map((i) => i.selectedUnit).toList(),
      address: address,
      payment: payment,
      total: cart.total(_minOrder),
    );
    cart.clear();
    if (mounted) context.go('/tracking');
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
          onPressed: () => context.go('/cart'),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSection(
                    title: 'Delivery Address',
                    trailing: TextButton(
                      onPressed: () => _showAddAddressSheet(context),
                      child: const Text('+ Add New',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ),
                    child: Column(
                      children: _addresses.asMap().entries.map((e) {
                        final selected = e.key == _selectedAddress;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedAddress = e.key),
                          child: _AddressTile(
                            data: e.value,
                            selected: selected,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSection(
                    title: 'Payment Method',
                    child: Column(
                      children: _payments.asMap().entries.map((e) {
                        final selected = e.key == _selectedPayment;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedPayment = e.key),
                          child: _PaymentTile(
                            data: e.value,
                            selected: selected,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSection(
                    title: 'Order Summary',
                    child: Column(
                      children: [
                        ...cart.items.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.product.image,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stack) =>
                                              Container(
                                        width: 44,
                                        height: 44,
                                        color: AppColors.background,
                                        child: const Icon(
                                            Icons.image_rounded,
                                            size: 20,
                                            color: AppColors.textLight),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.product.name,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textDark),
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis),
                                        Text(
                                            '${item.selectedUnit} × ${item.qty}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textLight)),
                                      ],
                                    ),
                                  ),
                                  Text('₹${item.total.toInt()}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark)),
                                ],
                              ),
                            )),
                        const Divider(height: 20, color: Color(0xFFF0F0F0)),
                        _SummaryRow(
                            label: 'Subtotal',
                            value: '₹${cart.subtotal.toInt()}'),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Delivery Fee',
                          value: cart.deliveryFee(_minOrder) == 0
                              ? 'FREE'
                              : '₹${cart.deliveryFee(_minOrder).toInt()}',
                          valueColor: cart.deliveryFee(_minOrder) == 0
                              ? AppColors.primary
                              : null,
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Discount',
                          value: '− ₹${cart.discount.toInt()}',
                          valueColor: AppColors.primary,
                        ),
                        const Divider(height: 20, color: Color(0xFFF0F0F0)),
                        _SummaryRow(
                          label: 'Total',
                          value: '₹${cart.total(_minOrder).toInt()}',
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDeliveryInfo(),
                ],
              ),
            ),
            _buildPlaceOrderBar(context, cart),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined,
              color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Estimated delivery in 20–30 minutes',
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBar(BuildContext context, CartProvider cart) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('₹${cart.total(_minOrder).toInt()}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const Text('Total amount',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textLight)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _placing ? null : () => _placeOrder(cart),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.5),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _placing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: AppColors.white, strokeWidth: 2.5),
                    )
                  : const Text('Place Order',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Address tile ──────────────────────────────────────────────────────────────

class _AddressTile extends StatelessWidget {
  final Map<String, String> data;
  final bool selected;
  const _AddressTile({required this.data, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.06)
            : AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.textLight.withValues(alpha: 0.2),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded,
              color: selected ? AppColors.primary : AppColors.textLight,
              size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['label']!,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textDark)),
                Text('${data['address']}, ${data['city']}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          if (selected)
            const Icon(Icons.check_circle_rounded,
                color: AppColors.primary, size: 18),
        ],
      ),
    );
  }
}

// ── Payment tile ──────────────────────────────────────────────────────────────

class _PaymentTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool selected;
  const _PaymentTile({required this.data, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.06)
            : AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.textLight.withValues(alpha: 0.2),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(data['icon'] as IconData,
              color: selected ? AppColors.primary : AppColors.textLight,
              size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(data['label'] as String,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textDark)),
          ),
          if (selected)
            const Icon(Icons.check_circle_rounded,
                color: AppColors.primary, size: 18),
        ],
      ),
    );
  }
}

// ── Summary row ───────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  const _SummaryRow(
      {required this.label,
      required this.value,
      this.valueColor,
      this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
        fontSize: bold ? 15 : 13,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: AppColors.textDark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value,
            style: style.copyWith(color: valueColor ?? AppColors.textDark)),
      ],
    );
  }
}
