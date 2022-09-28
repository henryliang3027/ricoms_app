import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/history_repository.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/repository/system_log_repository.dart';
import 'package:ricoms_app/utils/common_style.dart';

class DisplayStyle {
  static Widget getNodeDisplayName(Node node, BuildContext context,
      {bool isLastItemOfDirectory = false}) {
    //for sliver list and directory
    // display name for each row
    if (node.type == 5) {
      //a8k slot
      if (node.shelf != 0 && node.slot == 0) {
        //a8k FAN slot
        return RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              const TextSpan(
                text: "FAN",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: CommonStyle.sizeXL,
                  color: Colors.blue,
                ),
              ),
              const TextSpan(
                text: ' ',
                style: TextStyle(
                  fontSize: CommonStyle.sizeXL,
                ),
              ),
              TextSpan(
                text: node.name,
                style: TextStyle(
                  fontSize: CommonStyle.sizeXL,
                  color: isLastItemOfDirectory ? Colors.blue : Colors.black,
                ),
              ),
            ],
          ),
        );
      } else if (node.shelf != 0) {
        // a8k normal slot
        return RichText(
          //textScaleFactor: 1.0,
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: node.slot.toString().padLeft(2, '0'),
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: CommonStyle.sizeXL,
                  color: Colors.blue,
                ),
              ),
              const TextSpan(
                text: ' ',
                style: TextStyle(
                  fontSize: CommonStyle.sizeXL,
                ),
              ),
              TextSpan(
                text: node.name,
                style: TextStyle(
                  color: isLastItemOfDirectory ? Colors.blue : Colors.black,
                  fontSize: CommonStyle.sizeXL,
                ),
              ),
            ],
          ),
        );
      } else if (node.shelf == 0 && node.slot == 0) {
        //PCML2 (L)
        return RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: "PCM2 (L)",
                style: TextStyle(
                  color: isLastItemOfDirectory ? Colors.blue : Colors.black,
                  fontSize: CommonStyle.sizeXL,
                ),
              ),
            ],
          ),
        );
      } else {
        return RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: node.name,
                style: TextStyle(
                  color: isLastItemOfDirectory ? Colors.blue : Colors.black,
                  fontSize: CommonStyle.sizeXL,
                ),
              ),
            ],
          ),
        );
      }
    } else if (node.type == 4) {
      //shelf
      return RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: 'Shelf ' + node.shelf.toString(),
              style: TextStyle(
                color: isLastItemOfDirectory ? Colors.blue : Colors.black,
                fontSize: CommonStyle.sizeXL,
              ),
            ),
          ],
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: node.name,
              style: TextStyle(
                color: isLastItemOfDirectory ? Colors.blue : Colors.black,
                fontSize: CommonStyle.sizeXL,
              ),
            ),
          ],
        ),
      );
    }
  }

  static String getDeviceDisplayName(Record record) {
    if (record.type == 5) {
      //a8k slot
      if (record.shelf == 0 && record.slot == 1) {
        return '${record.name} [ PCM2 (L) ]';
      } else if (record.shelf != 0 && record.slot == 0) {
        return '${record.name} [ Shelf ${record.shelf} / FAN ]';
      } else {
        return '${record.name} [ Shelf ${record.shelf} / Slot ${record.slot} ]';
      }
    } else {
      // edfa
      return record.name;
    }
  }

  static String getSystemLogDeviceTypeDeviceDisplayName(Log log) {
    if (log.type == 5) {
      //a8k slot
      if (log.shelf == 0 && log.slot == 1) {
        return '${log.name} [ PCM2 (L) ]';
      } else if (log.shelf != 0 && log.slot == 0) {
        return '${log.name} [ ${log.device} / Shelf ${log.shelf} / FAN ]';
      } else {
        return '${log.name} [ ${log.device} / Shelf ${log.shelf} / Slot ${log.slot} ]';
      }
    } else {
      // edfa
      return log.name;
    }
  }
}
