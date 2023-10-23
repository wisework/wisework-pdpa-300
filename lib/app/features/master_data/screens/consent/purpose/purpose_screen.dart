import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose/purpose_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class PurposeScreen extends StatefulWidget {
  const PurposeScreen({super.key});

  @override
  State<PurposeScreen> createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen> {
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

    context.read<PurposeBloc>().add(GetPurposesEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurposeBloc, PurposeState>(
      builder: (context, state) {
        if (state is GotPurposes) {
          return PurposeView(initialPurpose: state.purposes);
        }
        if (state is PurposeError) {
          return ErrorMessageScreen(message: state.message);
        }

        return const LoadingScreen();
      },
    );
  }
}

class PurposeView extends StatefulWidget {
  const PurposeView({
    super.key,
    required this.initialPurpose,
  });

  final List<PurposeModel> initialPurpose;

  @override
  State<PurposeView> createState() => _PurposeViewState();
}

class _PurposeViewState extends State<PurposeView> {
  late List<PurposeModel> purposes;

  @override
  void initState() {
    super.initState();

    purposes = widget.initialPurpose;
  }

  void _updatePurposesChanged(UpdatedReturn<PurposeModel> updated) {
    switch (updated.type) {
      case UpdateType.created:
        purposes = purposes.map((purpose) => purpose).toList()
          ..add(updated.object);
        break;
      case UpdateType.updated:
        purposes = purposes
            .map((purpose) =>
                purpose.id == updated.object.id ? updated.object : purpose)
            .toList();
        break;
      case UpdateType.deleted:
        purposes = purposes
            .where((purpose) => purpose.id != updated.object.id)
            .toList();
        break;
    }

    setState(() {
      purposes = purposes
        ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate));
    });

    final event = UpdatePurposesChangedEvent(
      purpose: updated.object,
      updateType: updated.type,
    );
    context.read<PurposeBloc>().add(event);
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
          tr('masterData.cm.purpose.list'), //!
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
              child: purposes.isNotEmpty
                  ? ListView.builder(
                      itemCount: purposes.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(
                          context,
                          purpose: purposes[index],
                        );
                      },
                    )
                  : ExampleScreen(
                      headderText: tr('masterData.cm.purpose.list'),
                      buttonText: tr('masterData.cm.purpose.create'),
                      descriptionText: tr('masterData.cm.purpose.explain'),
                      onPress: () {
                        context.push(MasterDataRoute.createPurpose.path);
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(MasterDataRoute.createPurpose.path).then((value) {
            if (value != null) {
              _updatePurposesChanged(value as UpdatedReturn<PurposeModel>);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required PurposeModel purpose,
  }) {
    const language = 'en-US';
    final description = purpose.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final warningDescription = purpose.warningDescription.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    return MasterDataItemCard(
      title: description.text,
      subtitle: warningDescription.text,
      status: purpose.status,
      onTap: () async {
        await context
            .push(
          MasterDataRoute.editPurpose.path.replaceFirst(':id', purpose.id),
        )
            .then((value) {
          if (value != null) {
            _updatePurposesChanged(value as UpdatedReturn<PurposeModel>);
          }
        });
      },
    );
  }
}
