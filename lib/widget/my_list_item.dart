import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';

class MyListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailing;
  final VoidCallback? onTap;

  const MyListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Variables.colorCardGray,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  color: Variables.colorMuted,
                  fontSize: 14,
                ),
              )
            : null,
        trailing: trailing != null
            ? Text(
                trailing!,
                style: TextStyle(
                  color: Variables.colorMuted,
                  fontSize: 14,
                ),
              )
            : null,
      ),
    );
  }
}
