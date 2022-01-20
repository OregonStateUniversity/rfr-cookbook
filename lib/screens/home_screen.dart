import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rfr_cookbook/models/stored_item.dart';
import 'package:rfr_cookbook/search.dart';
import 'package:rfr_cookbook/storage_helper.dart';
import 'package:rfr_cookbook/styles.dart';
import 'admin_panel.dart';
import 'file_list.dart';
import 'login_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageHelper _storageHelper = StorageHelper();
  Map<String, List<StoredItem>> _storageMap = {};

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('theCookbook', style: Styles.navBarTitle),
          backgroundColor: Styles.themeColor,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _navigationToAdminPanel(context),
          ),
          actions: [
            IconButton(
                onPressed: () => _updateFiles(context),
                icon: const Icon(Icons.refresh)),
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchBar(
                          allSearchResults: titleList,
                          searchSuggestions: titleList));
                }),
          ],
        ),
        body: ListView.builder(
          itemCount: _storageMap.length,
          itemBuilder: _listViewItemBuilder,
        ));
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final targetDirectory = _storageMap.keys.toList()[index];
    final directoryName = targetDirectory.split('/').last;
    final fileList = _storageMap[targetDirectory];
    return Card(
      child: ListTile(
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: Text(directoryName, style: Styles.textDefault),
          onTap: () => _navigationToPdfList(context, directoryName, fileList!)),
    );
  }

  void _navigationToPdfList(
      BuildContext context, String sectionTitle, List<StoredItem> fileList) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FileList(fileList, sectionTitle)));
  }

  void _navigationToAdminPanel(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                user == null ? const LoginForm() : const AdminPanel()));
  }

  Future<void> _loadFiles() async {
    _storageHelper.updateFileState();
    final storageMap = await _storageHelper.storageMap();

    if (mounted) {
      setState(() {
        _storageMap = storageMap;
      });
    }
  }

  Future<void> _updateFiles(BuildContext context) async {
    _loadFiles();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        content: const Text('Checking for new files...',
            textAlign: TextAlign.center)));
  }
}

final titleList = [
  //0-Preface
  "00-010 Scope of Practice",
  "00-020 Advance Directives",
  "00-030 Death in the Field",
  "00-040 Glasgow Coma Scale",
  "00-050 Medical Control for Drugs & Procedures",
  "00-060 Universal Patient Care",
  "00-070 BLS Guidelines for single role EMT's",
  //1-Treatment
  "10-010 Abdominal Pain",
  "10-020 Altered Mental Status",
  "10-030 Anaphylaxis",
  "10-040 Burns",
  "10-050 Cardiac Arrest - AED-CPR-HP CPR",
  "10-051 Cardiac Arrest - Asystole",
  "10-052 Cardiac Arrest - PEA",
  "10-053 Cardiac Arrest - VF_Pulseless VT",
  "10-054 Cardiac Arrest - Post Resuscitation",
  "10-060 Cardiac Dysrhythmias - Bradycardia",
  "10-061 Cardiac Dysrhythmias - Tachycardia",
  "10-070 Chest Pain ACS",
  "10-080 Crush Injury",
  "10-090 Eye Emergencies",
  "10-100 Hyperkalemia",
  "10-110 Hypertension",
  "10-120 Hyperthermia",
  "10-130 Hypothermia",
  "10-140 Musculoskeletal Extremity Trauma",
  "10-141 Musculoskeletal Spinal Injury",
  "10-150 Nausea and Vomiting",
  "10-160 Neonatal Resuscitation",
  "10-170 OB GYN Emergencies",
  "10-180 Pain Management",
  "10-190 Poisoning and Overdose",
  "10-200 Respiratory Distress",
  "10-210 Seizures",
  "10-220 Shock",
  "10-230 Snakebike",
  "10-240 Stroke-CVA",
  "10-250 Submerged Patient",
  "10-260 Traumatic Brain Injury",
  //2-Medications
  //3-Procedures
  //4-Operations
  //5-Trauma
  //6-Hazmat
  //7-Misc
];

final suggestionList = [
  "10-180 Pain Management",
  "10-020 Altered Mental Status",
  "10-190 Poisoning and Overdose",
  "10-150 Nausea and Vomiting",
];
