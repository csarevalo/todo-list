import 'package:flutter/material.dart';

class SectionExpansionTile extends StatelessWidget {
  const SectionExpansionTile({
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
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        leading: leading,
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.only(bottom: 10),
        backgroundColor: themeColors.primary,
        collapsedBackgroundColor: themeColors.primary,
        iconColor: themeColors.primaryContainer,
        collapsedIconColor: themeColors.primaryContainer,
        title: Text(
          titleText,
          style: textTheme.titleMedium!.copyWith(
            color: themeColors.primaryContainer,
          ),
        ),
        children: children,
      ),
    );
  }
}
