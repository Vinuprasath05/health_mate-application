import 'package:flutter/material.dart';
import '../Controllers/health_controller.dart';
import 'view_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DateTime? selectedDate;

  Future<void> chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    final results = selectedDate == null ? [] : HealthController.instance.searchByDate(selectedDate!);
    return AnimatedBuilder(
      animation: HealthController.instance,
      builder: (context, _) {
        final currentResults = selectedDate == null ? [] : HealthController.instance.searchByDate(selectedDate!);
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
          children: [
            const Text('Find a record', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF1D2A3A))),
            const SizedBox(height: 6),
            const Text('Search your health history by date.', style: TextStyle(color: Color(0xFF8290A2))),
            const SizedBox(height: 24),
            InkWell(
              onTap: chooseDate,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Row(children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF2878E5)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(selectedDate == null ? 'Choose a date to search' : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}', style: const TextStyle(fontWeight: FontWeight.w600))),
                  const Icon(Icons.calendar_month_rounded, color: Color(0xFF8290A2)),
                ]),
              ),
            ),
            const SizedBox(height: 18),
            if (selectedDate == null)
              const Center(child: Padding(padding: EdgeInsets.all(25), child: Text('Select a date to view matching records.', style: TextStyle(color: Color(0xFF8290A2)))))
            else if (currentResults.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(25), child: Text('No record found for this date.', style: TextStyle(color: Color(0xFF8290A2)))))
            else
              ...currentResults.map((r) => Card(
                color: Colors.white, elevation: 0,
                child: ListTile(
                  leading: const Icon(Icons.event_note_rounded, color: Color(0xFF2878E5)),
                  title: Text('${r.steps} steps'),
                  subtitle: Text('${r.calories} kcal  •  ${r.water} ml water'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewListScreen(recordId: r.id))),
                ),
              )),
          ],
        );
      },
    );
  }
}
