import 'package:flutter/material.dart';

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
      child: ExpansionTile(
        leading: leading,
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.only(bottom: 10),
        // backgroundColor: themeColors.primary,
        collapsedBackgroundColor: themeColors.primary,
        iconColor: themeColors.primaryContainer,
        collapsedIconColor: themeColors.primaryContainer,
        title: Text(
          titleText,
          style: textTheme.titleMedium!.copyWith(
            color: themeColors.primaryContainer,
          ),
        ),
        // expansionAnimationStyle: AnimationStyle(
        //   curve: Curves.easeIn,
        //   duration: const Duration(milliseconds: 500),
        // ),
        children: children,
      ),
    );
  }
}
