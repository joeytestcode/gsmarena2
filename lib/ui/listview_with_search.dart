import 'package:flutter/material.dart';
import 'package:gsmarena2/ui/searchview.dart';
import 'show_spec_widget.dart';

class ListViewWithSearch extends StatefulWidget {
  const ListViewWithSearch(
      {Key? key, required this.list, required this.selectedList})
      : super(key: key);
  final List list;
  final List selectedList;

  @override
  State<ListViewWithSearch> createState() => _ListViewWithSearchState();
}

class _ListViewWithSearchState extends State<ListViewWithSearch> {
  String _query = '';

  List _search({List list = const [], String query = ''}) {
    return list.where((element) {
      var isContained = true;
      final string = element.toList().toString().toLowerCase();
      for (var q in query.split('  ')) {
        if (!string.contains(q.trim())) {
          isContained = false;
          break;
        }
      }
      return isContained || widget.selectedList.contains(element);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List list = _search(list: widget.list, query: _query);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return MultiSelectItem(
                  item: list[index],
                  onSelected: (bool value) {
                    if (value) {
                      widget.selectedList.add(list[index]);
                    } else {
                      widget.selectedList.remove(list[index]);
                    }
                  },
                  key: Key(list[index].id.toString()),
                  isSelected: widget.selectedList.contains(list[index]),
                );
              }),
        ),
        SearchView(onSearch: _onSearch),
      ],
    );
  }

  void _onSearch(String query) {
    setState(() {
      _query = query;
    });
  }
}

class MultiSelectItem extends StatefulWidget {
  MultiSelectItem(
      {required this.item,
      required this.onSelected,
      required this.isSelected,
      required key})
      : super(key: key);
  final dynamic item;
  final Function(bool) onSelected;
  bool isSelected = false;

  @override
  State<MultiSelectItem> createState() => _MultiSelectItemState();
}

class _MultiSelectItemState extends State<MultiSelectItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowSpecWidget(product: widget.item)));
        },
        child: Row(
          children: [
            widget.item.getSmallImage(),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(widget.item.model),
            )),
            Checkbox(
                value: widget.isSelected,
                onChanged: (value) {
                  setState(() {
                    widget.isSelected = value ?? false;
                    widget.onSelected(widget.isSelected);
                  });
                }),
          ],
        ),
      ),
    );
  }
}
