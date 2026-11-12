import 'package:flutter/material.dart';
import '../Controllers/health_controller.dart';
import '../widgets/metric_card.dart';
import 'view_list.dart';
import '../provider/user_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _dateText(DateTime date) => '${_month(date.month)} ${date.day}, ${date.year}';
  String _month(int month) => const ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][month - 1];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: HealthController.instance,
      builder: (context, _) {
        final record = HealthController.instance.todayRecord;
        final steps = record?.steps ?? 0;
        final calories = record?.calories ?? 0;
        final water = record?.water ?? 0;
        final abc = context.watch<UserProvider>();
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
          children: [
            Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(color: const Color(0xFFE4F0FF), borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.favorite_rounded, color: Color(0xFFF44336), size: 25),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HealthMate', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF1D2A3A))),
                    Text('Your daily wellness companion', style: TextStyle(fontSize: 12, color: Color(0xFF8290A2))),
                  ],
                )),
                const CircleAvatar(backgroundColor: Color(0xFFEAF7F0), child: Icon(Icons.person_rounded, color: Color(0xFF28A66A))),
              ],
            ),
            const SizedBox(height: 28),
            Text('Good day! 👋 ${abc.userName}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF1D2A3A))),
            const SizedBox(height: 5),
            Text('Here is your health summary for ${_dateText(DateTime.now())}.', style: const TextStyle(color: Color(0xFF8290A2), fontSize: 13)),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2878E5), Color(0xFF55A2F2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("TODAY'S OVERVIEW", style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.1, fontWeight: FontWeight.w600)),
                      SizedBox(height: 9),
                      Text('Small steps,Stronger you.', style: TextStyle(color: Colors.white, fontSize: 23, height: 1.25, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Keep building healthy habits.', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  )),
                  Container(
                    width: 76, height: 76,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(.17), shape: BoxShape.circle),
                    child: const Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 42),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Your activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2A3A))),
            const SizedBox(height: 13),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.80,
              children: [
                MetricCard(title: 'Steps walked', value: steps.toString(), unit: 'steps', icon: Icons.directions_walk_rounded, color: const Color(0xFF2878E5), background: const Color(0xFFE8F2FF)),
                MetricCard(title: 'Calories burned', value: calories.toString(), unit: 'kcal', icon: Icons.local_fire_department_rounded, color: const Color(0xFFF07842), background: const Color(0xFFFFEFE7)),
                MetricCard(title: 'Water intake', value: water.toString(), unit: 'ml', icon: Icons.water_drop_rounded, color: const Color(0xFF249AD6), background: const Color(0xFFE5F6FF)),
                MetricCard(title: 'Daily goal', value: steps >= 8000 ? 'Done' : '${((steps / 8000) * 100).round()}%', unit: 'steps', icon: Icons.flag_rounded, color: const Color(0xFF27A66A), background: const Color(0xFFE7F7EF)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2A3A))),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewListScreen())),
                  child: const Text('See all'),
                ),
              ],
            ),
            ...HealthController.instance.records.take(2).map((r) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Color(0xFFE8F2FF), child: Icon(Icons.calendar_today_rounded, color: Color(0xFF2878E5), size: 18)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_dateText(r.date), style: const TextStyle(fontWeight: FontWeight.w600))),
                  Text('${r.steps} steps', style: const TextStyle(color: Color(0xFF718096), fontSize: 12)),
                ],
              ),
            )),
          ],
        );
      },
    );
  }
}
