import 'package:flutter/material.dart';
import 'package:fitassistent/theme/app_theme.dart';

OverlayEntry showFitTopNotice(
  BuildContext context, {
  required String text,
  IconData icon = Icons.info_outline,
}) {
  final overlay = Overlay.of(context);
  final colors = context.platformColors;
  final sizes = context.platformSizes;

  late OverlayEntry entry;
  bool animate = false;
  bool showScheduled = false;
  StateSetter? innerSetState;

  entry = OverlayEntry(
    builder: (ctx) {
      return SafeArea(
        child: Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: sizes.commonTopNoticeTopOffset),
              child: StatefulBuilder(
                builder: (context, setState) {
                  innerSetState = setState;

                  if (!showScheduled) {
                    showScheduled = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (innerSetState == null) return;
                      innerSetState!(() => animate = true);
                    });
                  }

                  return AnimatedSlide(
                    duration: Duration(
                      milliseconds: sizes.commonTopNoticeAnimationMs,
                    ),
                    curve: Curves.easeInOut,
                    offset: animate ? Offset.zero : const Offset(0, -0.15),
                    child: AnimatedOpacity(
                      duration: Duration(
                        milliseconds: sizes.commonTopNoticeAnimationMs,
                      ),
                      curve: Curves.easeInOut,
                      opacity: animate ? 1 : 0,
                      child: AnimatedScale(
                        duration: Duration(
                          milliseconds: sizes.commonTopNoticeAnimationMs,
                        ),
                        curve: Curves.easeInOut,
                        scale: animate ? 1 : 0.98,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(ctx).size.width -
                                sizes.commonTopNoticeHorizontalMargin * 2,
                          ),
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    sizes.commonTopNoticeHorizontalPadding,
                                vertical: sizes.commonTopNoticeVerticalPadding,
                              ),
                              decoration: BoxDecoration(
                                color: colors.authCardBackground,
                                borderRadius: BorderRadius.circular(
                                  sizes.commonTopNoticeRadius,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    icon,
                                    size: sizes.commonTopNoticeIconSize,
                                    color: colors.textSecondary,
                                  ),
                                  SizedBox(
                                    width: sizes.commonTopNoticeIconGap,
                                  ),
                                  Flexible(
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        color: colors.textSecondary,
                                      ),
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
                },
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);

  Future<void>.delayed(const Duration(seconds: 2)).then((_) {
    if (innerSetState == null) return;
    innerSetState!(() => animate = false);
    Future<void>.delayed(
      Duration(milliseconds: sizes.commonTopNoticeAnimationMs),
    ).then((_) => entry.remove());
  });

  return entry;
}

