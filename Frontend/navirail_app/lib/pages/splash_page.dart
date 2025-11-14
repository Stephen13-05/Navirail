import 'package:flutter/material.dart';
import 'language_selector_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LanguageSelectorPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const blue = Colors.blue;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.9, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            final o = (((value - 0.85) / 0.15).clamp(0.0, 1.0)).toDouble();
            return Opacity(
              opacity: o,
              child: Transform.scale(scale: value, child: child),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.train_outlined, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 12),
              Text(
                'NaviRail',
                style: TextStyle(
                  color: blue,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
