import 'package:flutter/material.dart';
import '../ui/design_system.dart';
import 'home_page.dart';

enum TrainStatus { onTime, minorDelay, majorDelay, cancelled }

class TrainItem {
  TrainItem({
    required this.number,
    required this.name,
    required this.fromCode,
    required this.toCode,
    required this.dep,
    required this.arr,
    this.expDep,
    this.expArr,
    required this.status,
    this.platform,
  });

  final String number;
  final String name;
  final String fromCode;
  final String toCode;
  final DateTime dep;
  final DateTime arr;
  final DateTime? expDep;
  final DateTime? expArr;
  final TrainStatus status;
  final String? platform;
}

class FindMyTrainPage extends StatefulWidget {
  const FindMyTrainPage({super.key});

  @override
  State<FindMyTrainPage> createState() => _FindMyTrainPageState();
}

class _FindMyTrainPageState extends State<FindMyTrainPage> {
  final _search = TextEditingController();
  final _focus = FocusNode();
  bool _loading = false;
  bool _platformPulse = false;
  List<String> _recents = [
    '12028 Shatabdi',
    '16516 SBC → CAN',
    '12627 KSR → MAS',
  ];
  List<TrainItem> _results = [];

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onVoice() {}

  void _onSearchChanged(String q) async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    final data = _sampleData();
    final lower = q.trim().toLowerCase();
    List<TrainItem> filtered;
    if (lower.contains('→') || lower.contains('->')) {
      final parts = lower.replaceAll('->', '→').split('→');
      final from = parts.first.trim();
      final to = parts.length > 1 ? parts[1].trim() : '';
      filtered = data.where((t) => t.fromCode.toLowerCase().contains(from) && t.toCode.toLowerCase().contains(to)).toList();
    } else {
      filtered = data.where((t) =>
          t.number.toLowerCase().contains(lower) ||
          t.name.toLowerCase().contains(lower)).toList();
    }
    setState(() {
      _results = filtered;
      _loading = false;
    });
  }

  List<TrainItem> _sampleData() {
    final now = DateTime.now();
    return [
      TrainItem(
        number: '12028',
        name: 'Shatabdi Express',
        fromCode: 'SBC',
        toCode: 'MAS',
        dep: DateTime(now.year, now.month, now.day, 11, 30),
        arr: DateTime(now.year, now.month, now.day, 16, 55),
        expDep: null,
        expArr: null,
        status: TrainStatus.onTime,
        platform: '5',
      ),
      TrainItem(
        number: '16516',
        name: 'Karwar Express',
        fromCode: 'CAN',
        toCode: 'SBC',
        dep: DateTime(now.year, now.month, now.day, 13, 10),
        arr: DateTime(now.year, now.month, now.day, 20, 40),
        expDep: DateTime(now.year, now.month, now.day, 13, 20),
        expArr: DateTime(now.year, now.month, now.day, 20, 55),
        status: TrainStatus.minorDelay,
        platform: '3',
      ),
      TrainItem(
        number: '22691',
        name: 'Rajdhani',
        fromCode: 'SBC',
        toCode: 'NDLS',
        dep: DateTime(now.year, now.month, now.day, 20, 0),
        arr: DateTime(now.year, now.month, now.day + 1, 11, 0),
        expDep: DateTime(now.year, now.month, now.day, 21, 30),
        expArr: null,
        status: TrainStatus.majorDelay,
        platform: '1',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      appBar: AppBar(
        title: Text('KSR Bengaluru', style: AppTextStyles.h5),
        centerTitle: false,
        actions: [
          _LangMenu(),
          const SizedBox(width: 8),
          _VoiceIcon(onTap: _onVoice),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _SearchField(
                controller: _search,
                focusNode: _focus,
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.neutralWhite,
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
              final selected = states.contains(MaterialState.selected);
              return AppTextStyles.caption.copyWith(
                color: selected ? AppColors.primaryDeepBlue : AppColors.neutralDarkGrey,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              );
            }),
            iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
              final selected = states.contains(MaterialState.selected);
              return IconThemeData(color: selected ? AppColors.primaryDeepBlue : AppColors.neutralDarkGrey);
            }),
          ),
          child: NavigationBar(
            height: 64,
            backgroundColor: Colors.transparent,
            elevation: 0,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: 2,
            onDestinationSelected: (i) {
              if (i == 0) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              }
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
              NavigationDestination(icon: Icon(Icons.train_outlined), label: 'Find My Train'),
              NavigationDestination(icon: Icon(Icons.forum_outlined), label: 'Chatbot'),
              NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) return _SkeletonList();
    if (_search.text.trim().isEmpty) return _EmptyState(recents: _recents, onTapRecent: _onSearchChanged);
    if (_results.isEmpty) return _NoResults(query: _search.text, onTry: _onSearchChanged);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final t = _results[i];
        return _ResultCard(
          item: t,
          platformPulse: _platformPulse,
          onOpen: () async {
            setState(() => _platformPulse = false);
            final changed = await _openDetails(t);
            if (changed == true) {
              setState(() => _platformPulse = true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Platform changed for selected train'),
                  backgroundColor: AppColors.accentSafetyYellow,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              await Future.delayed(const Duration(milliseconds: 800));
              if (mounted) setState(() => _platformPulse = false);
            }
          },
        );
      },
    );
  }

  Future<bool?> _openDetails(TrainItem t) async {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _DetailsSheet(item: t);
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.focusNode, required this.onChanged});
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.low,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Train no., name, or SBC → MAS',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _LangMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'EN', child: Text('English')),
        PopupMenuItem(value: 'HI', child: Text('हिंदी')),
        PopupMenuItem(value: 'TA', child: Text('தமிழ்')),
      ],
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Icon(Icons.language, color: AppColors.primaryDeepBlue),
      ),
    );
  }
}

class _VoiceIcon extends StatelessWidget {
  const _VoiceIcon({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.mic, color: Colors.white),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.recents, required this.onTapRecent});
  final List<String> recents;
  final ValueChanged<String> onTapRecent;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        Center(child: Text('Search for trains or routes', style: AppTextStyles.bodyLg)),
        const SizedBox(height: 16),
        Text('Recent searches', style: AppTextStyles.h6),
        const SizedBox(height: 8),
        ...recents.map((r) => ListTile(
              title: Text(r, style: AppTextStyles.body),
              leading: const Icon(Icons.history),
              onTap: () => onTapRecent(r),
            )),
      ],
    );
  }
}

class _SkeletonList extends StatefulWidget {
  @override
  State<_SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<_SkeletonList> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _a = Tween(begin: .6, end: .3).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        return FadeTransition(
          opacity: _a,
          child: Container(
            height: 92,
            decoration: BoxDecoration(
              color: AppColors.neutralLightGrey,
              borderRadius: BorderRadius.circular(AppRadius.r16),
              border: Border.all(color: AppColors.cardBorder),
            ),
          ),
        );
      },
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query, required this.onTry});
  final String query;
  final ValueChanged<String> onTry;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        Text('No results for "$query"', style: AppTextStyles.h5),
        const SizedBox(height: 8),
        Text('Try a train number, name, or a route like SBC → MAS', style: AppTextStyles.body),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.item, required this.onOpen, required this.platformPulse});
  final TrainItem item;
  final VoidCallback onOpen;
  final bool platformPulse;

  Color _statusColor() {
    switch (item.status) {
      case TrainStatus.onTime:
        return AppColors.success;
      case TrainStatus.minorDelay:
        return AppColors.warning;
      case TrainStatus.majorDelay:
        return AppColors.error;
      case TrainStatus.cancelled:
        return AppColors.error;
    }
  }

  String _statusText() {
    switch (item.status) {
      case TrainStatus.onTime:
        return 'On Time';
      case TrainStatus.minorDelay:
        return 'Minor Delay';
      case TrainStatus.majorDelay:
        return 'Major Delay';
      case TrainStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _t(DateTime d) {
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(AppRadius.r16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: AppShadows.low,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('${item.number}  ${item.name}', style: AppTextStyles.h5),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_statusText(), style: AppTextStyles.caption.copyWith(color: color)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: Text('${item.fromCode}  ${_t(item.dep)}', style: AppTextStyles.bodyLg)),
                const Icon(Icons.arrow_forward_rounded, size: 18),
                Expanded(child: Text('${item.toCode}  ${_t(item.arr)}', textAlign: TextAlign.end, style: AppTextStyles.bodyLg)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (item.platform != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: platformPulse ? AppColors.accentSafetyYellow.withOpacity(0.2) : AppColors.neutralLightGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('PF ${item.platform}', style: AppTextStyles.caption.copyWith(color: AppColors.neutralDarkGrey)),
                  ),
                const Spacer(),
                TextButton.icon(onPressed: () {}, icon: const Icon(Icons.directions_walk), label: const Text('Navigate')),
                const SizedBox(width: 4),
                IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _DetailsSheet extends StatelessWidget {
  const _DetailsSheet({required this.item});
  final TrainItem item;

  Color _statusColor(TrainStatus s) {
    switch (s) {
      case TrainStatus.onTime:
        return AppColors.success;
      case TrainStatus.minorDelay:
        return AppColors.warning;
      case TrainStatus.majorDelay:
      case TrainStatus.cancelled:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, controller) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.neutralWhite,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: AppShadows.high,
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.neutralLightGrey,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 12),
                      Icon(Icons.place, color: AppColors.primaryDeepBlue),
                      SizedBox(width: 8),
                      Expanded(child: Text('Mini Map Preview')),
                      SizedBox(width: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('${item.number}  ${item.name}', style: AppTextStyles.h4)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: _statusColor(item.status).withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              item.status == TrainStatus.onTime
                                  ? 'On Time'
                                  : item.status == TrainStatus.minorDelay
                                      ? 'Minor Delay'
                                      : item.status == TrainStatus.majorDelay
                                          ? 'Major Delay'
                                          : 'Cancelled',
                              style: AppTextStyles.caption.copyWith(color: _statusColor(item.status)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.schedule),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Full timetable and stops')),
                          TextButton(onPressed: () {}, child: const Text('View')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.account_tree_outlined),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Coach layout: A1 B1 S1 S2 S3...')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.directions_walk),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Walking time to platform: 6–8 min')),
                          if (item.platform != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: AppColors.neutralLightGrey, borderRadius: BorderRadius.circular(20)),
                              child: Text('PF ${item.platform}', style: AppTextStyles.caption),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.accessible_forward),
                          SizedBox(width: 8),
                          Expanded(child: Text('Accessibility route options available')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.confirmation_num_outlined),
                          SizedBox(width: 8),
                          Expanded(child: Text('Ticket quick-link')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
                          ),
                          child: const Text('Launch AR Navigation'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
