part of '../custom_dropdown.dart';

class _OverlayBuilder extends StatefulWidget {
  final Widget Function(Size, Offset, VoidCallback hide) overlay;
  final Widget Function(VoidCallback show) child;
  final OverlayPortalController? overlayPortalController;
  final Function(bool)? visibility;
  final bool enabled;

  const _OverlayBuilder({
    required this.overlay,
    required this.child,
    this.overlayPortalController,
    this.visibility,
    this.enabled = true,
  });

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<_OverlayBuilder> {
  late OverlayPortalController overlayController;

  @override
  void initState() {
    super.initState();
    overlayController =
        widget.overlayPortalController ?? OverlayPortalController();
  }

  @override
  void didUpdateWidget(covariant _OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.overlayPortalController != oldWidget.overlayPortalController) {
      overlayController =
          widget.overlayPortalController ?? OverlayPortalController();
    }
    if (!widget.enabled && overlayController.isShowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !widget.enabled) hideOverlay();
      });
    }
  }

  void showOverlay() {
    if (!widget.enabled || overlayController.isShowing) return;
    overlayController.show();

    if (widget.visibility != null) {
      widget.visibility!(true);
    }
  }

  void hideOverlay() {
    if (!overlayController.isShowing) return;
    overlayController.hide();

    if (widget.visibility != null) {
      widget.visibility!(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayController,
      overlayChildBuilder: (_) {
        if (!widget.enabled) return const SizedBox.shrink();
        final renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        return widget.overlay(
            size, renderBox.localToGlobal(Offset.zero), hideOverlay);
      },
      child: widget.child(showOverlay),
    );
  }
}
