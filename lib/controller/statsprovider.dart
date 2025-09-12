import 'dart:convert';

import 'package:ksoftsms/controller/myprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'dbmodels/staffmodel.dart';

class StatsProvider extends Myprovider {
  final db = FirebaseFirestore.instance;
 int totaltempaltes=0;
 int totalscored=0;
  List<Map<String, dynamic>> revenues = [];
  List<Map<String, dynamic>> filteredRevenues = [];
  String my_selected_region = "";
  String totalvotes="0";
  int totalcontestants = 0;
  int totaljugdes = 0;
  bool adminshow=false;
  bool superadminshow=false;
  bool judgeshow=false;
  StatsProvider(){

  }

  List<Staff> staffList = [];
  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;


}
