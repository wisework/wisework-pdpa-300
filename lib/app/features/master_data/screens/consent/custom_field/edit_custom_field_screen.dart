import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditCustomFieldScreen extends StatelessWidget {
  const EditCustomFieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditCustomFieldView();
  }
}

class EditCustomFieldView extends StatefulWidget {
  const EditCustomFieldView({super.key});

  @override
  State<EditCustomFieldView> createState() => _EditCustomFieldViewState();
}

class _EditCustomFieldViewState extends State<EditCustomFieldView> {
  late TextEditingController titleController;
  late TextEditingController placeHolderController;
  late TextEditingController customFieldTypeController;
  late TextEditingController lenghtLimitController;
  late TextEditingController minLineController;
  late TextEditingController maxLineController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    placeHolderController = TextEditingController();
    customFieldTypeController = TextEditingController();
    lenghtLimitController = TextEditingController();
    minLineController = TextEditingController();
    maxLineController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: _buildCustomFieldForm(context),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildCustomFieldForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              tr('masterdata.consentmasterdata.customfields.name'), //!
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(
          text: 'masterdata.consentmasterdata.customfields.title',
          required: true,
        ),
        CustomTextField(
          controller: titleController,
          hintText: 'Enter title',
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(
          text: 'masterdata.consentmasterdata.customfields.placeholder',
          required: true,
        ),
        CustomTextField(
          controller: placeHolderController,
          hintText: 'Enter place holder',
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(
          text: 'masterdata.consentmasterdata.customfields.customfieldtype',
          required: true,
        ),
        CustomTextField(
          controller: customFieldTypeController,
          hintText: 'Enter customFieldType',
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(
          text: 'masterdata.consentmasterdata.customfields.lenghtlimit',
          required: true,
        ),
        const CustomTextField(
          hintText: 'Enter lenght limit',
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(
          text: 'masterdata.consentmasterdata.customfields.maxline',
          required: true,
        ),
        const CustomTextField(
          hintText: 'Enter max line',
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(
          text: 'masterdata.consentmasterdata.customfields.minline',
          required: true,
        ),
        const CustomTextField(
          hintText: 'Enter min line',
        ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          CustomIconButton(
            onPressed: () {
              context.pop();
            },
            icon: Ionicons.chevron_back_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          const SizedBox(width: UiConfig.appBarTitleSpacing),
          Text(
            tr('masterdata.consentmasterdata.customfields.edit'), //!
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      actions: [
        CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Ionicons.save_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
