import 'package:flutter/material.dart';
import 'package:ReferAll/widget/CustomButton.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class RichEditor extends StatefulWidget {
  @override
  _RichEditorState createState() => _RichEditorState();
}

class _RichEditorState extends State<RichEditor> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "JD Editor",
          style: TextStyle(color: Colors.cyan),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.cyan,
            ),
            onPressed: () {
              Navigator.pop(context, _controller);
            }),
        actions: <Widget>[
          CustomButton(
            label: "Done",
            onTap: () {
              Navigator.pop(context, _controller);
            },
          )
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }
}
