import 'package:flutter/material.dart';

import '../../../pages/app_texts.dart';

import '../../children/models/child.dart';
import '../../children/utils/child_display_utils.dart';

import '../data/vaccine_repository.dart';
import '../models/vaccine.dart';
import '../models/vaccine_record.dart';
import '../services/vaccine_notification_service.dart';

class VaccineFormPage extends StatefulWidget {
  final Child child;
  final VaccineDose dose;
  final VaccineRecord? record;

  const VaccineFormPage({
    super.key,
    required this.child,
    required this.dose,
    this.record,
  });

  @override
  State<VaccineFormPage> createState() => _VaccineFormPageState();
}

class _VaccineFormPageState extends State<VaccineFormPage> {
  late DateTime _appliedDate;
  late VaccineRecordStatus _status;

  late final TextEditingController _healthCenterController;
  late final TextEditingController _notesController;

  bool _saving = false;
  bool _deleting = false;

  bool get _editing => widget.record != null;
  bool get _isApplied => _status == VaccineRecordStatus.applied;

  @override
  void initState() {
    super.initState();

    _appliedDate = widget.record?.appliedDate ?? DateTime.now();
    _status = widget.record?.status ?? VaccineRecordStatus.applied;

    _healthCenterController = TextEditingController(
      text: widget.record?.healthCenter ?? '',
    );

    _notesController = TextEditingController(
      text: widget.record?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _healthCenterController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _appliedDate.isAfter(now) ? now : _appliedDate,
      firstDate: widget.child.birthDate,
      lastDate: now,
      helpText: T.txt('vaccineAppliedDate'),
      cancelText: T.txt('cancel'),
      confirmText: T.txt('accept'),
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _appliedDate = selected;
    });
  }

  Future<void> _save() async {
    if (_saving || _deleting) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final String healthCenter =
          _healthCenterController.text.trim();
      final String notes = _notesController.text.trim();

      final VaccineRecord record = VaccineRecord(
        id: widget.record?.id ??
            '${widget.child.id}_${widget.dose.id}',
        childId: widget.child.id,
        scheduleId: widget.dose.id,
        vaccineCode: widget.dose.vaccineCode,
        appliedDate: _isApplied
            ? _appliedDate
            : (widget.record?.appliedDate ?? DateTime.now()),
        status: _status,
        healthCenter: _isApplied && healthCenter.isNotEmpty
            ? healthCenter
            : null,
        notes: notes.isEmpty ? null : notes,
        createdAt: widget.record?.createdAt ?? DateTime.now(),
      );

      await VaccineRepository.instance.saveRecord(record);

      await VaccineNotificationService.instance.rescheduleForChild(
        widget.child,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _delete() async {
    final VaccineRecord? record = widget.record;

    if (record == null || _saving || _deleting) {
      return;
    }

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(T.txt('deleteVaccineRecord')),
          content: Text(T.txt('deleteVaccineRecordQuestion')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(T.txt('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: Text(T.txt('delete')),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) {
      return;
    }

    setState(() {
      _deleting = true;
    });

    try {
      await VaccineRepository.instance.deleteRecord(record.id);

      await VaccineNotificationService.instance.rescheduleForChild(
        widget.child,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
    } finally {
      if (mounted) {
        setState(() {
          _deleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark =
        Theme.of(context).brightness == Brightness.dark;

    final Color childColor =
        widget.child.sex == ChildSex.girl ? Colors.pink : Colors.blue;

    const Color appliedColor = Color(0xFF00A896);
    const Color notAppliedColor = Color(0xFFE76F51);

    final Color activeColor =
        _isApplied ? appliedColor : notAppliedColor;

    return Scaffold(
      backgroundColor:
          dark ? const Color(0xFF15131A) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor:
            dark ? const Color(0xFF211B2E) : Colors.white,
        foregroundColor:
            dark ? Colors.white : const Color(0xFF2D2D2D),
        elevation: 0,
        title: Text(
          _editing
              ? T.txt('editVaccineRecord')
              : T.txt('registerVaccine'),
          style: const TextStyle(
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_editing)
            IconButton(
              tooltip: T.txt('delete'),
              onPressed: _deleting ? null : _delete,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      dark ? const Color(0xFF211B2E) : Colors.white,
                      childColor.withValues(
                        alpha: dark ? 0.15 : 0.07,
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: childColor.withValues(alpha: 0.10),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: childColor.withValues(alpha: 0.14),
                      ),
                      child: Icon(
                        widget.child.sex == ChildSex.girl
                            ? Icons.face_3_rounded
                            : Icons.face_6_rounded,
                        color: childColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.child.name,
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: dark
                                  ? Colors.white
                                  : const Color(0xFF2D2D2D),
                            ),
                          ),
                          Text(
                            childAgeText(widget.child.birthDate),
                            style: TextStyle(
                              fontFamily: 'Baloo2',
                              fontSize: 14,
                              color:
                                  dark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                T.txt(widget.dose.nameKey),
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color:
                      dark ? Colors.white : const Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                T.txt(widget.dose.doseLabelKey),
                style: const TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                T.txt(widget.dose.preventsKey),
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 14.5,
                  height: 1.25,
                  color: dark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                T.txt('vaccineDoseStatus'),
                style: const TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                T.txt('vaccineDoseStatusSubtitle'),
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 14,
                  height: 1.25,
                  color: dark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _StatusOption(
                      selected: _isApplied,
                      dark: dark,
                      color: appliedColor,
                      icon: Icons.check_circle_rounded,
                      title: T.txt('vaccineMarkApplied'),
                      subtitle: T.txt('vaccineAppliedOptionHelp'),
                      onTap: () {
                        setState(() {
                          _status = VaccineRecordStatus.applied;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatusOption(
                      selected: !_isApplied,
                      dark: dark,
                      color: notAppliedColor,
                      icon: Icons.remove_circle_rounded,
                      title: T.txt('vaccineMarkNotApplied'),
                      subtitle: T.txt('vaccineNotAppliedOptionHelp'),
                      onTap: () {
                        setState(() {
                          _status = VaccineRecordStatus.notApplied;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _isApplied
                    ? Column(
                        key: const ValueKey('appliedFields'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            T.txt('vaccineAppliedDate'),
                            style: const TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                            child: InkWell(
                              onTap: _selectDate,
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: dark
                                      ? const Color(0xFF211B2E)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: appliedColor.withValues(
                                      alpha: 0.22,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_rounded,
                                      color: appliedColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        simpleDateText(_appliedDate),
                                        style: TextStyle(
                                          fontFamily: 'Fredoka',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: dark
                                              ? Colors.white
                                              : const Color(0xFF2D2D2D),
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _healthCenterController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: T.txt('healthCenterOptional'),
                              prefixIcon: const Icon(
                                Icons.local_hospital_outlined,
                              ),
                              filled: true,
                              fillColor: dark
                                  ? const Color(0xFF211B2E)
                                  : Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: appliedColor.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        key: const ValueKey('notAppliedInfo'),
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: notAppliedColor.withValues(
                            alpha: dark ? 0.13 : 0.08,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: notAppliedColor.withValues(alpha: 0.24),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: notAppliedColor.withValues(
                                  alpha: 0.14,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                color: notAppliedColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                T.txt('vaccineNotAppliedUnlockInfo'),
                                style: TextStyle(
                                  fontFamily: 'Baloo2',
                                  fontSize: 14.5,
                                  height: 1.3,
                                  fontWeight: FontWeight.w600,
                                  color: dark
                                      ? Colors.white70
                                      : const Color(0xFF5B4039),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _notesController,
                minLines: 3,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: T.txt('notesOptional'),
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 52),
                    child: Icon(Icons.notes_rounded),
                  ),
                  filled: true,
                  fillColor:
                      dark ? const Color(0xFF211B2E) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: activeColor.withValues(alpha: 0.12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton.icon(
                  onPressed:
                      (_saving || _deleting) ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: activeColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        activeColor.withValues(alpha: 0.45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),
                  icon: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.3,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          _isApplied
                              ? Icons.check_circle_rounded
                              : Icons.remove_circle_rounded,
                        ),
                  label: Text(
                    T.txt('saveVaccineRecord'),
                    style: const TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final bool selected;
  final bool dark;
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _StatusOption({
    required this.selected,
    required this.dark,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 142),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: dark ? 0.18 : 0.10)
                : dark
                    ? const Color(0xFF211B2E)
                    : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? color
                  : dark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06),
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.withValues(
                        alpha: selected ? 0.18 : 0.09,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 23,
                    ),
                  ),
                  const Spacer(),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: selected ? 1 : 0,
                    child: Icon(
                      Icons.check_rounded,
                      color: color,
                      size: 21,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: selected
                      ? color
                      : dark
                          ? Colors.white
                          : const Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 12.4,
                  height: 1.18,
                  color: dark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
