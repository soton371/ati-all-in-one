import 'dart:io';
import 'package:ati_all_in_one/models/apps_hub_mod.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppsHubDb {
  AppsHubDb._private();
  static final AppsHubDb instance = AppsHubDb._private();
  static const String tblAppsData = "APPS_DATA";

  Database? database;
  Future<Database> get getDatabase async => database ??= await initDatabase();

  Future<Database> initDatabase() async {
    Directory supportDirectory = await getApplicationSupportDirectory();
    String path = join(supportDirectory.path, 'appshubdb.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: onCreate,
    );
  }

  Future onCreate(Database db, int version) async {
    await db.execute("""
    CREATE TABLE $tblAppsData(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appOrder INTEGER,
    appName TEXT,
    appId TEXT,
    appImg TEXT,
    appUrl TEXT,
    appInstalled TEXT
    )
    """);
  }

  Future<int> addApp(AppsHubModel appsHubModel) async {
    debugPrint('call addApp');
    Database db = await instance.getDatabase;
    var addData = await db.insert(tblAppsData, appsHubModel.toJson());
    return addData;
  }

  Future<List<AppsHubModel>> getApps() async {
    debugPrint('call getApps');
    Database db = await instance.getDatabase;
    var apps = await db.query(tblAppsData, orderBy: 'appOrder');
    List<AppsHubModel> appsHubModel = apps.isNotEmpty
        ? apps.map((e) => AppsHubModel.fromJson(e)).toList()
        : [];
    debugPrint('appsHubModel sized: ${appsHubModel.length}');
    return appsHubModel;
  }

  Future deleteAllApps() async {
    debugPrint('call deleteAllApps');
    Database db = await instance.getDatabase;
    return await db.rawDelete("Delete from $tblAppsData");
  }

  Future<void> updateApp(int appOrder, String newAppInstalled) async {
  Database db = await instance.getDatabase;

  // Update the record.
  await db.update(
    tblAppsData,
    {'appInstalled': newAppInstalled},
    where: 'appOrder = ?',
    whereArgs: [appOrder],
  );
}

}
