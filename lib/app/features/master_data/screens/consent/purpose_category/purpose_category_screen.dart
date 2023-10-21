import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose_category/purpose_category_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class PurposeCategoryScreen extends StatefulWidget {
  const PurposeCategoryScreen({super.key});

  @override
  State<PurposeCategoryScreen> createState() => _PurposeCategoryScreenState();
}

class _PurposeCategoryScreenState extends State<PurposeCategoryScreen> {
  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();

    String companyId = '';
    if (bloc.state is SignedInUser) {
      companyId = (bloc.state as SignedInUser).user.currentCompany;
    }

    context
        .read<PurposeCategoryBloc>()
        .add(GetPurposeCategoriesEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return const PurposeCategoryView();
  }
}

class PurposeCategoryView extends StatefulWidget {
  const PurposeCategoryView({super.key});

  @override
  State<PurposeCategoryView> createState() => _PurposeCategoryViewState();
}

class _PurposeCategoryViewState extends State<PurposeCategoryView> {
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
          tr('masterData.cm.purposeCategory.list'), //!
          style: Theme.of(context).textTheme.titleLarge,
        ),
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
              child: BlocBuilder<PurposeCategoryBloc, PurposeCategoryState>(
                builder: (context, state) {
                  if (state is GotPurposeCategories) {
                    return state.purposeCategories.isNotEmpty
                        ? ListView.builder(
                            itemCount: state.purposeCategories.length,
                            itemBuilder: (context, index) {
                              return _buildItemCard(
                                context,
                                purposeCategory: state.purposeCategories[index],
                              );
                            },
                          )
                        : ExampleScreen(
                            headderText:
                                tr('masterData.cm.purposeCategory.list'),
                            buttonText:
                                tr('masterData.cm.purposeCategory.create'),
                            descriptionText:
                                tr('masterData.cm.purposeCategory.explain'),
                            onPress: () {
                              context.push(
                                  MasterDataRoute.createPurposeCategory.path);
                            },
                          );
                  }
                  if (state is PurposeCategoryError) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(MasterDataRoute.createPurposeCategory.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required PurposeCategoryModel purposeCategory,
  }) {
    const language = 'en-US';
    final title = purposeCategory.title.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final description = purposeCategory.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    return MasterDataItemCard(
      title: title.text,
      subtitle: description.text,
      status: purposeCategory.status,
      onTap: () {
        context.push(
          MasterDataRoute.editPurposeCategory.path
              .replaceFirst(':id', purposeCategory.id),
        );
      },
    );
  }
}
