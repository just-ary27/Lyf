import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyf/src/global/variables.dart';
import 'package:lyf/src/routes/routing.dart';
import 'package:lyf/src/utils/handlers/route_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../state/theme/theme_state.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
            appBar: AppBar(
              shadowColor: Colors.transparent,
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
              title: Text(
                AppLocalizations.of(context)!.settings,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            backgroundColor: Colors.transparent,
            body: ListView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.antiAlias,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 0.25 * size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'pfp',
                        child: Material(
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              goRouter.push(RouteHandler.avatar);
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white.withOpacity(0.15),
                              backgroundImage:
                                  AssetImage("assets/images/diary.jpg"),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0.025 * size.height),
                        child: Text(
                          currentUser.userName,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.05 * size.width),
                  // height: 0.50 * size.height,
                  child: Column(
                    // clipBehavior: Clip.antiAlias,
                    children: [
                      ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        leading: Icon(
                          Icons.manage_accounts_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () {
                          goRouter.push(RouteHandler.accountSettings);
                        },
                        dense: true,
                        title: Text(
                          AppLocalizations.of(context)!.account,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.accountDesc,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      // ListTile(
                      //   tileColor: Colors.white.withOpacity(0.15),
                      //   leading: Icon(
                      //     Icons.stacked_bar_chart_outlined,
                      //     color: Colors.white,
                      //   ),
                      //   onTap: () {},
                      //   title: Text(
                      //     "Data",
                      //     style: Theme.of(context).textTheme.headline4,
                      //   ),
                      //   subtitle: Text(
                      //     "Invite a friend",
                      //     style: Theme.of(context).textTheme.bodyText1,
                      //   ),
                      // ),
                      ListTile(
                        leading: Icon(
                          Icons.help_outline_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () {
                          goRouter.push(
                            RouteHandler.helpSettings,
                            extra: "https://just-ary27.github.io/Lyf/",
                          );
                        },
                        dense: true,
                        title: Text(
                          AppLocalizations.of(context)!.helpCenter,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.helpCenterDesc,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.access_alarm,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () {
                          goRouter.push(RouteHandler.notificationSettings);
                        },
                        dense: true,
                        title: Text(
                          AppLocalizations.of(context)!.notifications,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.notificationsDesc,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),

                      // ListTile(
                      //   tileColor: Colors.white.withOpacity(0.15),
                      //   leading: Stack(
                      //     children: [
                      //       Icon(
                      //         FontAwesomeIcons.rupeeSign,
                      //         color: Colors.white,
                      //       ),
                      //     ],
                      //   ),
                      //   onTap: () {
                      //     RouteManager.navigateToThemeSettings(context);
                      //   },
                      //   title: Text(
                      //     "Billing & payments",
                      //     style: Theme.of(context).textTheme.headline4,
                      //   ),
                      //   subtitle: Text(
                      //     "Change the app's theme.",
                      //     style: Theme.of(context).textTheme.bodyText1,
                      //   ),
                      // ),
                      ListTile(
                        leading: Icon(
                          Icons.dark_mode_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () {
                          goRouter.push(RouteHandler.themeSettings);
                        },
                        dense: true,
                        title: Text(
                          AppLocalizations.of(context)!.themes,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.themesDesc,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.language,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () {
                          goRouter.push(RouteHandler.languageSettings);
                        },
                        dense: true,
                        title: Text(
                          AppLocalizations.of(context)!.language,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.languageDesc,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        leading: Icon(
                          Icons.contacts,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () {
                          goRouter.push(RouteHandler.inviteSettings);
                        },
                        dense: true,
                        title: Text(
                          AppLocalizations.of(context)!.invite,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.inviteDesc,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.20 * size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Crafted by",
                          style: GoogleFonts.caveat(
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 0.05 * size.height,
                        margin: const EdgeInsets.only(bottom: 12),
                        alignment: Alignment.bottomCenter,
                        child: SvgPicture.asset(
                          "assets/images/InCognoS_labs.svg",
                          width: 40,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
