import 'package:flutter/material.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';

class DisplayStyle {
  static Widget getDisplayName(Node node, BuildContext context,
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
              TextSpan(
                text: "FAN",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: CommonStyle.sizeXL,
                  color: isLastItemOfDirectory
                      ? CustomStyle.severityColor[node.status]
                      : Colors.blue,
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
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: node.slot.toString().padLeft(2, '0'),
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: CommonStyle.sizeXL,
                  color: isLastItemOfDirectory
                      ? CustomStyle.severityColor[node.status]
                      : Colors.blue,
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
}
