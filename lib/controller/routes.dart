import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// imports
import '../components/dashboard.dart';
import '../screen/accesscomponent.dart';
import '../screen/acceslist.dart';
import '../screen/adminresults.dart';
import '../screen/judgelandingpage.dart';
import '../screen/actionbuttons.dart';
import '../screen/autoform2.dart';
import '../screen/bestcriteria.dart';
import '../screen/clearscores.dart';
import '../screen/contestantlist.dart';
import '../screen/contestantsetup.dart';
import '../screen/episodereg.dart';
import '../screen/episodelistpage.dart';
// import '../screen/episodemanageheading.dart';
import '../screen/eviction.dart';
import '../screen/forgot_password.dart';
import '../screen/judgelistpage.dart';
import '../screen/judgescoresheet.dart';
import '../screen/judgeui.dart';
import '../screen/judgeselect.dart';
import '../screen/judgesetup.dart';
import '../screen/levelreg.dart';
import '../screen/login.dart';
import '../screen/marks.dart';
import '../screen/newscoringsheet.dart';
import '../screen/printcontestantscoresheet.dart';
import '../screen/rawvote.dart';
import '../screen/regionreg.dart';
import '../screen/regionreglistpage.dart';
import '../screen/regionupdate.dart';
import '../screen/registerstudents.dart';
import '../screen/registerzone.dart';
import '../screen/regstaff.dart';
import '../screen/seasonreg.dart';
import '../screen/sexreg.dart';
import '../screen/testvote.dart';
import '../screen/viewmarks.dart';
import '../screen/viewscores.dart';
import '../screen/viewstaff.dart';
import '../screen/viewvotes.dart';
import '../screen/votinglist.dart';
import '../screen/weekreg.dart';
import '../screen/weeklysheet.dart';
import 'dbmodels/contestantsmodel.dart';
import 'dbmodels/levelmodel.dart';
import 'dbmodels/regionmodel.dart';
import 'dbmodels/staffmodel.dart';
import 'myprovider.dart';

class Routes {

  static const registercontestant = "/registercontestant";
  static const registerzone = "/registerzone";
  static const regstaff = "/regstaff";
  static const revenuetype = "/revenuetype";
  static const accesscomponent = "/accesscomponent";
  static const login = "/login";
  static const home = "/home";
  static const dashboard = "/dashboard";
  static const sexreg = "/sexreg";
  static const seasonreg = "/seasonreg";
  static const episodereg = "/episodereg";
  static const marks = "/marks";
  static const contestantlist = "/contestantlist";
  static const weekreg = "/weekreg";
  static const scoresheet = "/scoresheet";
  static const viewstaff = "/viewstaff";
  static const judgesetup = "/judgesetup";
  static const scores = "/scores";
  static const judgeselect = "/judgeselect";
  static const setupjudge = "/setupjudge";
  static const episodeh = "/episodeh";
  static const jscore = "/jscore";
  static const autoform = "/autoform";
  static const viewmarks = "/viewmarks";
  static const judgescoresheet = "/judgescoresheet";
  static const levelreg = "/levelreg";
  static const weeklysheet = "/weeklysheet";
  static const eviction = "/eviction";
  static const votinglist = "/votinglist";
  static const votes = "/votes";
  static const regionreg = "/regionreg";
  static const clearscores = "/clearscores";
  static const accesslist = "/accesslist";
  static const autoform2 = "/autoform2";
  static const viewvotes = "/viewvotes";
  static const bestcriteria = "/bestcriteria";
  static const judgelist = "/judgelist";
  static const contestantsetup = "/contestantsetup";
  static const regionlist = "/regionlist";
  static const regionupdate = "/regionupdate";
  static const viewscore = "/viewscore";
  static const supperadmin = "/Super Admin";
  static const admin = "/Admin";
  static const judge = "/Judge";
  static const judgelandingpage = "/judgelandingpage";
  static const forgotpass = "/forgotpass";
  static const episodelist = "/episodelist";
  static const adminresults = "/adminresults";
  static const testvote = "/testvote";
  static const rawvote = "/rawvote";
  // Role → Allowed routes mapping
  static const roleAllowedRoutes = {
    "Judge": [
      Routes.judgelandingpage,
      Routes.scores,
      Routes.autoform2,
      Routes.viewmarks,
    ],
  };

}

///  All routes migrated into GoRouter (no RoleGuard)
final GoRouter router = GoRouter(
  initialLocation: Routes.login,
  redirect: (context, state) async {
    final provider = Provider.of<Myprovider>(context, listen: false);

    await provider.getdata();
    await provider.getaccessvel();

    final loggingIn = state.matchedLocation == '/login';

    // Not logged in → send to login
    if (provider.auth.currentUser == null) {
      return loggingIn ? null : '/login';
    }

    // If logged in & at /login → send to dashboard/home
    if (loggingIn) {
      if (provider.accesslevel == "Admin" || provider.accesslevel == "Super Admin") {
        return Routes.dashboard; // or Routes.home
      }
      final allowed = Routes.roleAllowedRoutes[provider.accesslevel];
      if (allowed != null && allowed.isNotEmpty) {
        return allowed.first;
      }
      return '/login'; // fallback
    }

    // ✅ Allow Admin & Super Admin full access
    if (provider.accesslevel == "Admin" || provider.accesslevel == "Super Admin") {
      return null;
    }

    // Restrict Judge and others
    final allowedRoutes = Routes.roleAllowedRoutes[provider.accesslevel] ?? [];
    if (!allowedRoutes.contains(state.matchedLocation)) {
      return allowedRoutes.isNotEmpty ? allowedRoutes.first : '/login';
    }

    return null; // Allow
  },

  routes: [
    GoRoute(path: Routes.login, builder: (c, s) => LoginPage()),
    GoRoute(
      path: Routes.registercontestant,
      builder: (context, state) {
        final item = state.extra as ContestantModel?;
        return RegisterContestants(contestantData: item);
      },
    ),
    GoRoute(path: Routes.registerzone, builder: (c, s) => RegisterZone()),
    GoRoute(
      path: Routes.regstaff,
      builder: (context, state) {
        final item = state.extra as Staff?;
        return Regstaff(staffData: item);
      },
    ),
    GoRoute(path: Routes.viewmarks, builder: (c, s) => viewScorePage()),
    GoRoute(path: Routes.accesscomponent, builder: (c, s) => AccessComponent()),
    GoRoute(
    path: Routes.levelreg,
    builder: (context, state) {
    final level = state.extra as LevelModel?;
    return LevelListScreen(levelData: level);
    },),

    GoRoute(path: Routes.dashboard, builder: (c, s) => DashboardLayout()),
    GoRoute(path: Routes.sexreg, builder: (c, s) => SexRegistrationScreen()),
    GoRoute(path: Routes.seasonreg, builder: (c, s) => SeasonRegistration()),
    GoRoute(path: Routes.episodereg, builder: (c, s) => EpisodeRegistration()),
    GoRoute(path: Routes.marks, builder: (c, s) => EvictionScreen()),
    GoRoute(path: Routes.contestantlist, builder: (c, s) => ContestantsListScreen()),
    GoRoute(path: Routes.weekreg, builder: (c, s) => WeekRegistration()),
    GoRoute(path: Routes.scoresheet, builder: (c, s) => GenerateScoreSheet()),
    GoRoute(path: Routes.viewstaff, builder: (c, s) => StaffListScreen()),
    GoRoute(
      path: Routes.judgesetup,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return JudgeSetupPage(staffData: extra);
      },
    ),
    GoRoute(path: Routes.scores, builder: (c, s) => JudgeScoringPage()),
    GoRoute(path: Routes.judgeselect, builder: (c, s) => JudgeSelect()),
    GoRoute(path: Routes.jscore, builder: (c, s) => JudgeGroundScreen()),
    GoRoute(path: Routes.judgescoresheet, builder: (c, s) => JudgeScoreSheet()),
    GoRoute(path: Routes.weeklysheet, builder: (c, s) => WeeklyScoreSheet()),
    GoRoute(path: Routes.eviction, builder: (c, s) => EvictionSheet()),
    GoRoute(path: Routes.votes, builder: (c, s) => JudgeSelect()),
    GoRoute(path: Routes.votinglist, builder: (c, s) => VotingList()),

    GoRoute(path: Routes.regionlist, builder: (c, s) => RegionListPage()),
    GoRoute(
      path: Routes.regionreg,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final region = extra?["region"] as RegionModel?;
        final isEdit = extra?["isEdit"] as bool? ?? false;

        return Regionregistration(region: region);
      },
    ),
    GoRoute(path: Routes.clearscores, builder: (c, s) => clearScores()),
    GoRoute(path: Routes.accesslist, builder: (c, s) => AccessList()),
    GoRoute(path: Routes.autoform2, builder: (c, s) => DynamicForm()),
    GoRoute(path: Routes.viewvotes, builder: (c, s) => VotesEditPage()),
    GoRoute(path: Routes.bestcriteria, builder: (c, s) => CriteriaScoreSheet()),
    GoRoute(path: Routes.judgelist, builder: (c, s) => JudgeListPage()),
    GoRoute(path: Routes.contestantsetup, builder: (c, s) => ContestantSetup()),
    GoRoute(path: Routes.viewscore, builder: (c, s) => ViewJudgeScores()),
    GoRoute(path: Routes.judgelandingpage, builder: (c, s) => JudgeLandingPage()),
    GoRoute(path: Routes.forgotpass, builder: (c, s) => Forgotpassword()),
    GoRoute(path: Routes.episodelist, builder: (c, s) => EpisodeListPage()),
    GoRoute(path: Routes.adminresults, builder: (c, s) => AdminResultsPage()),
    GoRoute(path: Routes.testvote, builder: (c, s) => Testvote()),
    GoRoute(path: Routes.rawvote, builder: (c, s) => Rawvote()),
  ],
);