import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_stepper.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class SummaryRequestStep extends StatefulWidget {
  const SummaryRequestStep({
    super.key,
    required this.requestTypes,
    required this.language,
  });

  final List<RequestTypeModel> requestTypes;
  final String language;

  @override
  State<SummaryRequestStep> createState() => _SummaryRequestStepState();
}

class _SummaryRequestStepState extends State<SummaryRequestStep> {
  final requestSelectedKey = GlobalKey();

  String processRequestSelected = '';
  List<String> requestExpanded = [];

  @override
  void initState() {
    super.initState();

    _autoScrollToRequest();
  }

  Future<void> _autoScrollToRequest() async {
    final cubit = context.read<ProcessDataSubjectRightCubit>();

    processRequestSelected = cubit.state.processRequestSelected;
    requestExpanded = [processRequestSelected];

    await Future.delayed(const Duration(milliseconds: 400)).then((_) async {
      await Scrollable.ensureVisible(
        requestSelectedKey.currentContext!,
        duration: const Duration(milliseconds: 400),
      );
    });
  }

  void _setRequestExpand(String id) {
    if (!requestExpanded.contains(id)) {
      setState(() {
        requestExpanded.add(id);
      });
    } else {
      setState(() {
        requestExpanded.remove(id);
      });
    }
  }

  Map<String, int> _getStepIndexByProcess(
    DataSubjectRightModel dataSubjectRight,
  ) {
    Map<String, int> map = {};

    for (ProcessRequestModel request in dataSubjectRight.processRequests) {
      map.addAll({request.id: 0});

      if (dataSubjectRight.verifyFormStatus != RequestResultStatus.none) {
        map[request.id] = 1;
      }
      if (request.considerRequestStatus != RequestResultStatus.none) {
        map[request.id] = 2;
      }
      if (request.proofOfActionText.isNotEmpty) {
        map[request.id] = 3;
      }
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProcessDataSubjectRightCubit,
        ProcessDataSubjectRightState>(
      builder: (context, state) {
        final indexes = _getStepIndexByProcess(state.initialDataSubjectRight);

        return Column(
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tr('dataSubjectRight.StepProcessDsr.summaryRequest.summary'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    tr('dataSubjectRight.StepProcessDsr.summaryRequest.result'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final processRequest =
                    state.initialDataSubjectRight.processRequests[index];

                return _buildSummaryRequestCard(
                  context,
                  key: processRequest.id == processRequestSelected
                      ? requestSelectedKey
                      : null,
                  index: index + 1,
                  dataSubjectRight: state.initialDataSubjectRight,
                  processRequest: processRequest,
                  stepIndex: indexes[processRequest.id] ?? 0,
                );
              },
              itemCount: state.initialDataSubjectRight.processRequests.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: UiConfig.lineSpacing,
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        );
      },
    );
  }

  CustomContainer _buildSummaryRequestCard(
    BuildContext context, {
    Key? key,
    required int index,
    required DataSubjectRightModel dataSubjectRight,
    required ProcessRequestModel processRequest,
    required int stepIndex,
  }) {
    final requestType = UtilFunctions.getRequestTypeById(
      widget.requestTypes,
      processRequest.requestType,
    );
    final description = requestType.description.firstWhere(
      (item) => item.language == widget.language,
      orElse: () => const LocalizedModel.empty(),
    );

    final steps = <CustomStep>[
      CustomStep(
        title: Text(
          tr('dataSubjectRight.StepProcessDsr.summaryRequest.title'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        content: _buildFormDetailStep(context),
      ),
      CustomStep(
        title: Text(
          tr('dataSubjectRight.StepProcessDsr.summaryRequest.check'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        content: _buildVerifyFormStep(
          context,
          status: dataSubjectRight.verifyFormStatus,
          reasonText: dataSubjectRight.rejectVerifyReason,
        ),
      ),
      CustomStep(
        title: Text(
          tr('dataSubjectRight.StepProcessDsr.summaryRequest.consider'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        content: _buildConsiderRequestStep(
          context,
          status: processRequest.considerRequestStatus,
          reasonText: processRequest.rejectConsiderReason,
        ),
      ),
      CustomStep(
        title: Text(
          tr('dataSubjectRight.StepProcessDsr.summaryRequest.results'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        content: _buildProcessRequestStep(
          context,
          status: processRequest.proofOfActionText.isNotEmpty,
        ),
      ),
    ];

    return CustomContainer(
      key: key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MaterialInkWell(
            onTap: () {
              _setRequestExpand(processRequest.id);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '$index. ${description.text}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 2.0),
                  Icon(
                    requestExpanded.contains(processRequest.id)
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: 20.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
          ExpandedContainer(
            expand: requestExpanded.contains(processRequest.id),
            duration: const Duration(milliseconds: 400),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: UiConfig.defaultPaddingSpacing,
                    horizontal: UiConfig.defaultPaddingSpacing * 2,
                  ),
                  child: CustomStepper(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    steps: steps,
                    currentStep: stepIndex,
                    onPreviousStep: () {},
                    onNextStep: () {},
                    checkIcon: true,
                    showContentInSummary: true,
                    hideStepperControls: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildFormDetailStep(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('dataSubjectRight.StepProcessDsr.summaryRequest.requestReceived'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: UiConfig.lineGap),
      ],
    );
  }

  Column _buildVerifyFormStep(
    BuildContext context, {
    required RequestResultStatus status,
    required String reasonText,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          status == RequestResultStatus.pass
              ? tr('dataSubjectRight.StepProcessDsr.summaryRequest.pass')
              : status == RequestResultStatus.fail
                  ? tr('dataSubjectRight.StepProcessDsr.summaryRequest.notPass')
                  : tr(
                      'dataSubjectRight.StepProcessDsr.summaryRequest.notYetProcessed'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Visibility(
          visible: reasonText.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: UiConfig.textSpacing),
            child: Text(
              '${tr('dataSubjectRight.StepProcessDsr.summaryRequest.reason')} : $reasonText',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        const SizedBox(height: UiConfig.lineGap),
      ],
    );
  }

  Column _buildConsiderRequestStep(
    BuildContext context, {
    required RequestResultStatus status,
    required String reasonText,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          status == RequestResultStatus.pass
              ? tr('dataSubjectRight.StepProcessDsr.summaryRequest.carryOut')
              : status == RequestResultStatus.fail
                  ? tr(
                      'dataSubjectRight.StepProcessDsr.summaryRequest.refuseProcessing')
                  : tr(
                      'dataSubjectRight.StepProcessDsr.summaryRequest.inProgress'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Visibility(
          visible: reasonText.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: UiConfig.textSpacing),
            child: Text(
              '${tr('dataSubjectRight.StepProcessDsr.summaryRequest.reason')} : $reasonText',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        const SizedBox(height: UiConfig.lineGap),
      ],
    );
  }

  Column _buildProcessRequestStep(
    BuildContext context, {
    required bool status,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          status
              ? tr('dataSubjectRight.StepProcessDsr.summaryRequest.completed')
              : tr('dataSubjectRight.StepProcessDsr.summaryRequest.inProgress'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: UiConfig.lineGap),
      ],
    );
  }
}
