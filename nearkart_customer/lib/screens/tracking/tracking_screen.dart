import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_customer/core/state/app_state.dart';
import 'package:nearkart_customer/core/theme/app_colors.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  int _etaSeconds = 18 * 60;
  Timer? _stepTimer;
  Timer? _etaTimer;
  late final String _orderId;
  late AnimationController _pinController;
  late Animation<double> _pinAnim;

  static const _steps = [
    _StepData('Order Placed',      'Your order has been received',      Icons.receipt_long_rounded),
    _StepData('Confirmed',         'Store has confirmed your order',     Icons.check_circle_rounded),
    _StepData('Preparing',         'Store is packing your items',        Icons.shopping_bag_rounded),
    _StepData('Out for Delivery',  'Agent is on the way to you',         Icons.delivery_dining_rounded),
    _StepData('Delivered',         'Order delivered successfully 🎉',    Icons.home_rounded),
  ];

  @override
  void initState() {
    super.initState();
    // Use the real order ID placed in checkout
    _orderId = context.read<AppState>().lastOrderId;

    _pinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pinAnim = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _pinController, curve: Curves.easeInOut),
    );

    _stepTimer = Timer.periodic(const Duration(seconds: 5), (t) {
      if (_currentStep < _steps.length - 1) {
        setState(() => _currentStep++);
      } else {
        t.cancel();
      }
    });

    _etaTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_etaSeconds > 0) {
        setState(() => _etaSeconds--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _etaTimer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  String get _etaLabel {
    if (_etaSeconds <= 0) return 'Arriving now!';
    final m = _etaSeconds ~/ 60;
    final s = _etaSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _delivered => _currentStep == _steps.length - 1;

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
          onPressed: () =>
              context.go('/home'),
        ),
        title: const Text('Track Order',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _delivered
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _delivered ? 'Delivered' : 'Live',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _delivered
                          ? AppColors.primary
                          : AppColors.secondary),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMap(),
            const SizedBox(height: 16),
            if (!_delivered) ...[
              _buildEtaCard(),
              const SizedBox(height: 12),
            ],
            _buildStepper(),
            const SizedBox(height: 12),
            if (!_delivered) _buildAgentCard(),
            if (_delivered) _buildDeliveredCard(context),
            const SizedBox(height: 12),
            _buildOrderInfo(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Map placeholder ─────────────────────────────────────────────────────────

  Widget _buildMap() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _GridPainter()),
            CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _RoutePainter()),
            // Delivery pin
            Center(
              child: AnimatedBuilder(
                animation: _pinAnim,
                builder: (context, child) =>
                    Transform.translate(offset: Offset(0, _pinAnim.value), child: child),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.delivery_dining_rounded,
                      color: AppColors.white, size: 26),
                ),
              ),
            ),
            // Home pin
            Positioned(
              right: 60,
              bottom: 50,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const Icon(Icons.home_rounded,
                    color: AppColors.primary, size: 14),
              ),
            ),
            // Live badge
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_rounded,
                        size: 14, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text('Live Map',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── ETA card ────────────────────────────────────────────────────────────────

  Widget _buildEtaCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded,
              color: AppColors.white, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Estimated Arrival',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(_steps[_currentStep].subtitle,
                    style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.8),
                        fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _etaLabel,
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              if (_etaSeconds > 0)
                Text('remaining',
                    style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.8),
                        fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stepper ─────────────────────────────────────────────────────────────────

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: List.generate(_steps.length, (i) {
          final done = i < _currentStep;
          final active = i == _currentStep;
          final last = i == _steps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 36,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: done || active
                            ? AppColors.primary
                            : AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: done || active
                              ? AppColors.primary
                              : AppColors.textLight.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        done ? Icons.check_rounded : _steps[i].icon,
                        color: done || active
                            ? AppColors.white
                            : AppColors.textLight,
                        size: 18,
                      ),
                    ),
                    if (!last)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 2,
                        height: 32,
                        color: done
                            ? AppColors.primary
                            : AppColors.textLight.withValues(alpha: 0.2),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 6, bottom: last ? 0 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _steps[i].title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: done || active
                              ? AppColors.textDark
                              : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _steps[i].subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: active
                              ? AppColors.primary
                              : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (active)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _PulsingDot(),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ── Agent card ──────────────────────────────────────────────────────────────

  Widget _buildAgentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded,
                color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delivery Agent',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textLight)),
                const SizedBox(height: 2),
                const Text('Rajan Kumar',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.secondary, size: 14),
                    const SizedBox(width: 3),
                    const Text('4.8',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textDark)),
                    const SizedBox(width: 8),
                    Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                            color: AppColors.textLight,
                            shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    const Text('245 deliveries',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textLight)),
                  ],
                ),
              ],
            ),
          ),
          _ActionBtn(
              icon: Icons.call_rounded,
              color: AppColors.primary,
              onTap: () {}),
          const SizedBox(width: 8),
          _ActionBtn(
              icon: Icons.chat_bubble_outline_rounded,
              color: AppColors.secondary,
              onTap: () {}),
        ],
      ),
    );
  }

  // ── Delivered card ──────────────────────────────────────────────────────────

  Widget _buildDeliveredCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.white, size: 52),
          const SizedBox(height: 12),
          const Text('Order Delivered! 🎉',
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Hope you enjoy your items!',
              style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.85),
                  fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      context.go('/home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Home'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showRatingSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Rate Order',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Rating sheet ────────────────────────────────────────────────────────────

  void _showRatingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const _RatingSheet(),
    );
  }

  // ── Order info ──────────────────────────────────────────────────────────────

  Widget _buildOrderInfo() {
    final appState = context.read<AppState>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Details',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
          const SizedBox(height: 12),
          _InfoRow(label: 'Order ID', value: _orderId),
          const SizedBox(height: 8),
          const _InfoRow(label: 'Store', value: 'Fresh Mart'),
          const SizedBox(height: 8),
          _InfoRow(
              label: 'Deliver to',
              value: appState.deliveryAddress.isNotEmpty
                  ? appState.deliveryAddress
                  : '12, MG Road, Koramangala'),
          const SizedBox(height: 8),
          _InfoRow(
              label: 'Payment',
              value: appState.paymentMethod.isNotEmpty
                  ? appState.paymentMethod
                  : 'Cash on Delivery'),
        ],
      ),
    );
  }
}

// ── Pulsing dot ───────────────────────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..repeat(reverse: true);
    _a = Tween<double>(begin: 0.3, end: 1.0).animate(_c);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _a,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
            color: AppColors.primary, shape: BoxShape.circle),
      ),
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

// ── Info row ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark)),
      ],
    );
  }
}

// ── Step data ─────────────────────────────────────────────────────────────────

class _StepData {
  final String title;
  final String subtitle;
  final IconData icon;
  const _StepData(this.title, this.subtitle, this.icon);
}

// ── Custom painters ───────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC8E6C9)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withAlpha(120)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.5)
      ..cubicTo(
        size.width * 0.55, size.height * 0.35,
        size.width * 0.65, size.height * 0.55,
        size.width * 0.78, size.height * 0.62,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_RoutePainter old) => false;
}

// ── Rating sheet ──────────────────────────────────────────────────────────────

class _RatingSheet extends StatefulWidget {
  const _RatingSheet();
  @override
  State<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<_RatingSheet> {
  int _rating = 0;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Rate your order',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
          const SizedBox(height: 6),
          const Text('How was your experience?',
              style: TextStyle(fontSize: 13, color: AppColors.textLight)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    i < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: AppColors.secondary,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write a review (optional)',
              hintStyle:
                  const TextStyle(color: AppColors.textLight, fontSize: 13),
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
              onPressed: _rating == 0
                  ? null
                  : () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.4),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text('Submit Review',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
