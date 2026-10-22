import 'package:flutter/material.dart';

import '../ui/design_system.dart';

// Entry page for all ticket-related flows
class TicketsMainPage extends StatelessWidget {
  const TicketsMainPage({super.key});

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
            'Tickets',
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
                Text(
                  'Plan and book your journey with local and long-distance tickets.',
                  style: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.neutralDarkGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Ways to Buy Tickets',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.primaryDeepBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: const [
                    _TicketAppCard(
                      title: 'UTS App',
                      subtitle: 'Local train paperless tickets & season passes',
                      icon: Icons.phone_iphone,
                    ),
                    SizedBox(height: 10),
                    _TicketAppCard(
                      title: 'IRCTC Rail Connect',
                      subtitle: 'Book long-distance train tickets across India',
                      icon: Icons.train_outlined,
                    ),
                    SizedBox(height: 10),
                    _TicketAppCard(
                      title: 'RailOne',
                      subtitle: 'Multi-train booking and travel management',
                      icon: Icons.apps,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Ticket Types',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.primaryDeepBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _TicketTypeCard(
                  title: 'Local Trains',
                  subtitle: 'Metro / suburban tickets and passes',
                  icon: Icons.directions_subway_filled_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LocalTicketsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _TicketTypeCard(
                  title: 'Long-Distance Trains',
                  subtitle: 'IRCTC-style booking for express trains',
                  icon: Icons.train_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LongDistanceSearchPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketAppCard extends StatelessWidget {
  const _TicketAppCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.low,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryDeepBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primaryDeepBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.neutralDarkGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.neutralGrey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.open_in_new, color: AppColors.neutralGrey, size: 20),
        ],
      ),
    );
  }
}

class _TicketTypeCard extends StatelessWidget {
  const _TicketTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

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
        onTap: onTap,
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppColors.primaryDeepBlue.withOpacity(0.12),
                ),
                child: Icon(icon, color: AppColors.primaryDeepBlue),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.neutralDarkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
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

// 2. Local Trains Ticket Page
class LocalTicketsPage extends StatefulWidget {
  const LocalTicketsPage({super.key});

  @override
  State<LocalTicketsPage> createState() => _LocalTicketsPageState();
}

class _LocalTicketsPageState extends State<LocalTicketsPage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  int _adults = 1;
  int _children = 0;
  double? _price;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _calculatePrice() {
    // Simple mock pricing: base 10 + distance factor + passengers
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      setState(() => _price = null);
      return;
    }
    final passengers = _adults + _children * 0.5;
    setState(() {
      _price = 10 + passengers * 15;
    });
  }

  void _showTicket() {
    if (_price == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocalTicketViewPage(
          from: _fromController.text,
          to: _toController.text,
          adults: _adults,
          children: _children,
          price: _price!,
        ),
      ),
    );
  }

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
            'Local Train Ticket',
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
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: AppShadows.low,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Journey Details', style: AppTextStyles.h5),
                      const SizedBox(height: 12),
                      _LabeledField(
                        label: 'From Station',
                        icon: Icons.radio_button_checked,
                        controller: _fromController,
                        hint: 'Enter source station',
                      ),
                      const SizedBox(height: 10),
                      _LabeledField(
                        label: 'To Station',
                        icon: Icons.location_on_outlined,
                        controller: _toController,
                        hint: 'Enter destination station',
                      ),
                      const SizedBox(height: 16),
                      Text('Passengers', style: AppTextStyles.h5),
                      const SizedBox(height: 8),
                      _PassengerStepper(
                        label: 'Adults',
                        count: _adults,
                        onChanged: (v) {
                          setState(() => _adults = v.clamp(0, 6));
                        },
                      ),
                      const SizedBox(height: 8),
                      _PassengerStepper(
                        label: 'Children',
                        count: _children,
                        onChanged: (v) {
                          setState(() => _children = v.clamp(0, 6));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _calculatePrice,
                    icon: const Icon(Icons.currency_rupee),
                    label: Text(
                      'Show Price',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDeepBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                      ),
                    ),
                  ),
                ),
                if (_price != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.neutralWhite,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: AppShadows.low,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long,
                            color: AppColors.primaryDeepBlue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Estimated fare: ${_price!.toStringAsFixed(2)}',
                            style: AppTextStyles.bodyLg,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showTicket,
                      icon: const Icon(Icons.local_activity_outlined),
                      label: Text(
                        'Buy Ticket',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryRailwayGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r16),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.hint,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppColors.neutralWhite,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20),
              hintText: hint,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _PassengerStepper extends StatelessWidget {
  const _PassengerStepper({
    required this.label,
    required this.count,
    required this.onChanged,
  });

  final String label;
  final int count;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body,
          ),
        ),
        IconButton(
          onPressed: () => onChanged(count - 1),
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          '$count',
          style: AppTextStyles.bodyLg,
        ),
        IconButton(
          onPressed: () => onChanged(count + 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class LocalTicketViewPage extends StatelessWidget {
  const LocalTicketViewPage({
    super.key,
    required this.from,
    required this.to,
    required this.adults,
    required this.children,
    required this.price,
  });

  final String from;
  final String to;
  final int adults;
  final int children;
  final double price;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final validTill = now.add(const Duration(hours: 1));

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
            'Local Ticket',
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: AppShadows.medium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Local Ticket',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.primaryDeepBlue,
                          ),
                        ),
                        const Icon(Icons.qr_code_2,
                            size: 40, color: AppColors.primaryDeepBlue),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.trip_origin,
                            size: 18, color: AppColors.primaryDeepBlue),
                        const SizedBox(width: 6),
                        Text('From', style: AppTextStyles.caption),
                        const SizedBox(width: 6),
                        Text(from, style: AppTextStyles.bodyLg),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 18, color: AppColors.primaryDeepBlue),
                        const SizedBox(width: 6),
                        Text('To', style: AppTextStyles.caption),
                        const SizedBox(width: 6),
                        Text(to, style: AppTextStyles.bodyLg),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.people_alt_outlined,
                            size: 18, color: AppColors.primaryDeepBlue),
                        const SizedBox(width: 6),
                        Text(
                          'Passengers:',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$adults Adults, $children Children',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 18, color: AppColors.primaryDeepBlue),
                        const SizedBox(width: 6),
                        Text('Issued', style: AppTextStyles.caption),
                        const SizedBox(width: 6),
                        Text(
                          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} • ${now.day}/${now.month}/${now.year}',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 18, color: AppColors.primaryDeepBlue),
                        const SizedBox(width: 6),
                        Text('Valid till', style: AppTextStyles.caption),
                        const SizedBox(width: 6),
                        Text(
                          '${validTill.hour.toString().padLeft(2, '0')}:${validTill.minute.toString().padLeft(2, '0')} • ${validTill.day}/${validTill.month}/${validTill.year}',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Fare', style: AppTextStyles.bodyLg),
                        Text(
                          '${price.toStringAsFixed(2)}',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.primaryDeepBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Please keep this ticket ready for inspection. Subject to railway rules.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neutralGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 3. Long-Distance Train Booking Pages
class LongDistanceSearchPage extends StatefulWidget {
  const LongDistanceSearchPage({super.key});

  @override
  State<LongDistanceSearchPage> createState() => _LongDistanceSearchPageState();
}

class _LongDistanceSearchPageState extends State<LongDistanceSearchPage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime _date = DateTime.now();
  String _quota = 'General';
  final TextEditingController _trainController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _trainController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _searchTrains() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LongDistanceResultsPage(
          from: _fromController.text,
          to: _toController.text,
          date: _date,
          quota: _quota,
        ),
      ),
    );
  }

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
            'Book Long-Distance',
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
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: AppShadows.low,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Search Trains', style: AppTextStyles.h5),
                      const SizedBox(height: 12),
                      _LabeledField(
                        label: 'From',
                        icon: Icons.trip_origin,
                        controller: _fromController,
                        hint: 'Enter source station',
                      ),
                      const SizedBox(height: 10),
                      _LabeledField(
                        label: 'To',
                        icon: Icons.location_on_outlined,
                        controller: _toController,
                        hint: 'Enter destination station',
                      ),
                      const SizedBox(height: 10),
                      Text('Date', style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.neutralWhite,
                            borderRadius:
                                BorderRadius.circular(AppRadius.r12),
                            border:
                                Border.all(color: AppColors.cardBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${_date.day}/${_date.month}/${_date.year}',
                                style: AppTextStyles.body,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Quota', style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neutralWhite,
                          borderRadius:
                              BorderRadius.circular(AppRadius.r12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _quota,
                            items: const [
                              'General',
                              'Tatkal',
                              'Ladies',
                              'Senior Citizen',
                            ]
                                .map((q) => DropdownMenuItem(
                                      value: q,
                                      child: Text(q),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _quota = v);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _LabeledField(
                        label: 'Train No / Name',
                        icon: Icons.search,
                        controller: _trainController,
                        hint: 'Optional smart search',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _searchTrains,
                    icon: const Icon(Icons.search),
                    label: Text(
                      'Search Trains',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDeepBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                      ),
                    ),
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

class LongDistanceResultsPage extends StatelessWidget {
  const LongDistanceResultsPage({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.quota,
  });

  final String from;
  final String to;
  final DateTime date;
  final String quota;

  @override
  Widget build(BuildContext context) {
    final trains = _mockTrains;

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
            'Trains • $from → $to',
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: trains.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final t = trains[index];
              return _TrainResultCard(train: t, date: date, quota: quota);
            },
          ),
        ),
      ),
    );
  }
}

class _TrainResultCard extends StatelessWidget {
  const _TrainResultCard({
    required this.train,
    required this.date,
    required this.quota,
  });

  final _Train train;
  final DateTime date;
  final String quota;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        side: BorderSide(color: AppColors.cardBorder),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r16),
          color: AppColors.neutralWhite,
          boxShadow: AppShadows.low,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${train.number} • ${train.name}',
              style: AppTextStyles.h5.copyWith(
                color: AppColors.neutralDarkGrey,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
              	Icon(Icons.schedule, size: 16, color: AppColors.neutralGrey),
                const SizedBox(width: 4),
                Text(
                  '${train.departure} → ${train.arrival} • ${train.duration}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.neutralGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: train.days
                  .map((d) => Chip(
                        label: Text(
                          d,
                          style: AppTextStyles.caption,
                        ),
                        backgroundColor:
                            AppColors.neutralLightGrey.withOpacity(0.8),
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: train.classes.map((c) {
                final availability = train.availability[c] ?? 'WL';
                final color = availability.startsWith('AVL')
                    ? AppColors.secondaryRailwayGreen
                    : availability.startsWith('RAC')
                        ? AppColors.accentSafetyYellow
                        : AppColors.error;
                return OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PassengerEntryPage(
                          train: train,
                          travelDate: date,
                          quota: quota,
                          travelClass: c,
                          availability: availability,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color.withOpacity(0.7)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        c,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.neutralDarkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          availability,
                          style: AppTextStyles.caption.copyWith(
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class PassengerEntryPage extends StatefulWidget {
  const PassengerEntryPage({
    super.key,
    required this.train,
    required this.travelDate,
    required this.quota,
    required this.travelClass,
    required this.availability,
  });

  final _Train train;
  final DateTime travelDate;
  final String quota;
  final String travelClass;
  final String availability;

  @override
  State<PassengerEntryPage> createState() => _PassengerEntryPageState();
}

class _PassengerEntryPageState extends State<PassengerEntryPage> {
  final List<_Passenger> _passengers = [
    _Passenger(name: '', age: '', gender: 'M', berthPreference: 'No pref'),
  ];

  double get _baseFare => widget.train.baseFare[widget.travelClass] ?? 500;

  double get _totalFare => _baseFare * _passengers.length;

  void _addPassenger() {
    setState(() {
      _passengers.add(
        _Passenger(name: '', age: '', gender: 'M', berthPreference: 'No pref'),
      );
    });
  }

  void _book() {
    final ticket = _Ticket(
      pnr: '6${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      train: widget.train,
      travelDate: widget.travelDate,
      quota: widget.quota,
      travelClass: widget.travelClass,
      passengers: _passengers,
      totalFare: _totalFare,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EticketPage(ticket: ticket),
      ),
    );
  }

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
            'Passengers & Fare',
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
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: AppShadows.low,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.train.number} • ${widget.train.name}',
                        style: AppTextStyles.h5,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.train.departure} → ${widget.train.arrival} • ${widget.travelClass} • ${widget.quota}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.neutralGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Passengers',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.primaryDeepBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                ..._passengers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final p = entry.value;
                  return _PassengerCard(
                    index: index,
                    passenger: p,
                    onChanged: (updated) {
                      setState(() {
                        _passengers[index] = updated;
                      });
                    },
                  );
                }),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _addPassenger,
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                  label: const Text('Add Passenger'),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: AppShadows.low,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Fare', style: AppTextStyles.bodyLg),
                          const SizedBox(height: 4),
                          Text(
                            '${_totalFare.toStringAsFixed(2)}',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.primaryDeepBlue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: _book,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryRailwayGreen,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.r16),
                            ),
                          ),
                          child: Text(
                            'Book Ticket',
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _PassengerCard extends StatelessWidget {
  const _PassengerCard({
    required this.index,
    required this.passenger,
    required this.onChanged,
  });

  final int index;
  final _Passenger passenger;
  final ValueChanged<_Passenger> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.low,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Passenger ${index + 1}', style: AppTextStyles.caption),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _SmallTextField(
                  label: 'Name',
                  initialValue: passenger.name,
                  onChanged: (v) =>
                      onChanged(passenger.copyWith(name: v)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: _SmallTextField(
                  label: 'Age',
                  keyboardType: TextInputType.number,
                  initialValue: passenger.age,
                  onChanged: (v) =>
                      onChanged(passenger.copyWith(age: v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _DropdownField(
                  label: 'Gender',
                  value: passenger.gender,
                  items: const ['M', 'F', 'Other'],
                  onChanged: (v) {
                    if (v != null) {
                      onChanged(passenger.copyWith(gender: v));
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DropdownField(
                  label: 'Berth Pref.',
                  value: passenger.berthPreference,
                  items: const ['No pref', 'Lower', 'Middle', 'Upper'],
                  onChanged: (v) {
                    if (v != null) {
                      onChanged(passenger.copyWith(berthPreference: v));
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallTextField extends StatelessWidget {
  const _SmallTextField({
    required this.label,
    this.initialValue = '',
    this.keyboardType,
    required this.onChanged,
  });

  final String label;
  final String initialValue;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppColors.neutralWhite,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.neutralWhite,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class EticketPage extends StatelessWidget {
  const EticketPage({super.key, required this.ticket});

  final _Ticket ticket;

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
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
          title: Text(
            'E-Ticket',
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: AppShadows.high,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PNR', style: AppTextStyles.caption),
                            const SizedBox(height: 2),
                            Text(
                              ticket.pnr,
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primaryDeepBlue,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.qr_code_2,
                            size: 56, color: AppColors.primaryDeepBlue),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 10),
                    Text(
                      '${ticket.train.number} • ${ticket.train.name}',
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.trip_origin,
                            size: 18, color: AppColors.primaryDeepBlue),
                        const SizedBox(width: 4),
                        Text(ticket.train.from, style: AppTextStyles.body),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios,
                            size: 14, color: AppColors.neutralGrey),
                        const SizedBox(width: 4),
                        const Icon(Icons.location_on_outlined,
                            size: 18, color: AppColors.primaryDeepBlue),
                        const SizedBox(width: 4),
                        Text(ticket.train.to, style: AppTextStyles.body),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 16, color: AppColors.neutralGrey),
                        const SizedBox(width: 4),
                        Text(
                          '${ticket.travelDate.day}/${ticket.travelDate.month}/${ticket.travelDate.year} • ${ticket.train.departure}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _pill('Class: ${ticket.travelClass}'),
                        _pill('Quota: ${ticket.quota}'),
                        _pill('Boarding: ${ticket.train.from}'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 10),
                    Text('Passengers', style: AppTextStyles.h5),
                    const SizedBox(height: 8),
                    ...ticket.passengers.asMap().entries.map((entry) {
                      final idx = entry.key + 1;
                      final p = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$idx. ${p.name.isEmpty ? 'Passenger $idx' : p.name}',
                              style: AppTextStyles.body,
                            ),
                            Text(
                              '${p.gender}, ${p.age} yrs • ${p.berthPreference}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.neutralGrey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 14),
                    Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Fare', style: AppTextStyles.bodyLg),
                        Text(
                          '\u000f${ticket.totalFare.toStringAsFixed(2)}',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.primaryDeepBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is your confirmed e-ticket. Please carry a valid ID proof during the journey.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neutralGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutralLightGrey,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption,
      ),
    );
  }
}

class _Train {
  const _Train({
    required this.number,
    required this.name,
    required this.from,
    required this.to,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.days,
    required this.classes,
    required this.availability,
    required this.baseFare,
  });

  final String number;
  final String name;
  final String from;
  final String to;
  final String departure;
  final String arrival;
  final String duration;
  final List<String> days;
  final List<String> classes;
  final Map<String, String> availability; // class -> status
  final Map<String, double> baseFare; // class -> base fare
}

class _Passenger {
  const _Passenger({
    required this.name,
    required this.age,
    required this.gender,
    required this.berthPreference,
  });

  final String name;
  final String age;
  final String gender;
  final String berthPreference;

  _Passenger copyWith({
    String? name,
    String? age,
    String? gender,
    String? berthPreference,
  }) {
    return _Passenger(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      berthPreference: berthPreference ?? this.berthPreference,
    );
  }
}

class _Ticket {
  const _Ticket({
    required this.pnr,
    required this.train,
    required this.travelDate,
    required this.quota,
    required this.travelClass,
    required this.passengers,
    required this.totalFare,
  });

  final String pnr;
  final _Train train;
  final DateTime travelDate;
  final String quota;
  final String travelClass;
  final List<_Passenger> passengers;
  final double totalFare;
}

const _mockTrains = [
  _Train(
    number: '12610',
    name: 'Chennai Express',
    from: 'AVD',
    to: 'MAS',
    departure: '10:40',
    arrival: '11:20',
    duration: '0h 40m',
    days: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    classes: ['SL', '3A', '2A'],
    availability: {
      'SL': 'AVL 45',
      '3A': 'RAC 12',
      '2A': 'WL 8',
    },
    baseFare: {
      'SL': 180,
      '3A': 650,
      '2A': 920,
    },
  ),
  _Train(
    number: '22638',
    name: 'West Coast SF',
    from: 'AVD',
    to: 'ERS',
    departure: '18:30',
    arrival: '07:20',
    duration: '12h 50m',
    days: ['M', 'W', 'F'],
    classes: ['SL', '3A', '2A', '1A'],
    availability: {
      'SL': 'AVL 12',
      '3A': 'AVL 4',
      '2A': 'RAC 3',
      '1A': 'WL 2',
    },
    baseFare: {
      'SL': 520,
      '3A': 1480,
      '2A': 2120,
      '1A': 3120,
    },
  ),
];
