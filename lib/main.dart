import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Dock<IconData>(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (icon, isHovered, isDragging) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: isHovered ? 80 : 64,
                height: isHovered ? 80 : 64,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.primaries[icon.hashCode % Colors.primaries.length],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: isHovered ? 20 : 10,
                      offset: Offset(0, isHovered ? 6 : 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isHovered ? 36 : 28,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  
  final List<T> items;

  
  final Widget Function(T item, bool isHovered, bool isDragging) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T extends Object> extends State<Dock<T>> {
  
  late final List<T> _items = widget.items.toList();
  int? _hoverIndex;
  int? _draggingIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black26,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isHovered = _hoverIndex == index;
          final isDragging = _draggingIndex == index;

          return DragTarget<T>(
            onWillAccept: (data) {
              setState(() {
                _hoverIndex = index;
              });
              return true;
            },
            onLeave: (_) {
              setState(() {
                _hoverIndex = null;
              });
            },
            onAccept: (data) {
              final fromIndex = _draggingIndex!;
              final toIndex = index;

              setState(() {
                final removed = _items.removeAt(fromIndex);
                _items.insert(toIndex, removed);
                _draggingIndex = null;
                _hoverIndex = null;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return LongPressDraggable<T>(
                data: item,
                dragAnchorStrategy: pointerDragAnchorStrategy,
                feedback: Material(
                  color: Colors.transparent,
                  child: widget.builder(item, true, true),
                ),
                childWhenDragging: const SizedBox.shrink(),
                onDragStarted: () {
                  setState(() {
                    _draggingIndex = index;
                  });
                },
                onDragEnd: (_) {
                  setState(() {
                    _draggingIndex = null;
                    _hoverIndex = null;
                  });
                },
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _hoverIndex = index;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      if (_hoverIndex == index) _hoverIndex = null;
                    });
                  },
                  child: widget.builder(item, isHovered, isDragging),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
