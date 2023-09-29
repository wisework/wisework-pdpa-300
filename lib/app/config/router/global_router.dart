import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/authentication/routes/authentication_route.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';

class GlobalRouter {
  static final String initial = AuthenticationRoute.splash.path;

  static GoRouter get router {
    return GoRouter(
      initialLocation: initial,
      routes: [
        ...AuthenticationRoute.routes,
        ...GeneralRoute.routes,
      ],
    );
  }
}