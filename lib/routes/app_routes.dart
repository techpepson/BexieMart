import 'package:bexie_mart/screens/launch_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (context, state) => const LaunchScreen()),
  ],
  initialLocation: "/",
);
