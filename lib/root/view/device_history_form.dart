import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/view/custom_style.dart';

class DeviceHistoryForm extends StatefulWidget {
  const DeviceHistoryForm({Key? key, required this.rootRepository})
      : super(key: key);

  final RootRepository rootRepository;

  @override
  State<DeviceHistoryForm> createState() => _DeviceHistoryFormState();
}

class _DeviceHistoryFormState extends State<DeviceHistoryForm> {
  _mySliverChildBuilderDelegate(List data) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        print('build _mySliverChildBuilderDelegate : ${index}');
        return Padding(
          padding: EdgeInsets.all(1.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          width: 30.0,
                          height: 60.0,
                          color:
                              CustomStyle.severityColor[data[index]['status']],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 2.0),
                          child: Container(
                            child: Text(
                              data[index]['event'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 18.0,
                                //fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 6.0),
                          child: Container(
                            child: Text(
                              data[index]['start_time'],
                              style: GoogleFonts.roboto(
                                fontSize: 12.0,
                                //fontWeight: FontWeight.w600,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      childCount: data.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.rootRepository.getDeviceHistory(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List) {
            return Container(
              color: Colors.grey.shade300,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: _mySliverChildBuilderDelegate(snapshot.data))
                ],
              ),
            );
          } else {
            //String
            return Center(
              child: Text("Error: ${snapshot.data}"),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
