import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/power_verification_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class IdentityProofingPage extends StatefulWidget {
  const IdentityProofingPage({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.previousPage,
    required this.dataSubjectRight,
  });

  final PageController controller;
  final int currentPage;
  final int previousPage;
  final DataSubjectRightModel dataSubjectRight;

  @override
  State<IdentityProofingPage> createState() => _IdentityProofingPageState();
}

class _IdentityProofingPageState extends State<IdentityProofingPage> {
  bool isExpanded = false;
  List<PowerVerificationModel> selectIdentityProofing = [];

  void _setIdentityProofing(PowerVerificationModel identityProofing) {
    final selectIds =
        selectIdentityProofing.map((selected) => selected.id).toList();

    setState(() {
      if (selectIds.contains(identityProofing.id)) {
        selectIdentityProofing = selectIdentityProofing
            .where((selected) => selected.id != identityProofing.id)
            .toList();
      } else {
        selectIdentityProofing = selectIdentityProofing
            .map((selected) => selected)
            .toList()
          ..add(identityProofing);
      }
    });
  }

  List<PowerVerificationModel> identityProofing =  [
    PowerVerificationModel(
      id: '1',
      title: tr('dataSubjectRight.identityVerification.copyOfHouseRegistration'),
      additionalReq: false,
    ),
    PowerVerificationModel(
      id: '2',
      title: tr('dataSubjectRight.identityVerification.copyOfIdentificationCare'),
      additionalReq: false,
    ),
    PowerVerificationModel(
      id: '3',
      title: tr('dataSubjectRight.identityVerification.copyOfPassport'),
      additionalReq: false,
    ),
    PowerVerificationModel(
      id: '4',
      title: tr('dataSubjectRight.identityVerification.other'),
      additionalReq: true,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: UiConfig.lineSpacing),
        Expanded(
          child: SingleChildScrollView(
            child: CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    tr('dataSubjectRight.identityVerification.title'), 
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    tr('dataSubjectRight.identityVerification.subtitle'), 
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Column(
                    children: identityProofing
                        .map((identityProofing) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: UiConfig.lineGap,
                              ),
                              child:
                                  _buildCheckBoxTile(context, identityProofing),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        ContentWrapper(
          child: Container(
            padding: const EdgeInsets.all(
              UiConfig.defaultPaddingSpacing,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.outline,
                  blurRadius: 1.0,
                  offset: const Offset(0, -2.0),
                ),
              ],
            ),
            child: _buildPageViewController(
              context,
              widget.controller,
              widget.currentPage,
            ),
          ),
        ),
      ],
    );
  }

  //? Checkbox List
  Widget _buildCheckBoxTile(
      BuildContext context, PowerVerificationModel powerVerification) {
    final selectIds =
        selectIdentityProofing.map((category) => category.id).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: UiConfig.actionSpacing,
              ),
              child: CustomCheckBox(
                value: selectIds.contains(powerVerification.id),
                onChanged: (_) {
                  _setIdentityProofing(powerVerification);
                },
              ),
            ),
            Expanded(
              child: Text(
                powerVerification.title, 
                style: !selectIds.contains(powerVerification.id)
                    ? Theme.of(context).textTheme.bodyMedium?.copyWith()
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
        ExpandedContainer(
          expand: selectIds.contains(powerVerification.id),
          duration: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.only(
              left: UiConfig.actionSpacing,
              right: UiConfig.actionSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: powerVerification.additionalReq,
                  child:  Column(
                    children: [
                      SizedBox(height: UiConfig.lineSpacing),
                      Row(
                        children: <Widget>[
                          TitleRequiredText(
                            text: tr('dataSubjectRight.identityVerification.documentType'),
                            required: true, 
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: tr('dataSubjectRight.identityVerification.hintdocumentType'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                 Row(
                  children: <Widget>[
                    TitleRequiredText(
                      text: tr('dataSubjectRight.identityVerification.copyFile'),
                      required: true, 
                    ),
                  ],
                ),
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
                        backgroundColor:
                            Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _buildPageViewController(
    BuildContext context,
    PageController controller,
    int currentpage,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          onPressed: previousPage,
          child: Text(
            tr("app.previous"),
          ),
        ),
        Text("$currentpage/7"),
        TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            onPressed: nextPage,
            child: currentpage != 7
                ? Text(
                    tr("app.next"),
                  )
                : const Text("ส่งแบบคำร้อง")),
      ],
    );
  }

  void nextPage() {
    widget.controller.animateToPage(widget.currentPage + 1,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    context.read<FormDataSubjectRightCubit>().nextPage(widget.currentPage + 1);
  }

  void previousPage() {
    if (widget.previousPage == 1) {
      widget.controller.animateToPage(1,
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
      context.read<FormDataSubjectRightCubit>().nextPage(1);
    } else {
      widget.controller.animateToPage(widget.currentPage - 1,
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
      context
          .read<FormDataSubjectRightCubit>()
          .nextPage(widget.currentPage - 1);
    }
  }

  //? Expanded Children
  ExpandedContainer _buildExpandedContainer(
      BuildContext context, bool additionalReq) {
    return ExpandedContainer(
      expand: isExpanded,
      duration: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
              visible: additionalReq,
              child:  Column(
                children: [
                  Row(
                    children: <Widget>[
                      TitleRequiredText(
                        text: tr('dataSubjectRight.identityVerification.documentType'),
                        required: true, //!
                      ),
                    ],
                  ),
                  SizedBox(height: UiConfig.lineSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: tr('dataSubjectRight.identityVerification.hintdocumentType'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: UiConfig.lineSpacing),
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
