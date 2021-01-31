import 'dart:async';

import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import '../../repositories/baseRepository.dart';
import 'header_map.dart';

/// Centered [CircularProgressIndicator] widget.
Widget get _loadingIndicator =>
    Center(child: const CircularProgressIndicator());

/// Function which handles reloading [QueryModel] models.
Future<void> _onRefresh(BuildContext context, BaseRepository repository) {
  final Completer<void> completer = Completer<void>();

  repository.refreshData().then((_) {
    if (repository.loadingFailed) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Error"),
          action: SnackBarAction(
            label: "Error",
            onPressed: () => _onRefresh(context, repository),
          ),
        ),
      );
    }
    completer.complete();
  });

  return completer.future;
}

/// This widget is used for all tabs inside the app.
/// Its main features are connection error handeling,
/// pull to refresh, as well as working as a sliver list.
class SliverPage<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final Widget header;
  final ScrollController controller;
  final List<Widget> body, actions;

  const SliverPage({
    @required this.title,
    @required this.header,
    @required this.body,
    this.controller,
    this.actions,
  });

  factory SliverPage.slide({
    @required String title,
    //@required List<String> slides,
    @required List<Widget> body,
    List<Widget> actions,
  }) {
    return SliverPage(
      title: title,
      header: SizedBox(height: 0),
      body: body,
      actions: actions,
    );
  }

  factory SliverPage.map({
    @required String title,
    @required LatLng coordinates,
    @required List<Widget> body,
    List<Widget> actions,
    Map<String, String> popupMenu,
  }) {
    return SliverPage(
      title: title,
      header: MapHeader(coordinates),
      body: body,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: CustomScrollView(
          key: PageStorageKey(title),
          controller: controller,
          slivers: <Widget>[
            /*SliverBar(
              title: title,
              header: model.isLoading
                  ? _loadingIndicator
                  : model.loadingFailed ? Separator.none() : header,
            ),*/
            if (model.isLoading)
              SliverFillRemaining(child: _loadingIndicator)
            else if (model.loadingFailed)
              SliverFillRemaining(
                child: ChangeNotifierProvider.value(
                  value: model,
                  child: ConnectionError<T>(),
                ),
              )
            else
              ...body,
          ],
        ),
      ),
    );
  }
}

/// Basic page which has reloading properties.
/// It uses the [BlanckPage] widget inside it.
class ReloadablePage<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final Widget body, fab;
  final List<Widget> actions;

  const ReloadablePage({
    @required this.title,
    @required this.body,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SimplePage1(
      title: title,
      fab: fab,
      body: Consumer<T>(
        builder: (context, model, child) => RefreshIndicator(
          onRefresh: () => _onRefresh(context, model),
          child: model.isLoading
              ? _loadingIndicator
              : model.loadingFailed
                  ? SliverFillRemaining(
                      child: ChangeNotifierProvider.value(
                        value: model,
                        child: ConnectionError<T>(),
                      ),
                    )
                  : SafeArea(bottom: false, child: body),
        ),
      ),
    );
  }
}

/// Widget used to display a connection error message.
/// It allows user to reload the page with a simple button.
class ConnectionError<T extends BaseRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => BigTip(
        subtitle: Text("Network Error"),
        action: Text(
          "Network Error",
          style: TextStyle(
            fontFamily: 'ProductSans',
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actionCallback: () async {},
        child: Icon(Icons.cloud_off),
      ),
    );
  }
}

/// Basic screen, which includes an [AppBar] widget.
/// Used when the desired page doesn't have slivers or reloading.
class SimplePage1 extends StatelessWidget {
  final String title;
  final Widget body, fab;
  final List<Widget> actions;

  const SimplePage1({
    @required this.title,
    @required this.body,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style: TextStyle(fontFamily: 'ProductSans'),
        ),
        centerTitle: true,
        actions: actions,
      ),
      body: body,
      floatingActionButton: fab,
    );
  }
}

/// Used when the desired page doesn't have slivers or reloading.
class SimplePage2 extends StatelessWidget {
  final Widget body, fab;
  final List<Widget> actions;

  const SimplePage2({
    @required this.body,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: fab,
    );
  }
}
