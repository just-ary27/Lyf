import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../../global/variables.dart';
import '../../models/diary_model.dart';
import '../endpoints/diary_endpoints.dart';
import '../enums/query_type.dart';
import '../enums/request_type.dart';
import '../errors/diary/diary_errors.dart';
import '../helpers/http_helper.dart';
import '../helpers/uri_helper.dart';

class DiaryApiClient {
  DiaryApiClient._();

  /// Helper method to create a [DiaryEntry] in the database.
  static Future<int> createEntry({
    required DiaryEntry entry,
  }) async {
    http.Response? response;
    try {
      response = await HttpHelper.doDiaryRequest(
        requestType: RequestType.post,
        requestUri: UriHelper.constructUri(
          // queryType: QueryType.test,
          pathSegs: DiaryEndpoints.createEntry(
            userId: currentUser.userId,
          ),
        ),
        requestBody: entry.toData(),
      );
      if (response != null) {
        return response.statusCode;
      } else {
        return -1;
      }
    } on DiaryException catch (e, stackTr) {
      rethrow;
    }
  }

  static Future<DiaryEntry?> getEntry({
    required DiaryEntry entry,
  }) async {
    http.Response? response;
    DiaryEntry? responseEntry;
    try {
      response = await HttpHelper.doDiaryRequest(
        requestType: RequestType.get,
        requestUri: UriHelper.constructUri(
          pathSegs: DiaryEndpoints.getEntry(
            userId: currentUser.userId,
            entryId: entry.entryId!,
          ),
        ),
      );
      if (response != null) {
        var decodeResponse = jsonDecode(response.body);
        responseEntry = DiaryEntry.fromJson(decodeResponse);
      }
      return responseEntry;
    } on DiaryException catch (e, stackTr) {
      rethrow;
    }
  }

  /// Helper method to retrieve the entire Diary of a [LyfUser].
  static Future<List<DiaryEntry>?> getDiary() async {
    http.Response? response;
    List<DiaryEntry>? diary;
    try {
      response = await HttpHelper.doDiaryRequest(
        requestType: RequestType.get,
        requestUri: UriHelper.constructUri(
          // queryType: QueryType.test,
          pathSegs: DiaryEndpoints.getAllEntries(
            userId: currentUser.userId,
          ),
        ),
      );
      if (response != null) {
        diary = [];
        json.decode(response.body).forEach(
          (element) {
            DiaryEntry entry = DiaryEntry.fromJson(element);
            diary!.add(entry);
          },
        );
      }
      return diary;
    } on DiaryException {
      rethrow;
    }
  }

  /// Helper method that saves a [DiaryEntry] as a Pdf on the local storage.
  static Future<Uint8List?> getEntryPdf({
    required DiaryEntry entry,
  }) async {
    http.Response? response;
    try {
      response = await HttpHelper.doDiaryRequest(
        requestType: RequestType.get,
        requestUri: UriHelper.constructUri(
          pathSegs: DiaryEndpoints.getEntryPdf(
            userId: currentUser.userId,
            entryId: entry.entryId!,
          ),
        ),
      );
      if (response != null) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } on DiaryException catch (e, stackTr) {
      rethrow;
    }
  }

  /// Helper method that saves a [DiaryEntry] as a Txt file
  /// on the local storage.
  static Future<Uint8List?> getEntryTxt({
    required DiaryEntry entry,
  }) async {
    http.Response? response;
    try {
      response = await HttpHelper.doDiaryRequest(
        requestType: RequestType.get,
        requestUri: UriHelper.constructUri(
          pathSegs: DiaryEndpoints.getEntryTxt(
            userId: currentUser.userId,
            entryId: entry.entryId!,
          ),
        ),
      );
      if (response != null) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } on DiaryException catch (e, stackTr) {
      rethrow;
    }
  }

  /// Helper method that saves the diary of a [LyfUser] as a Pdf
  /// on the local storage.
  static Future<Uint8List?> getDiaryPdf() async {
    late http.Response? response;
    try {
      response = await HttpHelper.doDiaryRequest(
        requestType: RequestType.get,
        requestUri: UriHelper.constructUri(
          pathSegs: DiaryEndpoints.getDiaryPdf(
            userId: currentUser.userId,
          ),
        ),
      );
      if (response != null) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } on DiaryException catch (e, stackTr) {
      rethrow;
    }
  }

  /// Helper method that saves the diary of a [LyfUser] as a Txt file
  /// on the local storage.
  static Future<Uint8List?> getDiaryTxt() async {
    late http.Response? response;
    try {
      response = await HttpHelper.doDiaryRequest(
        requestType: RequestType.get,
        requestUri: UriHelper.constructUri(
          pathSegs: DiaryEndpoints.getDiaryTxt(
            userId: currentUser.userId,
          ),
        ),
      );
      if (response != null) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } on DiaryException catch (e, stackTr) {
      rethrow;
    }
  }

  /// Helper method to update a [DiaryEntry] in the database.
  static Future<int> updateEntry({
    required DiaryEntry entry,
  }) async {
    http.Response? response;
    try {
      response = await HttpHelper.doDiaryRequest(
        requestType: RequestType.put,
        requestUri: UriHelper.constructUri(
          // queryType: QueryType.test,
          pathSegs: DiaryEndpoints.updateEntry(
            userId: currentUser.userId,
            entryId: entry.entryId!,
          ),
        ),
        requestBody: entry.toData(),
      );
      if (response != null) {
        return response.statusCode;
      } else {
        return -1;
      }
    } on DiaryException catch (e, stackTr) {
      rethrow;
    }
  }

  /// Helper method to delete a [DiaryEntry] in the database.
  static Future<int> deleteEntry({
    required DiaryEntry entry,
  }) async {
    http.Response? response;
    try {
      response = await HttpHelper.doDiaryRequest(
        requestType: RequestType.delete,
        requestUri: UriHelper.constructUri(
          // queryType: QueryType.test,
          pathSegs: DiaryEndpoints.deleteEntry(
            userId: currentUser.userId,
            entryId: entry.entryId!,
          ),
        ),
      );
      if (response != null) {
        return response.statusCode;
      } else {
        return -1;
      }
    } on DiaryException catch (e, stackTr) {
      rethrow;
    }
  }
}
