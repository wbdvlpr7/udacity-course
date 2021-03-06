// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: unused_field

import 'package:flutter/material.dart';

// TODO: Check if we need to import anything
import 'category.dart';

final _backgroundColor = Colors.green[100];

// TODO: Define any constants

/// Category Route (screen).
///
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryRoute extends StatelessWidget {
  const CategoryRoute({Key? key}) : super(key: key);

  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Create a list of the eight Categories, using the names and colors
    // from above. Use a placeholder icon, such as `Icons.cake` for each
    // Category. We'll add custom icons later.
    final List<Category> categories = [];
    for (var i = 0; i < _categoryNames.length; i++) {
      categories.add(
        Category(
            name: _categoryNames[i],
            color: _baseColors[i] as ColorSwatch<dynamic>,
            iconLocation: Icons.cake),
      );
    }

    // TODO: Create a list view of the Categories
    final listView = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: _backgroundColor,
      child: _buildListView(categories),
    );

    // TODO: Create an App Bar
    final appBar = AppBar(
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: _backgroundColor,
      title: const Text(
        'Unit Converter',
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }

  ListView _buildListView(List<Category> categories) {
    return ListView.builder(
      itemBuilder: (context, index) => categories[index],
      itemCount: categories.length,
    );
  }
}
