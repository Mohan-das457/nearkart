import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_customer/core/data/dummy_data.dart';
import 'package:nearkart_customer/core/models/product_model.dart';
import 'package:nearkart_customer/core/models/store_model.dart';
import 'package:nearkart_customer/core/state/app_state.dart';
import 'package:nearkart_customer/core/state/cart_provider.dart';
import 'package:nearkart_customer/core/theme/app_colors.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _imageIndex = 0;
  late String _selectedUnit;
  bool _descExpanded = true;
  bool _benefitsExpanded = true;
  final _pageController = PageController();

  ProductModel get _product => DummyData.allProducts.firstWhere(
        (p) => p.id == widget.productId,
        orElse: () => DummyData.allProducts.first,
      );

  StoreModel get _store => DummyData.stores.firstWhere(
        (s) => s.id == _product.storeId,
        orElse: () => DummyData.stores.first,
      );

  List<ProductModel> get _related => DummyData.allProducts
      .where((p) => p.category == _product.category && p.id != _product.id)
      .take(6)
      .toList();

  @override
  void initState() {
    super.initState();
    _selectedUnit = _product.unit;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;
    final images = product.images.isNotEmpty ? product.images : [product.image];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildImageGallery(images)),
              SliverToBoxAdapter(child: _buildProductInfo(product)),
              SliverToBoxAdapter(child: _buildUnitSelector(product)),
              SliverToBoxAdapter(child: _buildStoreRow()),
              SliverToBoxAdapter(child: _buildDivider()),
              SliverToBoxAdapter(child: _buildAccordion(
                title: 'Description',
                expanded: _descExpanded,
                onTap: () => setState(() => _descExpanded = !_descExpanded),
                child: Text(
                  product.description,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textLight, height: 1.6),
                ),
              )),
              SliverToBoxAdapter(child: _buildDivider()),
              if (product.benefits.isNotEmpty)
                SliverToBoxAdapter(child: _buildAccordion(
                  title: 'Benefits',
                  expanded: _benefitsExpanded,
                  onTap: () =>
                      setState(() => _benefitsExpanded = !_benefitsExpanded),
                  child: Column(
                    children: product.benefits
                        .map((b) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(b,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textDark)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                )),
              SliverToBoxAdapter(child: _buildDivider()),
              if (_related.isNotEmpty) ...[
                SliverToBoxAdapter(child: _buildSectionTitle('You may also like')),
                SliverToBoxAdapter(child: _buildRelated()),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16, color: AppColors.textDark),
              ),
            ),
          ),
          // Wishlist button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 58,
            child: Consumer<AppState>(
              builder: (context, appState, _) => GestureDetector(
                onTap: () => appState.toggleWishlist(_product.id),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    appState.isWishlisted(_product.id)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 18,
                    color: appState.isWishlisted(_product.id)
                        ? Colors.red
                        : AppColors.textDark,
                  ),
                ),
              ),
            ),
          ),
          // Cart icon
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: GestureDetector(
              onTap: () => context.go('/cart'),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.shopping_cart_outlined,
                    size: 18, color: AppColors.textDark),
              ),
            ),
          ),
          // Bottom bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(product),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(List<String> images) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _imageIndex = i),
            itemCount: images.length,
            itemBuilder: (context, i) => Image.network(
              images[i],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                color: AppColors.background,
                child: const Icon(Icons.image_rounded,
                    size: 64, color: AppColors.textLight),
              ),
            ),
          ),
          if (images.length > 1)
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _imageIndex == i ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _imageIndex == i
                          ? AppColors.primary
                          : Colors.white60,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          if (_product.discountPercent > 0)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_product.discountPercent}% OFF',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${product.price.toInt()}',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark),
                  ),
                  Text(
                    '₹${product.originalPrice.toInt()}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.secondary, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toString(),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${product.reviewCount} reviews',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textLight),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSelector(ProductModel product) {
    if (product.unitOptions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select unit',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: product.unitOptions.map((u) {
              final selected = u == _selectedUnit;
              return GestureDetector(
                onTap: () => setState(() => _selectedUnit = u),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    u,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.white : AppColors.textDark,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreRow() {
    final store = _store;
    return GestureDetector(
      onTap: () => context.go('/shop/${store.id}'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.storefront_rounded,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  Text(store.category,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: AppColors.secondary, size: 14),
                const SizedBox(width: 3),
                Text(store.rating.toString(),
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textDark)),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 12, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark)),
                const Spacer(),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: child,
          ),
      ],
    );
  }

  Widget _buildDivider() =>
      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0));

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
      );

  Widget _buildRelated() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _related.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final p = _related[i];
          return GestureDetector(
            onTap: () => context.go('/product/${p.id}'),
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
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
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12)),
                    child: Image.network(
                      p.image,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        height: 100,
                        color: AppColors.background,
                        child: const Icon(Icons.image_rounded,
                            color: AppColors.textLight),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text('₹${p.price.toInt()}',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(ProductModel product) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final qty = cart.contains(product.id) ? cart.qtyOf(product.id) : 0;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('₹${product.price.toInt()}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    Text(_selectedUnit,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textLight)),
                  ],
                ),
              ),
              qty == 0
                  ? SizedBox(
                      height: 48,
                      width: 160,
                      child: ElevatedButton(
                        onPressed: () =>
                            cart.add(product, unit: _selectedUnit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Add to Cart',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                      ),
                    )
                  : Container(
                      height: 48,
                      width: 160,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove,
                                color: AppColors.white, size: 20),
                            onPressed: () => cart.decrement(product.id),
                          ),
                          Text('$qty',
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add,
                                color: AppColors.white, size: 20),
                            onPressed: () => cart.increment(product.id),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
