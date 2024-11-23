import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Text(
                  "Your Content Here",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Dock(
                items: const [
                  Icons.person,
                  Icons.message,
                  Icons.call,
                  Icons.camera,
                  Icons.photo,
                ],
                builder: (icon, isFocused) {
                  return AnimatedContainer(
                    
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: isFocused ? 80 : 64, // Control width here
                    height: isFocused ? 80 : 64, // Control height here
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors
                          .primaries[icon.hashCode % Colors.primaries.length],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isFocused
                          ? [BoxShadow(color: Colors.black26, blurRadius: 12)]
                          : null,
                    ),
                    child: Center(
                      child: Icon(icon, color: Colors.white, size: isFocused ? 40 : 28),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item with a focus state.
  final Widget Function(T item, bool isFocused) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  /// Index of the currently focused item for hover effect.
  int? _focusedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Make the Row only as wide as needed
        children: _items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return GestureDetector(
            key: ValueKey(item), // Assign a unique key for reorder
            onPanStart: (_) => setState(() => _focusedIndex = index),
            onPanEnd: (_) => setState(() => _focusedIndex = null),
            child: MouseRegion(
              onEnter: (_) => setState(() => _focusedIndex = index),
              onExit: (_) => setState(() => _focusedIndex = null),
              child: widget.builder(item, _focusedIndex == index),
            ),
          );
        }).toList(),
      ),
    );
  }
}
