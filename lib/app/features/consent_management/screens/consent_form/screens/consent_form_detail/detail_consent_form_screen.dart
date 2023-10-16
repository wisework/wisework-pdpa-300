import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/bloc/consent_form_detail/consent_form_detail_bloc.dart';
import 'package:pdpa/app/features/consent_management/screens/consent_form/screens/consent_form_detail/tabs/consent_info_tab.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class DetailConsentFormScreen extends StatefulWidget {
  const DetailConsentFormScreen({
    super.key,
    required this.consentFormId,
  });

  final String consentFormId;

  @override
  State<DetailConsentFormScreen> createState() =>
      _DetailConsentFormScreenState();
}

class _DetailConsentFormScreenState extends State<DetailConsentFormScreen> {
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
    return BlocProvider<ConsentFormDetailBloc>(
      create: (context) => serviceLocator<ConsentFormDetailBloc>()
        ..add(
          GetConsentFormEvent(
            consentId: widget.consentFormId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocBuilder<ConsentFormDetailBloc, ConsentFormDetailState>(
        builder: (context, state) {
          if (state is GotConsentFormDetail) {
            return ConsentFormDetailView(
              consentForm: state.consentForm,
              customFields: state.customFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
            );
          }
          if (state is ConsentFormDetailError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class ConsentFormDetailView extends StatefulWidget {
  const ConsentFormDetailView({
    super.key,
    required this.consentForm,
    required this.customFields,
    required this.purposeCategories,
    required this.purposes,
  });

  final ConsentFormModel consentForm;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;

  @override
  State<ConsentFormDetailView> createState() => _ConsentFormDetailViewState();
}

class _ConsentFormDetailViewState extends State<ConsentFormDetailView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
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
            'Consent Form',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            CustomIconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              icon: Ionicons.eye_outline,
              iconColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
            ),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'information'),
              Tab(text: 'form'),
            ],
            // isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Theme.of(context).colorScheme.primary,
            labelStyle: Theme.of(context).textTheme.bodySmall,
          ),
          appBarHeight: 100.0,
        ),
        body: TabBarView(
          children: <Widget>[
            ConsentInfoTab(
              consentForm: widget.consentForm,
              customFields: widget.customFields,
              purposeCategories: widget.purposeCategories,
              purposes: widget.purposes,
            ),
            const Text("data"),
          ],
        ),
      ),
    );
  }
}
