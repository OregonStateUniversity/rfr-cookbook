import 'package:flutter/material.dart';

void main() => runApp(const Page2());

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'The Cookbook';

    const treatments = ['Abdominal Pain',
      'Altered Mental Status', 'Anaphylaxis', 'Burns',
      'Cardiac Arrest - AED / CPR / HR CPR', 'Cardiac Arrest - Asystole',
      'Cardiac Arrest - PEA', 'Cardiac Arrest - VFib / Pulseless VT',
      'Cardiac Arrest - Post Resuscitation', 'Cardiac Dysrhythmaias - Bradycardia',
      'Cardiac Dysrhythmias - Tachycardia', 'Chest Pain / Acute Coronary Syndrom / STEMI'];

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent[700],
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: treatments.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(treatments[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}