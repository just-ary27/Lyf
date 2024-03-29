import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/diary_model.dart';
import '../../routes/routing.dart';
import '../../shared/snackbars/delete_snack.dart';
import '../../utils/errors/diary/diary_errors.dart';
import '../../utils/handlers/route_handler.dart';
import '../../state/diary/diary_list_state.dart';
import '../../state/theme/theme_state.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends ConsumerState<DiaryScreen> {
  List<DiaryEntry>? diaryEntries = [];
  bool retrieveStatus = true;

  void retrieveStatusNotifier(bool flag) {
    setState(() {
      retrieveStatus = flag;
    });
  }

  void _deleteEntry(DiaryEntry entry) {
    ref.read(diaryNotifier.notifier).removeEntry(entry);
  }

  void _refresh({bool? forceRefresh}) {
    try {
      ref.read(diaryNotifier).value;
      if (forceRefresh != null && forceRefresh) {
        ref.read(diaryNotifier.notifier).refresh();
      }
    } on DiaryException catch (e) {
      ref.read(diaryNotifier.notifier).refresh();
    }
  }

  void _retrieveDiaryPdf() {
    ref.read(diaryNotifier.notifier).retrieveDiaryPdf();
  }

  void _retrieveDiaryTxt() {
    ref.read(diaryNotifier.notifier).retrieveDiaryTxt();
  }

  void _retrieveEntryPdf(DiaryEntry entry) {
    ref.read(diaryNotifier.notifier).retrieveEntryPdf(entry);
  }

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var theme = ref.read(themeNotifier.notifier).getCurrentState();
    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: theme.gradientColors,
            ),
          ),
          child: const CustomPaint(),
        ),
        SizedBox(
          height: size.height,
          width: size.width,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                goRouter.push(RouteHandler.createDiary);
              },
              backgroundColor: Theme.of(context).splashColor,
              child: Icon(
                Icons.add,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            backgroundColor: Colors.transparent,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () {
                      goRouter.pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  expandedHeight: 0.3 * size.height,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      foregroundDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.15),
                      ),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withBlue(10),
                          BlendMode.saturation,
                        ),
                        child: Image.asset(
                          "assets/images/diary.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.yourDiary,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  actions: [
                    PopupMenuButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      color: Theme.of(context).iconTheme.color,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: ListTile(
                              onTap: () {
                                _retrieveDiaryPdf();
                              },
                              minLeadingWidth: 25,
                              dense: true,
                              leading: Icon(
                                Icons.picture_as_pdf_rounded,
                                color: theme.gradientColors[2],
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.exportAsPdf,
                                style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                    color: theme.gradientColors[2],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: ListTile(
                              onTap: () {
                                _retrieveDiaryTxt();
                              },
                              minLeadingWidth: 25,
                              dense: true,
                              leading: Icon(
                                Icons.short_text,
                                color: theme.gradientColors[2],
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.exportAsTxt,
                                style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                    color: theme.gradientColors[2],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    )
                  ],
                ),
                Consumer(
                  builder: ((context, ref, child) {
                    final diaryState = ref.watch(diaryNotifier);
                    return diaryState.when(
                      data: ((diary) {
                        if (diary!.isEmpty) {
                          return const SliverFillRemaining(
                            child: Center(
                              child: Text(
                                "Looks like you don't have any todos :) \n Yay!",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } else {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.05 * size.width,
                                    vertical: 0.015 * size.height),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  // color: Colors.white.withOpacity(0.15),
                                  child: InkWell(
                                    onTap: () {
                                      goRouter.push(
                                        RouteHandler.viewDiary(
                                          diary[index].entryId!,
                                        ),
                                        extra: diary[index],
                                      );
                                    },
                                    child: SizedBox(
                                      height: 0.4 * size.height,
                                      width: 0.2 * size.width,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.05 * size.width,
                                            vertical: 0.01 * size.height),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 0.075 * size.height,
                                              alignment: Alignment.bottomLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    diary[index].title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3,
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Share.share(
                                                          "${diary[index].entryTitle}\n\n${diary[index].entryDescription}\n\nDated:${diary[index].entryCreatedAt.day}/${diary[index].entryCreatedAt.month}/${diary[index].entryCreatedAt.year}");
                                                    },
                                                    icon: Icon(
                                                      Icons.share_rounded,
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                0,
                                                0.025 * size.height,
                                                0.0085 * size.width,
                                                0.025 * size.height,
                                              ),
                                              height: 0.225 * size.height,
                                              child: Text(
                                                diary[index].description,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${diary[index].entryCreatedAt.day}/${diary[index].entryCreatedAt.month}/${diary[index].entryCreatedAt.year}",
                                                  style: GoogleFonts.ubuntu(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                ),
                                                ButtonBar(
                                                  alignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    // TextButton(
                                                    //   onPressed: () {
                                                    //     SnackBar snackBar =
                                                    //         deleteSnack(
                                                    //       parentContext:
                                                    //           context,
                                                    //       size: size,
                                                    //       item: diary[index],
                                                    //       performDeleteTask:
                                                    //           _deleteEntry,
                                                    //     );
                                                    //     ScaffoldMessenger.of(
                                                    //             context)
                                                    //         .showSnackBar(
                                                    //             snackBar);
                                                    //   },
                                                    //   child: Text(
                                                    //     AppLocalizations.of(
                                                    //             context)!
                                                    //         .delete,
                                                    //     style:
                                                    //         GoogleFonts.ubuntu(
                                                    //       textStyle: TextStyle(
                                                    //         color: Colors.red,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        _retrieveEntryPdf(
                                                            diary[index]);
                                                      },
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .saveAsPdf,
                                                        style: GoogleFonts
                                                            .ubuntu(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              childCount: diary.length,
                            ),
                          );
                        }
                      }),
                      error: (Object error, StackTrace? stackTrace) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: Text("Unable to retrieve your Diary."),
                          ),
                        );
                      },
                      loading: () {
                        return SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
