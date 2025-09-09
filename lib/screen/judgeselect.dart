import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ksoftsms/controller/routes.dart';
import '../controller/myprovider.dart';
import 'dropdown.dart';

class JudgeSelect extends StatefulWidget {
  const JudgeSelect({super.key});

  @override
  State<JudgeSelect> createState() => _JudgeSelectState();
}

class _JudgeSelectState extends State<JudgeSelect> {
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<Myprovider>().fetchRegion();
    });

  }

  String? level;
  String? selectedLevel;
  String? selectedEpisodeName;
  String? myRegion;

  @override
  Widget build(BuildContext context) {
    final inputFill = const Color(0xFF2C2C3C);
    return Consumer<Myprovider>(
      builder: (BuildContext context, value, child) {
        return  Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D2F45),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go(Routes.dashboard),
            ),
            title:  Text(
              'Select Level',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                  constraints:BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          value.loadingRegion
                              ? const CircularProgressIndicator()
                              : DropdownButtonFormField<String>(
                            value: myRegion,
                            items: value.regs
                                .map(
                                  (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(
                                  cat,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                            dropdownColor: inputFill,
                            onChanged: (value) {
                              setState(() {
                                myRegion = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Contestant Region",
                              labelStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              filled: true,
                              fillColor: inputFill,
                            ),
                            validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Please select a category'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: level,
                            items: value.levelss.map(
                            (cat) => DropdownMenuItem(
                                value: cat.levelname,
                                child: Text(
                                  cat.levelname,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ).toList(),
                            dropdownColor: inputFill,
                            onChanged: (value) {
                              setState(() {
                                level = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Level Category",
                              labelStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              filled: true,
                              fillColor: inputFill,
                            ),
                            validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Please select a level'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          CustomDropdown(
                            label: "Episode",
                            items: value.episodes.map((e) => e.episodename).toList(),
                            value: selectedEpisodeName,
                            isLoading: value.loadingEpisodes,
                            onChanged: (val) {
                              setState(() {
                                selectedEpisodeName = val;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            onPressed:value.isLoading?null: () async{

                              value.isLoading;
                              if (level == null || level!.isEmpty|| selectedEpisodeName == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select a level and episode before continuing."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              await value.setContestantvoteDetails(voteslevel: level!, votesepisode: selectedEpisodeName!, votesregion: myRegion!, pagekeyvote: 'votes3310');
                              await value.votesdata();
                              if(!mounted) return;

                              Navigator.pushNamed(context, Routes.votinglist);
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label:  value.isLoading
                                ? const Text("Loading contestants...")
                                : const Text("Continue"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
            ),
          );
      },
    );
  }
}
