import 'package:flutter/material.dart';
import '../ui/design_system.dart';
import 'home_page.dart';

class StationSelectorPage extends StatefulWidget {
  const StationSelectorPage({super.key});

  @override
  State<StationSelectorPage> createState() => _StationSelectorPageState();
}

class _StationSelectorPageState extends State<StationSelectorPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final List<_Station> _allStations = const [
    // Chennai core & suburban
    _Station(code: 'MAS', name: 'Chennai Central'),
    _Station(code: 'MS', name: 'Chennai Egmore'),
    _Station(code: 'PRES', name: 'Perambur'),
    _Station(code: 'AVD', name: 'Avadi'),
    _Station(code: 'TRL', name: 'Tiruvallur'),
    _Station(code: 'TMLP', name: 'Tirumullaivoyal'),
    _Station(code: 'PON', name: 'Ponneri'),
    _Station(code: 'TBM', name: 'Tambaram'),
    _Station(code: 'CGL', name: 'Chengalpattu Junction'),

    // Major Indian junctions
    _Station(code: 'SBC', name: 'KSR Bengaluru'),
    _Station(code: 'BNC', name: 'Bangalore Cantt'),
    _Station(code: 'MDU', name: 'Madurai Junction'),
    _Station(code: 'CBE', name: 'Coimbatore Junction'),
    _Station(code: 'NDLS', name: 'New Delhi'),
    _Station(code: 'BCT', name: 'Mumbai Central'),
    _Station(code: 'HWH', name: 'Howrah Junction'),
    _Station(code: 'SC', name: 'Secunderabad Junction'),
    _Station(code: 'SBCY', name: 'Varanasi City'),
  ];

  String _codeQuery = '';
  String _nameQuery = '';

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allStations.where((s) {
      final cq = _codeQuery.trim().toLowerCase();
      final nq = _nameQuery.trim().toLowerCase();

      final matchesCode = cq.isEmpty || s.code.toLowerCase().contains(cq);
      final matchesName = nq.isEmpty || s.name.toLowerCase().contains(nq);

      // Match if either code OR name filter matches (both empty means show all)
      return matchesCode && matchesName;
    }).toList();

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Select Station',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.cardBorder.withOpacity(0.9)),
                    boxShadow: AppShadows.low,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          'Station code',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutralGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _codeController,
                        onChanged: (v) => setState(() => _codeQuery = v),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Station code (e.g., AVD)',
                          prefixIcon: Icon(Icons.tag),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(color: AppColors.cardBorder.withOpacity(0.6)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Text(
                          'or',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutralGrey,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: AppColors.cardBorder.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.cardBorder.withOpacity(0.9)),
                    boxShadow: AppShadows.low,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          'Station name',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutralGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          controller: _nameController,
                          onChanged: (v) => setState(() => _nameQuery = v),
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: 'Station name (e.g., Avadi)',
                            prefixIcon: Icon(Icons.train),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular stations',
                      style: AppTextStyles.h4,
                    ),
                    Text(
                      'Near Chennai',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _ChipStation(code: 'AVD', name: 'Avadi'),
                      SizedBox(width: 8),
                      _ChipStation(code: 'MAS', name: 'Chennai Central'),
                      SizedBox(width: 8),
                      _ChipStation(code: 'TBM', name: 'Tambaram'),
                      SizedBox(width: 8),
                      _ChipStation(code: 'CGL', name: 'Chengalpattu'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'All stations',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No stations match your search',
                            style: AppTextStyles.body.copyWith(color: AppColors.neutralGrey),
                          ),
                        )
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            final s = filtered[index];
                            return _StationTile(station: s);
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

class _StationTile extends StatelessWidget {
  const _StationTile({required this.station});
  final _Station station;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.low,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.brandLightBlue.withOpacity(0.15),
          child: Text(
            station.code,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 11,
              color: AppColors.primaryDeepBlue,
            ),
          ),
        ),
        title: Text(
          station.name,
          style: AppTextStyles.h5,
        ),
        subtitle: Text(
          'Code: ${station.code}',
          style: AppTextStyles.caption,
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        },
      ),
    );
  }
}

class _ChipStation extends StatelessWidget {
  const _ChipStation({required this.code, required this.name});
  final String code;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: AppColors.neutralWhite,
      side: BorderSide(color: AppColors.cardBorder),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            code,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 6),
          Text(name),
        ],
      ),
      onPressed: () {
        // This chip is a quick filter into the code field
        final state = context.findAncestorStateOfType<_StationSelectorPageState>();
        if (state != null) {
          state.setState(() {
            state._codeQuery = code;
            state._codeController.text = code;
          });
        }
      },
    );
  }
}

class _Station {
  const _Station({required this.code, required this.name});
  final String code;
  final String name;
}
