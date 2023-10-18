// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/etc/user_input_field.dart';
import 'package:pdpa/app/data/models/etc/user_input_option.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';

part 'current_user_consent_form_state.dart';

class CurrentUserConsentFormCubit extends Cubit<CurrentUserConsentFormState> {
  CurrentUserConsentFormCubit()
      : super(CurrentUserConsentFormState(
          userConsent: UserConsentModel.empty(),
        ));

  Future<void> initialUserConsent(
    ConsentFormModel consentForm,
    List<PurposeCategoryModel> purposeCategories,
  ) async {
    final customFieldValues = consentForm.customFields
        .map((id) => UserInputField(id: id, value: ''))
        .toList();

    List<UserInputOption> purposeValues = [];
    for (PurposeCategoryModel category in purposeCategories) {
      final values = category.purposes
          .map(
            (id) => UserInputOption(
              id: id,
              parentId: category.id,
              value: true,
            ),
          )
          .toList();
      purposeValues.addAll(values);
    }

    final updated = state.userConsent.copyWith(
      consentFormId: consentForm.id,
      customFields: customFieldValues,
      purposes: purposeValues,
    );

    emit(state.copyWith(userConsent: updated));
  }

  void setUserConsentForm(UserConsentModel userConsent) {
    emit(state.copyWith(userConsent: userConsent));
  }
}