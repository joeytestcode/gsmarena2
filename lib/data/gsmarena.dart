import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:html/dom.dart' as dom;

import '../common/webfetcher.dart';
import 'product.dart';

class GSMarena {
  static const compareBaseURL = 'https://m.gsmarena.com/compare.php3?idPhone1=';
  static const baseURL = 'https://m.gsmarena.com/';
  static const baseRumorUrl = 'https://m.gsmarena.com/rumored.php3';
  static const selectorRumor = '#list-brands > div > ul > li > a';
  static const selectorLatestContainer = '#latest-container > * > * > * > a';
  static const selectorInStoresContainer =
      '#instores-container > * > * > * > a';

  static Stream<Product> updateLatestModels(List<Product> existingList) async* {
    final int latestRumorId = await _getLatestRumorID();
    final int latestId = await _getLatestID();
    final int latestInStoreId = await _getLatestInStoreID();

    for (int id = latestRumorId; id > latestId; id--) {
      final Product product = await getProductSpec(id);
      if (product.model.isNotEmpty) {
        product.company = 'Rumor';
        yield product;
      }
    }
    for (int id = latestId; id > latestInStoreId; id--) {
      final Product product = await getProductSpec(id);
      if (product.model.isNotEmpty) {
        product.company = 'Released';
        yield product;
      }
    }
    for (int id = latestInStoreId; id > existingList[0].id; id--) {
      final Product product = await getProductSpec(id);
      if (product.model.isNotEmpty) {
        yield product;
      }
    }
    for (var item in existingList) {
      if (item.id <= latestInStoreId &&
          (item.company == 'Rumor' || item.company == 'Released')) {
        final Product product = await getProductSpec(item.id);
        if (product.model.isNotEmpty) {
          yield product;
        }
      }
    }
  }

  static Stream<Product> getAll(List<Product> existingList) async* {
    final int latestRomorId = await _getLatestRumorID();
    for (int id = latestRomorId; id > 0; id--) {
      final product = Product();
      product.id = id;
      if (!existingList.contains(product)) {
        final Product product = await getProductSpec(id);
        if (product.model.isNotEmpty) {
          yield product;
        }
      }
    }
  }

  static Future<Product> getProductSpec(int id) async {
    final dom.Document document =
        await WebFetcher.fetchData(compareBaseURL + id.toString());
    final Product product = Product();
    product.id = id;
    return await _updateProduct(product, document);
  }

  static Future<int> _getLatestRumorID() async {
    final dom.Document document = await WebFetcher.fetchData(baseRumorUrl);
    var test = document.querySelector(selectorRumor)?.attributes['href'];
    try {
      return int.parse(RegExp(r'(-)(\d*).php').firstMatch(test!)!.group(2)!);
    } catch (e) {
      return 0;
    }
  }

  static Future<int> _getLatestInStoreID() async {
    final dom.Document document = await WebFetcher.fetchData(baseURL);
    var test =
        document.querySelector(selectorInStoresContainer)?.attributes['href'];
    try {
      return int.parse(RegExp(r'(-)(\d*).php').firstMatch(test!)!.group(2)!);
    } catch (e) {
      return 0;
    }
  }

  static Future<int> _getLatestID() async {
    final dom.Document document = await WebFetcher.fetchData(baseURL);
    var test =
        document.querySelector(selectorLatestContainer)?.attributes['href'];
    try {
      return int.parse(RegExp(r'(-)(\d*).php').firstMatch(test!)!.group(2)!);
    } catch (e) {
      return 0;
    }
  }

  static Future<Product> _updateProduct(
      Product product, dom.Document document) async {
    product.model = document
            .querySelector('#specs-list > table > tbody > tr > td > a > h3')
            ?.text
            .trim() ??
        '';
    if (product.model.isEmpty) {
      return product;
    }

    product.company = product.model.split(' ')[0];
    product.imgSrc = document
            .querySelector('#specs-list > * > tbody > tr > td.nfo > a > img')
            ?.attributes['src'] ??
        '';
    if (product.imgSrc.isNotEmpty) {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(product.imgSrc)).load("");
      final data = imageData.buffer
          .asUint8List(imageData.offsetInBytes, imageData.lengthInBytes);
      product.img = base64Encode(data);
    }

    product.network =
        document.querySelector('[data-spec="nettech"]')?.text.trim() ?? '';
    product.announced =
        document.querySelector('[data-spec="year"]')?.text.trim() ?? '';
    product.status =
        document.querySelector('[data-spec="status"]')?.text.trim() ?? '';
    product.dimensions =
        document.querySelector('[data-spec="dimensions"]')?.text.trim() ?? '';
    product.weight =
        document.querySelector('[data-spec="weight"]')?.text.trim() ?? '';
    product.bodyMaterials =
        document.querySelector('[data-spec="build"]')?.text.trim() ?? '';
    product.sim =
        document.querySelector('[data-spec="sim"]')?.text.trim() ?? '';
    product.bodyOthers =
        document.querySelector('[data-spec="bodyother"]')?.text.trim() ?? '';
    product.displayType =
        document.querySelector('[data-spec="displaytype"]')?.text.trim() ?? '';
    product.displaySize =
        document.querySelector('[data-spec="displaysize"]')?.text.trim() ?? '';
    product.displayResolution = document
            .querySelector('[data-spec="displayresolution"]')
            ?.text
            .trim() ??
        '';
    product.displayProtection = document
            .querySelector('[data-spec="displayprotection"]')
            ?.text
            .trim() ??
        '';
    product.displayOthers =
        document.querySelector('[data-spec="displayother"]')?.text.trim() ?? '';
    product.os = document.querySelector('[data-spec="os"]')?.text.trim() ?? '';
    product.chipset =
        document.querySelector('[data-spec="chipset"]')?.text.trim() ?? '';
    product.cpu =
        document.querySelector('[data-spec="cpu"]')?.text.trim() ?? '';
    product.gpu =
        document.querySelector('[data-spec="gpu"]')?.text.trim() ?? '';
    product.cardSlot =
        (document.querySelector('[data-spec="memoryslot"]')?.text.trim() ?? '')
            .replaceFirst('Yes', 'Cardslot')
            .replaceFirst('No', '');
    product.memory =
        document.querySelector('[data-spec="internalmemory"]')?.text.trim() ??
            '';
    product.memoryOther =
        document.querySelector('[data-spec="memoryother"]')?.text.trim() ?? '';
    product.rearCameraModules =
        document.querySelector('[data-spec="cam1modules"]')?.text.split('\n') ??
            [];
    product.rearCameraFeatures =
        document.querySelector('[data-spec="cam1features"]')?.text.trim() ?? '';
    product.rearCameraVideo =
        document.querySelector('[data-spec="cam1video"]')?.text.trim() ?? '';
    product.frontCameraModules =
        document.querySelector('[data-spec="cam2modules"]')?.text.split('\n') ??
            [];
    product.frontCameraFeatures =
        document.querySelector('[data-spec="cam2features"]')?.text.trim() ?? '';
    product.frontCameraVideo =
        document.querySelector('[data-spec="cam2video"]')?.text.trim() ?? '';
    product.soundOthers =
        document.querySelector('[data-spec="optionalother"]')?.text.trim() ??
            '';
    product.wlan =
        (document.querySelector('[data-spec="wlan"]')?.text.trim() ?? '')
            .replaceFirst('Yes', 'WIFI')
            .replaceFirst('No', '');
    String data =
        document.querySelector('[data-spec="bluetooth"]')?.text.trim() ?? '';

    product.bluetooth == 'Yes'
        ? 'Bluetooth'
        : data == 'No'
            ? ''
            : 'Bluetooth' + data;

    product.gps =
        (document.querySelector('[data-spec="gps"]')?.text.trim() ?? '')
            .replaceFirst('Yes', 'GPS')
            .replaceFirst('No', '');
    product.nfc =
        (document.querySelector('[data-spec="nfc"]')?.text.trim() ?? '')
            .replaceFirst('Yes', 'NFC')
            .replaceFirst('No', '');
    product.radio =
        (document.querySelector('[data-spec="radio"]')?.text.trim() ?? '')
            .replaceFirst('Yes', 'Radio')
            .replaceFirst('No', '');
    product.usb =
        document.querySelector('[data-spec="usb"]')?.text.trim() ?? '';
    product.sensors =
        document.querySelector('[data-spec="sensors"]')?.text.trim() ?? '';
    product.featureOthers =
        document.querySelector('[data-spec="featuresother"]')?.text.trim() ??
            '';
    product.battery =
        document.querySelector('[data-spec="batdescription1"]')?.text.trim() ??
            '';
    product.colors =
        document.querySelector('[data-spec="colors"]')?.text.trim() ?? '';
    product.modelName =
        document.querySelector('[data-spec="models"]')?.text.trim() ?? '';
    var price = document
            .querySelector('[data-spec="price"]')
            ?.text
            .replaceAll(' ', '')
            .replaceAll(' ', '')
            .replaceAll(',', '') ??
        '';

    product.priceUS = double.parse(
        RegExp(r'\$(\d+\.?\d+)').firstMatch(price)?.group(1) ?? '-1');
    product.priceEU = double.parse(
        RegExp(r'€(\d+\.?\d+)').firstMatch(price)?.group(1) ?? '-1');
    product.priceEN = double.parse(
        RegExp(r'£(\d+\.?\d+)').firstMatch(price)?.group(1) ?? '-1');
    product.priceIN = double.parse(
        RegExp(r'₹(\d+\.?\d+)').firstMatch(price)?.group(1) ?? '-1');

    List<String> texts =
        document.querySelectorAll('td').map((e) => e.text.trim()).toList();
    texts[0] = '';

    product.loudSpeaker = texts[texts.indexOf('Loudspeaker') + 1]
        .replaceFirst('Yes', 'Loudspeaker')
        .replaceFirst('No', '');
    product.earjack = texts[texts.indexOf('3.5mm jack') + 1]
        .replaceFirst('Yes', '3.5mm earjack')
        .replaceFirst('No', '');
    product.infrared = texts[texts.indexOf('Infrared port') + 1]
        .replaceFirst('Yes', 'Infrared port')
        .replaceFirst('No', '');
    product.charging = texts[texts.indexOf('Charging') + 1];
    return product;
  }
}
