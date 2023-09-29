part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInWithGoogleEvent extends SignInEvent {
  const SignInWithGoogleEvent();

  @override
  List<Object> get props => [];
}

class SignOutEvent extends SignInEvent {
  const SignOutEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentUserEvent extends SignInEvent {
  const GetCurrentUserEvent();

  @override
  List<Object> get props => [];
}

class UpdateCurrentUserEvent extends SignInEvent {
  const UpdateCurrentUserEvent({
    required this.user,
    required this.companies,
  });

  final UserModel user;
  final List<CompanyModel> companies;

  @override
  List<Object> get props => [user, companies];
}