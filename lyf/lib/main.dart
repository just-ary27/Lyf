import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyf/src/global/functions.dart';
import './src/app.dart';

/// EntryPoint for the app.
void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Services.
  await initServiceProvider();

  // Run Lyf.
  runApp(
    const ProviderScope(
      child: Lyf(),
    ),
  );
}
