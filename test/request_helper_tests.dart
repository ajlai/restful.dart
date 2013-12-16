library restful.tests.request;

import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
import 'package:restful/src/request_helper.dart';
import 'package:restful/src/formats.dart';
import 'request_mock.dart';

class FormatContentTypeLess extends JsonFormat {
  get contentType => null;
}

void testRequests() {
  group("Request", () {
    HttpRequestMock httpRequest;

    setUp(() {
      httpRequest = new HttpRequestMock();
      httpRequestFactory = () => httpRequest;
    });

    group("with a contentType on format", () {
      var format = JSON_FORMAT;
      test("should set header's Content-Type on POST requests", () {
        var request = new RequestHelper.post('url', format);
        request.send().then(expectAsync1((json) {
          httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', format.contentType)).verify(happenedOnce);
        }));
      });

      test("should set header's Content-Type on PUT requests", () {
        new RequestHelper.put('url', format).send().then(expectAsync1((json) {
          httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', format.contentType)).verify(happenedOnce);
        }));
      });

      test("should not set header's Content-Type on GET requests", () {
        new RequestHelper.get('url', format).send().then(expectAsync1((json) {
          httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', format.contentType)).verify(neverHappened);
        }));
      });
    });

    group("without a contentType on format", () {
      var format = new FormatContentTypeLess();

      test("should not set header's Content-Type on POST requests", () {
        var request = new RequestHelper.post('url', format);
        request.send().then(expectAsync1((json) {
          httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', format.contentType)).verify(neverHappened);
        }));
      });

      test("should not set header's Content-Type on PUT requests", () {
        new RequestHelper.put('url', format).send().then(expectAsync1((json) {
          httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', format.contentType)).verify(neverHappened);
        }));
      });

      test("should not set header's Content-Type on GET requests", () {
        new RequestHelper.get('url', format).send().then(expectAsync1((json) {
          httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', format.contentType)).verify(neverHappened);
        }));
      });
    });
  });
}