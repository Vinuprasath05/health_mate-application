import 'package:flutter/material.dart';
import '../Controllers/health_controller.dart';
import '../Models/health_record.dart';

class EditScreen extends StatefulWidget {
  final HealthRecord record;
  const EditScreen({super.key, required this.record});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController steps;
  late final TextEditingController calories;
  late final TextEditingController water;

  @override
  void initState() {
    super.initState();
    steps = TextEditingController(text: widget.record.steps.toString());
    calories = TextEditingController(text: widget.record.calories.toString());
    water = TextEditingController(text: widget.record.water.toString());
  }

  @override
  void dispose() {
    steps.dispose(); calories.dispose(); water.dispose();
    super.dispose();
  }

  void save() {
    if (!formKey.currentState!.validate()) return;
    HealthController.instance.updateRecord(widget.record.copyWith(
      steps: int.parse(steps.text), calories: int.parse(calories.text), water: int.parse(water.text),
    ));
    Navigator.pop(context);
  }

  Widget field(String label, TextEditingController controller, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: const Color(0xFF2878E5))),
      validator: (v) {
        final n = int.tryParse(v ?? '');
        if (n == null || n < 0) return 'Enter a valid number';
        return null;
      },
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edit record', style: TextStyle(fontWeight: FontWeight.bold))),
    body: Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Update your activity', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 22),
          field('Steps walked', steps, Icons.directions_walk_rounded),
          field('Calories burned (kcal)', calories, Icons.local_fire_department_rounded),
          field('Water intake (ml)', water, Icons.water_drop_rounded),
          const SizedBox(height: 10),
          SizedBox(height: 52, child: FilledButton(onPressed: save, child: const Text('Save changes'))),
        ],
      ),
    ),
  );
}
