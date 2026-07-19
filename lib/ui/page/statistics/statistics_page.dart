// ignore_for_file: incorrect_parent_class, missing_golden_test, avoid_hard_coded_strings
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../index.dart';

@RoutePage()
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(
      body: Center(
        child: CommonText(
          'Statistics Screen',
          style: null,
        ),
      ),
    );
  }
}
