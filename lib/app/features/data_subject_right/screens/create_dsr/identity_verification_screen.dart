import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class RequestIdentityVerificaiotnScreen extends StatefulWidget {
  const RequestIdentityVerificaiotnScreen({super.key});

  @override
  State<RequestIdentityVerificaiotnScreen> createState() =>
      _RequestIdentityVerificaiotnScreenState();
}

class _RequestIdentityVerificaiotnScreenState
    extends State<RequestIdentityVerificaiotnScreen> {
  @override
  Widget build(BuildContext context) {
    return const IdentityVerificationView();
  }
}

class IdentityVerificationView extends StatefulWidget {
  const IdentityVerificationView({super.key});

  @override
  State<IdentityVerificationView> createState() =>
      _IdentityVerificationViewState();
}

class _IdentityVerificationViewState extends State<IdentityVerificationView> {
  bool isExpanded = false;

  void _setExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  List<String> power = [
    'สำเนาทะเบียนบ้าน',
    'สำเนาบัตรประชาชน (กรณีสัญชาติไทย)',
    'สำเนาพาสสปอร์ต (กรณีต่างชาติ)',
    'อื่นๆ ถ้ามี (โปรดระบุ)'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icons.chevron_left_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('dataSubjectRight.manageRequests'), 
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: _buildPowerVerificationForm(context),
    );
  }

  //? Content
  Widget _buildPowerVerificationForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: UiConfig.lineSpacing),
          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: UiConfig.lineSpacing),
                Text(
                  'เอกสารพิสูจน์ตัวตนและพิสูจน์ถิ่นที่อยู่เจ้าของข้อมูล', //!
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Text(
                  'ข้าพเจ้าได้แนบเอกสารดังต่อไปนี้เพื่อการตรวจสอบตัวตน', //!
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Column(
                  children: power
                      .map((menu) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: UiConfig.lineGap,
                            ),
                            child: _buildCheckBoxTile(context, menu),
                          ))
                      .toList(),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                CustomButton(
                  height: 40.0,
                  onPressed: () {
                    context.push(DataSubjectRightRoute.stepFive.path);
                  },
                  child: Text(
                    'ถัดไป', //!
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //? Checkbox List
  Widget _buildCheckBoxTile(BuildContext context, String name) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCheckBox(
              value: isExpanded,
              onChanged: (bool? value) {
                _setExpand();
              },
            ),
            const SizedBox(width: UiConfig.actionSpacing),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialInkWell(
                    borderRadius: BorderRadius.circular(4.0),
                    onTap: _setExpand,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        name, 
                        style: isExpanded == false
                            ? Theme.of(context).textTheme.bodyMedium?.copyWith()
                            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: UiConfig.textLineSpacing),
                  _buildExpandedContainer(context, name),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  //? Expanded Children
  ExpandedContainer _buildExpandedContainer(BuildContext context, String name) {
    return ExpandedContainer(
      expand: isExpanded,
      duration: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
              visible: name.contains(tr('dataSubjectRight.identityVerification.other')),
              child:  Column(
                children: [
                  Row(
                    children: <Widget>[
                      TitleRequiredText(
                        text: tr('dataSubjectRight.identityVerification.documentType'),
                        required: true, 
                      ),
                    ],
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: tr('dataSubjectRight.identityVerification.hintdocumentType'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                ],
              )),
           Row(
            children: <Widget>[
              TitleRequiredText(
                text: tr('dataSubjectRight.identityVerification.copyFile'),
                required: true, 
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
               Expanded(
                child: CustomTextField(
                  hintText: tr('dataSubjectRight.identityVerification.fileNotSelected'),
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomIconButton(
                  onPressed: () {},
                  icon: Ionicons.cloud_upload,
                  iconColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }
}
