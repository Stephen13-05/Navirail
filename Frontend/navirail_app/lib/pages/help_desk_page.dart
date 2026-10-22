import 'package:flutter/material.dart';

import '../ui/design_system.dart';

class HelpDeskPage extends StatelessWidget {
  const HelpDeskPage({super.key});

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
            'Help Desk',
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
                  'Emergency and assistance contacts at the station.',
                  style: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.neutralDarkGrey,
                  ),
                ),
                const SizedBox(height: 16),
                _HelpCard(
                  title: 'Railway Police (RPF)',
                  description:
                      'For security issues, theft, harassment or suspicious activity inside trains and station premises.',
                  primaryLabel: 'Call RPF',
                  primaryIcon: Icons.local_police_outlined,
                ),
                const SizedBox(height: 12),
                _HelpCard(
                  title: 'Emergency Services',
                  description:
                      'Medical emergency, fire or any life threatening situation. Connects to national emergency helplines.',
                  primaryLabel: 'Call Emergency',
                  primaryIcon: Icons.emergency_outlined,
                ),
                const SizedBox(height: 12),
                _HelpCard(
                  title: 'Station Master',
                  description:
                      'For operational queries, platform changes, announcements and urgent station-level support.',
                  primaryLabel: 'Call Station Master',
                  primaryIcon: Icons.manage_accounts_outlined,
                ),
                const SizedBox(height: 12),
                _HelpCard(
                  title: 'Enquiry / Help Desk',
                  description:
                      'Timings of trains, platform enquiries, ticket and reservation related guidance.',
                  primaryLabel: 'Call Enquiry',
                  primaryIcon: Icons.support_agent_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.primaryIcon,
  });

  final String title;
  final String description;
  final String primaryLabel;
  final IconData primaryIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryDeepBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(primaryIcon, color: AppColors.primaryDeepBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.neutralDarkGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.body.copyWith(
              color: AppColors.neutralDarkGrey,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$primaryLabel (demo only, no real call)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.call),
              label: Text(primaryLabel),
            ),
          ),
        ],
      ),
    );
  }
}
