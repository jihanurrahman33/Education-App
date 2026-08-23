import 'package:flutter/material.dart';
import 'core/app/app.dart';
import 'core/app/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator and feature dependencies
  await initGlobalDependencies();

  runApp(const EducationApp());
}
