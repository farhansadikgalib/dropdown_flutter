part of '../custom_dropdown.dart';

class _AnimatedSection extends StatefulWidget {
  final bool expand;
  final VoidCallback animationDismissed;
  final Widget child;
  final AlignmentGeometry alignment;
  final Duration? duration;
  final Curve? curve;

  const _AnimatedSection({
    this.expand = false,
    required this.animationDismissed,
    required this.child,
    required this.alignment,
    this.duration,
    this.curve,
  });

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late CurvedAnimation animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    runExpand();
  }

  void prepareAnimations() {
    animController = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 300),
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !widget.expand) widget.animationDismissed();
          });
        }
      });

    animation = CurvedAnimation(
      parent: animController,
      curve: widget.curve ?? Curves.linearToEaseOut,
    );
  }

  void runExpand() {
    if (widget.expand) {
      animController.forward();
    } else {
      animController.reverse();
    }
  }

  @override
  void didUpdateWidget(_AnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    animController.duration =
        widget.duration ?? const Duration(milliseconds: 300);
    animation.curve = widget.curve ?? Curves.linearToEaseOut;
    if (oldWidget.expand != widget.expand) runExpand();
  }

  @override
  void dispose() {
    animation.dispose();
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: AnimatedBuilder(
        animation: animation,
        child: widget.child,
        builder: (context, child) => ClipRect(
          child: Align(
            alignment: widget.alignment,
            heightFactor: animation.value.clamp(0.0, 1.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
