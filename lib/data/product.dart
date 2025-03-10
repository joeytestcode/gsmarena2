import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

// ** Add dev_dependencies
//    build_runner, objectbox_generator
//
// ** command
// flutter pub run build_runner build

@Entity()
class Product extends Equatable {
  Product();

  @Id(assignable: true)
  int id = 0;
  String model = '';
  String company = '';
  String imgSrc = '';
  String img = '';
  String network = '';
  String announced = '';
  String status = '';
  String dimensions = '';
  String weight = '';
  String bodyMaterials = '';
  String sim = '';
  String bodyOthers = '';
  String displayType = '';
  String displaySize = '';
  String displayResolution = '';
  String displayProtection = '';
  String displayOthers = '';
  String os = '';
  String chipset = '';
  String cpu = '';
  String gpu = '';
  String cardSlot = '';
  String memory = '';
  String memoryOther = '';
  List<String> rearCameraModules = [];
  String rearCameraFeatures = '';
  String rearCameraVideo = '';
  List<String> frontCameraModules = [];
  String frontCameraFeatures = '';
  String frontCameraVideo = '';
  String loudSpeaker = '';
  String earjack = '';
  String soundOthers = '';
  String wlan = '';
  String bluetooth = '';
  String gps = '';
  String nfc = '';
  String infrared = '';
  String radio = '';
  String usb = '';
  String sensors = '';
  String featureOthers = '';
  String battery = '';
  String charging = '';
  String colors = '';
  String modelName = '';
  double priceUS = 0.0;
  double priceEU = 0.0;
  double priceEN = 0.0;
  double priceIN = 0.0;
  @Transient()
  Uint8List image = Uint8List.fromList([]);

  String getRearCameraString() {
    StringBuffer result = StringBuffer();
    for (var element in rearCameraModules) {
      result.write('$element\n');
    }
    return result.toString().trim();
  }

  String getFrontCameraString() {
    StringBuffer result = StringBuffer();
    for (var element in frontCameraModules) {
      result.write('$element\n');
    }
    return result.toString().trim();
  }

  String getPriceString() {
    StringBuffer result = StringBuffer();
    result.write(priceUS > 0 ? '\$$priceUS\n' : '');
    result.write(priceEU > 0 ? '€$priceEU\n' : '');
    result.write(priceEN > 0 ? '£$priceEN\n' : '');
    result.write(priceIN > 0 ? '₹$priceIN\n' : '');

    return result.toString().trim();
  }

  Widget getSmallImage() {
    if (img.isNotEmpty) {
      if (image.isEmpty) {
        image = base64Decode(img);
      }
      return Image.memory(
        image,
        errorBuilder: (context, object, stacktrace) {
          return const Text('☹️');
        },
        width: 47,
      );
    } else {
      return const Text('☹️');
    }
  }

  Widget getLargeImage() {
    if (img.isNotEmpty) {
      if (image.isEmpty) {
        image = base64Decode(img);
      }
      return Image.memory(
        image,
        errorBuilder: (context, object, stacktrace) {
          return const Text('☹️');
        },
        width: 200,
      );
    } else {
      return const Text('☹️');
    }
  }

  List<String> getTitleList() {
    return [
      'Model',
      'Company',
      'Network',
      'Announced',
      'Status',
      'Dimensions',
      'Weight',
      'Materials',
      'SIM',
      'Body others',
      'Display Type',
      'Display Size',
      'Display Resolution',
      'Display Protection',
      'Display Others',
      'OS',
      'Chipset',
      'CPU',
      'GPU',
      'CardSlot',
      'Memory',
      'Memory Others',
      'Rear Camera',
      'Rear Camera Features',
      'Rear Camera Video',
      'Front Camera',
      'Front Camera Features',
      'Front Camera Video',
      'Loud Speaker',
      'Earjack',
      'Sound Others',
      'Wifi',
      'Bluetooth',
      'GPS',
      'NFC',
      'Infrared',
      'Radio',
      'USB',
      'Sensors',
      'Others',
      'Battery',
      'Charging',
      'Colors',
      'ModelNames',
      'Price US',
      'Price EU',
      'Price EN',
      'Price IN',
    ];
  }

  List<String> toList() {
    return [
      model,
      company,
      network,
      announced,
      status,
      dimensions,
      weight,
      bodyMaterials,
      sim,
      bodyOthers,
      displayType,
      displaySize,
      displayResolution,
      displayProtection,
      displayOthers,
      os,
      chipset,
      cpu,
      gpu,
      cardSlot,
      memory,
      memoryOther,
      getRearCameraString(),
      rearCameraFeatures,
      rearCameraVideo,
      getFrontCameraString(),
      frontCameraFeatures,
      frontCameraVideo,
      loudSpeaker,
      earjack,
      soundOthers,
      wlan,
      bluetooth,
      gps,
      nfc,
      infrared,
      radio,
      usb,
      sensors,
      featureOthers,
      battery,
      charging,
      colors,
      modelName,
      (priceUS > 0 ? '\$$priceUS' : ''),
      (priceEU > 0 ? '€$priceEU' : ''),
      (priceEN > 0 ? '£$priceEN' : ''),
      (priceIN > 0 ? '₹$priceIN' : '')
    ];
  }

  String _getLaunchDate() {
    final reg = RegExp(r'(\d+, \w+)');
    final dateString = reg.firstMatch(status)?.group(0) ??
        reg.firstMatch(announced)?.group(0) ??
        '';
    if (dateString.isEmpty) {
      return '';
    } else {
      try {
        return DateFormat("''yy.M")
            .format(DateFormat('yyyy, MMMM').parse(dateString));
      } catch (e) {
        return '';
      }
    }
  }

  String _getDisplay() {
    final result = StringBuffer();

    var size = RegExp(r'[\d.]+').firstMatch(displaySize)?.group(0) ?? '';
    if (size.isNotEmpty) {
      result.write('$size" ');
    }

    var resolution =
        RegExp(r'[\d]+').firstMatch(displayResolution)?.group(0) ?? '';
    if (resolution.isNotEmpty) {
      switch (resolution) {
        case '720':
          result.write('HD+ ');
          break;
        case '1080':
          result.write('FHD+ ');
          break;
        case '1440':
          result.write('QHD+ ');
          break;
        default:
          var temp =
              RegExp(r'\d+ x \d+').firstMatch(displayResolution)?.group(0) ??
                  '';
          if (temp.isNotEmpty) {
            result.write('$temp ');
          }
          break;
      }
    }

    final informations = displayType.split(',');
    result.write('${informations[0]} ');

    for (var element in informations) {
      if (element.contains('Hz')) {
        result.write('(${element.trim()})');
      }
    }

    return result.toString().trim();
  }

  String _getOneChipset(String chipset) {
    if (chipset.contains('Qualcomm')) {
      return RegExp(r'Qualcomm ?([A-z]{2,4}[^ ]+)')
              .firstMatch(chipset)
              ?.group(1) ??
          '';
    } else if (chipset.contains('MediaTek')) {
      return RegExp(r'Media[T|t]ek ?([^\(.]+)').firstMatch(chipset)?.group(1) ??
          '';
    } else if (chipset.contains('Unisoc')) {
      return RegExp(r'Unisoc ?([^\(.]+)').firstMatch(chipset)?.group(1) ?? '';
    } else if (chipset.contains('Exynos')) {
      return RegExp(r'(Exynos .+) \(').firstMatch(chipset)?.group(1) ?? '';
    } else {
      return chipset;
    }
  }

  String _getChipset() {
    if (chipset.contains('\n')) {
      StringBuffer result = StringBuffer();
      chipset.split('\n').forEach((element) {
        result.write('${_getOneChipset(element)} ');
      });
      return result.toString();
    } else {
      return _getOneChipset(chipset);
    }
  }

  String _getCamera() {
    StringBuffer result = StringBuffer();

    var rearCamString = rearCameraModules
        .map((e) => RegExp(r'([\d\.]+)( )?MP').hasMatch(e)
            ? '${RegExp(r'([\d\.]+)( )?MP').firstMatch(e)?.group(1)}MP'
            : RegExp(r',').hasMatch(e)
                ? RegExp(r'([^,]*),').firstMatch(e)?.group(1)
                : e)
        .toList()
        .join("/");

    var frontCamString = frontCameraModules
        .map((e) => RegExp(r'([\d\.]+)( )?MP').hasMatch(e)
            ? '${RegExp(r'([\d\.]+)( )?MP').firstMatch(e)?.group(1)}MP'
            : RegExp(r',').hasMatch(e)
                ? RegExp(r'([^,]*),').firstMatch(e)?.group(1)
                : e)
        .toList()
        .join("/");

    if (frontCamString.isNotEmpty && rearCamString.isNotEmpty) {
      result.write('$rearCamString+$frontCamString');
    } else if (rearCamString.isNotEmpty) {
      result.write(rearCamString);
    } else if (frontCamString.isNotEmpty) {
      result.write('Front $frontCamString');
    }

    return result.toString();
  }

  String _getMemory() {
    StringBuffer result = StringBuffer();
    // var temp = memory.split(',');

    // for (var e in temp) {
    //   if (RegExp(r'([\d\.]+[G|M|K]B)[ ]*([\d\.]+[G|M|K]B)[ ]*RAM')
    //       .hasMatch(e)) {
    //     print(
    //         '${RegExp(r'([\d\.]+[G|M|K]B)[ ]*([\d\.]+[G|M|K]B)[ ]*RAM').firstMatch(e)?.group(2)}+${RegExp(r'([\d\.]+[G|M|K]B)[ ]*([\d\.]+[G|M|K]B)[ ]*RAM').firstMatch(e)?.group(1)}');
    //   } else {
    //     print(e);
    //   }
    // }

    result.write(memory
        .split(',')
        .map((e) => RegExp(r'([\d\.]+[G|M|K]B)[ ]*([\d\.]+[G|M|K]B)[ ]*RAM')
                .hasMatch(e)
            ? '${RegExp(r'([\d\.]+[G|M|K]B)[ ]*([\d\.]+[G|M|K]B)[ ]*RAM').firstMatch(e)?.group(2)}+${RegExp(r'([\d\.]+[G|M|K]B)[ ]*([\d\.]+[G|M|K]B)[ ]*RAM').firstMatch(e)?.group(1)}'
            : e)
        .toList()
        .join('/'));

    // result.write(memory
    //     .split(RegExp(',[ ]?'))
    //     .map((e) => RegExp(r'(\d+)GB (\d+)GB RAM').hasMatch(e)
    //         ? RegExp(r'(\d+)GB (\d+)GB RAM').firstMatch(e)
    //         : e)
    //     .toList()
    //     .join('/'));

    return result.toString().trim();
  }

  String _getBattery() {
    StringBuffer result = StringBuffer();
    var bat = RegExp(r'([\d\.]+[ ]*)mAh').firstMatch(battery)?.group(1);
    if (bat != null) {
      result.write('${bat}mAh');
    } else {
      result.write(battery);
    }

    var chg = charging
        .split('\n')
        .map((e) => RegExp(r'Fast charging ([\d\.]+[ ]?)W').hasMatch(e)
            ? '${RegExp(r'Fast charging ([\d\.]+[ ]?)W').firstMatch(e)?.group(1)}W'
            : RegExp(r'([\d\.]+[ ]?)W[ ]*[w|W]ired').hasMatch(e)
                ? '${RegExp(r'([\d\.]+[ ]?)W[ ]*wired').firstMatch(e)?.group(1)}W'
                : RegExp(r'[w|W]ireless charging ([\d\.]+)W').hasMatch(e)
                    ? '${RegExp(r'[w|W]ireless charging ([\d\.]+[ ]?)W').firstMatch(e)?.group(1)}W wireless'
                    : RegExp(r'([\d\.]+[ ]?)W[ ]*[w|W]ireless').hasMatch(e)
                        ? '${RegExp(r'([\d\.]+[ ]?)W[ ]*wireless').firstMatch(e)?.group(1)}W wireless'
                        : e)
        .toList()
        .join('/');
    if (chg.isNotEmpty) {
      result.write(' ($chg)');
    }

    return result.toString().trim();
  }

  List<String> toSimpleList() {
    return [
      network.contains('5G') && !model.contains('5G') ? '$model (5G)' : model,
      _getLaunchDate(),
      _getDisplay(),
      _getChipset(),
      _getCamera(),
      _getBattery(),
      _getMemory(),
    ];
  }

  List<String> getSimpleTitleList() {
    return [
      'Model',
      'Launch',
      'Display',
      'Chipset',
      'Camera',
      'Battery',
      'Memory',
    ];
  }

  @override
  List<Object?> get props => [id];
}
