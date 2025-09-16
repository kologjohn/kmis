import 'package:go_router/go_router.dart';
import 'package:ksoftsms/controller/dbmodels/classmodel.dart';

import 'package:ksoftsms/screen/signup.dart';
import '../components/academicyrmodel.dart';
import '../components/dashboard.dart';

import '../screen/academicyr.dart';
import '../screen/acceslist.dart';
import '../screen/accesscomponent.dart';
import '../screen/class.dart';
import '../screen/department.dart';

import '../screen/gradingsystem.dart';
import '../screen/judgeui.dart';

import '../screen/levelreg.dart';
import '../screen/multipleschools.dart';
import '../screen/registerschool.dart';
import '../screen/regstaff.dart';
import '../screen/scoreconfig.dart';
import '../screen/subject.dart';
import '../screen/teachersetup.dart';
import '../screen/term.dart';
import '../screen/termlist.dart';
import '../screen/viewacademicyr.dart';
import '../screen/viewclass.dart';
import '../screen/viewdepartment.dart';
import '../screen/viewschool.dart';
import '../screen/viewsubject.dart';
import 'dbmodels/departmodel.dart';
import 'dbmodels/levelmodel.dart';
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
  static const viewstaff = "/viewstaff";
  static const nextpage = "/nextpage";


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
  static const gradingsystem = "/gradingsystem";
  static const setupteacher = "/setupteacher";
  static const academicyr = "/academicyr";
  static const viewacademicyr = "/viewacademicyr";
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


  routes: [
    GoRoute(path: Routes.login, builder: (c, s) => SpacerSignUpPage()),
    GoRoute(
      path: Routes.regstaff,
      builder: (context, state) {
        final item = state.extra as Staff?;
        return Regstaff();
      },
    ),

    GoRoute(
    path: Routes.levelreg,
    builder: (context, state) {
    final level = state.extra as LevelModel?;
    return LevelListScreen(levelData: level);
    },),

    GoRoute(path: Routes.dashboard, builder: (c, s) => DashboardLayout()),
    GoRoute(path: Routes.nextpage, builder: (c, s) => SchoolList()),

    GoRoute(path: Routes.jscore, builder: (c, s) => JudgeGroundScreen()),
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
    GoRoute(
      path: Routes.academicyr,
      builder: (context, state) {
        final year = state.extra as AcademicModel?;
        return AcademicYr(year: year);
      },
    ),
    GoRoute(path: Routes.gradingsystem, builder: (c, s) => GradingSystemFormPage()),
    GoRoute(path: Routes.viewterm, builder: (c, s) => Viewterms()),
    GoRoute(path: Routes.viewdepart, builder: (c, s) => Viewdepartment()),
    GoRoute(path: Routes.viewclass, builder: (c, s) => Viewclass()),
    GoRoute(path: Routes.viewsubjects, builder: (c, s) => ViewSubjectPage()),
    //GoRoute(path: Routes.viewschool, builder: (c, s) => ViewSchoolPage()),
    GoRoute(path: Routes.accesscomponent, builder: (c, s) => AccessComponent()),
    GoRoute(path: Routes.accesslist, builder: (c, s) => AccessList()),
    GoRoute(path: Routes.setupteacher, builder: (c, s) => TeacherSetupPage()),
    GoRoute(path: Routes.viewacademicyr, builder: (c, s) => ViewAcademicyr()),
  ],
);