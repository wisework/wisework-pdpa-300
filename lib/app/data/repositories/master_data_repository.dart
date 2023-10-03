import 'package:dartz/dartz.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/services/apis/master_data_api.dart';
import 'package:pdpa/app/shared/errors/exceptions.dart';
import 'package:pdpa/app/shared/errors/failure.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class MasterDataRepository {
  const MasterDataRepository(this._api);

  final MasterDataApi _api;

  //? Purpose
  ResultFuture<List<PurposeModel>> getPurposes(String companyId) async {
    try {
      final result = await _api.getPurposes(companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<PurposeModel> getPurposeById(
    String purposeId,
    String companyId,
  ) async {
    try {
      final result = await _api.getPurposeById(purposeId, companyId);

      if (result != null) return Right(result);

      return const Left(
        ApiFailure(message: 'Purpose not found', statusCode: 404),
      );
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultFuture<PurposeModel> createPurpose(
    PurposeModel purpose,
    String companyId,
  ) async {
    try {
      final result = await _api.createPurpose(purpose, companyId);

      return Right(result);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid updatePurpose(
    PurposeModel purpose,
    String companyId,
  ) async {
    try {
      await _api.updatePurpose(purpose, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }

  ResultVoid deletePurpose(
    String purposeId,
    String companyId,
  ) async {
    try {
      await _api.deletePurpose(purposeId, companyId);

      return const Right(null);
    } on ApiException catch (error) {
      return Left(ApiFailure.fromException(error));
    }
  }
}