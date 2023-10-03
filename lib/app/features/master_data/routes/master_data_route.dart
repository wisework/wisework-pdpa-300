import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/master_data/screens/consent/custom_field/custom_field_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/custom_field/screens/edit_custom_field_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose_category/purpose_category_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose_category/screens/edit_purpose_category_screen.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/data_subject_right.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/reason_type/screens/edit_reason_type_screen.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/reject_type/screens/edit_reject_type_screen.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/request_reason_template/screens/edit_request_reason_template_screen.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/request_reject_template/screens/edit_request_reject_template_screen.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/request_type/screens/edit_request_type_screen.dart';
import 'package:pdpa/app/features/master_data/screens/master_data_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose/purpose_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose/edit_purpose_screen.dart';

class MasterDataRoute {
  static final GoRoute masterData = GoRoute(
    path: '/master-data',
    builder: (context, _) => MasterDataScreen(),
  );

  static final GoRoute customFields = GoRoute(
    path: '/master-data/custom-fields',
    builder: (context, _) => const CustomFieldScreen(),
  );

  static final GoRoute createCustomField = GoRoute(
    path: '/master-data/custom-field/create',
    builder: (context, _) => const EditCustomFieldScreen(),
  );

  static final GoRoute editCustomField = GoRoute(
    path: '/master-data/custom-fields/edit',
    builder: (context, _) => const EditCustomFieldScreen(),
  );

  static final GoRoute purposes = GoRoute(
    path: '/master-data/purposes',
    builder: (context, _) => const PurposeScreen(),
  );

  static final GoRoute createPurpose = GoRoute(
    path: '/master-data/purposes/create',
    builder: (context, _) => const EditPurposeScreen(purposeId: ''),
  );

  static final GoRoute editPurpose = GoRoute(
    path: '/master-data/purposes/:id/edit',
    builder: (context, state) => EditPurposeScreen(
      purposeId: state.pathParameters['id'] ?? '',
    ),
  );

  static final GoRoute purposesCategories = GoRoute(
    path: '/master-data/purposescategory',
    builder: (context, _) => const PurposeCategoryScreen(),
  );

  static final GoRoute createPurposeCategory = GoRoute(
    path: '/master-data/purposecategory/create',
    builder: (context, _) => const EditPurposeCategoryScreen(),
  );

  static final GoRoute editPurposeCategory = GoRoute(
    path: '/master-data/purposecategory/edit',
    builder: (context, _) => const EditPurposeCategoryScreen(),
  );

  static final GoRoute reasonType = GoRoute(
    path: '/master-data/reasontype',
    builder: (context, _) => const ReasonTypeScreen(),
  );

  static final GoRoute createReasonType = GoRoute(
    path: '/master-data/reasontype/create',
    builder: (context, _) => const EditReasonTypeScreen(),
  );

  static final GoRoute editReasonType = GoRoute(
    path: '/master-data/reasontype/edit',
    builder: (context, _) => const EditReasonTypeScreen(),
  );

  static final GoRoute requestType = GoRoute(
    path: '/master-data/requesttype',
    builder: (context, _) => const RequestTypeScreen(),
  );

  static final GoRoute createRequestType = GoRoute(
    path: '/master-data/requesttype/create',
    builder: (context, _) => const EditRequestTypeScreen(),
  );

  static final GoRoute editRequestType = GoRoute(
    path: '/master-data/requesttype/edit',
    builder: (context, _) => const EditRequestTypeScreen(),
  );

  static final GoRoute rejectType = GoRoute(
    path: '/master-data/rejecttype',
    builder: (context, _) => const RejectTypeScreen(),
  );

  static final GoRoute createRejectType = GoRoute(
    path: '/master-data/rejecttype/create',
    builder: (context, _) => const EditRejectTypeScreen(),
  );

  static final GoRoute editRejectType = GoRoute(
    path: '/master-data/rejecttype/edit',
    builder: (context, _) => const EditRejectTypeScreen(),
  );

  static final GoRoute requestReason = GoRoute(
    path: '/master-data/requestreason',
    builder: (context, _) => const RequestReasonTemplateScreen(),
  );

  static final GoRoute createRequestReason = GoRoute(
    path: '/master-data/requestreason/create',
    builder: (context, _) => const EditRequestReasonTemplateScreen(),
  );

  static final GoRoute editRequestReason = GoRoute(
    path: '/master-data/requestreason/edit',
    builder: (context, _) => const EditRequestReasonTemplateScreen(),
  );

  static final GoRoute requestReject = GoRoute(
    path: '/master-data/requestreject',
    builder: (context, _) => const RequestRejectTemplateScreen(),
  );

  static final GoRoute createRequestReject = GoRoute(
    path: '/master-data/requestreject/create',
    builder: (context, _) => const EditRequestRejectTemplateScreen(),
  );

  static final GoRoute editRequestReject = GoRoute(
    path: '/master-data/requestreject/edit',
    builder: (context, _) => const EditRequestRejectTemplateScreen(),
  );

  static final List<GoRoute> routes = <GoRoute>[
    masterData,
    //consent
    customFields,
    createCustomField,
    editCustomField,
    purposes,
    createPurpose,
    editPurpose,
    purposesCategories,
    createPurposeCategory,
    editPurposeCategory,
    //dsr
    reasonType,
    createReasonType,
    editReasonType,
    requestType,
    createRequestType,
    editRequestType,
    rejectType,
    createRejectType,
    editRejectType,
    requestReason,
    createRequestReason,
    editRequestReason,
    requestReject,
    createRequestReject,
    editRequestReject
  ];
}