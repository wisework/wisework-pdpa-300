// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'user_consent_form_event.dart';
part 'user_consent_form_state.dart';

class UserConsentFormBloc
    extends Bloc<UserConsentFormEvent, UserConsentFormState> {
  UserConsentFormBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _consentRepository = consentRepository,
        _masterDataRepository = masterDataRepository,
        super(const UserConsentFormInitial()) {
    on<GetUserConsentFormEvent>(_getUserConsentFormHandler);
    on<SubmitUserConsentFormEvent>(_submitUserConsentFormHandler);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getUserConsentFormHandler(
    GetUserConsentFormEvent event,
    Emitter<UserConsentFormState> emit,
  ) async {
    if (event.consentId.isEmpty) {
      emit(const UserConsentFormError('Required consent ID'));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const UserConsentFormError('Required company ID'));
      return;
    }

    emit(const GettingUserConsentForm());

    final result = await _consentRepository.getConsentFormById(
      event.consentId,
      event.companyId,
    );

    ConsentFormModel gotConsentForm = ConsentFormModel.empty();
    List<CustomFieldModel> gotCustomFields = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<PurposeModel> gotPurposes = [];
    ConsentThemeModel gotConsentTheme = ConsentThemeModel.initial();

    await result.fold(
      (failure) {
        emit(UserConsentFormError(failure.errorMessage));
        return;
      },
      (consentForm) async {
        gotConsentForm = consentForm;

        for (String customFieldId in consentForm.customFields) {
          final result = await _masterDataRepository.getCustomFieldById(
            customFieldId,
            event.companyId,
          );

          result.fold(
            (failure) => emit(UserConsentFormError(failure.errorMessage)),
            (customField) => gotCustomFields.add(customField),
          );
        }

        for (String purposeCategoryId in consentForm.purposeCategories) {
          final result = await _masterDataRepository.getPurposeCategoryById(
            purposeCategoryId,
            event.companyId,
          );

          await result.fold(
            (failure) {
              emit(UserConsentFormError(failure.errorMessage));
              return;
            },
            (purposeCategory) async {
              gotPurposeCategories.add(purposeCategory);

              for (String purposeId in purposeCategory.purposes) {
                final result = await _masterDataRepository.getPurposeById(
                  purposeId,
                  event.companyId,
                );

                result.fold(
                  (failure) => emit(
                    UserConsentFormError(failure.errorMessage),
                  ),
                  (purpose) => gotPurposes.add(purpose),
                );
              }
            },
          );
        }

        final result = await _consentRepository.getConsentThemeById(
          consentForm.consentThemeId,
          event.companyId,
        );

        result.fold(
          (failure) => emit(UserConsentFormError(failure.errorMessage)),
          (consentThemes) {
            gotConsentTheme = consentThemes;
          },
        );
      },
    );

    emit(
      GotUserConsentForm(
        gotConsentForm,
        gotCustomFields,
        gotPurposeCategories,
        gotPurposes,
        gotConsentTheme,
      ),
    );
  }

  Future<void> _submitUserConsentFormHandler(
    SubmitUserConsentFormEvent event,
    Emitter<UserConsentFormState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const UserConsentFormError('Required company ID'));
      return;
    }

    emit(const SubmittingUserConsentForm());

    final result = await _consentRepository.createUserConsent(
      event.userConsent,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(UserConsentFormError(failure.errorMessage)),
      (userConsent) => emit(
        SubmittedUserConsentForm(
          userConsent,
          event.consentForm,
        ),
      ),
    );
  }
}