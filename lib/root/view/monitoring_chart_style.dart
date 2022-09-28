import 'package:flutter/material.dart';
import 'package:ricoms_app/root/view/custom_style.dart';

class MonitoringChartStyle {
  static Widget getChartFilterData({
    required dynamic e,
    required Map<String, bool> checkBoxValues,
    required Map<String, ThresholdData> thresholdDataSet,
  }) {
    int style = e['style'] ?? -1;
    int length = e['length'] ?? 1;
    String value = e['value'].toString();
    double font = e['font'] != null ? (e['font'] as int).toDouble() : 14.0;
    int status = e['status'] ?? 0;
    String id = e['id'] != null ? e['id'].toString() : '-1';
    double majorH = e['MajorHI'] != null && e['MajorHI'] != 'x'
        ? double.parse(e['MajorHI'])
        : -1.0;
    double minorH = e['MinorHI'] != null && e['MinorHI'] != 'x'
        ? double.parse(e['MinorHI'])
        : -1.0;
    double majorL = e['MajorLO'] != null && e['MajorLO'] != 'x'
        ? double.parse(e['MajorLO'])
        : -1.0;
    double minorL = e['MinorLO'] != null && e['MinorLO'] != 'x'
        ? double.parse(e['MinorLO'])
        : -1.0;

    switch (style) {
      case 99: //勾選方塊
        if (id != '-1') {
          checkBoxValues[id] = false;
          thresholdDataSet[id] = ThresholdData(
            id: id,
            majorH: majorH,
            minorH: minorH,
            majorL: majorL,
            minorL: minorL,
          );
        }

        return Expanded(
          flex: (length * 0.5).ceil(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: CustomCheckbox(
                checkBoxValues: checkBoxValues,
                isEditing: true,
                readonly: 0,
                oid: id),
          ),
        );

      case 100: //文字標籤 - 白底黑字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.black, fontSize: font),
              ),
            ),
          ),
        );

      case 101: //文字標籤 - 灰底白字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 102: //文字標籤 - 白底藍字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.blue, fontSize: font),
              ),
            ),
          ),
        );
      case 103: //文字標籤 - 藍底白字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 104: //文字標籤 - 綠底白字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 105: //文字標籤 - 白底綠字
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.green, fontSize: font),
              ),
            ),
          ),
        );

      case 106: //文字標籤 - 白底黑字 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.black,
                    fontSize: font),
              ),
            ),
          ),
        );

      case 107: //文字標籤 - 白底藍字 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.blue,
                    fontSize: font),
              ),
            ),
          ),
        );

      case 108: //文字標籤 - 白底綠字 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.green,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 110: //文字標籤 - 白底黑字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.black, fontSize: font),
              ),
            ),
          ),
        );
      case 111: //文字標籤 - 灰底白字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 112: //文字標籤 - 白底藍字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.blue, fontSize: font),
              ),
            ),
          ),
        );
      case 113: //文字標籤 - 藍底白字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 114: //文字標籤 - 綠底白字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 115: //文字標籤 - 白底綠字, 文字置中
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.green, fontSize: font),
              ),
            ),
          ),
        );
      case 116: //文字標籤 - 白底黑字, 文字置中 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.black,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 117: //文字標籤 - 白底藍字, 文字置中 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.blue,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 118: //文字標籤 - 白底綠字, 文字置中 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.green,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 120: //文字標籤 - 白底黑字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.black,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 121: //文字標籤 - 灰底白字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 122: //文字標籤 - 白底藍字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.blue,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 123: //文字標籤 - 藍底白字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 124: //文字標籤 - 綠底白字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: font),
              ),
            ),
          ),
        );
      case 125: //文字標籤 - 白底綠字, 文字靠右
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.green,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 126: //文字標籤 - 白底黑字, 文字靠右 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.black,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 127: //文字標籤 - 白底藍字, 文字靠右 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.blue,
                    fontSize: font),
              ),
            ),
          ),
        );
      case 128: //文字標籤 - 白底綠字, 文字靠右 (有邊框)
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: CustomStyle.statusColor[status],
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color: status == 3 ? Colors.white : Colors.green,
                    fontSize: font),
              ),
            ),
          ),
        );
      default:
        return Expanded(
          flex: length,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.black, fontSize: font),
              ),
            ),
          ),
        );
    }
  }
}

class ThresholdData {
  const ThresholdData({
    required this.id, //threshold id
    required this.majorH,
    required this.minorH,
    required this.majorL,
    required this.minorL,
  });

  final String id;
  final double majorH;
  final double minorH;
  final double majorL;
  final double minorL;
}
