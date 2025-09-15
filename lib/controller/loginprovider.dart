
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ksoftsms/controller/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dbmodels/schoolmodel.dart';
import 'dbmodels/staffmodel.dart';

class LoginProvider extends ChangeNotifier {
  List<String> staffSchoolIds=[];
  List<String> schoolnames=[];
  List<SchoolModel> schoolList = [];
  List<Staff> staffschools = [];
  List<String> staffaccesslevel = ["admin", "teacher", "super admin"];
  String companyid = "ksoo1";
  String currentschool = "";
  Staff? usermodel;
  String schoolid = "";
  String accesslevel = "";
  String phone = "";
  String name = "";
  String errorMessage = "";
  int staffcount_in_school = 0;
  String schooldomain = "kologsoftsmiscom.com";
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  login(String email, String password, BuildContext context) async {
    try {

      final loginhere = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (loginhere.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('useremail', email);
        final detail = await db.collection("staff").where('email', isEqualTo: email).get();
        int numberofdocs = detail.docs.length;
        final userData = detail.docs.first.data();
        usermodel = Staff.fromMap(userData, detail.docs.first.id);
        String emailTxt = usermodel?.email ?? '';
        String nameTxt = usermodel?.name ?? '';
        String roleTxt = usermodel?.accessLevel ?? '';
        String phoneTxt = usermodel?.phone ?? '';
        String schoolTxt = usermodel?.schoolname ?? '';
        String scchoolIdTxt = usermodel?.schoolId ?? '';

        prefs.setString("school", schoolTxt);
        prefs.setString("email", emailTxt);
        prefs.setString("name", nameTxt);
        prefs.setString("role", roleTxt);
        prefs.setString("phone", phoneTxt);
        prefs.setString("schoolid", scchoolIdTxt);

        if (numberofdocs > 1) {
          staffschools = detail.docs.map((doc) {
            return Staff.fromMap(doc.data(), doc.id);
          }).toList();
          prefs.setStringList("staffschools", staffschools.map((e) => e.schoolId).toList());
          prefs.setStringList("schoolnames", staffschools.map((e) => e.schoolname).toList());
          await getdata();
          context.go(Routes.nextpage);
          notifyListeners();
        }
        else {
          await getdata();
          auth.currentUser!.updateDisplayName(nameTxt);
          context.go(Routes.dashboard);
          notifyListeners();
        }

        //useremail=email;
        notifyListeners();
      }
    } catch (e) {

      print(e);
    }
  }
  getdata() async {
    final prefs = await SharedPreferences.getInstance();
    schoolid = prefs.getString('schoolid') ?? '';
    currentschool = prefs.getString('school') ?? '';
    phone = prefs.getString('phone') ?? '';
    accesslevel = prefs.getString('role') ?? '';
    name = prefs.getString('name') ?? '';
    staffSchoolIds = prefs.getStringList("staffschools") ?? [];
    schoolnames = prefs.getStringList("schoolnames") ?? [];
    print(schoolid);
    notifyListeners();
  }
  setSchool(String school, String schoolid) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("school", school);
      await prefs.setString("schoolid", schoolid);
    }catch(e){
      errorMessage = e.toString();
    }
    notifyListeners();
  }
  staffcount() async {
    await getdata();
    try {
      print(schoolid);
      final detail = await db.collection("staff").where('schoolId', isEqualTo: schoolid).get();
      int numberofdocs = detail.docs.length;
      staffcount_in_school = numberofdocs;
      print(numberofdocs);
    } catch (e) {
      print(e);
      return 0;
    }
  }
  Future<bool> staffexistbyphone(String phone) async {
    try {
      final detail = await db
          .collection("staff")
          .where('phone', isEqualTo: phone)
          .where('schoolId', isEqualTo: schoolid)
          .get();
      int numberofdocs = detail.docs.length;
      if (numberofdocs > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> staffexistbyemail(String email) async {
    try {
      final detail = await db
          .collection("staff")
          .where('email', isEqualTo: email)
          .where('schoolId', isEqualTo: schoolid)
          .get();
      int numberofdocs = detail.docs.length;
      if (numberofdocs > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
  // smsalert(String message,String phoneTxt) async {
  //   await db.collection("smsQueue").add({
  //     'phone': phoneTxt,
  //     'message': message,
  //     'senderId': "KologSoft",
  //     'createdat': DateTime.now().toIso8601String(),
  //     'status': 'pending',
  //   });
  // }

}