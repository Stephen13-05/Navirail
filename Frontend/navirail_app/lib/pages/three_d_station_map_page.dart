import 'package:flutter/material.dart';

import '../ui/design_system.dart';

class ThreeDStationMapPage extends StatefulWidget {
  const ThreeDStationMapPage({super.key});

  @override
  State<ThreeDStationMapPage> createState() => _ThreeDStationMapPageState();
}

class _ThreeDStationMapPageState extends State<ThreeDStationMapPage> {
  final Map<String, bool> _filters = {
    'Escalators': true,
    'Ticket Counters': true,
    'Police': true,
    'Restrooms': true,
    'Stairs': true,
  };

  late final List<_Facility> _allFacilities;
  _Facility? _selected;

  @override
  void initState() {
    super.initState();
    _allFacilities = [
      const _Facility(
        name: 'Main Ticket Counter',
        type: 'Ticket Counters',
        platform: 'Concourse',
        icon: Icons.confirmation_num_outlined,
      ),
      const _Facility(
        name: 'Platform 1 Police Help Desk',
        type: 'Police',
        platform: 'Platform 1',
        icon: Icons.local_police_outlined,
      ),
      const _Facility(
        name: 'Central Restrooms',
        type: 'Restrooms',
        platform: 'Between PF 2 & 3',
        icon: Icons.wc,
      ),
      const _Facility(
        name: 'Escalator to PF 2',
        type: 'Escalators',
        platform: 'Platform 2',
        icon: Icons.escalator,
      ),
      const _Facility(
        name: 'Stairs to PF 3',
        type: 'Stairs',
        platform: 'Platform 3',
        icon: Icons.stairs_outlined,
      ),
    ];
    _selected = _allFacilities.first;
  }

  @override
  Widget build(BuildContext context) {
    final visible = _allFacilities
        .where((f) => _filters[f.type] ?? false)
        .toList(growable: false);

    return AppGradientBackground(
      child: Scaffold
(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.primaryDeepBlue,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '3D Station Map',
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: _MapWithControls(
                    onFacilityTap: _onFacilityTap,
                    filters: _filters,
                  ),
                ),
              ),
              _BottomDrawer(
                filters: _filters,
                facilities: visible,
                selected: _selected,
                onFilterChanged: (label, value) {
                  setState(() {
                    _filters[label] = value;
                  });
                },
                onFacilityTap: _onFacilityTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFacilityTap(_Facility facility) {
    setState(() {
      _selected = facility;
    });
  }
}

class _MapWithControls extends StatelessWidget {
  const _MapWithControls({
    required this.onFacilityTap,
    required this.filters,
  });

  final ValueChanged<_Facility> onFacilityTap;
  final Map<String, bool> filters;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.medium,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/image/3dmap.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Ticket counter 🎫
            if (filters['Ticket Counters'] ?? false)
              Positioned(
                left: 32,
                top: 40,
                child: _MapMarker(
                  icon: Icons.confirmation_num_outlined,
                  label: 'Tickets',
                  color: AppColors.primaryDeepBlue,
                  onTap: () => onFacilityTap(
                    const _Facility(
                      name: 'Main Ticket Counter',
                      type: 'Ticket Counters',
                      platform: 'Concourse',
                      icon: Icons.confirmation_num_outlined,
                    ),
                  ),
                ),
              ),
            // Police station 🛡️
            if (filters['Police'] ?? false)
              Positioned(
                right: 36,
                top: 68,
                child: _MapMarker(
                  icon: Icons.local_police_outlined,
                  label: 'Police',
                  color: AppColors.secondaryRailwayGreen,
                  onTap: () => onFacilityTap(
                    const _Facility(
                      name: 'Platform 1 Police Help Desk',
                      type: 'Police',
                      platform: 'Platform 1',
                      icon: Icons.local_police_outlined,
                    ),
                  ),
                ),
              ),
            // Escalators ⬆️
            if (filters['Escalators'] ?? false)
              Positioned(
                right: 60,
                bottom: 72,
                child: _MapMarker(
                  icon: Icons.escalator,
                  label: 'Escalator',
                  color: AppColors.brandLightBlue,
                  onTap: () => onFacilityTap(
                    const _Facility(
                      name: 'Escalator to PF 2',
                      type: 'Escalators',
                      platform: 'Platform 2',
                      icon: Icons.escalator,
                    ),
                  ),
                ),
              ),
            // Stairs 🪜
            if (filters['Stairs'] ?? false)
              Positioned(
                left: 40,
                bottom: 60,
                child: _MapMarker(
                  icon: Icons.stairs_outlined,
                  label: 'Stairs',
                  color: AppColors.primaryDeepBlue,
                  onTap: () => onFacilityTap(
                    const _Facility(
                      name: 'Stairs to PF 3',
                      type: 'Stairs',
                      platform: 'Platform 3',
                      icon: Icons.stairs_outlined,
                    ),
                  ),
                ),
              ),
            // Restrooms 🚻
            if (filters['Restrooms'] ?? false)
              Positioned(
                right: 26,
                bottom: 32,
                child: _MapMarker(
                  icon: Icons.wc,
                  label: 'Restrooms',
                  color: AppColors.accentSafetyYellow,
                  onTap: () => onFacilityTap(
                    const _Facility(
                      name: 'Central Restrooms',
                      type: 'Restrooms',
                      platform: 'Between PF 2 & 3',
                      icon: Icons.wc,
                    ),
                  ),
                ),
              ),
            // Floating controls (Rotate / Zoom / Reset)
            Positioned(
              top: 12,
              right: 12,
              child: Column(
                children: const [
                  _MapControlButton(
                    icon: Icons.threed_rotation_outlined,
                    label: 'Rotate',
                  ),
                  SizedBox(height: 8),
                  _MapControlButton(
                    icon: Icons.zoom_in,
                    label: 'Zoom',
                  ),
                  SizedBox(height: 8),
                  _MapControlButton(
                    icon: Icons.refresh,
                    label: 'Reset',
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

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppShadows.medium,
              border: Border.all(color: color, width: 1.4),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 22,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              boxShadow: AppShadows.low,
            ),
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.medium,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.primaryDeepBlue,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDeepBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomDrawer extends StatelessWidget {
  const _BottomDrawer({
    required this.filters,
    required this.facilities,
    required this.selected,
    required this.onFilterChanged,
    required this.onFacilityTap,
  });

  final Map<String, bool> filters;
  final List<_Facility> facilities;
  final _Facility? selected;
  final void Function(String label, bool value) onFilterChanged;
  final ValueChanged<_Facility> onFacilityTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.r20),
        ),
        boxShadow: AppShadows.high,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralLightGrey,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Facilities',
              style: AppTextStyles.h5.copyWith(
                color: AppColors.primaryDeepBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            _FilterRow(
              filters: filters,
              onChanged: onFilterChanged,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: facilities.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final f = facilities[index];
                  final isSelected = selected != null && selected!.name == f.name;
                  return _FacilityCard(
                    facility: f,
                    isSelected: isSelected,
                    onTap: () => onFacilityTap(f),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            if (selected != null)
              _FacilityDetailCard(
                facility: selected!,
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filters,
    required this.onChanged,
  });

  final Map<String, bool> filters;
  final void Function(String label, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    final entries = filters.entries.toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final e in entries) ...[
            _FilterChip(
              label: e.key,
              selected: e.value,
              onTap: () => onChanged(e.key, !e.value),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppColors.primaryDeepBlue
        : AppColors.neutralLightGrey;
    final fg = selected ? Colors.white : AppColors.neutralDarkGrey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected ? AppShadows.low : [],
          border: Border.all(
            color: selected
                ? AppColors.primaryDeepBlue
                : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconForFilter(label),
              size: 16,
              color: fg,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForFilter(String label) {
    switch (label) {
      case 'Escalators':
        return Icons.escalator;
      case 'Ticket Counters':
        return Icons.confirmation_num_outlined;
      case 'Police':
        return Icons.local_police_outlined;
      case 'Restrooms':
        return Icons.wc;
      case 'Stairs':
        return Icons.stairs_outlined;
      default:
        return Icons.place_outlined;
    }
  }
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({
    required this.facility,
    required this.isSelected,
    required this.onTap,
  });

  final _Facility facility;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryDeepBlue
                : AppColors.cardBorder,
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow: isSelected ? AppShadows.medium : AppShadows.low,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDeepBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    facility.icon,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    facility.name,
                    style: AppTextStyles.bodyLg,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              facility.type,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 2),
            Text(
              facility.platform,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryDeepBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FacilityDetailCard extends StatelessWidget {
  const _FacilityDetailCard({required this.facility});

  final _Facility facility;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.low,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryDeepBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  facility.icon,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      style: AppTextStyles.h6,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      facility.platform,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryDeepBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDeepBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    'Navigate',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryDeepBlue),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    'Report Issue',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primaryDeepBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.secondaryRailwayGreen),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    'Accessibility Info',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.secondaryRailwayGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Facility {
  const _Facility({
    required this.name,
    required this.type,
    required this.platform,
    required this.icon,
  });

  final String name;
  final String type;
  final String platform;
  final IconData icon;
}
