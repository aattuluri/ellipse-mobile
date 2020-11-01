import 'package:EllipseApp/ui/widgets/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

Future<Response> getData(String url) async {
  return Dio().get(url);
}

class MdDecode extends StatefulWidget {
  final String title;
  final String url;
  MdDecode(this.title, this.url);
  @override
  _MdDecodeState createState() => _MdDecodeState();
}

class _MdDecodeState extends State<MdDecode> {
  String data;
  bool isLoading = false;
  loadData() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      data = '';
    });
    try {
      final Response response = await getData('${widget.url}');
      setState(() {
        data = response.data;
      });
      print(data);
      setState(() {
        isLoading = false;
      });
    } catch (_) {}
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 4,
        title: Text(
          '${widget.title}',
          style: TextStyle(
              color: Theme.of(context).textTheme.caption.color,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [],
        centerTitle: true,
      ),
      body: isLoading
          ? LoaderCircular(0.25, 'Loading')
          : Markdown(
              data: data,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                blockSpacing: 12,
                h2: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headline6.color,
                  fontFamily: 'ProductSans',
                ),
                p: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.caption.color,
                ),
              ),
            ),
    );
  }
}
