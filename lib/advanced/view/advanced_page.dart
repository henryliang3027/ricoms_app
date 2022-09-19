import 'package:flutter/material.dart';
import 'package:ricoms_app/advanced/view/advanced_form.dart';

class AdvancedPage extends StatelessWidget {
  const AdvancedPage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return AdvancedForm(
      pageController: pageController,
    );
  }
}
