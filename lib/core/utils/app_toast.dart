import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppToast {
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: const Color(0xFF059669), // Rich Emerald
      icon: Icons.check_circle_rounded,
      textColor: Colors.white,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: const Color(0xFFDC2626), // High contrast Crimson
      icon: Icons.error_outline_rounded,
      textColor: Colors.white,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_outline_rounded,
      textColor: AppColors.onPrimary,
    );
  }

  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    try {
      _currentEntry?.remove();
    } catch (_) {}
    _currentEntry = null;
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color textColor = Colors.white,
    Duration duration = const Duration(milliseconds: 2600),
  }) {
    dismiss();

    final overlay = Overlay.maybeOf(context, rootOverlay: true) ??
        Overlay.maybeOf(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (ctx) => _TopToastWidget(
        message: message,
        backgroundColor: backgroundColor,
        icon: icon,
        textColor: textColor,
        onDismiss: dismiss,
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _dismissTimer = Timer(duration, () {
      dismiss();
    });
  }
}

class _TopToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final Color textColor;
  final VoidCallback onDismiss;

  const _TopToastWidget({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.textColor,
    required this.onDismiss,
  });

  @override
  State<_TopToastWidget> createState() => _TopToastWidgetState();
}

class _TopToastWidgetState extends State<_TopToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: SlideTransition(
            position: _offsetAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: GestureDetector(
                onTap: widget.onDismiss,
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta != null &&
                      details.primaryDelta! < -4) {
                    widget.onDismiss();
                  }
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 14.0),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.icon,
                          color: widget.textColor,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.message,
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: widget.textColor.withValues(alpha: 0.8),
                            size: 18,
                          ),
                          onPressed: widget.onDismiss,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
