import 'package:flutter/material.dart';

/// Task Tag Model
class Tag {
  final String id;
  Icon icon;
  String tagName;
  Tag({
    required this.id,
    required this.icon,
    required this.tagName,
  });
}