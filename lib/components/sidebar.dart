import 'package:ksoftsms/controller/myprovider.dart';
import 'package:ksoftsms/controller/statsprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (BuildContext context, value, Widget? child) {
        return Drawer(
          backgroundColor: Color(0xFF1C1D2A),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Color(0xFF2C2F3E)),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: Image(
                          image: AssetImage('assets/images/bookwormlogo.jpg'),
                          width: 80,
                          height: 80,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Bookworm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
               Flexible(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 10, bottom: 4),
                          child: Text(
                            "STUDENTS REGISTRATION",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: ExpansionTile(
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            leading: Icon(Icons.settings, color: Colors.white),
                            title: Text(
                              'Configurations',
                              style: TextStyle(color: Colors.white),
                            ),
                            children: [
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.military_tech,
                                  title: 'Term',
                                  onTap: () =>
                                      context.go(Routes.term),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.military_tech,
                                  title: 'Depart',
                                  onTap: () =>
                                      context.go(Routes.depart),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.military_tech,
                                  title: 'Class',
                                  onTap: () =>
                                      context.go(Routes.classes),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.military_tech,
                                  title: 'subject',
                                  onTap: () =>
                                      context.go(Routes.subjects),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.assignment,
                                  title: 'Students ',
                                  onTap: () => context.go(Routes.registerstudent,),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.military_tech,
                                  title: 'Region Registration',
                                  onTap: () => context.go(Routes.regionreg),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.military_tech,
                                  title: 'school',
                                  onTap: () => context.go(Routes.school),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.military_tech,
                                  title: 'score config',
                                  onTap: () => context.go(Routes.scoreconfig),
                                ),
                              ),
                              _drawerTile(
                                icon: Icons.cleaning_services_rounded,
                                title: 'Clear Results',
                                onTap: () => context.go(Routes.clearscores,),
                              ),
                              _drawerTile(
                                icon: Icons.cleaning_services_rounded,
                                title: 'Eviction',
                                onTap: () =>context.go(Routes.marks,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: _drawerTile(
                            icon: Icons.vpn_key,
                            title: 'Assess Components',
                            onTap: () =>context.go(Routes.accesscomponent,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: _drawerTile(
                            icon: Icons.vpn_key,
                            title: 'Contestants List',
                            onTap: () async{
                              context.go(Routes.viewstudentlist);
                            }
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 20, bottom: 4),
                          child: Text(
                            "JUDGE SETUP",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: ExpansionTile(
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            leading: Icon(Icons.people, color: Colors.white),
                            title: Text(
                              'Judge Data',
                              style: TextStyle(color: Colors.white),
                            ),
                            children: [

                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.person_add,
                                  title: 'Judge set up',
                                  onTap: () async {
                                    try {
                                      context.go(Routes.judgesetup,
                                      );
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                ),
                              ),

                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.person_add,
                                  title: 'View Judges',
                                  onTap: () async {
                                    try {
                                      context.go(Routes.judgelist,
                                      );
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.person_add,
                                  title: 'Contestant set up',
                                  onTap: () async {
                                    try {
                                      context.go(Routes.contestantsetup,
                                      );
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                ),
                              ),


                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 20, bottom: 4),
                          child: Text(
                            "USER MANAGEMENT",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: ExpansionTile(
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            leading: Icon(Icons.people, color: Colors.white),
                            title: Text(
                              'User Management',
                              style: TextStyle(color: Colors.white),
                            ),
                            children: [
                              _drawerTile(
                                icon: Icons.person_add,
                                title: 'Add Staff',
                                onTap: () async {
                                  try {
                                    context.go(Routes.regstaff);
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              ),
                              _drawerTile(
                                icon: Icons.view_list,
                                title: 'View Staff',
                                onTap: () async {
                                  try {
                                    context.go(Routes.viewstaff);
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 20, bottom: 4),
                          child: Text(
                            "MANAGE CONTESTANTS RESULTS",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: ExpansionTile(
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            leading: Icon(Icons.description_outlined, color: Colors.white),
                            title: Text(
                              'Contestants Results',
                              style: TextStyle(color: Colors.white),
                            ),
                            children: [

                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.grid_view_sharp,
                                  title: 'View Results',
                                  onTap: () async {
                                    try {
                                      context.go(Routes.viewscore);
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                ),
                              ),

                              // SizedBox(
                              //   child: _drawerTile(
                              //     icon: Icons.insert_page_break,
                              //     title: 'Enter Judge Results',
                              //     onTap: () async {
                              //       try {
                              //         context.go(Routes.adminresults,
                              //         );
                              //       } catch (e) {
                              //         print(e);
                              //       }
                              //     },
                              //   ),
                              // ),

                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.calendar_month,
                                  title: 'Votes',
                                  onTap: () =>
                                      context.go(Routes.votes),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.calendar_month,
                                  title: 'test vote',
                                  onTap: () =>
                                      context.go(Routes.testvote),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.calendar_month,
                                  title: 'view votes  test',
                                  onTap: () =>
                                      context.go(Routes.rawvote),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 20, bottom: 4),
                          child: Text(
                            "REPORTS",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: ExpansionTile(
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            leading: Icon(
                              Icons.insert_chart,
                              color: Colors.white,
                            ),
                            title: Text(
                              'Reports',
                              style: TextStyle(color: Colors.white),
                            ),
                            children: [
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.calendar_month,
                                  title: 'Contestant Sheet',
                                  onTap: () =>  context.go(Routes.scoresheet),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.calendar_month,
                                  title: 'Judge Sheet',
                                  onTap: () => context.go(Routes.judgescoresheet,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.calendar_month,
                                  title: 'weekly Sheet',
                                  onTap: () =>  context.go(Routes.weeklysheet,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.calendar_month,
                                  title: 'Eviction',
                                  onTap: () =>  context.go(Routes.eviction),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.calendar_month,
                                  title: 'Best Criteria',
                                  onTap: () =>  context.go(Routes.bestcriteria,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: _drawerTile(
                                  icon: Icons.calendar_month,
                                  title: 'Terminal report',
                                  onTap: () =>context.go(Routes.terminalreport,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.white24, height: 30),
                        SizedBox(
                          child: _drawerTile(
                            icon: Icons.logout,
                            title: 'Logout',
                            onTap: () async {
                            // await value.logout(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _drawerTile({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    contentPadding: EdgeInsets.only(left: 24.0),
    leading: Icon(icon, color: Colors.white70, size: 20),
    title: Text(title, style: TextStyle(color: Colors.white)),
    onTap: onTap,
    hoverColor: Colors.white10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
