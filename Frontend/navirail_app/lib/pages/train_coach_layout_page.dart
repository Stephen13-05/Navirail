import 'package:flutter/material.dart';

import '../ui/design_system.dart';

class TrainCoachLayoutPage extends StatelessWidget {
  const TrainCoachLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final variants = _CoachVariant.icfAndLhbVariants;

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
            'Coach Layouts',
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
                  'Understand your coach before you travel.',
                  style: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.neutralDarkGrey,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: AppShadows.low,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 20, color: AppColors.primaryDeepBlue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap a coach type (ICF / LHB) to see berth details and full layout image.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutralDarkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: variants.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final v = variants[index];
                      return _CoachVariantCard(variant: v);
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

class _CoachVariantCard extends StatelessWidget {
  const _CoachVariantCard({required this.variant});

  final _CoachVariant variant;

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
              builder: (_) => CoachLayoutDetailPage(variant: variant),
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
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  color: AppColors.brandLightBlue.withOpacity(0.12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  variant.thumbnailAsset,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${variant.code} • ${variant.shortName}',
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.neutralDarkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      variant.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neutralGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _PillChip(label: variant.familyLabel),
                        const SizedBox(width: 8),
                        _PillChip(label: '${variant.totalBerths} berths'),
                      ],
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

class _PillChip extends StatelessWidget {
  const _PillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGrey,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.neutralDarkGrey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CoachLayoutDetailPage extends StatelessWidget {
  const CoachLayoutDetailPage({super.key, required this.variant});

  final _CoachVariant variant;

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
            '${variant.code} • ${variant.shortName}',
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
                        variant.title,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primaryDeepBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _PillChip(label: variant.familyLabel),
                          const SizedBox(width: 8),
                          _PillChip(label: '${variant.totalBerths} berths (approx)'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        variant.description,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.neutralDarkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Layout diagram',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.primaryDeepBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    boxShadow: AppShadows.low,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: Image.asset(
                        variant.layoutAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Berth legend',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.primaryDeepBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'L: Lower • M: Middle • U: Upper • SL: Side Lower • SU: Side Upper',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.neutralGrey,
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

class _CoachVariant {
  const _CoachVariant({
    required this.code,
    required this.shortName,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.familyLabel,
    required this.totalBerths,
    required this.thumbnailAsset,
    required this.layoutAsset,
  });

  final String code;
  final String shortName;
  final String title;
  final String subtitle;
  final String description;
  final String familyLabel; // e.g. "ICF", "LHB"
  final int totalBerths;
  final String thumbnailAsset;
  final String layoutAsset;

  static List<_CoachVariant> get icfAndLhbVariants => const [
        _CoachVariant(
          code: '3A',
          shortName: 'AC 3-Tier',
          title: '3rd AC (ICF coach)',
          subtitle: '6-berth bays with side berths, fully air-conditioned.',
          description:
              '3rd AC ICF coaches have open bays of 6 berths (lower, middle, upper) facing each other on both sides of the aisle, plus 2 side berths (side lower, side upper) along the corridor. All berths are air-conditioned with curtains or partitions for basic privacy.',
          familyLabel: 'ICF',
          totalBerths: 64,
          thumbnailAsset: 'assets/image/3Ac_icf.png',
          layoutAsset: 'assets/image/3Ac_icf.png',
        ),
        _CoachVariant(
          code: '3A',
          shortName: 'AC 3-Tier',
          title: '3rd AC (LHB coach)',
          subtitle: 'Modern LHB 3-tier AC with improved ride quality.',
          description:
              '3rd AC LHB coaches use the newer Linke Hofmann Busch design with better safety, ride comfort and higher speed potential. The internal bay pattern is similar to ICF 3A with 6-berth bays and 2 side berths, but with wider gangways and better suspension.',
          familyLabel: 'LHB',
          totalBerths: 72,
          thumbnailAsset: 'assets/image/3Ac_lhb.png',
          layoutAsset: 'assets/image/3Ac_lhb.png',
        ),
        _CoachVariant(
          code: '2A',
          shortName: 'AC 2-Tier',
          title: '2nd AC (ICF coach)',
          subtitle: '4-berth bays with side lower and side upper.',
          description:
              '2nd AC ICF coaches offer 4-berth bays (lower and upper on each side) plus 2 side berths per bay. Compared to 3rd AC, there are fewer berths and more headroom, giving a more spacious and premium feel.',
          familyLabel: 'ICF',
          totalBerths: 48,
          thumbnailAsset: 'assets/image/2AC_icf.png',
          layoutAsset: 'assets/image/2AC_icf.png',
        ),
        _CoachVariant(
          code: '2A',
          shortName: 'AC 2-Tier',
          title: '2nd AC (LHB coach)',
          subtitle: 'Modern LHB 2-tier AC with more comfort.',
          description:
              '2nd AC LHB coaches are newer-generation coaches with improved safety, ride quality and better designed interiors. They follow the familiar 4-berth + side berth pattern with more comfort than 3rd AC.',
          familyLabel: 'LHB',
          totalBerths: 52,
          thumbnailAsset: 'assets/image/2AC_lhb.png',
          layoutAsset: 'assets/image/2AC_lhb.png',
        ),
        _CoachVariant(
          code: '1A',
          shortName: 'AC First Class',
          title: '1st AC (ICF coach)',
          subtitle: 'Enclosed cabins and coupes with maximum privacy.',
          description:
              '1st AC ICF coaches consist of lockable cabins and coupes with 2 or 4 berths each, offering the highest privacy level in Indian Railways. Berths are more spacious and come with bedding, curtains and dedicated luggage space.',
          familyLabel: 'ICF',
          totalBerths: 22,
          thumbnailAsset: 'assets/image/1AC_icf.png',
          layoutAsset: 'assets/image/1AC_icf.png',
        ),
        _CoachVariant(
          code: '1A',
          shortName: 'AC First Class',
          title: '1st AC (LHB coach)',
          subtitle: 'Premium LHB first class cabins.',
          description:
              '1st AC LHB coaches offer premium cabins and coupes in the newer LHB shell, combining privacy with better suspension, higher speed capability and improved safety compared to ICF stock.',
          familyLabel: 'LHB',
          totalBerths: 24,
          thumbnailAsset: 'assets/image/1Ac_lhb.png',
          layoutAsset: 'assets/image/1Ac_lhb.png',
        ),
        _CoachVariant(
          code: 'SL',
          shortName: 'Sleeper Class',
          title: 'Sleeper (ICF coach)',
          subtitle: 'Non-AC 3-tier sleeper with open bays.',
          description:
              'Sleeper ICF coaches are the most common non-air-conditioned coaches with open 3-tier bays and side berths. Windows are grilled with shutters, and ventilation is through fans and open windows.',
          familyLabel: 'ICF',
          totalBerths: 72,
          thumbnailAsset: 'assets/image/SL_icf.png',
          layoutAsset: 'assets/image/SL_icf.png',
        ),
        _CoachVariant(
          code: 'SL',
          shortName: 'Sleeper Class',
          title: 'Sleeper (LHB coach)',
          subtitle: 'LHB sleeper with better ride and safety.',
          description:
              'Sleeper LHB coaches use the new LHB design while retaining the popular 3-tier sleeper layout. They offer better ride comfort, improved safety features and higher permissible speeds.',
          familyLabel: 'LHB',
          totalBerths: 80,
          thumbnailAsset: 'assets/image/sl_lhb.png',
          layoutAsset: 'assets/image/sl_lhb.png',
        ),
      ];
}
