import 'package:flutter/material.dart';

import 'edit_text.dart';
import 'model_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ModalText> textWidget = [];
  final List<ModalText> undo = [];
  final List<ModalText> redo = [];

  Offset? initialPosition;

  void addText() {
    var newText = ModalText(
      id: DateTime.now().millisecondsSinceEpoch,
      actionType: ActionType.add,
      position: const Offset(50, 50),
      text: "New Text", // Placeholder text
    );
    setState(() {
      textWidget.add(newText);
      undo.add(newText);
      redo.clear();
    });
  }

  void undoClick() {
    if (undo.isEmpty) return;
    final lastAction = undo.removeLast();

    if (lastAction.actionType == ActionType.property) {
      final index =
          textWidget.indexWhere((widget) => widget.id == lastAction.id);
      if (index != -1) {
        var current = textWidget[index];
        redo.add(ModalText(
          actionType: ActionType.property,
          id: current.id,
          position: current.position,
          text: current.text,
          previousPosition: current.previousPosition,
          bold: current.bold,
          fontName: current.fontName,
          italic: current.italic,
          textSize: current.textSize,
          underline: current.underline,
        ));
      }
    } else {
      redo.add(lastAction);
    }

    setState(() {
      switch (lastAction.actionType) {
        case ActionType.add:
          // Remove the text widget added
          textWidget.removeWhere((widget) => widget.id == lastAction.id);
          break;

        case ActionType.move:
          // Restore the previous position
          final index =
              textWidget.indexWhere((widget) => widget.id == lastAction.id);
          if (index != -1) {
            textWidget[index].position = lastAction.previousPosition!;
          }
          break;

        case ActionType.property:
          // Restore all properties
          final index =
              textWidget.indexWhere((widget) => widget.id == lastAction.id);
          if (index != -1) {
            textWidget[index]
              ..textSize = lastAction.textSize
              ..text = lastAction.text
              ..italic = lastAction.italic
              ..fontName = lastAction.fontName
              ..bold = lastAction.bold
              ..underline = lastAction.underline;
          }
          break;
      }
    });
  }

  void redoClick() {
    if (redo.isEmpty) return;
    final lastAction = redo.removeLast();
    if (lastAction.actionType == ActionType.property) {
      final index =
          textWidget.indexWhere((widget) => widget.id == lastAction.id);
      if (index != -1) {
        var current = textWidget[index];
        undo.add(ModalText(
          actionType: ActionType.property,
          id: current.id,
          position: current.position,
          text: current.text,
          previousPosition: current.previousPosition,
          bold: current.bold,
          fontName: current.fontName,
          italic: current.italic,
          textSize: current.textSize,
          underline: current.underline,
        ));
      }
    } else {
      undo.add(lastAction);
    }
    setState(() {
      switch (lastAction.actionType) {
        case ActionType.add:
          textWidget.add(lastAction);
          break;
        case ActionType.move:
          final index =
              textWidget.indexWhere((widget) => widget.id == lastAction.id);
          if (index != -1) {
            textWidget[index].position = lastAction.position;
          }
          break;

        case ActionType.property:
          final index =
              textWidget.indexWhere((widget) => widget.id == lastAction.id);
          if (index != -1) {
            textWidget[index]
              ..textSize = lastAction.textSize
              ..position = lastAction.position
              ..text = lastAction.text
              ..italic = lastAction.italic
              ..fontName = lastAction.fontName
              ..bold = lastAction.bold
              ..underline = lastAction.underline;
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      title: const Text(
        "Canvas Text",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromRGBO(8, 129, 117, 1.0),
    );

    var mQ = MediaQuery.of(context);
    double useHeight = mQ.size.height -
        mQ.padding.top -
        mQ.padding.bottom -
        appBar.preferredSize.height;
    double useWidth = mQ.size.width;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: useWidth,
              height: useHeight - 100,
              color: Colors.grey[200],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (textWidget.isEmpty)
                    const Text(
                      'Add Text',
                      style: TextStyle(fontSize: 30, color: Colors.grey),
                    )
                  else
                    ...textWidget.map(
                      (action) {
                        return Positioned(
                          left: action.position.dx,
                          top: action.position.dy,
                          child: GestureDetector(
                            onPanStart: (details) {
                              initialPosition = action.position;
                            },
                            onPanUpdate: (details) {
                              setState(() {
                                final index = textWidget.indexWhere(
                                    (widget) => widget.id == action.id);
                                if (index != -1) {
                                  final previousPosition =
                                      textWidget[index].position;
                                  textWidget[index].position = Offset(
                                      previousPosition.dx + details.delta.dx,
                                      previousPosition.dy + details.delta.dy);
                                }
                              });
                            },
                            onPanEnd: (detail) {
                              final index = textWidget.indexWhere(
                                  (widget) => widget.id == action.id);
                              if (index != -1 && initialPosition != null) {
                                final newPosition = textWidget[index].position;

                                undo.add(
                                  ModalText(
                                      actionType: ActionType.move,
                                      id: action.id,
                                      position: newPosition,
                                      previousPosition: initialPosition),
                                );
                                redo.clear();
                              }
                            },
                            onDoubleTap: () async {
                              var prev = ModalText(
                                underline: action.underline,
                                textSize: action.textSize,
                                italic: action.italic,
                                fontName: action.fontName,
                                bold: action.bold,
                                actionType: ActionType.property,
                                id: action.id,
                                position: action.position,
                                previousPosition: action.previousPosition,
                                text: action.text,
                              );

                              bool? check = await dialogShow(context, action);
                              if (check == true) {
                                setState(() {
                                  undo.add(prev);
                                  redo.clear();
                                });
                              }
                            },
                            child: Text(
                              action.text,
                              style: TextStyle(
                                fontFamily: action.fontName.name,
                                fontSize: action.textSize,
                                fontStyle: action.italic
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                fontWeight: action.bold
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                decoration: action.underline
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                                color: Colors.black,
                              ), // Truncate if text is too long, with ellipsis
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: undo.isNotEmpty ? undoClick : null,
                    icon: const Icon(Icons.undo_rounded),
                  ),
                  ElevatedButton(
                    onPressed: addText,
                    style: ButtonStyle(
                      elevation: WidgetStateProperty.all(0),
                      backgroundColor: WidgetStateProperty.all(
                          const Color.fromRGBO(8, 129, 117, 1.0)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.text_fields_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Add Text",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: redo.isNotEmpty ? redoClick : null,
                    icon: const Icon(Icons.redo_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
