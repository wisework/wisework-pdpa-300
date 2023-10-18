part of 'user_consent_form_bloc.dart';

abstract class UserConsentFormState extends Equatable {
  const UserConsentFormState();

  @override
  List<Object> get props => [];
}

final class UserConsentFormInitial extends UserConsentFormState {
  const UserConsentFormInitial();

  @override
  List<Object> get props => [];
}

final class UserConsentFormError extends UserConsentFormState {
  const UserConsentFormError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingUserConsentForm extends UserConsentFormState {
  const GettingUserConsentForm();

  @override
  List<Object> get props => [];
}

class GotUserConsentForm extends UserConsentFormState {
  const GotUserConsentForm(
    this.consentForm,
    this.customFields,
    this.purposeCategories,
    this.purposes,
    this.consentTheme,
  );

  final ConsentFormModel consentForm;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final ConsentThemeModel consentTheme;

  @override
  List<Object> get props {
    return [
      consentForm,
      customFields,
      purposeCategories,
      purposes,
      consentTheme,
    ];
  }
}

class SubmittingUserConsentForm extends UserConsentFormState {
  const SubmittingUserConsentForm();

  @override
  List<Object> get props => [];
}

class SubmittedUserConsentForm extends UserConsentFormState {
  const SubmittedUserConsentForm(
    this.userConsent,
    this.consentForm,
  );

  final UserConsentModel userConsent;
  final ConsentFormModel consentForm;

  @override
  List<Object> get props => [userConsent, consentForm];
}