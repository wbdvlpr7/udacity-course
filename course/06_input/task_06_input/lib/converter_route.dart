// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: unused_element

import 'package:flutter/material.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the color and units to not be null.
  const ConverterRoute({
    required this.color,
    required this.units,
    Key? key,
  }) : super(key: key);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  var ddlValue = '';
  double? _inputValue;
  String _outputValue = '';
  Unit? _inputUnit;
  Unit? _outputUnit;
  bool _hasInvalidInput = false;
  List<DropdownMenuItem<String>>? _dropdownItems;

  @override
  void initState() {
    super.initState();
    _initValues();
    _initDropdownItems();
  }

  void _initValues() {
    setState(() {
      _inputUnit = widget.units[0];
      _outputUnit = widget.units[1];
    });
  }

  void _initDropdownItems() {
    var items = widget.units
        .map((unit) => DropdownMenuItem(
              value: unit.name,
              child: Text(unit.name!),
            ))
        .toList();
    setState(() {
      _dropdownItems = items;
    });
  }

  _calculate() {
    if (_inputValue == null) return;
    setState(() {
      final calculatedValue =
          _inputValue! * _inputUnit!.conversion! / _outputUnit!.conversion!;
      _outputValue = _format(calculatedValue);
    });
  }

  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void _onCahngedInputDropdown(value) {
    setState(() {
      _inputUnit = widget.units.firstWhere((u) => u.name == value);
    });
    _calculate();
  }

  void _onCahngedOutputDropdown(value) {
    setState(() {
      _outputUnit = widget.units.firstWhere((u) => u.name == value);
    });
    _calculate();
  }

  void onChangedInputTextField(String value) {
    setState(() {
      if (value.isEmpty) {
        _outputValue = '';
        _hasInvalidInput = false;
        return;
      }
      final parsedValue = double.tryParse(value);
      if (parsedValue == null) {
        _outputValue = '';
        _hasInvalidInput = true;
        return;
      }
      _hasInvalidInput = false;
      _inputValue = parsedValue;
      _calculate();
    });
  }

  Widget _buildDropdown(String? value, Function(String?)? onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          width: 1.0,
          color: Colors.grey[400]!,
        ),
      ),
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
          icon: const Icon(Icons.arrow_drop_down),
          style: Theme.of(context).textTheme.headline6,
          value: value,
          isExpanded: true,
          underline: Container(),
          borderRadius: BorderRadius.circular(5),
          items: _dropdownItems,
          onChanged: onChanged,
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return widget.units
        .map((e) => DropdownMenuItem<String>(
              value: e.name,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  e.name.toString(),
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final inputWidget = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            onChanged: onChangedInputTextField,
            style: Theme.of(context).textTheme.headline4,
            decoration: InputDecoration(
              errorText: _hasInvalidInput ? 'Invalid number entered' : null,
              labelStyle: Theme.of(context).textTheme.headline4,
              border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
              labelText: 'Input',
            ),
          ),
          _buildDropdown(_inputUnit!.name, _onCahngedInputDropdown),
        ],
      ),
    );
    final outputWidget = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            child: Text(
              _outputValue,
              style: Theme.of(context).textTheme.headline4,
            ),
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.headline4,
              border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
              labelText: 'Output',
            ),
          ),
          _buildDropdown(_outputUnit!.name, _onCahngedOutputDropdown),
        ],
      ),
    );

    const compareArrow = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    return Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          inputWidget,
          compareArrow,
          outputWidget,
        ],
      ),
    );
  }
}
