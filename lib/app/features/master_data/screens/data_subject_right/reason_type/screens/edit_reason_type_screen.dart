import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/edit_reason_type/edit_reason_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reason_type/reason_type_bloc.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditReasonTypeScreen extends StatefulWidget {
  const EditReasonTypeScreen({
    super.key,
    required this.reasonTypeId,
  });

  final String reasonTypeId;

  @override
  State<EditReasonTypeScreen> createState() => _EditReasonTypeScreenState();
}

class _EditReasonTypeScreenState extends State<EditReasonTypeScreen> {
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
    } else {
      currentUser = UserModel.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditReasonTypeBloc>(
      create: (context) => serviceLocator<EditReasonTypeBloc>()
        ..add(
          GetCurrentReasonTypeEvent(
            reasonTypeId: widget.reasonTypeId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditReasonTypeBloc, EditReasonTypeState>(
        listener: (context, state) {
          if (state is CreatedCurrentReasonType) {
            BotToast.showText(
              text: tr(
                  'consentManagement.consentForm.editConsentTheme.createSuccess'), //!
              contentColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              duration: UiConfig.toastDuration,
            );

            context.read<ReasonTypeBloc>().add(UpdateReasonTypeEvent(
                reasonType: state.reasonType, updateType: UpdateType.created));

            context.pop();
          }

          if (state is UpdatedCurrentReasonType) {
            BotToast.showText(
              text: tr(
                  'consentManagement.consentForm.editConsentTheme.updateSuccess'), //!
              contentColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              duration: UiConfig.toastDuration,
            );
          }

          if (state is DeletedCurrentReasonType) {
            BotToast.showText(
              text: tr(
                  'consentManagement.consentForm.editConsentTheme.deleteSuccess'), //!
              contentColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              duration: UiConfig.toastDuration,
            );

            final deleted = ReasonTypeModel.empty()
                .copyWith(reasonTypeId: state.reasonTypeId);

            context.read<ReasonTypeBloc>().add(UpdateReasonTypeEvent(
                reasonType: deleted, updateType: UpdateType.deleted));

            context.pop();
          }
        },
        builder: (context, state) {
          if (state is GotCurrentReasonType) {
            return EditReasonTypeView(
              initialReasonType: state.reasonType,
              currentUser: currentUser,
              isNewReasonType: widget.reasonTypeId.isEmpty,
            );
          }
          if (state is UpdatedCurrentReasonType) {
            return EditReasonTypeView(
              initialReasonType: state.reasonType,
              currentUser: currentUser,
              isNewReasonType: widget.reasonTypeId.isEmpty,
            );
          }
          if (state is EditReasonTypeError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditReasonTypeView extends StatefulWidget {
  const EditReasonTypeView({
    super.key,
    required this.initialReasonType,
    required this.currentUser,
    required this.isNewReasonType,
  });

  final ReasonTypeModel initialReasonType;
  final UserModel currentUser;
  final bool isNewReasonType;

  @override
  State<EditReasonTypeView> createState() => _EditReasonTypeViewState();
}

class _EditReasonTypeViewState extends State<EditReasonTypeView> {
  late ReasonTypeModel reasonType;

  late TextEditingController reasonTypeCodeController;
  late TextEditingController descriptionController;
  late bool isActivated;
  late bool isNeedInfo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initialData();
  }

  @override
  void dispose() {
    reasonTypeCodeController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void _initialData() {
    reasonType = widget.initialReasonType;
    reasonTypeCodeController = TextEditingController();
    descriptionController = TextEditingController();

    isNeedInfo = false;
    isActivated = true;

    if (reasonType != ReasonTypeModel.empty()) {
      if (reasonType.reasonCode.isNotEmpty) {
        reasonTypeCodeController = TextEditingController(
          text: reasonType.reasonCode,
        );
      }
      if (reasonType.description.isNotEmpty) {
        descriptionController = TextEditingController(
          text: reasonType.description.first.text,
        );
      }

      isNeedInfo = reasonType.requiredInputReasonText;

      isActivated = reasonType.status == ActiveStatus.active;
    }
  }

  void _setReasonCode(String? value) {
    setState(() {
      final reasonCode = reasonTypeCodeController.text;

      reasonType = reasonType.copyWith(reasonCode: reasonCode);
    });
  }

  void _setDescription(String? value) {
    setState(
      () {
        final description = [
          LocalizedModel(
            language: 'en-US',
            text: descriptionController.text,
          ),
        ];

        reasonType = reasonType.copyWith(description: description);
      },
    );
  }

  void _setNeedInfo(bool value) {
    setState(() {
      isNeedInfo = value;

      final requiredInputReasonText = isNeedInfo ? true : false;

      reasonType =
          reasonType.copyWith(requiredInputReasonText: requiredInputReasonText);
    });
  }

  void _setActiveStatus(bool value) {
    setState(() {
      isActivated = value;

      final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

      reasonType = reasonType.copyWith(status: status);
    });
  }

  void _saveReasonType() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewReasonType) {
        reasonType = reasonType.setCreate(
          widget.currentUser.email,
          DateTime.now(),
        );
        context.read<EditReasonTypeBloc>().add(CreateCurrentReasonTypeEvent(
              reasonType: reasonType,
              companyId: widget.currentUser.currentCompany,
            ));
      } else {
        reasonType = reasonType.setUpdate(
          widget.currentUser.email,
          DateTime.now(),
        );

        context.read<EditReasonTypeBloc>().add(UpdateCurrentReasonTypeEvent(
              reasonType: reasonType,
              companyId: widget.currentUser.currentCompany,
            ));
      }
    }
  }

  void _deleteReasonType() {
    context.read<EditReasonTypeBloc>().add(DeleteCurrentReasonTypeEvent(
          reasonTypeId: reasonType.reasonTypeId,
          companyId: widget.currentUser.currentCompany,
        ));
  }

  void _goBackAndUpdate() {
    if (!widget.isNewReasonType) {
      context.read<ReasonTypeBloc>().add(UpdateReasonTypeEvent(
            reasonType: reasonType,
            updateType: UpdateType.updated,
          ));
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(widget.initialReasonType),
        title: Text(
          widget.isNewReasonType
              ? tr('masterData.dsr.reason.create')
              : tr('masterData.dsr.reason.edit'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          _buildSaveButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: _buildReasonTypeForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Visibility(
              visible: widget.initialReasonType != ReasonTypeModel.empty(),
              child: _buildConfigurationInfo(context, widget.initialReasonType),
            ),
          ],
        ),
      ),
    );
  }

  Form _buildReasonTypeForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('masterData.dsr.reason.title'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.reason.reasoncode'),
            required: true,
          ),
          CustomTextField(
            controller: reasonTypeCodeController,
            hintText: tr('masterData.dsr.reason.reasoncodeHint'),
            required: true,
            onChanged: _setReasonCode,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.reason.description'),
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: tr('masterData.dsr.reason.descriptionHint'),
            onChanged: _setDescription,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                tr('masterData.dsr.reason.needmoreinformation'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              CustomSwitchButton(
                value: isNeedInfo,
                onChanged: _setNeedInfo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  CustomIconButton _buildPopButton(ReasonTypeModel reasonType) {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Builder _buildSaveButton() {
    return Builder(
      builder: (context) {
        if (reasonType != widget.initialReasonType) {
          return CustomIconButton(
            onPressed: _saveReasonType,
            icon: Ionicons.save_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          );
        }
        return CustomIconButton(
          icon: Ionicons.save_outline,
          iconColor: Theme.of(context).colorScheme.outlineVariant,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        );
      },
    );
  }

  Column _buildConfigurationInfo(
    BuildContext context,
    ReasonTypeModel reasonType,
  ) {
    return Column(
      children: <Widget>[
        CustomContainer(
          child: ConfigurationInfo(
            configBody: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  tr('masterData.cm.purposeCategory.active'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                CustomSwitchButton(
                  value: isActivated,
                  onChanged: _setActiveStatus,
                ),
              ],
            ),
            updatedBy: reasonType.updatedBy,
            updatedDate: reasonType.updatedDate,
            onDeletePressed: _deleteReasonType,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
