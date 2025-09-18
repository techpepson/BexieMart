import 'package:flutter/material.dart';
import 'package:bexie_mart/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MaterialApp.router(routerConfig: appRouter)));
}
