import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsmarena2/data/repository.dart';
import 'package:share/share.dart';

import '../bloc/product_bloc.dart';
import '../common/makeexcel.dart';
import '../data/product.dart';
import 'listview_with_search.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Product> _selectedList = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(const EventStart());
    BlocProvider.of<ProductBloc>(context).add(const EventUpdateLatest());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  Widget getBody() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.list.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListViewWithSearch(
              list: state.list, selectedList: _selectedList);
        }
      },
    );
  }

  AppBar getAppBar() {
    return AppBar(
      title: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Row(
            children: [
              Text(widget.title),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(' (${_selectedList.length} / ${state.list.length})',
                    style: const TextStyle(fontSize: 14)),
              ),
            ],
          );
        },
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: TextButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save to Excel...'),
                onPressed: () async {
                  final file = await makeExcel(
                      contents: _selectedList.isEmpty
                          ? (await Repository().list)
                          : _selectedList,
                      fileName: 'GSMarena.xlsx');
                  Share.shareFiles([file], text: 'Excel File');
                  Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem(
              child: TextButton.icon(
                icon: const Icon(Icons.update),
                label: const Text('Update latest models from website...'),
                onPressed: () {
                  Navigator.pop(context);
                  BlocProvider.of<ProductBloc>(context)
                      .add(const EventUpdateLatest());
                },
              ),
            ),
            PopupMenuItem(
              child: TextButton.icon(
                icon: const Icon(Icons.update),
                label: const Text('Get all models from website...'),
                onPressed: () {
                  Navigator.pop(context);
                  BlocProvider.of<ProductBloc>(context)
                      .add(const EventGetAll());
                },
              ),
            ),
            PopupMenuItem(
              child: TextButton.icon(
                icon: const Icon(Icons.delete_forever_outlined),
                label: const Text('Clear all models...'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AlertDialog(
                      title: const Text('Warning!!!'),
                      content:
                          const Text('Do you really want to clear all data?'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              BlocProvider.of<ProductBloc>(context)
                                  .add(const EventClearAll());
                              _selectedList.clear();
                            },
                            child: const Text('YES')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('NO')),
                      ],
                    );
                  }));
                },
              ),
            ),
            PopupMenuItem(
              child: TextButton.icon(
                icon: const Icon(Icons.delete_forever_rounded),
                label: const Text('Remove selected models...'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AlertDialog(
                      title: const Text('Warning!!!'),
                      content: const Text(
                          'Do you really want to remove selected models?'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              BlocProvider.of<ProductBloc>(context).add(
                                  EventRemoveSelected(
                                      list: _selectedList.toList()));
                              _selectedList.clear();
                            },
                            child: const Text('YES')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('NO')),
                      ],
                    );
                  }));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
