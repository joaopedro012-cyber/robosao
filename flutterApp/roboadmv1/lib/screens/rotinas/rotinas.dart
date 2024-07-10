import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> getDirectoryPath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;
  return appDocumentsPath;
}

Future<File> createJsonFile(String fileName, Map<String, dynamic> data) async {
  final directory = await getDirectoryPath();
  File file = File('$directory/rotinassalvas/$fileName.json');
  await file.create(recursive: true);
  String jsonString = jsonEncode(data);
  await file.writeAsString(jsonString);
  return file;
}

Future<Map<String, dynamic>> readJsonFile(String fileName) async {
  try {
    final directory = await getDirectoryPath();
    File file = File('$directory/rotinassalvas/$fileName.json');
    String fileContents = await file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(fileContents);
    return jsonData;
  } catch (e) {
    return null; // Arquivo não encontrado ou erro ao ler
  }
}
Future<File> updateJsonFile(String fileName, Map<String, dynamic> newData) async {
  final directory = await getDirectoryPath();
  File file = File('$directory/rotinassalvas/$fileName.json');
  String jsonString = jsonEncode(newData);
  await file.writeAsString(jsonString);
  return file;
}
Future<void> deleteJsonFile(String fileName) async {
  final directory = await getDirectoryPath();
  File file = File('$directory/rotinassalvas/$fileName.json');
  if (await file.exists()) {
    await file.delete();
  }
}
