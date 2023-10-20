import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/mandatory/mandatory_field/mandatory_field_bloc.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class MandatoryFieldScreen extends StatefulWidget {
  const MandatoryFieldScreen({super.key});

  @override
  State<MandatoryFieldScreen> createState() => _MandatoryFieldScreenState();
}

class _MandatoryFieldScreenState extends State<MandatoryFieldScreen> {
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

    context
        .read<MandatoryFieldBloc>()
        .add(GetMandatoryFieldsEvent(companyId: currentUser.currentCompany));
  }

  @override
  Widget build(BuildContext context) {
    return MandatoryFieldView(companyId: currentUser.currentCompany);
  }
}

class MandatoryFieldView extends StatefulWidget {
  const MandatoryFieldView({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  State<MandatoryFieldView> createState() => _MandatoryFieldViewState();
}

class _MandatoryFieldViewState extends State<MandatoryFieldView> {
  List<MandatoryFieldModel> mandatoryFields = [];
  bool isEditable = false;

  void _initialMandatoryFields(List<MandatoryFieldModel> initial) {
    mandatoryFields = initial;
  }

  void _setPriority(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final selected = mandatoryFields.removeAt(oldIndex);
    mandatoryFields.insert(newIndex, selected);
  }

  void _setEditable() {
    setState(() {
      isEditable = !isEditable;
    });
  }

  void _saveMandatoryFields() {
    final updated = mandatoryFields
        .asMap()
        .entries
        .map((entry) => mandatoryFields[entry.key].copyWith(
              priority: entry.key + 1,
            ))
        .toList();

    final event = UpdateMandatoryFieldsEvent(
      mandatoryFields: updated,
      companyId: widget.companyId,
    );
    context.read<MandatoryFieldBloc>().add(event);

    setState(() {
      isEditable = !isEditable;
      mandatoryFields = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Ionicons.chevron_back_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('masterData.main.mandatoryFields.list'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          isEditable
              ? CustomIconButton(
                  onPressed: _saveMandatoryFields,
                  icon: Ionicons.save_outline,
                  iconColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                )
              : CustomIconButton(
                  onPressed: _setEditable,
                  icon: Ionicons.pencil_outline,
                  iconColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child: BlocBuilder<MandatoryFieldBloc, MandatoryFieldState>(
                builder: (context, state) {
                  if (state is GotMandatoryFields) {
                    _initialMandatoryFields(state.mandatoryFields);

                    if (isEditable) {
                      return ReorderableListView.builder(
                        itemBuilder: (context, index) {
                          return _buildItemCard(
                            context,
                            key: mandatoryFields[index].id,
                            mandatoryField: mandatoryFields[index],
                          );
                        },
                        itemCount: mandatoryFields.length,
                        onReorder: _setPriority,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      );
                    }

                    return ListView.builder(
                      itemCount: mandatoryFields.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(
                          context,
                          key: mandatoryFields[index].id,
                          mandatoryField: mandatoryFields[index],
                        );
                      },
                    );
                  }
                  if (state is MandatoryFieldError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildItemCard(
    BuildContext context, {
    required String key,
    required MandatoryFieldModel mandatoryField,
  }) {
    const language = 'en-US';
    final title = mandatoryField.title.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    return Padding(
      key: ValueKey(key),
      padding: EdgeInsets.only(
        right: isEditable ? UiConfig.actionSpacing * 4 : 0,
      ),
      child: MasterDataItemCard(
        title: title.text,
        subtitle: customInputTypeNames[mandatoryField.inputType].toString(),
        status: mandatoryField.status,
        onTap: () {},
      ),
    );
  }
}