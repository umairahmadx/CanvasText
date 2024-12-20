import 'package:flutter/material.dart';
import 'model_text.dart';

Future<bool?> dialogShow(BuildContext context, ModalText textItem) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      TextEditingController controller = TextEditingController();
      TextEditingController numberController = TextEditingController();

      numberController.text = textItem.textSize.toString();
      controller.text = textItem.text;
      bool isBold = textItem.bold;
      bool isItalic = textItem.italic;
      bool isUnderLined = textItem.underline;
      FontName? fontFamily = textItem.fontName;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogueState) {
          return AlertDialog(
            title: const Text("Edit Text"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: "Enter text"),
                    style: TextStyle(
                      fontFamily: fontFamily?.name,
                      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      decoration: isUnderLined
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          setDialogueState(() {
                            isBold = !isBold;
                          });
                        },
                        icon: const Icon(Icons.format_bold_rounded),
                      ),
                      IconButton(
                        onPressed: () {
                          setDialogueState(() {
                            isItalic = !isItalic;
                          });
                        },
                        icon: const Icon(Icons.format_italic_rounded),
                      ),
                      IconButton(
                        onPressed: () {
                          setDialogueState(() {
                            isUnderLined = !isUnderLined;
                          });
                        },
                        icon: const Icon(Icons.format_underlined_rounded),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Font size"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          double num = double.parse(numberController.text) - 1;
                          if(num>0){
                            numberController.text =num.toString();
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: numberController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          numberController.text =
                              (double.parse(numberController.text) + 1)
                                  .toString();
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Font"),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: DropdownButton(
                          items: const [
                            DropdownMenuItem(
                              value: FontName.Roboto,
                              child: Text("Roboto"),
                            ),
                            DropdownMenuItem(
                              value: FontName.Montserrat,
                              child: Text("Montserrat"),
                            ),
                            DropdownMenuItem(
                              value: FontName.Mali,
                              child: Text("Mali"),
                            ),
                          ],
                          isExpanded: true,
                          onChanged: (value) {
                            if (value != null) {
                              setDialogueState(() {
                                fontFamily = value;
                              });
                            }
                          },
                          value: fontFamily,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false if cancelled
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  textItem.text = controller.text;
                  textItem.bold = isBold;
                  textItem.italic = isItalic;
                  textItem.underline = isUnderLined;
                  textItem.textSize = double.parse(numberController.text);
                  textItem.fontName = fontFamily!;
                  Navigator.of(context).pop(true); // Return true if saved
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    },
  ); // Ensure a default value is returned if showDialog returns null
}
