import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  final String title, link;
  PdfView(this.title, this.link);
  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
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
              Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.previousPage();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.nextPage();
            },
          ),
          /*IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).textTheme.caption.color,
                size: 27,
              ),
              onPressed: () {}),*/
        ],
      ),
      body: SfPdfViewer.network(
        '${widget.link}',
        controller: _pdfViewerController,
      ),
    );
  }
}
