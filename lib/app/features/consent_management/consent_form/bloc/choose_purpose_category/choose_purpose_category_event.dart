part of 'choose_purpose_category_bloc.dart';

abstract class ChoosePurposeCategoryEvent extends Equatable {
  const ChoosePurposeCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentAllPurposeCategoryEvent extends ChoosePurposeCategoryEvent {
  const GetCurrentAllPurposeCategoryEvent({
    required this.consentFormId,
    required this.companyId,
  });

  final String consentFormId;
  final String companyId;

  @override
  List<Object> get props => [companyId];
}