import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/modal_widget.dart';
import 'package:bexie_mart/screens/launch_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder:
          (context, state) => ModalWidget(
            title: "Done",
            description: "Go to your homepage to experience app features.",
            buttonTitle: "Go to Homepage",
            buttonAction: () {
              print("Go to Homepage");
            },
          ),
    ),
  ],
  initialLocation: "/",
);
