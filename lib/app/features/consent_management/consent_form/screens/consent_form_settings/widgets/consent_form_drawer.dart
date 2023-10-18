import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/widgets/preview/purpose_radio_option.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class ConsentFormDrawer extends StatelessWidget {
  const ConsentFormDrawer({
    super.key,
    required this.consentForm,
    required this.customFields,
    required this.purposeCategories,
    required this.purposes,
    required this.consentTheme,
  });

  final ConsentFormModel consentForm;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final ConsentThemeModel consentTheme;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        surfaceTintColor: Theme.of(context).colorScheme.onBackground,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    consentForm.headerText.first.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: consentTheme.headerTextColor),
                  ),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                _buildHeaderDescription(context),
                _buildCustomFieldSection(context),
                _buildPurposeCategorySection(context),
                _buildFooterDescription(context),
                Row(
                  children: <Widget>[
                    CustomCheckBox(
                      value: false,
                      onChanged: (value) {},
                      activeColor: consentTheme.actionButtonColor,
                    ),
                    const SizedBox(width: UiConfig.actionSpacing),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: consentForm.acceptConsentText.first.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: consentTheme.formTextColor),
                            ),
                            const WidgetSpan(
                              child: SizedBox(width: UiConfig.textSpacing),
                            ),
                            TextSpan(
                              text: consentForm.linkToPolicyText.first.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: consentTheme.linkToPolicyTextColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.lineGap * 2),
                CustomButton(
                  height: 40.0,
                  onPressed: () {},
                  buttonColor: consentTheme.submitButtonColor,
                  splashColor: consentTheme.submitTextColor,
                  child: Text(
                    consentForm.acceptText.first.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: consentTheme.submitTextColor),
                  ),
                ),
                const SizedBox(height: UiConfig.lineGap),
                CustomButton(
                  height: 40.0,
                  onPressed: () {},
                  buttonColor: consentTheme.cancelButtonColor,
                  splashColor: consentTheme.cancelTextColor,
                  child: Text(
                    consentForm.cancelText.first.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: consentTheme.cancelTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Visibility _buildHeaderDescription(BuildContext context) {
    return Visibility(
      visible: consentForm.headerDescription.first.text.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: UiConfig.lineSpacing,
        ),
        child: Text(
          consentForm.headerDescription.first.text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: consentTheme.formTextColor),
        ),
      ),
    );
  }

  Visibility _buildFooterDescription(BuildContext context) {
    return Visibility(
      visible: consentForm.headerDescription.first.text.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            height: 0.1,
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: UiConfig.lineSpacing),
            child: Text(
              consentForm.footerDescription.first.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: consentTheme.formTextColor),
            ),
          ),
          Divider(
            height: 0.1,
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  Visibility _buildCustomFieldSection(BuildContext context) {
    final customFieldFiltered = UtilFunctions.filterCustomFieldsByIds(
      customFields,
      consentForm.customFields,
    );

    return Visibility(
      visible: customFieldFiltered.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.separated(
            shrinkWrap: true,
            itemCount: customFieldFiltered.length,
            itemBuilder: (context, index) => _buildCustomField(
              context,
              customField: customFieldFiltered[index],
            ),
            separatorBuilder: (context, _) => const SizedBox(
              height: UiConfig.lineSpacing,
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing)
        ],
      ),
    );
  }

  Column _buildCustomField(
    BuildContext context, {
    required CustomFieldModel customField,
  }) {
    return Column(
      children: <Widget>[
        TitleRequiredText(
          text: customField.title.first.text,
          // required: true,
        ),
        CustomTextField(
          hintText: customField.hintText.first.text,
        ),
      ],
    );
  }

  Visibility _buildPurposeCategorySection(BuildContext context) {
    final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
      purposeCategories,
      consentForm.purposeCategories,
    );

    return Visibility(
      visible: purposeCategoryFiltered.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.separated(
            shrinkWrap: true,
            itemCount: purposeCategoryFiltered.length,
            itemBuilder: (context, index) => _buildPurposeCategory(
              context,
              index: index + 1,
              purposeCategory: purposeCategoryFiltered[index],
            ),
            separatorBuilder: (context, _) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: UiConfig.lineSpacing,
              ),
              child: Divider(
                height: 0.1,
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  Row _buildPurposeCategory(
    BuildContext context, {
    required int index,
    required PurposeCategoryModel purposeCategory,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(11.0),
          decoration: BoxDecoration(
            color: consentTheme.categoryIconColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            index.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        const SizedBox(width: UiConfig.actionSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 11.0),
              Text(
                purposeCategory.title.first.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: consentTheme.categoryTitleTextColor),
              ),
              const SizedBox(height: UiConfig.lineGap),
              Text(
                purposeCategory.description.first.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: consentTheme.formTextColor),
              ),
              const SizedBox(height: UiConfig.lineGap),
              _buildPurposeSection(
                context,
                purposeCategory: purposeCategory,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Visibility _buildPurposeSection(
    BuildContext context, {
    required PurposeCategoryModel purposeCategory,
  }) {
    final purposeFiltered = UtilFunctions.filterPurposeByIds(
      purposes,
      purposeCategory.purposes,
    );

    return Visibility(
      visible: purposeFiltered.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.separated(
            shrinkWrap: true,
            itemCount: purposeFiltered.length,
            itemBuilder: (context, index) => PurposeRadioOption(
              purpose: purposeFiltered[index],
              consentTheme: consentTheme,
            ),
            separatorBuilder: (context, _) => const SizedBox(
              height: UiConfig.lineSpacing,
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }
}