import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class PdfView extends StatefulWidget {
  final String title, link;
  PdfView(this.title, this.link);
  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  String link = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(widget.title),
        elevation: 5,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).textTheme.caption.color,
                size: 27,
              ),
              onPressed: () {}),
        ],
      ),
      body: PDF.network(
        '${widget.link}',
        placeHolder: Image.asset('assets/icons/loading.gif'),
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
