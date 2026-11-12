
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/health_record.dart';
import '../provider/user_provider.dart';
import '../database/database_helper.dart'; // Change path if needed

class HealthController extends ChangeNotifier {
  HealthController._();

  static final HealthController instance = HealthController._();

  final DatabaseHelper _db = DatabaseHelper.instance;

  List<HealthRecord> _records = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // GET ALL RECORDS
  List<HealthRecord> get records {
    final result = [..._records];

    result.sort((a, b) => b.date.compareTo(a.date));

    return result;
  }

  // FORMAT DATE
  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  // CONVERT SQLITE DATA TO HEALTH RECORD
  HealthRecord _fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: (map['id'] as num).toInt(),
      date: DateTime.parse(map['date'] as String),
      steps: (map['steps'] as num).toInt(),
      calories: (map['calories'] as num).toInt(),
      water: (map['water'] as num).toInt(),
    );
  }

  // CONVERT HEALTH RECORD TO SQLITE DATA
  Map<String, dynamic> _toMap(HealthRecord record) {
    return {
      'date': _formatDate(record.date),
      'steps': record.steps,
      'calories': record.calories,
      'water': record.water,
    };
  }

  // READ - LOAD ALL RECORDS FROM SQLITE
  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _db.getAllRecords();

      _records = data.map((row) => _fromMap(row)).toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // GET TODAY'S HEALTH RECORD
  HealthRecord? get todayRecord {
    final today = _formatDate(DateTime.now());

    for (final record in _records) {
      if (_formatDate(record.date) == today) {
        return record;
      }
    }

    return null;
  }

  // CREATE - INSERT NEW HEALTH RECORD
  Future<void> addRecord({
    required BuildContext context,
    required String name,
    required DateTime date,
    required int steps,
    required int calories,
    required int water,
  }) async {
    final dateString = _formatDate(date);

    final existing = await _db.getRecordByDate(dateString);

    final record = {
      'date': dateString,
      'steps': steps,
      'calories': calories,
      'water': water,
    };

    if (existing != null) {
      // UPDATE IF SAME DATE ALREADY EXISTS
      await _db.updateRecord(
        (existing['id'] as num).toInt(),
        record,
      );
    } else {
      // INSERT NEW RECORD
      await _db.insertRecord(record);
    }

    // UPDATE USER NAME
    if (context.mounted) {
      Provider.of<UserProvider>(
        context,
        listen: false,
      ).updateUserName(name);
    }

    // REFRESH RECORDS
    await loadRecords();
  }

  // UPDATE - EDIT EXISTING RECORD
  Future<void> updateRecord(HealthRecord updated) async {
    final result = await _db.updateRecord(
      updated.id,
      _toMap(updated),
    );

    if (result > 0) {
      await loadRecords();
    }
  }

  // DELETE - REMOVE RECORD
  Future<void> deleteRecord(int id) async {
    final result = await _db.deleteRecord(id);

    if (result > 0) {
      await loadRecords();
    }
  }

  // SEARCH - SEARCH HEALTH RECORDS BY DATE
  List<HealthRecord> searchByDate(DateTime date) {
    final selectedDate = _formatDate(date);

    return records.where((record) {
      return _formatDate(record.date) == selectedDate;
    }).toList();
  }

  // READ - GET RECORD BY ID
  Future<HealthRecord?> getRecordById(int id) async {
    final data = await _db.getRecordById(id);

    if (data == null) {
      return null;
    }

    return _fromMap(data);
  }

  // REFRESH ALL RECORDS
  Future<void> refreshRecords() async {
    await loadRecords();
  }
}
