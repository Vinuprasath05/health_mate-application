import 'package:flutter/material.dart';
import '../Controllers/health_controller.dart';
import 'view_list.dart';

class HealthListScreen extends StatelessWidget {
  const HealthListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: HealthController.instance,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
        children: [
          const Text('Health records', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF1D2A3A))),
          const SizedBox(height: 6),
          const Text('Review your daily health activity.', style: TextStyle(color: Color(0xFF8290A2))),
          const SizedBox(height: 20),
          ...HealthController.instance.records.map((record) => Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              leading: const CircleAvatar(backgroundColor: Color(0xFFE8F2FF), child: Icon(Icons.monitor_heart_rounded, color: Color(0xFF2878E5))),
              title: Text('${record.date.day}/${record.date.month}/${record.date.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${record.steps} steps  •  ${record.calories} kcal  •  ${record.water} ml', style: const TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewListScreen(recordId: record.id))),
            ),
          )),
          if (HealthController.instance.records.isEmpty)
            const Padding(padding: EdgeInsets.all(30), child: Center(child: Text('No records yet. Add your first record.'))),
        ],
      ),
    );
  }
}
