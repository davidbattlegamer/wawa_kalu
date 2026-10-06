import 'dart:io';

import 'package:flutter/material.dart';

import '../models/child.dart';

class ChildAvatar extends StatelessWidget {
  final Child child;
  final double size;
  final double borderWidth;

  const ChildAvatar({
    super.key,
    required this.child,
    this.size = 60,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        child.sex == ChildSex.girl
            ? Colors.pink
            : Colors.blue;

    final String? photoPath =
        child.photoPath;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(
        borderWidth,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(
          alpha: 0.12,
        ),
        border: Border.all(
          color: color.withValues(
            alpha: 0.30,
          ),
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: photoPath != null &&
                photoPath.trim().isNotEmpty
            ? Image.file(
                File(photoPath),
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return _FallbackAvatar(
                    child: child,
                    color: color,
                    size: size,
                  );
                },
              )
            : _FallbackAvatar(
                child: child,
                color: color,
                size: size,
              ),
      ),
    );
  }
}

class _FallbackAvatar
    extends StatelessWidget {
  final Child child;
  final Color color;
  final double size;

  const _FallbackAvatar({
    required this.child,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(
        alpha: 0.10,
      ),
      child: Center(
        child: Icon(
          child.sex == ChildSex.girl
              ? Icons.face_3_rounded
              : Icons.face_6_rounded,
          color: color,
          size: size * 0.52,
        ),
      ),
    );
  }
}