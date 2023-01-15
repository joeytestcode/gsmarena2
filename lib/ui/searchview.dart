import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView(
      {Key? key, this.enableSearchOnTextChange = true, required this.onSearch})
      : super(key: key);

  final bool enableSearchOnTextChange;
  final Function(String) onSearch;
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
          child: TextField(
            autofocus: true,
            controller: _controller,
            onSubmitted: widget.onSearch,
            onChanged: widget.enableSearchOnTextChange ? widget.onSearch : null,
            decoration: InputDecoration(
              fillColor: Colors.blueGrey.shade50,
              filled: true,
              prefixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  widget.onSearch(_controller.text);
                },
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  _controller.text = '';
                  widget.onSearch('');
                },
                icon: const Icon(
                  Icons.clear_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }
}
