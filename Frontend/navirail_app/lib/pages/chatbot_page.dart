import 'package:flutter/material.dart';

import '../ui/design_system.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  final TrainChatService _service = const TrainChatService();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isSending = true;
    });
    _controller.clear();

    final reply = await _service.getReply(text);
    if (!mounted) return;

    setState(() {
      _messages.add(_ChatMessage(text: reply, isUser: false));
      _isSending = false;
    });
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
            'Chatbot',
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
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: AppShadows.low,
                  ),
                  child: _messages.isEmpty
                      ? Center(
                          child: Text(
                            'Ask me anything about trains, tickets, stations or coach layouts.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.neutralGrey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[_messages.length - 1 - index];
                            return _ChatBubble(message: message);
                          },
                        ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.neutralWhite,
                          borderRadius: BorderRadius.circular(AppRadius.r16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Ask about trains, tickets or stations',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: _isSending
                          ? AppColors.neutralGrey
                          : AppColors.primaryDeepBlue,
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        onPressed: _isSending ? null : _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser
        ? AppColors.primaryDeepBlue
        : AppColors.neutralLightGrey;
    final textColor = isUser ? Colors.white : AppColors.neutralDarkGrey;

    return Align
(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: AppShadows.low,
        ),
        child: Text(
          message.text,
          style: AppTextStyles.body.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}

/// Simple offline chatbot focused on train-related FAQs.
class TrainChatService {
  const TrainChatService();

  Future<String> getReply(String rawPrompt) async {
    final prompt = rawPrompt.toLowerCase();

    // Small delay so responses feel natural.
    await Future<void>.delayed(const Duration(milliseconds: 200));

    if (prompt.contains('3rd ac') || prompt.contains('3a')) {
      return '3rd AC (3A) is a fully air-conditioned sleeper coach with 3 tiers of berths in each bay — lower (L), middle (M) and upper (U) — plus side lower (SL) and side upper (SU) berths along the corridor. It is cheaper than 2A but more comfortable than Sleeper (SL).';
    }

    if (prompt.contains('2nd ac') || prompt.contains('2a')) {
      return '2nd AC (2A) has only 2 tiers of berths (L and U) in each bay, plus side berths. So there are fewer people in the same space compared to 3A, giving more privacy and headroom. It is more expensive than 3A.';
    }

    if (prompt.contains('1st ac') || prompt.contains('1a') || prompt.contains('first class')) {
      return '1st AC (1A) is the most premium coach with lockable cabins and coupes (2 or 4 berths). It is fully air-conditioned with more space, privacy and better bedding.';
    }

    if (prompt.contains('sleeper') || prompt.contains('sl class') || prompt.contains('sl ')) {
      return 'Sleeper Class (SL) is a non-AC coach with 3 tiers of berths (L, M, U) and side berths (SL, SU). It is the most common long-distance class in India, with open windows and fans instead of air-conditioning.';
    }

    if (prompt.contains('coach layout') || prompt.contains('seat map') || prompt.contains('berth layout')) {
      return '''To see coach layouts in NaviRail:
1. On the Home page, tap the "Train Coach Layout" quick action.
2. Choose the coach type (3A, 2A, 1A, SL, etc.).
3. Tap a card to open a detail screen with an explanation and a zoomable layout image.
This helps you see where your berth (L/M/U/SL/SU) is located in the coach.''';
    }

    if (prompt.contains('local ticket') || prompt.contains('local train') || prompt.contains('uts')) {
      return '''For local / suburban tickets in NaviRail:
1. From Home, tap "Tickets".
2. Choose "Local Trains".
3. Enter From, To, Adults and Children.
4. Tap "Show Price" and then "Buy Ticket" to see a print-friendly ticket card with fare and validity time.''';
    }

    if (prompt.contains('long distance') || prompt.contains('irctc') || prompt.contains('express') || prompt.contains('book ticket')) {
      return '''For long-distance (IRCTC-style) booking in NaviRail:
1. Tap "Tickets" → "Long-Distance Trains".
2. Fill From, To, Date and Quota (General, Tatkal, etc.).
3. Tap "Search Trains" to see trains with classes (SL, 3A, 2A, 1A) and availability (AVL, RAC, WL).
4. Choose a class, add passenger details and tap "Book Ticket" to generate an e-ticket with PNR, fare and passenger list.''';
    }

    if (prompt.contains('pnr')) {
      return 'In this demo, NaviRail shows a PNR number only on the generated e-ticket after booking via the Long-Distance flow. Live PNR status with Railways servers is not connected yet.';
    }

    if (prompt.contains('food') || prompt.contains('shop') || prompt.contains('kovilpatti') || prompt.contains('beverages')) {
      return '''NaviRail Food & Shops:
- Kovilpatti Muruku Kadai: traditional snacks and murukku.
- Kumar Beverages: juices, cold drinks and water.
- Handloom Shops: handloom products and small gifts.
Use the "Food & Shops" quick action on the Home page, then tap a shop to see details and map/navigation buttons.''';
    }

    if (prompt.contains('navirail') || prompt.contains('what can you do') || prompt.contains('features')) {
      return '''Inside the NaviRail app I can guide you on:
- Coach layouts for 1A / 2A / 3A / SL with diagrams.
- Local and long-distance ticket flows.
- Food & shops near the station.
- Basic explanations of train classes and berths.
Ask things like "Explain 3rd AC", "What is Sleeper class?" or "How do I book a long-distance ticket?"''';
    }

    // Fallback generic response.
    return '''I am an offline train assistant in the NaviRail app. I can explain coach types (1A, 2A, 3A, SL), berth layouts, and how to use Tickets, Train Coach Layout and Food & Shops sections.
Try asking:
- What is 3rd AC?
- Explain Sleeper class.
- How do I book a long-distance ticket?
- How do I see the coach layout in this app?''';
  }
}
