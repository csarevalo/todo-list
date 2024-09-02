import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpandableTaskSection extends StatelessWidget {
  const ExpandableTaskSection({
    super.key,
    required this.titleText,
    required this.children,
    this.leading,
  });

  final String titleText;
  final List<Widget> children;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: RepaintBoundary(
        child: Material(
          child: Slidable(
            //FIXME: should use a slideable controller..
            groupTag: '0', //grouptag for taskTile
            enabled: false, //disable slideable
            child: ExpansionTile(
              // maintainState: true,
              initiallyExpanded: true,
              leading: leading,
              title: Text(
                titleText,
                style: textTheme.titleMedium!.copyWith(
                  color: themeColors.primaryContainer,
                ),
              ),
              expansionAnimationStyle: AnimationStyle(
                curve: Curves.easeInSine,
                duration: Duration(
                  milliseconds: min(300, 50 * children.length),
                ),
              ),
              shape: const Border(),
              collapsedShape: const Border(),
              backgroundColor: themeColors.primary,
              collapsedBackgroundColor: themeColors.primary,
              iconColor: themeColors.primaryContainer,
              collapsedIconColor: themeColors.primaryContainer,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
