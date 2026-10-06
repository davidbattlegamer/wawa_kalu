import 'package:flutter/material.dart';

import '../../../pages/app_config.dart';
import '../../../pages/app_texts.dart';

import '../data/child_repository.dart';
import '../models/child.dart';
import '../utils/child_display_utils.dart';
import '../widgets/child_avatar.dart';

import 'child_form_page.dart';
import 'child_profile_page.dart';

class ChildrenPage extends StatelessWidget {
  const ChildrenPage({
    super.key,
  });

  Future<void> _addChild(
    BuildContext context,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ChildFormPage(),
      ),
    );
  }

  Future<void> _openChild(
    BuildContext context,
    Child child,
  ) async {
    await ChildRepository.instance
        .selectChild(
      child.id,
    );

    if (!context.mounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChildProfilePage(
          childId:
              child.id,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return ValueListenableBuilder<String>(
      valueListenable:
          AppConfig.idioma,
      builder: (
        context,
        idiomaActual,
        _,
      ) {
        final bool dark =
            Theme.of(context)
                    .brightness ==
                Brightness.dark;

        return Scaffold(
          backgroundColor: dark
              ? const Color(
                  0xFF15131A,
                )
              : const Color(
                  0xFFFAF7F2,
                ),
          appBar: AppBar(
            automaticallyImplyLeading:
                false,
            backgroundColor: dark
                ? const Color(
                    0xFF211B2E,
                  )
                : Colors.white,
            foregroundColor: dark
                ? Colors.white
                : const Color(
                    0xFF2D2D2D,
                  ),
            elevation:
                0,
            title: Text(
              T.txt(
                'myChildren',
              ),
              style:
                  TextStyle(
                fontFamily:
                    'Fredoka',
                fontSize:
                    24,
                fontWeight:
                    FontWeight.w700,
                color: dark
                    ? Colors.white
                    : const Color(
                        0xFF2D2D2D,
                      ),
              ),
            ),
            actions: [
              IconButton(
                tooltip:
                    T.txt(
                  'addChild',
                ),
                onPressed:
                    () {
                  _addChild(
                    context,
                  );
                },
                icon:
                    const Icon(
                  Icons
                      .add_rounded,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child:
                ValueListenableBuilder<
                    List<Child>>(
              valueListenable:
                  ChildRepository
                      .instance
                      .children,
              builder: (
                context,
                children,
                _,
              ) {
                if (children.isEmpty) {
                  return _EmptyChildren(
                    dark:
                        dark,
                    onAdd:
                        () {
                      _addChild(
                        context,
                      );
                    },
                  );
                }

                return ValueListenableBuilder<
                    String?>(
                  valueListenable:
                      ChildRepository
                          .instance
                          .selectedChildId,
                  builder: (
                    context,
                    selectedId,
                    _,
                  ) {
                    return ListView(
                      padding:
                          const EdgeInsets
                              .fromLTRB(
                        20,
                        20,
                        20,
                        110,
                      ),
                      children: [
                        Text(
                          T.txt(
                            'childrenHeaderTitle',
                          ),
                          style:
                              TextStyle(
                            fontFamily:
                                'Fredoka',
                            fontSize:
                                25,
                            fontWeight:
                                FontWeight.w800,
                            color: dark
                                ? Colors.white
                                : const Color(
                                    0xFF4A2C82,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          T.txt(
                            'childrenHeaderSubtitle',
                          ),
                          style:
                              TextStyle(
                            fontFamily:
                                'Baloo2',
                            fontSize:
                                15.5,
                            height:
                                1.2,
                            color: dark
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ...children.map(
                          (
                            child,
                          ) {
                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom:
                                    13,
                              ),
                              child:
                                  _ChildCard(
                                child:
                                    child,
                                selected:
                                    child.id ==
                                        selectedId,
                                onTap:
                                    () {
                                  _openChild(
                                    context,
                                    child,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          floatingActionButton:
              ValueListenableBuilder<
                  List<Child>>(
            valueListenable:
                ChildRepository
                    .instance
                    .children,
            builder: (
              context,
              children,
              _,
            ) {
              if (children.isEmpty) {
                return const SizedBox
                    .shrink();
              }

              return FloatingActionButton
                  .extended(
                onPressed:
                    () {
                  _addChild(
                    context,
                  );
                },
                backgroundColor:
                    const Color(
                  0xFF7B2CBF,
                ),
                foregroundColor:
                    Colors.white,
                icon:
                    const Icon(
                  Icons
                      .add_rounded,
                ),
                label:
                    Text(
                  T.txt(
                    'addChild',
                  ),
                  style:
                      const TextStyle(
                    fontFamily:
                        'Fredoka',
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _EmptyChildren
    extends StatelessWidget {
  final bool dark;
  final VoidCallback onAdd;

  const _EmptyChildren({
    required this.dark,
    required this.onAdd,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          24,
        ),
        child:
            Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width:
                  110,
              height:
                  110,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                gradient:
                    LinearGradient(
                  colors: [
                    const Color(
                      0xFF7B2CBF,
                    ).withValues(
                      alpha:
                          0.22,
                    ),
                    const Color(
                      0xFFFF006E,
                    ).withValues(
                      alpha:
                          0.12,
                    ),
                  ],
                  begin:
                      Alignment.topLeft,
                  end:
                      Alignment.bottomRight,
                ),
              ),
              child:
                  const Icon(
                Icons
                    .child_care_rounded,
                size:
                    58,
                color:
                    Color(
                  0xFF7B2CBF,
                ),
              ),
            ),
            const SizedBox(
              height:
                  24,
            ),
            Text(
              T.txt(
                'noChildrenRegistered',
              ),
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontFamily:
                    'Fredoka',
                fontSize:
                    23,
                fontWeight:
                    FontWeight.w700,
                color: dark
                    ? Colors.white
                    : const Color(
                        0xFF2D2D2D,
                      ),
              ),
            ),
            const SizedBox(
              height:
                  10,
            ),
            Text(
              T.txt(
                'childrenEmptyDescription',
              ),
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontFamily:
                    'Baloo2',
                fontSize:
                    16,
                height:
                    1.3,
                fontWeight:
                    FontWeight.w500,
                color: dark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
            const SizedBox(
              height:
                  28,
            ),
            SizedBox(
              width:
                  double.infinity,
              height:
                  56,
              child:
                  FilledButton.icon(
                onPressed:
                    onAdd,
                style:
                    FilledButton
                        .styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF7B2CBF,
                  ),
                  foregroundColor:
                      Colors.white,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),
                  ),
                ),
                icon:
                    const Icon(
                  Icons
                      .add_rounded,
                ),
                label:
                    Text(
                  T.txt(
                    'addChild',
                  ),
                  style:
                      const TextStyle(
                    fontFamily:
                        'Fredoka',
                    fontSize:
                        18,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildCard
    extends StatelessWidget {
  final Child child;
  final bool selected;
  final VoidCallback onTap;

  const _ChildCard({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool dark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    final Color color =
        child.sex == ChildSex.girl
            ? Colors.pink
            : Colors.blue;

    return Material(
      color:
          Colors.transparent,
      borderRadius:
          BorderRadius.circular(
        24,
      ),
      child: InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        child:
            AnimatedContainer(
          duration:
              const Duration(
            milliseconds:
                200,
          ),
          padding:
              const EdgeInsets.all(
            16,
          ),
          decoration:
              BoxDecoration(
            gradient:
                LinearGradient(
              colors: [
                dark
                    ? const Color(
                        0xFF211B2E,
                      )
                    : Colors.white,
                color.withValues(
                  alpha: dark
                      ? 0.16
                      : 0.08,
                ),
              ],
              begin:
                  Alignment.centerLeft,
              end:
                  Alignment.centerRight,
            ),
            borderRadius:
                BorderRadius.circular(
              24,
            ),
            border:
                Border.all(
              color: selected
                  ? const Color(
                      0xFF7B2CBF,
                    )
                  : color.withValues(
                      alpha:
                          0.16,
                    ),
              width: selected
                  ? 2
                  : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    color.withValues(
                  alpha:
                      0.07,
                ),
                blurRadius:
                    12,
                offset:
                    const Offset(
                  0,
                  5,
                ),
              ),
            ],
          ),
          child:
              Row(
            children: [
              ChildAvatar(
                child:
                    child,
                size:
                    61,
              ),
              const SizedBox(
                width:
                    14,
              ),
              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child:
                              Text(
                            child.name,
                            overflow:
                                TextOverflow.ellipsis,
                            maxLines:
                                1,
                            style:
                                TextStyle(
                              fontFamily:
                                  'Fredoka',
                              fontSize:
                                  19,
                              fontWeight:
                                  FontWeight.w800,
                              color: dark
                                  ? Colors.white
                                  : const Color(
                                      0xFF2D2D2D,
                                    ),
                            ),
                          ),
                        ),
                        if (selected) ...[
                          const SizedBox(
                            width:
                                8,
                          ),
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  8,
                              vertical:
                                  3,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  const Color(
                                0xFF00A896,
                              ).withValues(
                                alpha:
                                    0.13,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                            ),
                            child:
                                Text(
                              T.txt(
                                'active',
                              ),
                              style:
                                  const TextStyle(
                                fontFamily:
                                    'Baloo2',
                                fontSize:
                                    11.5,
                                fontWeight:
                                    FontWeight.w700,
                                color:
                                    Color(
                                  0xFF00A896,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(
                      height:
                          4,
                    ),
                    Text(
                      childAgeText(
                        child.birthDate,
                      ),
                      style:
                          TextStyle(
                        fontFamily:
                            'Baloo2',
                        fontSize:
                            15,
                        color: dark
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height:
                          2,
                    ),
                    Text(
                      child.sex ==
                              ChildSex.girl
                          ? T.txt(
                              'girl',
                            )
                          : T.txt(
                              'boy',
                            ),
                      style:
                          TextStyle(
                        fontFamily:
                            'Baloo2',
                        fontSize:
                            13.5,
                        color:
                            color,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width:
                    6,
              ),
              Icon(
                Icons
                    .chevron_right_rounded,
                color: selected
                    ? const Color(
                        0xFF7B2CBF,
                      )
                    : color,
                size:
                    28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}