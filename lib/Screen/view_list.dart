import 'package:flutter/material.dart';
import '../Controllers/health_controller.dart';
import '../Models/health_record.dart';
import 'Edit.dart';

class ViewListScreen extends StatelessWidget {
  final int? recordId;
  const ViewListScreen({super.key, this.recordId});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: HealthController.instance,
      builder: (context, _) {
        final records = recordId == null
          ? HealthController.instance.records
          : HealthController.instance.records.where((r) => r.id == recordId).toList();
        return Scaffold(
          appBar: AppBar(title: Text(recordId == null ? 'All records' : 'Record details', style: const TextStyle(fontWeight: FontWeight.bold))),
          body: records.isEmpty
            ? const Center(child: Text('Record not found.'))
            : ListView(
                padding: const EdgeInsets.all(20),
                children: records.map((r) => _recordCard(context, r)).toList(),
              ),
        );
      },
    );
  }

  Widget _recordCard(BuildContext context, HealthRecord r) => Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('${r.date.day}/${r.date.month}/${r.date.year}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 18),
      _line(Icons.directions_walk_rounded, 'Steps walked', '${r.steps} steps', const Color(0xFF2878E5)),
      _line(Icons.local_fire_department_rounded, 'Calories burned', '${r.calories} kcal', const Color(0xFFF07842)),
      _line(Icons.water_drop_rounded, 'Water intake', '${r.water} ml', const Color(0xFF249AD6)),
      const SizedBox(height: 15),
      Row(children: [
        Expanded(child: OutlinedButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditScreen(record: r))),
          icon: const Icon(Icons.edit_outlined), label: const Text('Edit'),
        )),
        const SizedBox(width: 10),
        Expanded(child: FilledButton.tonalIcon(
          onPressed: () => _confirmDelete(context, r),
          icon: const Icon(Icons.delete_outline_rounded), label: const Text('Delete'),
          style: FilledButton.styleFrom(foregroundColor: Colors.red),
        )),
      ]),
    ]),
  );

  Widget _line(IconData icon, String title, String value, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(children: [
      Icon(icon, color: color),
      const SizedBox(width: 12),
      Expanded(child: Text(title, style: const TextStyle(color: Color(0xFF718096)))),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ]),
  );

  Future<void> _confirmDelete(BuildContext context, HealthRecord r) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete record?'),
        content: const Text('Are you sure you want to delete this health record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      HealthController.instance.deleteRecord(r.id);
      if (context.mounted) Navigator.pop(context);
    }
  }
}
