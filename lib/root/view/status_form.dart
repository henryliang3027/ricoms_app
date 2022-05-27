import 'package:flutter/material.dart';
import 'package:ricoms_app/root/view/custom_style.dart';

class StatusForm extends StatefulWidget {
  const StatusForm({Key? key, required this.items}) : super(key: key);

  final List items;

  @override
  State<StatusForm> createState() => _StatusFormState();
}

class _StatusFormState extends State<StatusForm>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    print('build Status');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var item in widget.items)
            if (item.length == 3) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 6.0),
                      child: CustomStyle.getBox(
                          item[0]['style'], item[0]['value']),
                    ),
                  ),
                  //CustomStyle.getBox(item[1]['style'], item[1]['value']),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CustomStyle.getBox(
                          item[2]['style'], item[2]['value']),
                    ),
                  ),
                ],
              )
            ] else if (item.length == 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CustomStyle.getBox(
                          item[0]['style'], item[0]['value']),
                    ),
                  ),
                ],
              ),
            ]
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
