import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int? _pressed;

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;

    const items = [
      _NavItem(id: 0, icon: Icons.home_rounded,     labelKey: 'home'),
      _NavItem(id: 1, icon: Icons.auto_awesome,      labelKey: 'genie'),
      _NavItem(id: 2, icon: Icons.local_bar_rounded, labelKey: 'my_bar'),
    ];

    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0d0030).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(30),
            // ← cyan border matching other pills
            border: Border.all(
              color: Colors.cyan.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: items.map((item) {
              final active = widget.currentIndex == item.id;
              final pressed = _pressed == item.id;

              return GestureDetector(
                onTapDown: (_) => setState(() => _pressed = item.id),
                onTapUp: (_) {
                  setState(() => _pressed = null);
                  widget.onTap(item.id);
                },
                onTapCancel: () => setState(() => _pressed = null),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: AnimatedScale(
                    scale: pressed ? 0.82 : active ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 120),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: active
                                ? [BoxShadow(
                                    color: Colors.cyan.withValues(alpha: 0.6),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  )]
                                : [],
                          ),
                          child: Icon(
                            item.icon,
                            color: active ? Colors.cyan : Colors.white38,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 0.5,
                            color: active ? Colors.cyan : Colors.white30,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          child: Text(t(item.labelKey)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final int id;
  final IconData icon;
  final String labelKey;

  const _NavItem({
    required this.id,
    required this.icon,
    required this.labelKey,
  });
}