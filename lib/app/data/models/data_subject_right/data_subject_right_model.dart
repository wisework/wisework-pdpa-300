import 'package:equatable/equatable.dart';

import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_verification_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class DataSubjectRightModel extends Equatable {
  const DataSubjectRightModel({
    required this.id,
    required this.dataRequester,
    required this.dataOwner,
    required this.isDataOwner,
    required this.powerVerifications,
    required this.identityVerifications,
    required this.processRequests,
    required this.requestExpirationDate,
    required this.notifyEmail,
    required this.requestFormVerified,
    required this.requestFormStatus,
    required this.rejectFormReason,
    required this.considerRequest,
    required this.lastSeenBy,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  /// Data subject right ID
  final String id;

  /// The data about requester who requesting the form.
  final List<RequesterInputModel> dataRequester;

  /// Requester data in case where the requester is not the owner of data.
  final List<RequesterInputModel> dataOwner;

  /// Check whether the requester and the data owner are the same person or not?
  final bool isDataOwner;

  /// Power of attorneys in case where the requester is not the owner of data.
  final List<RequesterVerificationModel> powerVerifications;

  /// Identity proofs to confirm the identity of the requester.
  final List<RequesterVerificationModel> identityVerifications;

  /// The request that the requester want to action in this form.
  final List<ProcessRequestModel> processRequests;

  /// Expiration date of this form.
  /// Starting from the requested date until the scheduled date [such as 30 days].
  final DateTime requestExpirationDate;

  /// Email notification to relevant people.
  final List<String> notifyEmail;

  /// Verify that the data subject right form is verified by operator or not.
  final bool requestFormVerified;

  /// The results of checking that this form is correct and complete.
  /// Use in [Verify data subject right step].
  final RequestResultStatus requestFormStatus;

  /// Reason for rejecting this form.
  /// Use in [Verify data subject right step].
  final String rejectFormReason;

  /// Consider the request whether to reject the request or continue action.
  /// Use in [Considering step].
  final bool considerRequest;

  /// The lastest user who see the data subject right form.
  final String lastSeenBy;

  /// The date and user who created the form.
  final String createdBy;
  final DateTime createdDate;

  /// The date and operator who edited or updated the form.
  final String updatedBy;
  final DateTime updatedDate;

  DataSubjectRightModel.empty()
      : this(
          id: '',
          dataRequester: [],
          dataOwner: [],
          isDataOwner: true,
          powerVerifications: [],
          identityVerifications: [],
          processRequests: [],
          requestExpirationDate: DateTime.fromMillisecondsSinceEpoch(0),
          notifyEmail: [],
          requestFormVerified: false,
          requestFormStatus: RequestResultStatus.none,
          rejectFormReason: '',
          considerRequest: false,
          lastSeenBy: '',
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  DataSubjectRightModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          dataRequester: List<RequesterInputModel>.from(
            (map['dataRequester'] as DataMap).entries.map<RequesterInputModel>(
                (item) => RequesterInputModel.fromMap(
                    {'id': item.key, ...item.value})),
          ),
          dataOwner: List<RequesterInputModel>.from(
            (map['dataOwner'] as DataMap).entries.map<RequesterInputModel>(
                (item) => RequesterInputModel.fromMap(
                    {'id': item.key, ...item.value})),
          ),
          isDataOwner: map['isDataOwner'] as bool,
          powerVerifications: List<RequesterVerificationModel>.from(
            (map['powerVerifications'] as DataMap)
                .entries
                .map<RequesterVerificationModel>((item) =>
                    RequesterVerificationModel.fromMap(
                        {'id': item.key, ...item.value})),
          ),
          identityVerifications: List<RequesterVerificationModel>.from(
            (map['identityVerifications'] as DataMap)
                .entries
                .map<RequesterVerificationModel>((item) =>
                    RequesterVerificationModel.fromMap(
                        {'id': item.key, ...item.value})),
          ),
          processRequests: List<ProcessRequestModel>.from(
            (map['processRequests'] as DataMap)
                .entries
                .map<ProcessRequestModel>((item) => ProcessRequestModel.fromMap(
                    {'id': item.key, ...item.value})),
          ),
          requestExpirationDate:
              DateTime.parse(map['requestExpirationDate'] as String),
          notifyEmail: List<String>.from(map['notifyEmail'] as List<dynamic>),
          requestFormVerified: map['requestFormVerified'] as bool,
          requestFormStatus:
              RequestResultStatus.values[map['requestFormStatus'] as int],
          rejectFormReason: map['rejectFormReason'] as String,
          considerRequest: map['considerRequest'] as bool,
          lastSeenBy: map['lastSeenBy'] as String,
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  factory DataSubjectRightModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return DataSubjectRightModel.fromMap(response);
  }

  DataMap toMap() => {
        'id': id,
        'dataRequester': dataRequester.fold(
          {},
          (map, requesterInput) => map..addAll(requesterInput.toMap()),
        ),
        'dataOwner': dataOwner.fold(
          {},
          (map, requesterInput) => map..addAll(requesterInput.toMap()),
        ),
        'isDataOwner': isDataOwner,
        'powerVerifications': powerVerifications.fold(
          {},
          (map, requesterVerification) =>
              map..addAll(requesterVerification.toMap()),
        ),
        'identityVerifications': identityVerifications.fold(
          {},
          (map, requesterVerification) =>
              map..addAll(requesterVerification.toMap()),
        ),
        'processRequests': processRequests.fold(
          {},
          (map, processRequest) => map..addAll(processRequest.toMap()),
        ),
        'requestExpirationDate': requestExpirationDate.toIso8601String(),
        'notifyEmail': notifyEmail,
        'requestFormVerified': requestFormVerified,
        'requestFormStatus': requestFormStatus.index,
        'rejectFormReason': rejectFormReason,
        'considerRequest': considerRequest,
        'lastSeenBy': lastSeenBy,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  DataSubjectRightModel copyWith({
    String? id,
    List<RequesterInputModel>? dataRequester,
    List<RequesterInputModel>? dataOwner,
    bool? isDataOwner,
    List<RequesterVerificationModel>? powerVerifications,
    List<RequesterVerificationModel>? identityVerifications,
    List<ProcessRequestModel>? processRequests,
    DateTime? requestExpirationDate,
    List<String>? notifyEmail,
    bool? requestFormVerified,
    RequestResultStatus? requestFormStatus,
    String? rejectFormReason,
    bool? considerRequest,
    String? lastSeenBy,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return DataSubjectRightModel(
      id: id ?? this.id,
      dataRequester: dataRequester ?? this.dataRequester,
      dataOwner: dataOwner ?? this.dataOwner,
      isDataOwner: isDataOwner ?? this.isDataOwner,
      powerVerifications: powerVerifications ?? this.powerVerifications,
      identityVerifications:
          identityVerifications ?? this.identityVerifications,
      processRequests: processRequests ?? this.processRequests,
      requestExpirationDate:
          requestExpirationDate ?? this.requestExpirationDate,
      notifyEmail: notifyEmail ?? this.notifyEmail,
      requestFormVerified: requestFormVerified ?? this.requestFormVerified,
      requestFormStatus: requestFormStatus ?? this.requestFormStatus,
      rejectFormReason: rejectFormReason ?? this.rejectFormReason,
      considerRequest: considerRequest ?? this.considerRequest,
      lastSeenBy: lastSeenBy ?? this.lastSeenBy,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  DataSubjectRightModel setCreate(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  DataSubjectRightModel setUpdate(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      id,
      dataRequester,
      dataOwner,
      isDataOwner,
      powerVerifications,
      identityVerifications,
      processRequests,
      requestExpirationDate,
      notifyEmail,
      requestFormVerified,
      requestFormStatus,
      rejectFormReason,
      considerRequest,
      lastSeenBy,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
