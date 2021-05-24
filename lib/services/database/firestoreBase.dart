import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/services/error/error.dart';

class FirestoreService {
  /// This is an initialisation class.
  /// It only performs input output operations and provides streams
  /// Tt must never perform data manipulation tasks
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();

  /// Updates [data] to document provided
  Future<bool> updateData({
    required Map<String, dynamic> data,
    required DocumentReference document,
  }) async {
    try {
      return await document.update(data).then((value) => true);
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }

  /// Sets [data] to document provided
  Future<bool> setData({
    required Map<String, dynamic> data,
    required DocumentReference document,
  }) async {
    try {
      return await document.set(data).then((value) => true);
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }

  /// Gets [data] from document provided
  Future<Map<String, dynamic>> getData({
    required DocumentReference document,
  }) async {
    try {
      final snapshot = await document.get();
      if (snapshot.exists)
        return snapshot.data()!;
      else
        throw Exception("No Data Found");
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      return {};
    }
  }
}