import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/drawers/models/drawer_menu_models.dart';

final List<DrawerMenuModel> drawerMenuPreset = [
  DrawerMenuModel(
    value: 'home',
    title: 'Home',
    icon: Ionicons.home_outline,
    route: GeneralRoute.home,
  ),
  DrawerMenuModel(
    value: 'consent_management',
    title: 'Consent Management',
    icon: Ionicons.reader_outline,
    route: GeneralRoute.home,
    children: [
      DrawerMenuModel(
        value: 'consent_forms',
        title: 'Consent Forms',
        icon: Ionicons.clipboard_outline,
        route: ConsentFormRoute.consentForm,
        parent: 'consent_management',
      ),
      DrawerMenuModel(
        value: 'user_consents',
        title: 'User Consents',
        icon: Ionicons.people_outline,
        route: UserConsentRoute.userConsentScreen,
        parent: 'consent_management',
      ),
    ],
  ),
  DrawerMenuModel(
    value: 'data_subject_right',
    title: 'Data Subject Right',
    icon: Ionicons.shield_checkmark_outline,
    route: DataSubjectRightRoute.dataSubjectRight,
  ),
  DrawerMenuModel(
    value: 'master_data',
    title: 'Master Data',
    icon: Ionicons.server_outline,
    route: MasterDataRoute.masterData,
  ),
  DrawerMenuModel(
    value: 'settings',
    title: 'Settings',
    icon: Ionicons.settings_outline,
    route: GeneralRoute.setting,
  ),
];