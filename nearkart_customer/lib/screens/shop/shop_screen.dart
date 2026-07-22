import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_customer/core/data/dummy_data.dart';
import 'package:nearkart_customer/core/models/product_model.dart';
import 'package:nearkart_customer/core/models/store_model.dart';
import 'package:nearkart_customer/core/state/cart_provider.dart';
import 'package:nearkart_customer/core/theme/app_colors.dart';

class ShopScreen extends StatefulWidget {
  final String storeId;
  const ShopScreen({super.key, required this.storeId});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  StoreModel get _store => DummyData.stores.firstWhere(
        (s) => s.id == widget.storeId,
        orElse: () => DummyData.stores.first,
      );

  List<String> get _tabs {
    final cats = DummyData.allProducts
        .where((p) => p.storeId == widget.storeId)
        .map((p) => p.category)
        .toSet()
        .toList();
    return ['All', ...cats];
  }

  List<ProductModel> _productsFor(String tab) {
    final storeProducts = DummyData.allProducts
        .where((p) => p.storeId == widget.storeId)
        .toList();
    if (tab == 'All') return storeProducts;
    return storeProducts.where((p) => p.category == tab).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = _store;
    final tabs = _tabs;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(store, innerBoxIsScrolled),
          _buildTabBar(tabs),
        ],
        body: TabBarView(
          controller: _tabController,
          children: tabs
              .map((tab) => _ProductTab(
                    products: _productsFor(tab),
                  ))
              .toList(),
        ),
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, _) =>
            cart.itemCount > 0 ? _buildCartBar(cart) : const SizedBox.shrink(),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(StoreModel store, bool collapsed) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppColors.white,
      leading: GestureDetector(
        onTap: () => context.go('/home'),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: collapsed ? Colors.transparent : Colors.black26,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: collapsed ? AppColors.textDark : AppColors.white,
            size: 18,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        title: collapsed
            ? Text(store.name,
                style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))
            : null,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              store.banner,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                color: AppColors.primary.withValues(alpha: 0.15),
                child: const Icon(Icons.storefront_rounded,
                    size: 64, color: AppColors.primary),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.name,
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(store.category,
                      style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.85),
                          fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoPill(
                        icon: Icons.star_rounded,
                        label: '${store.rating} (${store.reviewCount})',
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 8),
                      _InfoPill(
                        icon: Icons.access_time_rounded,
                        label: '${store.deliveryMinutes} min',
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 8),
                      _InfoPill(
                        icon: Icons.near_me_rounded,
                        label: store.distance,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPersistentHeader _buildTabBar(List<String> tabs) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          labelStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          indicatorColor: AppColors.primary,
          indicatorWeight: 2.5,
          dividerColor: Colors.transparent,
          tabs: tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
    );
  }

  Widget _buildCartBar(CartProvider cart) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go('/cart'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${cart.itemCount} item${cart.itemCount == 1 ? '' : 's'}',
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'View Cart',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '₹${cart.subtotal.toInt()}',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: AppColors.white, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Tab content ───────────────────────────────────────────────────────────────

class _ProductTab extends StatelessWidget {
  final List<ProductModel> products;

  const _ProductTab({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 56, color: AppColors.textLight.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            const Text('No products',
                style: TextStyle(fontSize: 15, color: AppColors.textLight)),
          ],
        ),
      );
    }
    return Consumer<CartProvider>(
      builder: (context, cart, _) => GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: products.length,
        itemBuilder: (context, i) => _ShopProductCard(
          product: products[i],
          qty: cart.contains(products[i].id)
              ? cart.qtyOf(products[i].id)
              : 0,
          onQtyChanged: (qty) => qty == 0
              ? cart.remove(products[i].id)
              : qty > (cart.contains(products[i].id)
                  ? cart.qtyOf(products[i].id)
                  : 0)
                  ? cart.add(products[i])
                  : cart.decrement(products[i].id),
        ),
      ),
    );
  }
}

// ── Shop product card ─────────────────────────────────────────────────────────

class _ShopProductCard extends StatelessWidget {
  final ProductModel product;
  final int qty;
  final ValueChanged<int> onQtyChanged;

  const _ShopProductCard({
    required this.product,
    required this.qty,
    required this.onQtyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Image.network(
                    product.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      height: 120,
                      color: AppColors.background,
                      child: const Icon(Icons.image_rounded,
                          color: AppColors.textLight, size: 36),
                    ),
                  ),
                ),
                if (product.discountPercent > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${product.discountPercent}% OFF',
                        style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(product.unit,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textLight)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹${product.price.toInt()}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark)),
                          Text('₹${product.originalPrice.toInt()}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textLight,
                                decoration: TextDecoration.lineThrough,
                              )),
                        ],
                      ),
                      qty == 0
                          ? GestureDetector(
                              onTap: () => onQtyChanged(1),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.add,
                                    color: AppColors.white, size: 18),
                              ),
                            )
                          : Row(
                              children: [
                                _QtyBtn(
                                    icon: Icons.remove,
                                    onTap: () => onQtyChanged(qty - 1)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6),
                                  child: Text('$qty',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark)),
                                ),
                                _QtyBtn(
                                    icon: Icons.add,
                                    onTap: () => onQtyChanged(qty + 1)),
                              ],
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }
}

// ── Info pill ─────────────────────────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoPill(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ── Tab bar delegate ──────────────────────────────────────────────────────────

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(color: AppColors.white, child: tabBar);

  @override
  bool shouldRebuild(_TabBarDelegate old) => old.tabBar != tabBar;
}
