// ignore_for_file: avoid_print, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:quanht_auto_dropper/models/drop_item.dart';
import 'package:quanht_auto_dropper/quanht_auto_dropper.dart';

enum Format { EXCEL, PDF, UNKNOWN }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Auto Dropper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Format _formatSelect = Format.UNKNOWN;
  ScrollController scrollController = ScrollController();
  final _itemsFormat =
      Format.values.where((v) => v != Format.UNKNOWN).map((element) {
    final index = Format.values.indexOf(element);
    return DropItem(id: index, name: element.name, index: index, data: element);
  }).toList();

  void _selectDropdown(DropItem item) {
    _formatSelect = item.data;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
        title: Text(widget.title),
      ),
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'You just select :',
                    ),
                    Text(
                      _formatSelect.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    AppAutoDropdown(
                      items: _itemsFormat,
                      label: 'Label',
                      hintText: 'Hint text',
                      parentScrollController: scrollController,
                      onSelected: _selectDropdown,
                    ),
                    const SizedBox(height: 500.0),
                    AppAutoDropdown(
                      items: _itemsFormat,
                      label: 'Label',
                      hintText: 'Hint text',
                      parentScrollController: scrollController,
                      onSelected: _selectDropdown,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
