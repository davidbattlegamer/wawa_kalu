import 'package:flutter/foundation.dart';

import '../../../core/database/app_database.dart';

import '../models/child.dart';

class ChildRepository {
  ChildRepository._();

  static final ChildRepository instance =
      ChildRepository._();

  static const String _selectedChildKey =
      'selected_child_id';

  final ValueNotifier<List<Child>>
      children =
      ValueNotifier<List<Child>>(
    <Child>[],
  );

  final ValueNotifier<String?>
      selectedChildId =
      ValueNotifier<String?>(null);

  bool _initialized = false;

  bool get initialized => _initialized;

  Child? get selectedChild {
    final String? id =
        selectedChildId.value;

    if (id == null) {
      return null;
    }

    return findById(id);
  }

  Child? findById(
    String id,
  ) {
    for (final Child child
        in children.value) {
      if (child.id == id) {
        return child;
      }
    }

    return null;
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final List<Child> storedChildren =
        await AppDatabase.instance
            .getChildren();

    children.value = storedChildren;

    final String? storedSelectedId =
        await AppDatabase.instance
            .getState(
      _selectedChildKey,
    );

    if (storedSelectedId != null &&
        findById(storedSelectedId) !=
            null) {
      selectedChildId.value =
          storedSelectedId;
    } else if (storedChildren.isNotEmpty) {
      final String firstChildId =
          storedChildren.first.id;

      selectedChildId.value =
          firstChildId;

      await AppDatabase.instance
          .setState(
        _selectedChildKey,
        firstChildId,
      );
    } else {
      selectedChildId.value = null;

      await AppDatabase.instance
          .deleteState(
        _selectedChildKey,
      );
    }

    _initialized = true;
  }

  Future<void> addChild(
    Child child,
  ) async {
    await AppDatabase.instance
        .insertChild(child);

    children.value = [
      ...children.value,
      child,
    ];

    await selectChild(child.id);
  }

  Future<void> updateChild(
    Child child,
  ) async {
    await AppDatabase.instance
        .updateChild(child);

    final List<Child> updated =
        children.value.map(
      (current) {
        if (current.id == child.id) {
          return child;
        }

        return current;
      },
    ).toList();

    children.value = updated;
  }

  Future<void> removeChild(
    String id,
  ) async {
    await AppDatabase.instance
        .deleteChild(id);

    final List<Child> updated =
        children.value
            .where(
              (child) =>
                  child.id != id,
            )
            .toList();

    children.value = updated;

    if (selectedChildId.value != id) {
      return;
    }

    if (updated.isEmpty) {
      selectedChildId.value = null;

      await AppDatabase.instance
          .deleteState(
        _selectedChildKey,
      );

      return;
    }

    final String newSelectedId =
        updated.first.id;

    selectedChildId.value =
        newSelectedId;

    await AppDatabase.instance
        .setState(
      _selectedChildKey,
      newSelectedId,
    );
  }

  Future<void> selectChild(
    String id,
  ) async {
    if (findById(id) == null) {
      return;
    }

    selectedChildId.value = id;

    await AppDatabase.instance
        .setState(
      _selectedChildKey,
      id,
    );
  }
}