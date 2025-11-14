import 'package:flutter/material.dart';
import '../ui/design_system.dart';
import 'find_my_train_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool liveMode = true;
  int navIndex = 0;
  String lang = 'EN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      appBar: AppBar(
        title: Text('NaviRail', style: AppTextStyles.h5),
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _AppDrawer(
        currentLang: lang,
        onChangeLang: (v) => setState(() => lang = v),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                liveMode: liveMode,
                stationText: liveMode ? 'KSR Bengaluru' : 'Virtual Mode',
                lang: lang,
                onToggleMode: (v) => setState(() => liveMode = v),
                onChangeLang: (v) => setState(() => lang = v),
              ),
              const SizedBox(height: 16),
              _SearchBar(),
              const SizedBox(height: 20),
              _SectionTitle(title: 'Quick Actions'),
              const SizedBox(height: 12),
              _FeatureGrid(),
              const SizedBox(height: 20),
              _SectionTitle(title: 'Live Now'),
              const SizedBox(height: 12),
              _RealtimeWidgets(liveMode: liveMode),
              const SizedBox(height: 24),
            ],
          ),
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
            selectedIndex: navIndex,
            onDestinationSelected: (i) {
              if (i == 2) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const FindMyTrainPage()),
                );
                return;
              }
              setState(() => navIndex = i);
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
              NavigationDestination(icon: Icon(Icons.train_outlined), label: 'Train Info'),
              NavigationDestination(icon: Icon(Icons.forum_outlined), label: 'Chatbot'),
              NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.liveMode,
    required this.stationText,
    required this.lang,
    required this.onToggleMode,
    required this.onChangeLang,
  });

  final bool liveMode;
  final String stationText;
  final String lang;
  final ValueChanged<bool> onToggleMode;
  final ValueChanged<String> onChangeLang;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
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
                    Icon(Icons.location_on_rounded, color: AppColors.primaryDeepBlue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        stationText,
                        style: AppTextStyles.h3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _ModeToggle(
                  liveMode: liveMode,
                  onChanged: onToggleMode,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          children: [
            _LangButton(current: lang, onSelected: onChangeLang),
            const SizedBox(height: 12),
            _VoiceButton(onPressed: () {}),
          ],
        )
      ],
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.liveMode, required this.onChanged});
  final bool liveMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.neutralLightGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              selected: liveMode,
              label: 'Live Mode',
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _Segment(
              selected: !liveMode,
              label: 'Virtual Mode',
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.selected, required this.label, required this.onTap});
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.h6.copyWith(
            color: selected ? Colors.white : AppColors.neutralDarkGrey,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  const _LangButton({required this.current, required this.onSelected});
  final String current;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.low,
      ),
      child: PopupMenuButton<String>(
        initialValue: current,
        onSelected: onSelected,
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'EN', child: Text('English')),
          PopupMenuItem(value: 'HI', child: Text('हिंदी')),
          PopupMenuItem(value: 'TA', child: Text('தமிழ்')),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.language, color: AppColors.primaryDeepBlue),
              const SizedBox(width: 8),
              Text(current, style: AppTextStyles.h6),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.neutralGrey),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoiceButton extends StatelessWidget {
  const _VoiceButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.mic, color: Colors.white),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.low,
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search facilities, trains, or directions…',
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.h4);
  }
}

class _FeatureGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _FeatureItem(Icons.travel_explore, '3D Station Map', AppColors.primaryDeepBlue),
      _FeatureItem(Icons.navigation_outlined, 'AR Navigation', AppColors.secondaryRailwayGreen),
      _FeatureItem(Icons.train_outlined, 'Find My Train', AppColors.primaryDeepBlue),
      _FeatureItem(Icons.place_outlined, 'Facilities Finder', AppColors.secondaryRailwayGreen),
      _FeatureItem(Icons.confirmation_num_outlined, 'Ticket & ATM Status', AppColors.primaryDeepBlue),
      _FeatureItem(Icons.chat_bubble_outline, 'Multilingual Chatbot', AppColors.secondaryRailwayGreen),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final it = items[i];
        return _FeatureCard(icon: it.icon, label: it.label, color: it.color);
      },
    );
  }
}

class _FeatureItem {
  _FeatureItem(this.icon, this.label, this.color);
  final IconData icon;
  final String label;
  final Color color;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.medium,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: AppTextStyles.h5,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RealtimeWidgets extends StatelessWidget {
  const _RealtimeWidgets({required this.liveMode});
  final bool liveMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_railway_filled, color: AppColors.primaryDeepBlue),
                  const SizedBox(width: 8),
                  Text('Live Train Status', style: AppTextStyles.h5),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryRailwayGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(liveMode ? 'Live' : 'Virtual', style: AppTextStyles.caption.copyWith(color: AppColors.secondaryRailwayGreen)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _trainRow('12028 Shatabdi', 'On Time', AppColors.success),
              const SizedBox(height: 8),
              _trainRow('16516 Karwar Exp', 'Delayed 10m', AppColors.warning),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Card(
          child: Row(
            children: [
              const Icon(Icons.campaign_outlined, color: AppColors.accentSafetyYellow),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Platform change: Train 16516 now at PF-3. Please follow guidance signs.', style: AppTextStyles.body),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Card(
          child: Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primaryDeepBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _StatusChip(label: 'Ticket Counter: Open', color: AppColors.success),
                    _StatusChip(label: 'ATM: Busy', color: AppColors.warning),
                    _StatusChip(label: 'Info Desk: Open', color: AppColors.success),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.accessible_forward, color: AppColors.primaryDeepBlue),
                  const SizedBox(width: 8),
                  Text('Accessibility', style: AppTextStyles.h5),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  _QuickIcon(icon: Icons.wheelchair_pickup, label: 'Wheelchair'),
                  SizedBox(width: 12),
                  _QuickIcon(icon: Icons.elevator_outlined, label: 'Lift'),
                  SizedBox(width: 12),
                  _QuickIcon(icon: Icons.stairs_outlined, label: 'Ramp'),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _trainRow(String name, String status, Color color) {
    return Row(
      children: [
        Expanded(child: Text(name, style: AppTextStyles.bodyLg)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(status, style: AppTextStyles.caption.copyWith(color: color)),
        )
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: color)),
    );
  }
}

class _QuickIcon extends StatelessWidget {
  const _QuickIcon({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.neutralLightGrey,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryDeepBlue),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.low,
      ),
      child: child,
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.currentLang, required this.onChangeLang});
  final String currentLang;
  final ValueChanged<String> onChangeLang;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primaryDeepBlue),
              accountName: const Text('Guest User'),
              accountEmail: Text('Language: ' + currentLang),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primaryDeepBlue),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () => Navigator.of(context).pop(),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.travel_explore),
              title: const Text('3D Station Map'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.navigation_outlined),
              title: const Text('AR Navigation'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.train_outlined),
              title: const Text('Train Info'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.place_outlined),
              title: const Text('Facilities Finder'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('Chatbot'),
              onTap: () => Navigator.of(context).pop(),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Change Language'),
              subtitle: Text(currentLang),
              onTap: () async {
                final selection = await showDialog<String>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Select Language'),
                    children: [
                      SimpleDialogOption(child: const Text('English'), onPressed: () => Navigator.pop(context, 'EN')),
                      SimpleDialogOption(child: const Text('हिंदी'), onPressed: () => Navigator.pop(context, 'HI')),
                      SimpleDialogOption(child: const Text('தமிழ்'), onPressed: () => Navigator.pop(context, 'TA')),
                    ],
                  ),
                );
                if (selection != null) {
                  onChangeLang(selection);
                }
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
