// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'data_subject_right_event.dart';
part 'data_subject_right_state.dart';

class DataSubjectRightBloc
    extends Bloc<DataSubjectRightEvent, DataSubjectRightState> {
  DataSubjectRightBloc({
    required DataSubjectRightRepository dataSubjectRightRepository,
  })  : _dataSubjectRightRepository = dataSubjectRightRepository,
        super(const DataSubjectRightInitial()) {
    on<GetDataSubjectRightsEvent>(_getDataSubjectRightsHandler);
    on<UpdateDataSubjectRightsEvent>(_updateDataSubjectRightsHandler);
  }

  final DataSubjectRightRepository _dataSubjectRightRepository;

  Future<void> _getDataSubjectRightsHandler(
    GetDataSubjectRightsEvent event,
    Emitter<DataSubjectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const DataSubjectRightError('Required company ID'));
      return;
    }

    emit(const GettingDataSubjectRights());

    final result = await _dataSubjectRightRepository.getDataSubjectRights(
      event.companyId,
    );

    result.fold(
      (failure) => emit(DataSubjectRightError(failure.errorMessage)),
      (dataSubjectRight) => emit(GotDataSubjectRights(
        dataSubjectRight
          ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      )),
    );
  }

  Future<void> _updateDataSubjectRightsHandler(
    UpdateDataSubjectRightsEvent event,
    Emitter<DataSubjectRightState> emit,
  ) async {
    if (state is GotDataSubjectRights) {
      final dataSubjectRights =
          (state as GotDataSubjectRights).dataSubjectRights;

      List<DataSubjectRightModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = dataSubjectRights.map((dsr) => dsr).toList()
            ..add(event.dataSubjectRight);
          break;
        case UpdateType.updated:
          for (DataSubjectRightModel dsr in dataSubjectRights) {
            if (dsr.id == event.dataSubjectRight.id) {
              updated.add(event.dataSubjectRight);
            } else {
              updated.add(dsr);
            }
          }
          break;
        case UpdateType.deleted:
          updated = dataSubjectRights
              .where((purpose) => purpose.id != event.dataSubjectRight.id)
              .toList();
          break;
      }

      emit(
        GotDataSubjectRights(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}