import 'package:go_router/go_router.dart';
import 'package:ksoftsms/controller/dbmodels/classmodel.dart';
import 'package:ksoftsms/screen/signup.dart';
import 'package:provider/provider.dart';
// imports
import '../components/dashboard.dart';
import '../screen/accesscomponent.dart';
import '../screen/acceslist.dart';
import '../screen/adminresults.dart';
import '../screen/class.dart';
import '../screen/department.dart';
import '../screen/judgelandingpage.dart';
import '../screen/autoform2.dart';
import '../screen/bestcriteria.dart';
import '../screen/clearscores.dart';
import '../screen/contestantsetup.dart';
import '../screen/episodereg.dart';
import '../screen/episodelistpage.dart';
import '../screen/eviction.dart';
import '../screen/forgot_password.dart';
import '../screen/judgelistpage.dart';
import '../screen/judgescoresheet.dart';
import '../screen/judgeui.dart';
import '../screen/judgeselect.dart';
import '../screen/judgesetup.dart';
import '../screen/levelreg.dart';
import '../screen/marks.dart';
import '../screen/newscoringsheet.dart';
import '../screen/printcontestantscoresheet.dart';
import '../screen/rawvote.dart';
import '../screen/regionreg.dart';
import '../screen/regionreglistpage.dart';
import '../screen/registerschool.dart';
import '../screen/registerstudents.dart';
import '../screen/registerzone.dart';
import '../screen/regstaff.dart';
import '../screen/scoreconfig.dart';
import '../screen/seasonreg.dart';
import '../screen/sexreg.dart';
import '../screen/studentlist.dart';
import '../screen/subject.dart';
import '../screen/term.dart';
import '../screen/terminalreport.dart';
import '../screen/termlist.dart';
import '../screen/testvote.dart';
import '../screen/viewclass.dart';
import '../screen/viewdepartment.dart';
import '../screen/viewmarks.dart';
import '../screen/viewschool.dart';
import '../screen/viewscores.dart';
import '../screen/viewstaff.dart';
import '../screen/viewsubject.dart';
import '../screen/viewvotes.dart';
import '../screen/votinglist.dart';
import '../screen/weekreg.dart';
import '../screen/weeklysheet.dart';
import 'dbmodels/contestantsmodel.dart';
import 'dbmodels/departmodel.dart';
import 'dbmodels/levelmodel.dart';
import 'dbmodels/regionmodel.dart';
import 'dbmodels/schoolmodel.dart';
import 'dbmodels/scoremodel.dart';
import 'dbmodels/staffmodel.dart';
import 'dbmodels/subjectmodel.dart';
import 'dbmodels/termmodel.dart';
import 'myprovider.dart';

class Routes {

  static const registerstudent = "/registerstudent";
  static const term = "/term";
  static const depart = "/depart";
  static const classes = "/classes";
  static const subjects = "/subjects";
  static const school = "/school";
  static const scoreconfig = "/scoreconfig";
  static const viewconfig = "/viewconfig";
  static const viewterm = "/viewterm";
  static const viewdepart = "/viewdepart";
  static const viewclass = "/viewclass";
  static const viewsubjects = "/viewsubjects";
  static const viewstudentlist = "/viewstudentlist";
  static const viewschool = "/viewschool";






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
  static const terminalreport = "/terminalreport";
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

  // redirect: (context, state) async {
  //   final provider = Provider.of<Myprovider>(context, listen: false);
  //
  //   await provider.getdata();
  //   await provider.getaccessvel();
  //
  //   final loggingIn = state.matchedLocation == '/login';
  //
  //   // Not logged in → send to login
  //   if (provider.auth.currentUser == null) {
  //     return loggingIn ? null : '/dashboard';
  //   }
  //
  //   // If logged in & at /login → send to dashboard/home
  //   if (loggingIn) {
  //     if (provider.accesslevel == "Admin" || provider.accesslevel == "Super Admin") {
  //       return Routes.dashboard; // or Routes.home
  //     }
  //     final allowed = Routes.roleAllowedRoutes[provider.accesslevel];
  //     if (allowed != null && allowed.isNotEmpty) {
  //       return allowed.first;
  //     }
  //     return '/login'; // fallback
  //   }
  //   // ✅ Allow Admin & Super Admin full access
  //   if (provider.accesslevel == "Admin" || provider.accesslevel == "Super Admin") {
  //     return null;
  //   }
  //
  //   // Restrict Judge and others
  //   final allowedRoutes = Routes.roleAllowedRoutes[provider.accesslevel] ?? [];
  //   if (!allowedRoutes.contains(state.matchedLocation)) {
  //     return allowedRoutes.isNotEmpty ? allowedRoutes.first : '/login';
  //   }
  //
  //   return null; // Allow
  // },
  routes: [
    GoRoute(path: Routes.login, builder: (c, s) => SpacerSignUpPage()),
    GoRoute(
      path: Routes.registerstudent,
      builder: (context, state) {
        final item = state.extra as StudentModel?;
        return RegisterStudent(studentData: item);
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
    GoRoute(path: Routes.viewstudentlist, builder: (c, s) => StudentListScreen()),
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
    GoRoute(path: Routes.terminalreport, builder: (c, s) => ReportSheet()),
    GoRoute(
      path: Routes.term,
      builder: (context, state) {
        final term = state.extra as TermModel?;
        return Term(term: term);
      },
    ),
    GoRoute(
      path: Routes.depart,
      builder: (context, state) {
        final depart = state.extra as DepartmentModel?;
        return Department(depart: depart);
      },
    ),
    GoRoute(
      path: Routes.classes,
      builder: (context, state) {
        final classes = state.extra as ClassModel?;
        return ClassScreen(classes: classes);
      },
    ),
    GoRoute(
      path: Routes.subjects,
      builder: (context, state) {
        final subject = state.extra is SubjectModel ? state.extra as SubjectModel : null;
        return SubjectRegistration(subject: subject);
      },
    ),
    GoRoute(
      path: Routes.school,
      builder: (context, state) {
        final school = state.extra is SchoolModel ? state.extra as SchoolModel : null;
        return RegisterSchool(school: school);
      },
    ),
    GoRoute(
      path: Routes.scoreconfig,
      builder: (context, state) {
        final config = state.extra as ScoremodelConfig?;
        return ScoreConfigPage(config: config);
      },
    ),
    GoRoute(path: Routes.viewterm, builder: (c, s) => Viewterms()),
    GoRoute(path: Routes.viewdepart, builder: (c, s) => Viewdepartment()),
    GoRoute(path: Routes.viewclass, builder: (c, s) => Viewclass()),
    GoRoute(path: Routes.viewsubjects, builder: (c, s) => ViewSubjectPage()),
    GoRoute(path: Routes.viewschool, builder: (c, s) => ViewSchoolPage()),
    GoRoute(path: Routes.viewconfig, builder: (c, s) => ViewSchoolPage()),
  ],
);