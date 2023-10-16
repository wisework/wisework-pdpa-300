// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:path/path.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';

import 'constants.dart';

class UtilFunctions {
  static CompanyModel getCurrentCompany(
    List<CompanyModel> companies,
    String currentCompanyId,
  ) {
    for (CompanyModel company in companies) {
      if (company.id == currentCompanyId) return company;
    }
    return CompanyModel.empty();
  }
<<<<<<< HEAD

  static List<CustomFieldModel> filterCustomFieldsByIds(
    List<CustomFieldModel> customFields,
    List<String> customFieldsIds,
  ) {
    return customFields
        .where((category) => customFieldsIds.contains(category.id))
        .toList();
  }

  static List<PurposeCategoryModel> filterPurposeCategoriesByIds(
    List<PurposeCategoryModel> purposeCategories,
    List<String> purposeCategoryIds,
  ) {
    return purposeCategories
        .where((category) => purposeCategoryIds.contains(category.id))
        .toList();
  }

  static List<PurposeModel> filterPurposeByIds(
    List<PurposeModel> purposes,
    List<String> purposeIds,
  ) {
    return purposes
        .where((category) => purposeIds.contains(category.id))
        .toList();
  }

  // static Color getColorFromString(String source) {
  //   return Color(int.parse(source, radix: 16));
  // }

  // static String getHexFromColor(Color color) {
  //   return color.toString().split('(0x')[1].split(')')[0];
  // }

  static String getUniqueFileName(File file) {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final fileExtension = extension(file.path);

    return '$fileName$fileExtension';
  }

  static String getFileNameFromUrl(String url) {
    if (url.isEmpty) return '';

    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;

    return pathSegments.last;
  }

  static String getConsentImagePath(
    String companyId,
    String consentFormId,
    ConsentFormImageType imageType,
  ) {
    final company = 'companies/$companyId';
    final consent = 'consents/$consentFormId';
    final folder = '${imageType.name}/';

    return [company, consent, folder].join('/');
  }
=======
>>>>>>> parent of 376bc1f (add consent form detail)
}

// class GeneralFunctions {
//   static XFile pickImage(){

//   }
// }