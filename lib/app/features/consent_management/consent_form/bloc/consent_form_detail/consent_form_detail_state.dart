part of 'consent_form_detail_bloc.dart';

abstract class ConsentFormDetailState extends Equatable {
  const ConsentFormDetailState();

  @override
  List<Object> get props => [];
}

class ConsentFormDetailInitial extends ConsentFormDetailState {
  const ConsentFormDetailInitial();

  @override
  List<Object> get props => [];
}

class ConsentFormDetailError extends ConsentFormDetailState {
  const ConsentFormDetailError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingConsentFormDetail extends ConsentFormDetailState {
  const GettingConsentFormDetail();

  @override
  List<Object> get props => [];
}

class GotConsentFormDetail extends ConsentFormDetailState {
  const GotConsentFormDetail(
    this.consentForm,
    this.mandatoryFields,
    this.purposeCategories,
    this.purposes,
    this.customFields,
    this.consentThemes,
    this.consentTheme,
  );

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
  final List<ConsentThemeModel> consentThemes;
  final ConsentThemeModel consentTheme;

  @override
  List<Object> get props => [
        consentForm,
        mandatoryFields,
        purposeCategories,
        purposes,
        customFields,
        consentThemes,
        consentTheme,
      ];
}
