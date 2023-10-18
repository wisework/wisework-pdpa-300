import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

import 'accept_consent_checkbox.dart';
import 'purpose_radio_option.dart';

class ConsentFormPreview extends StatefulWidget {
  const ConsentFormPreview({
    super.key,
    required this.consentForm,
    required this.customFields,
    required this.purposeCategories,
    required this.purposes,
    required this.consentTheme,
    this.onCustomFieldChanged,
    this.onPurposeChanged,
    this.onConsentAccepted,
    this.onSubmitted,
    this.isVerifyRequired = false,
  });

  final ConsentFormModel consentForm;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final ConsentThemeModel consentTheme;
  final Function(String customFieldId, String value)? onCustomFieldChanged;
  final Function(
    String purposeId,
    String categoryId,
    bool value,
  )? onPurposeChanged;
  final Function(bool value)? onConsentAccepted;
  final VoidCallback? onSubmitted;
  final bool isVerifyRequired;

  @override
  State<ConsentFormPreview> createState() => _ConsentFormPreviewState();
}

class _ConsentFormPreviewState extends State<ConsentFormPreview> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
      decoration: BoxDecoration(
        color: widget.consentTheme.backgroundColor,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: widget.consentTheme.bodyBackgroundColor,
        ),
        child: Column(
          children: <Widget>[
            Visibility(
              visible: widget.consentForm.logoImage.isNotEmpty ||
                  widget.consentForm.headerBackgroundImage.isNotEmpty,
              child: _buildHeaderImage(),
            ),
            _buildConsentForm(context),
            _buidActionButton(context),
          ],
        ),
      ),
    );
  }

  Container _buildHeaderImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.consentTheme.headerBackgroundColor,
        image: widget.consentForm.headerBackgroundImage.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(
                  widget.consentForm.headerBackgroundImage,
                ),
                fit: BoxFit.fitWidth,
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: UiConfig.lineSpacing,
        ),
        child: SizedBox(
          height: 90.0,
          child: Visibility(
            visible: widget.consentForm.logoImage.isNotEmpty,
            child: Image.network(
              widget.consentForm.logoImage,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Form _buildConsentForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
        decoration: BoxDecoration(
          image: widget.consentForm.bodyBackgroundImage.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(
                    widget.consentForm.bodyBackgroundImage,
                  ),
                  fit: BoxFit.fitHeight,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.consentForm.headerText.first.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: widget.consentTheme.headerTextColor),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildHeaderDescription(context),
            ),
            _buildCustomFieldSection(context),
            _buildPurposeCategorySection(context),
            _buildFooterDescription(context),
            AcceptConsentCheckbox(
              consentForm: widget.consentForm,
              consentTheme: widget.consentTheme,
              onChanged: (value) {
                if (widget.onConsentAccepted != null) {
                  widget.onConsentAccepted!(value);
                }
              },
            ),
            const SizedBox(height: UiConfig.lineGap),
          ],
        ),
      ),
    );
  }

  Visibility _buildHeaderDescription(BuildContext context) {
    return Visibility(
      visible: widget.consentForm.headerDescription.first.text.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: UiConfig.lineSpacing,
        ),
        child: Text(
          widget.consentForm.headerDescription.first.text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: widget.consentTheme.formTextColor),
        ),
      ),
    );
  }

  Visibility _buildFooterDescription(BuildContext context) {
    return Visibility(
      visible: widget.consentForm.headerDescription.first.text.isNotEmpty,
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
              widget.consentForm.footerDescription.first.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: widget.consentTheme.formTextColor),
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
      widget.customFields,
      widget.consentForm.customFields,
    );

    return Visibility(
      visible: customFieldFiltered.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
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
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TitleRequiredText(
          text: customField.title.first.text,
        ),
        CustomTextField(
          hintText: customField.hintText.first.text,
          keyboardType: customField.inputType,
          onChanged: (value) {
            if (widget.onCustomFieldChanged != null) {
              widget.onCustomFieldChanged!(customField.id, value);
            }
          },
          required: widget.isVerifyRequired,
        ),
      ],
    );
  }

  Visibility _buildPurposeCategorySection(BuildContext context) {
    final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
      widget.purposeCategories,
      widget.consentForm.purposeCategories,
    );

    return Visibility(
      visible: purposeCategoryFiltered.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
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
            color: widget.consentTheme.categoryIconColor,
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 11.0),
              Text(
                purposeCategory.title.first.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.consentTheme.categoryTitleTextColor),
              ),
              const SizedBox(height: UiConfig.lineGap),
              Text(
                purposeCategory.description.first.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: widget.consentTheme.formTextColor),
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
      widget.purposes,
      purposeCategory.purposes,
    );

    return Visibility(
      visible: purposeFiltered.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: purposeFiltered.length,
            itemBuilder: (context, index) => PurposeRadioOption(
              purpose: purposeFiltered[index],
              consentTheme: widget.consentTheme,
              onChanged: (value) {
                if (widget.onPurposeChanged != null) {
                  widget.onPurposeChanged!(
                    purposeFiltered[index].id,
                    purposeCategory.id,
                    value,
                  );
                }
              },
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

  Padding _buidActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: UiConfig.defaultPaddingSpacing,
        right: UiConfig.defaultPaddingSpacing,
        bottom: UiConfig.defaultPaddingSpacing,
      ),
      child: Column(
        children: <Widget>[
          CustomButton(
            height: 40.0,
            onPressed: () {
              if (widget.onSubmitted != null) {
                if (widget.isVerifyRequired) {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmitted!();
                  }
                } else {
                  widget.onSubmitted!();
                }
              }
            },
            buttonColor: widget.consentTheme.submitButtonColor,
            splashColor: widget.consentTheme.submitTextColor,
            child: Text(
              widget.consentForm.submitText.first.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: widget.consentTheme.submitTextColor),
            ),
          ),
          // const SizedBox(height: UiConfig.lineGap),
          // CustomButton(
          //   height: 40.0,
          //   onPressed: () {},
          //   buttonColor: widget.consentTheme.cancelButtonColor,
          //   splashColor: widget.consentTheme.cancelTextColor,
          //   child: Text(
          //     widget.consentForm.cancelText.first.text,
          //     style: Theme.of(context)
          //         .textTheme
          //         .bodyMedium
          //         ?.copyWith(color: widget.consentTheme.cancelTextColor),
          //   ),
          // ),
        ],
      ),
    );
  }
}