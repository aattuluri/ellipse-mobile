import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';
import '../repositories/index.dart';

class Repository1 {
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
}
