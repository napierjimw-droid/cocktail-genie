import 'package:flutter/material.dart';

class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final bool fullWidth;
  final bool outlined;
  final double fontSize;
  final EdgeInsets? padding;

  const NeonButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = Colors.cyan,
    this.fullWidth = false,
    this.outlined = false,
    this.fontSize = 13,
    this.padding,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onTap == null;
    final color = isDisabled ? Colors.white24 : widget.color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!isDisabled) widget.onTap!();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          decoration: BoxDecoration(
            color: widget.outlined
                ? Colors.transparent
                : color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: color.withValues(alpha: widget.outlined ? 0.4 : 0.75),
            ),
            boxShadow: widget.outlined || isDisabled
                ? []
                : [
                    BoxShadow(
                      color: color.withValues(alpha: _pressed ? 0.35 : 0.2),
                      blurRadius: _pressed ? 18 : 12,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: widget.fontSize,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}