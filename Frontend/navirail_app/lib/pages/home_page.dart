import 'package:flutter/material.dart';

import '../ui/design_system.dart';
import 'find_my_train_page.dart';
import 'package:navirail_app/pages/ar_navigation_page.dart';
import 'package:navirail_app/pages/train_coach_layout_page.dart';
import 'package:navirail_app/pages/food_shops_page.dart';
import 'package:navirail_app/pages/tickets_page.dart';
import 'package:navirail_app/pages/chatbot_page.dart';
import 'package:navirail_app/pages/help_desk_page.dart';
import 'package:navirail_app/pages/three_d_station_map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: AppColors.neutralLightGrey.withOpacity(0.12),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Open chatbot screen or overlay
          },
          backgroundColor: AppColors.primaryDeepBlue,
          child: const Icon(Icons.forum_outlined, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _TopHeader(),
                SizedBox(height: 18),
                _WeatherSection(),
                SizedBox(height: 22),
                _LiveTrainSection(),
                SizedBox(height: 26),
                _ArVrBanner(),
                SizedBox(height: 26),
                _QuickActionsSection(),
                SizedBox(height: 18),
                _EmergencyBanner(),
                SizedBox(height: 24),
                _ServicesSection(),
                SizedBox(height: 24),
                _FeedbackSection(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _BottomNav(
          currentIndex: _navIndex,
          onChanged: (index) {
            if (index == 1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const FindMyTrainPage()),
              );
              return;
            }
            setState(() => _navIndex = index);
          },
        ),
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        color: AppColors.neutralWhite,
        border: Border.all(color: AppColors.error.withOpacity(0.25)),
        boxShadow: AppShadows.low,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Assistance',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Please press the button in case of emergency.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.neutralDarkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.success, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Emergency Alert Sent',
                          style: AppTextStyles.h5,
                        ),
                      ],
                    ),
                    content: Text(
                      'Your location and details have been shared with the nearest railway police station. Please stay safe and wait for assistance.',
                      style: AppTextStyles.body,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(
              'EMERGENCY',
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onChanged});
  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: selected
                  ? AppColors.primaryDeepBlue
                  : AppColors.neutralDarkGrey,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            );
          }),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
            final selected = states.contains(MaterialState.selected);
            return IconThemeData(
              color: selected
                  ? AppColors.primaryDeepBlue
                  : AppColors.neutralDarkGrey,
            );
          }),
        ),
        child: NavigationBar(
          height: 64,
          backgroundColor: Colors.transparent,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: currentIndex,
          onDestinationSelected: onChanged,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.train_outlined),
              label: 'Trains',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.cardBorder.withOpacity(0.9)),
        boxShadow: AppShadows.low,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryDeepBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.train_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neutralGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Guest User',
                      style: AppTextStyles.h4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Avadi Railway Station',
            style: AppTextStyles.h3,
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

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
          hintText: 'Search trains, facilities or directions',
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
  const _SectionTitle(this.title, {Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.h4.copyWith(
        color: AppColors.primaryDeepBlue,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, Key? key}) : super(key: key);
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

class _WeatherSection extends StatelessWidget {
  const _WeatherSection();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today in Avadi', style: AppTextStyles.bodyLg),
              const SizedBox(height: 4),
              Text('Mist', style: AppTextStyles.body),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('27°C', style: AppTextStyles.h3),
              const SizedBox(height: 4),
              Text('Humidity 80%', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveTrainSection extends StatelessWidget {
  const _LiveTrainSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SectionTitle('Live Train Status'),
        SizedBox(height: 12),
        _LiveTrainCard(),
      ],
    );
  }
}

class _LiveTrainCard extends StatelessWidget {
  const _LiveTrainCard();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.directions_railway_filled,
                  color: AppColors.primaryDeepBlue),
              const SizedBox(width: 8),
              Text(
                'Live Trains at Avadi',
                style: AppTextStyles.h5,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryDeepBlue.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time,
                    size: 18, color: AppColors.primaryDeepBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Next arriving: 12610 Chennai Express • PF-2 • 10:40',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _trainRow('12610 Chennai Express', 'Arriving 10:40', '2'),
          const SizedBox(height: 8),
          _trainRow('56002 Local Passenger', 'Departing 11:05', '3'),
        ],
      ),
    );
  }

  Widget _trainRow(String name, String time, String platform) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.bodyLg),
              const SizedBox(height: 2),
              Text('Platform $platform • $time', style: AppTextStyles.caption),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'On Time',
            style: AppTextStyles.caption.copyWith(color: AppColors.success),
          ),
        ),
      ],
    );
  }
}

class _ArVrBanner extends StatelessWidget {
  const _ArVrBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: AppShadows.low,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: SizedBox(
          height: 150,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/image/AR.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'AR Navigation',
                    style: AppTextStyles.h4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const ArNavigationPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Let's Go",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryDeepBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickActionItem('3D Map', Icons.public_outlined),
      _QuickActionItem('AR Navigation', Icons.camera_outlined),
      _QuickActionItem('Train Coach Layout', Icons.train_outlined),
      _QuickActionItem('Food & Shops', Icons.restaurant_outlined),
      _QuickActionItem('Tickets', Icons.confirmation_num_outlined),
      _QuickActionItem('Find My Train', Icons.train_outlined),
      _QuickActionItem('Chatbot', Icons.forum_outlined),
      _QuickActionItem('Help Desk', Icons.support_agent_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Quick Actions'),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final it = items[index];
              return _QuickActionCard(item: it);
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionItem {
  _QuickActionItem(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.item});
  final _QuickActionItem item;

  void _handleTap(BuildContext context) {
    if (item.label == '3D Map') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ThreeDStationMapPage(),
        ),
      );
    } else if (item.label == 'Train Coach Layout') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TrainCoachLayoutPage()),
      );
    } else if (item.label == 'AR Navigation') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ArNavigationPage()),
      );
    } else if (item.label == 'Find My Train') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FindMyTrainPage()),
      );
    } else if (item.label == 'Tickets') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TicketsMainPage()),
      );
    } else if (item.label == 'Food & Shops') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FoodShopsPage()),
      );
    } else if (item.label == 'Chatbot') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatbotPage()),
      );
    } else if (item.label == 'Help Desk') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HelpDeskPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        width: 140,
        height: 140, // Fixed height to ensure consistency
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: AppShadows.low,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 90, // Fixed height for the icon container
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.r16),
                ),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryDeepBlue.withOpacity(0.8),
                    AppColors.primaryDeepBlue.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  item.icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                item.label,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesSection extends StatelessWidget {
  const _ServicesSection();

  @override
  Widget build(BuildContext context) {
    final services = [
      _ServiceItemData('Accessibility', Icons.accessible),
      _ServiceItemData('Ticket Counters', Icons.confirmation_num_outlined),
      _ServiceItemData('Vending Machine', Icons.local_mall_outlined),
      _ServiceItemData('Railway Police', Icons.local_police_outlined),
      _ServiceItemData('Waiting Hall', Icons.chair_alt_outlined),
      _ServiceItemData('Station Master Room', Icons.account_balance_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Services'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.8,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) => _ServiceTile(data: services[index]),
        ),
      ],
    );
  }
}

class _ServiceItemData {
  _ServiceItemData(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.data});
  final _ServiceItemData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryDeepBlue.withOpacity(0.18)),
        boxShadow: AppShadows.low,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primaryDeepBlue,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              data.icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              data.label,
              style: AppTextStyles.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  const _FeedbackSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: AppShadows.low,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: SizedBox(
          height: 150,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/image/feedback.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 16,
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Feedback',
                        style: AppTextStyles.h4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "We'd love to hear your experience with NaviRail.",
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white.withOpacity(0.98),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to feedback form page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Let's Go",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryDeepBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
