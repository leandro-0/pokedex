import 'package:flutter/material.dart';

class SelectableList<T> extends StatefulWidget {
  final List<T> items;
  final bool pinSelected;
  final bool Function(T) isSelected;
  final void Function(int index) onSelected;
  final Widget Function(T)? leadingBuilder;

  const SelectableList({
    super.key,
    required this.items,
    required this.isSelected,
    required this.onSelected,
    this.leadingBuilder,
    this.pinSelected = true,
  });

  @override
  State<SelectableList<T>> createState() => _SelectableListState<T>();
}

class _SelectableListState<T> extends State<SelectableList<T>> {
  bool _ordered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.pinSelected && !_ordered) {
      _ordered = true;
      int selectedIndex = 0;
      for (final item in widget.items) {
        if (widget.isSelected(item)) {
          final selected = widget.items.removeAt(selectedIndex);
          widget.items.insert(0, selected);
          break;
        }
        selectedIndex++;
      }
    }

    return ListView.separated(
      itemCount: widget.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 5.0),
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final isSelected = widget.isSelected(item);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Material(
              child: ListTile(
                leading: widget.leadingBuilder == null
                    ? null
                    : widget.leadingBuilder!(item),
                title: Text(
                  item.toString(),
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onTap: () => widget.onSelected(index),
                selected: isSelected,
                selectedTileColor: Colors.green[500],
                tileColor: Colors.transparent,
                selectedColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
