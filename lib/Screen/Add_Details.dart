
import 'package:flutter/material.dart';
import '../Controllers/health_controller.dart';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({super.key});

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final stepsController = TextEditingController();
  final caloriesController = TextEditingController();
  final waterController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    nameController.dispose();
    stepsController.dispose();
    caloriesController.dispose();
    waterController.dispose();
    super.dispose();
  }

  // Choose date
  Future<void> chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  // Save health record
  void saveRecord() {
    if (!formKey.currentState!.validate()) return;

    HealthController.instance.addRecord(
        context: context,
      name: nameController.text.trim(),
      date: selectedDate,
      steps: int.parse(stepsController.text.trim()),
      calories: int.parse(caloriesController.text.trim()),
      water: int.parse(waterController.text.trim()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Health record saved successfully'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add health record',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Record your day',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2A3A),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Add your daily activity details below.',
              style: TextStyle(color: Color(0xFF8290A2)),
            ),

            const SizedBox(height: 24),

            _dateTile(),

            const SizedBox(height: 20),

            // User Name
            _field(
              'User Name',
              'Enter your Name',
              nameController,
              Icons.account_circle_rounded,
              isNumber: false,
            ),

            const SizedBox(height: 16),

            // Steps
            _field(
              'Steps walked',
              'e.g. 7850',
              stepsController,
              Icons.directions_walk_rounded,
            ),

            const SizedBox(height: 16),

            // Calories
            _field(
              'Calories burned (kcal)',
              'e.g. 420',
              caloriesController,
              Icons.local_fire_department_rounded,
            ),

            const SizedBox(height: 16),

            // Water
            _field(
              'Water intake (ml)',
              'e.g. 2000',
              waterController,
              Icons.water_drop_rounded,
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: saveRecord,
                icon: const Icon(Icons.check_rounded),
                label: const Text(
                  'Save health record',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2878E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Date selection tile
  Widget _dateTile() => InkWell(
        onTap: chooseDate,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF2878E5),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Text(
                'Change date',
                style: TextStyle(
                  color: Color(0xFF2878E5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );

  // Reusable input field
  Widget _field(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = true,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF344054),
            ),
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: controller,

            keyboardType: isNumber
                ? TextInputType.number
                : TextInputType.name,

            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF2878E5),
              ),
            ),

            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter $label';
              }

              // Validate only numeric fields
              if (isNumber) {
                final number = int.tryParse(value.trim());

                if (number == null || number < 0) {
                  return 'Enter a valid positive number';
                }
              }

              return null;
            },
          ),
        ],
      );
}
