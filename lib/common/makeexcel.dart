import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../data/product.dart';
import 'helper.dart';

Future<String> makeExcel(
    {required List<Product> contents, required String fileName}) async {
  final Workbook workbook = Workbook();
  workbook.worksheets[0].name = 'Full Spec';
  final Worksheet sheet = workbook.worksheets[0];

  final styleTitle = workbook.styles.add('styleTitle');
  styleTitle.borders.all.lineStyle = LineStyle.thin;
  styleTitle.hAlign = HAlignType.center;
  styleTitle.vAlign = VAlignType.center;
  styleTitle.bold = true;
  styleTitle.backColor = '#f2f2f2';

  final styleNormal = workbook.styles.add('styleNormal');
  styleNormal.borders.all.lineStyle = LineStyle.thin;
  styleNormal.hAlign = HAlignType.center;
  styleNormal.vAlign = VAlignType.center;

  int iRow = 1;
  int iCol = 1;
  Product().getTitleList().forEach((element) {
    sheet.getRangeByIndex(iRow, iCol).setText(element);
    sheet.getRangeByIndex(iRow, iCol++).cellStyle = styleTitle;
  });

  for (var product in contents) {
    iRow++;
    iCol = 1;
    product.toList().forEach((element) {
      sheet.getRangeByIndex(iRow, iCol).setText(element);
      sheet.getRangeByIndex(iRow, iCol++).cellStyle = styleNormal;
    });
  }

  final Worksheet sheetSimple = workbook.worksheets.add();
  sheetSimple.name = 'Simple Spec';
  iRow = 1;
  iCol = 1;

  Product().getSimpleTitleList().forEach((element) {
    sheetSimple.getRangeByIndex(iRow, iCol).setText(element);
    sheetSimple.getRangeByIndex(iRow++, iCol).cellStyle = styleTitle;
  });

  for (var product in contents) {
    iRow = 1;
    iCol++;
    product.toSimpleList().forEach((element) {
      sheetSimple.getRangeByIndex(iRow, iCol).setText(element);
      sheetSimple.getRangeByIndex(iRow++, iCol).cellStyle = styleNormal;
    });
  }

  final List<int> bytes = workbook.saveAsStream();

  final file = await getFile(_getSheetName());
  file.writeAsBytesSync(bytes);
  workbook.dispose();
  return file.path;
}

// Future<String> makeExcel2(
//     {required List<Product> contents, required String fileName}) async {
//   final excel = Excel.createExcel();
//   excel.copy('Sheet1', 'SimpleSpec');
//   excel.rename('Sheet1', _getSheetName());

//   var cellStyle = CellStyle(
//     backgroundColorHex: ,
//     verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center,);
//   final currentSheet = excel[_getSheetName()];

//   currentSheet.appendRow(Product().getTitleList());
//   for (var element in contents) {
//     if (element.model.trim().isNotEmpty) {
//       currentSheet.appendRow(element.toList());
//     }
//   }

//   final simpleSheet = excel['SimpleSpec'];
//   final title = Product().getSimpleTitleList();
//   final simpleSpecs = [];

//   for (var element in contents) {
//     simpleSpecs.add(element.toSimpleList());
//   }

//   var i = 0;
//   for (var element in title) {
//     final items = [element];
//     for (var element in simpleSpecs) {
//       items.add(element[i]);
//     }
//     i++;
//     simpleSheet.appendRow(items);
//   }

//   final file = await getFile(fileName);

//   final fileBytes = excel.save();

//   if (fileBytes != null) {
//     file
//       ..createSync(recursive: true)
//       ..writeAsBytesSync(fileBytes);
//   }
//   return file.path;
// }

String _getSheetName() {
  return 'GSMarena_${DateTime.now().toString().substring(0, 19).replaceAll('-', '').replaceAll(':', '').replaceAll(' ', '_')}.xlsx';
}
