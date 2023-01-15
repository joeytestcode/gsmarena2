import 'package:flutter/material.dart';

import '../common/helper.dart';
import '../data/product.dart';

class ShowSpecWidget extends StatelessWidget {
  const ShowSpecWidget({Key? key, required this.product}) : super(key: key);

  TableRow getTableRow(String title, String content) {
    return TableRow(children: [
      SizedBox(width: 40, child: Center(child: SelectableText(title))),
      Center(child: SelectableText(content)),
    ]);
  }

  final Product product;
  @override
  Widget build(BuildContext context) {
    getFile('test.html').then((value) {
      value.writeAsStringSync(test([product]));
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Specification'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
              columnWidths: const {
                0: FlexColumnWidth(40),
                1: FlexColumnWidth(100)
              },
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  const Center(child: Text('Image')),
                  Center(child: product.getLargeImage()),
                ]),
                getTableRow('Model', product.model),
                getTableRow('Company', product.company),
                getTableRow('Network', product.network),
                getTableRow('Announced', product.announced),
                getTableRow('Status', product.status),
                getTableRow('Network', product.network),
                getTableRow('Dimensions', product.dimensions),
                getTableRow('Weight', product.weight),
                getTableRow('Body', product.bodyMaterials),
                getTableRow('SIM', product.sim),
                getTableRow('Body others', product.bodyOthers),
                getTableRow('Display Type', product.displayType),
                getTableRow('Display Size', product.displaySize),
                getTableRow('Display Resolution', product.displayResolution),
                getTableRow('Display Protection', product.displayProtection),
                getTableRow('Display Others', product.displayOthers),
                getTableRow('OS', product.os),
                getTableRow('Chipset', product.chipset),
                getTableRow('CPU', product.cpu),
                getTableRow('GPU', product.gpu),
                getTableRow('Card Slot', product.cardSlot),
                getTableRow('Memory', product.memory),
                getTableRow('Memory Others', product.memoryOther),
                getTableRow('Rear Camera', product.getRearCameraString()),
                getTableRow('Rear Camera Features', product.rearCameraFeatures),
                getTableRow('Rear Camera Video', product.rearCameraVideo),
                getTableRow('Front Camera', product.getFrontCameraString()),
                getTableRow(
                    'Front Camera Features', product.frontCameraFeatures),
                getTableRow('Front Camera Video', product.frontCameraVideo),
                getTableRow('Earjack', product.earjack),
                getTableRow('Sound', product.soundOthers),
                getTableRow('WIFI', product.wlan),
                getTableRow('Bluetooth', product.bluetooth),
                getTableRow('GPS', product.gps),
                getTableRow('NFC', product.nfc),
                getTableRow('Infrared', product.infrared),
                getTableRow('Radio', product.radio),
                getTableRow('USB', product.usb),
                getTableRow('Sensors', product.sensors),
                getTableRow('Feature Others', product.featureOthers),
                getTableRow('Battery', product.battery),
                getTableRow('Charging', product.charging),
                getTableRow('Colors', product.colors),
                getTableRow('Model Names', product.modelName),
                getTableRow('Prices', product.getPriceString()),
              ]),
        ),
      ),
    );
  }
}

String test(List<Product> list) {
  StringBuffer result = StringBuffer();
  result.write('<html>\n');
  result.write('<body>\n');
  result.write('<table>\n');

  result.write('<tr>\n');
  result.write('<th>');
  result.write('Product');
  result.write('</th>\n');
  for (var element in list) {
    result.write('<th>');
    result.write(element.model);
    result.write('</th>\n');
  }
  result.write('</tr>\n');

  result.write('<tr>\n');
  result.write('<th>');
  result.write('Company');
  result.write('</th>\n');
  for (var element in list) {
    result.write('<th>');
    result.write(element.company);
    result.write('</th>\n');
  }
  result.write('</tr>\n');

  result.write('<tr>\n');
  result.write('<th>');
  result.write('Company');
  result.write('</th>\n');
  for (var element in list) {
    result.write('<th>');
    result.write(element.company);
    result.write('</th>\n');
  }
  result.write('</tr>\n');

  result.write('</table>\n');
  result.write('</body>\n');
  result.write('</html>');

  return result.toString();
}



// getTableRow('Network', product.network),
// getTableRow('Announced', product.announced),
// getTableRow('Status', product.status),
// getTableRow('Network', product.network),
// getTableRow('Dimensions', product.dimensions),
// getTableRow('Weight', product.weight),
// getTableRow('Body', product.bodyMaterials),
// getTableRow('SIM', product.sim),
// getTableRow('Body others', product.bodyOthers),
// getTableRow('Display Type', product.displayType),
// getTableRow('Display Size', product.displaySize),
// getTableRow('Display Resolution', product.displayResolution),
// getTableRow('Display Protection', product.displayProtection),
// getTableRow('Display Others', product.displayOthers),
// getTableRow('OS', product.os),
// getTableRow('Chipset', product.chipset),
// getTableRow('CPU', product.cpu),
// getTableRow('GPU', product.gpu),
// getTableRow('Card Slot', product.cardSlot),
// getTableRow('Memory', product.memory),
// getTableRow('Memory Others', product.memoryOther),
// getTableRow('Rear Camera', product.getRearCameraString()),
// getTableRow('Rear Camera Features', product.rearCameraFeatures),
// getTableRow('Rear Camera Video', product.rearCameraVideo),
// getTableRow('Front Camera', product.getFrontCameraString()),
// getTableRow(
// 'Front Camera Features', product.frontCameraFeatures),
// getTableRow('Front Camera Video', product.frontCameraVideo),
// getTableRow('Earjack', product.earjack),
// getTableRow('Sound', product.soundOthers),
// getTableRow('WIFI', product.wlan),
// getTableRow('Bluetooth', product.bluetooth),
// getTableRow('GPS', product.gps),
// getTableRow('NFC', product.nfc),
// getTableRow('Infrared', product.infrared),
// getTableRow('Radio', product.radio),
// getTableRow('USB', product.usb),
// getTableRow('Sensors', product.sensors),
// getTableRow('Feature Others', product.featureOthers),
// getTableRow('Battery', product.battery),
// getTableRow('Charging', product.charging),
// getTableRow('Colors', product.colors),
// getTableRow('Model Names', product.modelName),
// getTableRow('Prices', product.getPriceString()),