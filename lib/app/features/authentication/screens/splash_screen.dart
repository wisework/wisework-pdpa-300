import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/authentication/routes/authentication_route.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _getCurrentUser();
  }

  void _getCurrentUser() {
    context.read<SignInBloc>().add(const GetCurrentUserEvent());
  }

  void _alreadySignedIn(UserModel user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome back!',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );

    if (user.companies.isEmpty || user.currentCompany.isEmpty) {
      context.pushReplacement(AuthenticationRoute.acceptInvite.path);
    } else {
      context.pushReplacement(GeneralRoute.home.path);
    }
  }

  void _redirectToSignIn() {
    context.pushReplacement(AuthenticationRoute.signIn.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) async {
            await Future.delayed(const Duration(milliseconds: 500)).then((_) {
              if (state is SignedInUser) {
                _alreadySignedIn(state.user);
              } else if (state is SignInInitial || state is SignInError) {
                _redirectToSignIn();
              }
            });
          },
          child: _buildWiseWorkLogo(),
        ),
      ),
    );
  }

  Widget _buildWiseWorkLogo() {
    final logo = SizedBox(
      width: 180.0,
      child: Image.asset(
        'assets/images/wisework-logo.png',
        fit: BoxFit.contain,
      ),
    );

    return logo
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.5))
        .animate()
        .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad);
  }
}