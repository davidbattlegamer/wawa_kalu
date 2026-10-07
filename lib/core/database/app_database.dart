import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../features/children/models/child.dart';

import '../../features/growth/models/growth_measurement.dart';

import '../../features/vaccines/models/vaccine_record.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance =
      AppDatabase._();

  static const String _databaseName =
      'wawa_kalu.db';

  // ==========================================================================
  // VERSIÓN DE BASE DE DATOS
  //
  // v1 = perfiles
  // v2 = vacunas
  // v3 = crecimiento
  // v4 = perímetro cefálico
  // ==========================================================================

  static const int _databaseVersion = 4;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database =
        await _openDatabase();

    return _database!;
  }

  Future<Database>
      _openDatabase() async {
    final String databasesPath =
        await getDatabasesPath();

    final String path = p.join(
      databasesPath,
      _databaseName,
    );

    return openDatabase(
      path,
      version:
          _databaseVersion,

      // ----------------------------------------------------------------------
      // ACTIVAR FOREIGN KEYS
      // ----------------------------------------------------------------------

      onConfigure: (
        db,
      ) async {
        await db.execute(
          'PRAGMA foreign_keys = ON',
        );
      },

      onCreate:
          _onCreate,

      onUpgrade:
          _onUpgrade,
    );
  }

  // ==========================================================================
  // CREATE
  // ==========================================================================

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    // ------------------------------------------------------------------------
    // CHILDREN
    // ------------------------------------------------------------------------

    await db.execute(
      '''
      CREATE TABLE children (
        id TEXT PRIMARY KEY,

        name TEXT NOT NULL,

        birth_date TEXT NOT NULL,

        sex TEXT NOT NULL,

        photo_path TEXT,

        created_at TEXT NOT NULL
      )
      ''',
    );

    // ------------------------------------------------------------------------
    // APP STATE
    // ------------------------------------------------------------------------

    await db.execute(
      '''
      CREATE TABLE app_state (
        key TEXT PRIMARY KEY,

        value TEXT
      )
      ''',
    );

    // ------------------------------------------------------------------------
    // VACUNAS
    // ------------------------------------------------------------------------

    await _createVaccineRecordsTable(
      db,
    );

    // ------------------------------------------------------------------------
    // CRECIMIENTO
    // ------------------------------------------------------------------------

    await _createGrowthMeasurementsTable(
      db,
    );
  }

  // ==========================================================================
  // MIGRACIONES
  // ==========================================================================

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // ------------------------------------------------------------------------
    // VERSIONES ANTERIORES A VACUNAS
    // ------------------------------------------------------------------------

    if (oldVersion < 2) {
      await _createVaccineRecordsTable(
        db,
      );
    }

    // ------------------------------------------------------------------------
    // VERSIONES ANTERIORES A CRECIMIENTO
    // ------------------------------------------------------------------------

    if (oldVersion < 3) {
      await _createGrowthMeasurementsTable(
        db,
      );
    }

    // ------------------------------------------------------------------------
    // V3 -> V4
    //
    // Agrega perímetro cefálico sin borrar controles existentes.
    // ------------------------------------------------------------------------

    if (oldVersion >= 3 &&
        oldVersion < 4) {
      await db.execute(
        '''
        ALTER TABLE growth_measurements
        ADD COLUMN head_circumference_cm REAL
        ''',
      );
    }
  }

  // ==========================================================================
  // TABLA VACUNAS
  // ==========================================================================

  Future<void>
      _createVaccineRecordsTable(
    Database db,
  ) async {
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS vaccine_records (
        id TEXT PRIMARY KEY,

        child_id TEXT NOT NULL,

        schedule_id TEXT NOT NULL,

        vaccine_code TEXT NOT NULL,

        applied_date TEXT NOT NULL,

        health_center TEXT,

        notes TEXT,

        created_at TEXT NOT NULL,

        FOREIGN KEY (child_id)
          REFERENCES children(id)
          ON DELETE CASCADE,

        UNIQUE(child_id, schedule_id)
      )
      ''',
    );

    await db.execute(
      '''
      CREATE INDEX IF NOT EXISTS
      idx_vaccine_records_child
      ON vaccine_records(
        child_id
      )
      ''',
    );
  }

  // ==========================================================================
  // TABLA CRECIMIENTO
  // ==========================================================================

  Future<void>
      _createGrowthMeasurementsTable(
    Database db,
  ) async {
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS growth_measurements (
        id TEXT PRIMARY KEY,

        child_id TEXT NOT NULL,

        measured_at TEXT NOT NULL,

        weight_kg REAL NOT NULL,

        height_cm REAL NOT NULL,

        head_circumference_cm REAL,

        measurement_type TEXT NOT NULL,

        notes TEXT,

        created_at TEXT NOT NULL,

        FOREIGN KEY (child_id)
          REFERENCES children(id)
          ON DELETE CASCADE
      )
      ''',
    );

    await db.execute(
      '''
      CREATE INDEX IF NOT EXISTS
      idx_growth_measurements_child_date
      ON growth_measurements(
        child_id,
        measured_at
      )
      ''',
    );
  }

  // ==========================================================================
  // CHILDREN
  // ==========================================================================

  Future<List<Child>>
      getChildren() async {
    final Database db =
        await database;

    final result =
        await db.query(
      'children',

      orderBy:
          'created_at ASC',
    );

    return result
        .map(
          (
            map,
          ) =>
              Child.fromMap(
            map,
          ),
        )
        .toList();
  }

  Future<void> insertChild(
    Child child,
  ) async {
    final Database db =
        await database;

    await db.insert(
      'children',

      child.toMap(),

      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<void> updateChild(
    Child child,
  ) async {
    final Database db =
        await database;

    await db.update(
      'children',

      child.toMap(),

      where:
          'id = ?',

      whereArgs: [
        child.id,
      ],
    );
  }

  Future<void> deleteChild(
    String id,
  ) async {
    final Database db =
        await database;

    await db.delete(
      'children',

      where:
          'id = ?',

      whereArgs: [
        id,
      ],
    );
  }

  // ==========================================================================
  // VACCINES
  // ==========================================================================

  Future<List<VaccineRecord>>
      getVaccineRecords(
    String childId,
  ) async {
    final Database db =
        await database;

    final result =
        await db.query(
      'vaccine_records',

      where:
          'child_id = ?',

      whereArgs: [
        childId,
      ],

      orderBy:
          'applied_date ASC',
    );

    return result
        .map(
          (
            map,
          ) =>
              VaccineRecord.fromMap(
            map,
          ),
        )
        .toList();
  }

  Future<void>
      saveVaccineRecord(
    VaccineRecord record,
  ) async {
    final Database db =
        await database;

    await db.insert(
      'vaccine_records',

      record.toMap(),

      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<void>
      deleteVaccineRecord(
    String id,
  ) async {
    final Database db =
        await database;

    await db.delete(
      'vaccine_records',

      where:
          'id = ?',

      whereArgs: [
        id,
      ],
    );
  }

  // ==========================================================================
  // GROWTH
  // ==========================================================================

  Future<List<GrowthMeasurement>>
      getGrowthMeasurements(
    String childId,
  ) async {
    final Database db =
        await database;

    final result =
        await db.query(
      'growth_measurements',

      where:
          'child_id = ?',

      whereArgs: [
        childId,
      ],

      orderBy:
          'measured_at DESC, created_at DESC',
    );

    return result
        .map(
          (
            map,
          ) =>
              GrowthMeasurement.fromMap(
            map,
          ),
        )
        .toList();
  }

  Future<GrowthMeasurement?>
      getLatestGrowthMeasurement(
    String childId,
  ) async {
    final Database db =
        await database;

    final result =
        await db.query(
      'growth_measurements',

      where:
          'child_id = ?',

      whereArgs: [
        childId,
      ],

      orderBy:
          'measured_at DESC, created_at DESC',

      limit:
          1,
    );

    if (result.isEmpty) {
      return null;
    }

    return GrowthMeasurement.fromMap(
      result.first,
    );
  }

  Future<void>
      insertGrowthMeasurement(
    GrowthMeasurement measurement,
  ) async {
    final Database db =
        await database;

    await db.insert(
      'growth_measurements',

      measurement.toMap(),

      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<void>
      updateGrowthMeasurement(
    GrowthMeasurement measurement,
  ) async {
    final Database db =
        await database;

    await db.update(
      'growth_measurements',

      measurement.toMap(),

      where:
          'id = ?',

      whereArgs: [
        measurement.id,
      ],
    );
  }

  Future<void>
      deleteGrowthMeasurement(
    String id,
  ) async {
    final Database db =
        await database;

    await db.delete(
      'growth_measurements',

      where:
          'id = ?',

      whereArgs: [
        id,
      ],
    );
  }

  // ==========================================================================
  // APP STATE
  // ==========================================================================

  Future<String?> getState(
    String key,
  ) async {
    final Database db =
        await database;

    final result =
        await db.query(
      'app_state',

      columns: [
        'value',
      ],

      where:
          'key = ?',

      whereArgs: [
        key,
      ],

      limit:
          1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first[
        'value'] as String?;
  }

  Future<void> setState(
    String key,
    String value,
  ) async {
    final Database db =
        await database;

    await db.insert(
      'app_state',

      {
        'key':
            key,
        'value':
            value,
      },

      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteState(
    String key,
  ) async {
    final Database db =
        await database;

    await db.delete(
      'app_state',

      where:
          'key = ?',

      whereArgs: [
        key,
      ],
    );
  }

  // ==========================================================================
  // CLOSE
  // ==========================================================================

  Future<void> close() async {
    final Database? db =
        _database;

    if (db == null) {
      return;
    }

    await db.close();

    _database = null;
  }
}