import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';

import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

class AcknowledgePage extends StatefulWidget {
  const AcknowledgePage({
    super.key,
  });

  @override
  State<AcknowledgePage> createState() => _AcknowledgePageState();
}

class _AcknowledgePageState extends State<AcknowledgePage> {
  @override
  Widget build(BuildContext context) {
    final isAcknowledge = context.select(
      (FormDataSubjectRightCubit cubit) => cubit.state.isAcknowledge,
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: UiConfig.lineSpacing),
                Text(
                  tr('dataSubjectRight.acknowledge.title'), 
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      value: isAcknowledge,
                      onChanged: (_) {
                        context
                            .read<FormDataSubjectRightCubit>()
                            .setAcknowledge(!isAcknowledge);
                      },
                    ),
                    const SizedBox(width: UiConfig.actionSpacing),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          tr("dataSubjectRight.acknowledge.subtitle"), 
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.lineSpacing),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
