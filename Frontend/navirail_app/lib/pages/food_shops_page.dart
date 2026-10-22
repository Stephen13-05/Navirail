import 'package:flutter/material.dart';

import '../ui/design_system.dart';

class FoodShopsPage extends StatelessWidget {
  const FoodShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const shops = [
      _Shop(
        name: 'Kovilpatti Muruku Kadai',
        category: 'Snacks & Sweets',
        description:
            'Famous for crispy Kovilpatti murukku and traditional South Indian snacks. Freshly prepared items, ideal for takeaway before your journey.',
      ),
      _Shop(
        name: 'Kumar Beverages',
        category: 'Juice & Beverages',
        description:
            'Cold drinks, fresh juices and bottled water for travellers. A quick stop to grab something refreshing on the go.',
      ),
      _Shop(
        name: 'Handloom Shops',
        category: 'Handloom & Gifts',
        description:
            'Handloom products, shawls and small gift items crafted by local artisans. Perfect for last‑minute souvenirs.',
      ),
    ];

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.primaryDeepBlue,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Food & Shops',
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover food, beverages and shopping options inside the station.',
                  style: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.neutralDarkGrey,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: shops.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final shop = shops[index];
                      return _ShopCard(shop: shop);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop});

  final _Shop shop;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        side: BorderSide(color: AppColors.cardBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ShopDetailPage(shop: shop),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r16),
            color: AppColors.neutralWhite,
            boxShadow: AppShadows.low,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.primaryDeepBlue.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.storefront,
                  color: AppColors.primaryDeepBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.neutralDarkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shop.category,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neutralGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.neutralGrey),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopDetailPage extends StatelessWidget {
  const ShopDetailPage({super.key, required this.shop});

  final _Shop shop;

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.primaryDeepBlue,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            shop.name,
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    boxShadow: AppShadows.medium,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primaryDeepBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shop.category,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.neutralGrey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        shop.description,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.neutralDarkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Actions',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.primaryDeepBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Hook into station map / 3D map screen
                        },
                        icon: const Icon(Icons.map_outlined),
                        label: Text(
                          'Show direction on map',
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDeepBlue,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.r16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Integrate with AR navigation / navigation page
                        },
                        icon: const Icon(Icons.navigation_outlined),
                        label: Text(
                          'Navigate',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primaryDeepBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.primaryDeepBlue,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.r16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Shop {
  const _Shop({
    required this.name,
    required this.category,
    required this.description,
  });

  final String name;
  final String category;
  final String description;
}
