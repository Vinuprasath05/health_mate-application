HEALTHMATE - SIMPLE FLUTTER UI SOURCE

Included screens:
- Dashboard: daily steps, calories, water and recent records
- Add_Details: add a daily record with date and input validation
- List: browse saved records
- Search: find a record by date
- view_list: view, edit and delete records
- Edit: update a selected record
- metric_card: reusable dashboard metric card

HOW TO USE
1. Open your existing Flutter project in VS Code.
2. Keep your existing lib folder as a backup.
3. Copy the folders and main.dart from this package into your project's lib folder.
   Folder names and capitalisation match the structure shown in your screenshot:
   Controllers, Models, Screen, widgets.
4. If your project has a different main.dart, back it up before replacing it.
5. Run:
      flutter pub get
      flutter run

IMPORTANT DATABASE NOTE
This is a UI starter version. The HealthController currently stores sample records in memory
so you can run and test the screens immediately. Records will reset when the app restarts.
It does NOT yet connect to your existing database_helper.dart / sqflite database.
For the coursework, connect the controller's add, update, delete, list and search methods
to your SQLite database before final submission.

The coursework requires sqflite and a health_records table with:
id (primary key), date (text), steps (integer), calories (integer), water (integer).
Do not submit this in-memory demo as your completed database implementation.
