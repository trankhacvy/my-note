import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'view_state.dart';

export 'view_state.dart';

class ViewStateModel with ChangeNotifier {
  bool _disposed = false;

  ViewState _viewState;

  ViewStateModel({ViewState viewState})
      : _viewState = viewState ?? ViewState.idle {
    debugPrint('ViewStateModel---constructor--->$runtimeType');
  }

  ViewState get viewState => _viewState;

  set viewState(ViewState viewState) {
    _viewStateError = null;
    _viewState = viewState;
    notifyListeners();
  }

  ViewStateError _viewStateError;

  ViewStateError get viewStateError => _viewStateError;

  bool get isBusy => viewState == ViewState.busy;

  bool get isIdle => viewState == ViewState.idle;

  bool get isEmpty => viewState == ViewState.empty;

  bool get isError => viewState == ViewState.error;

  void setIdle() {
    viewState = ViewState.idle;
  }

  void setBusy() {
    viewState = ViewState.busy;
  }

  void setEmpty() {
    viewState = ViewState.empty;
  }

  void setError(e, stackTrace, {String message}) {
    ViewStateErrorType errorType = ViewStateErrorType.defaultError;

    //https://github.com/flutterchina/dio/blob/master/README-ZH.md#dioerrortype
    if (e is DioError) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.SEND_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorType = ViewStateErrorType.networkTimeOutError;
        message = e.error;
      } else if (e.type == DioErrorType.RESPONSE) {
        // incorrect status, such as 404, 503...
        message = e.error;
      } else if (e.type == DioErrorType.CANCEL) {
        // to be continue...
        message = e.error;
      } else {
        // dio将原error重新套了一层
        e = e.error;
        // if (e is UnAuthorizedException) {
        //   stackTrace = null;
        //   errorType = ViewStateErrorType.unauthorizedError;
        // } else if (e is NotSuccessException) {
        //   stackTrace = null;
        //   message = e.message;
        // }
        // else
        if (e is SocketException) {
          errorType = ViewStateErrorType.networkTimeOutError;
          message = e.message;
        } else {
          message = e.message;
        }
      }
    }
    viewState = ViewState.error;
    _viewStateError = ViewStateError(
      errorType,
      message: message,
      errorMessage: e.toString(),
    );
    printErrorStack(e, stackTrace);
    onError(viewStateError);
  }

  void onError(ViewStateError viewStateError) {}

  /// 显示错误消息
  showErrorMessage(context, {String message}) {
    if (viewStateError != null || message != null) {
      if (viewStateError.isNetworkTimeOut) {
        message ??= 'Internet error';
      } else {
        message ??= viewStateError.message;
      }
      Future.microtask(() {
        //display error message
      });
    }
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _viewStateError: $_viewStateError}';
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    debugPrint('view_state_model dispose -->$runtimeType');
    super.dispose();
  }
}

/// [e]为错误类型 :可能为 Error , Exception ,String
/// [s]为堆栈信息
printErrorStack(e, s) {
  debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----error-----↓↓↓↓↓↓↓↓↓↓----->
$e
<-----↑↑↑↑↑↑↑↑↑↑-----error-----↑↑↑↑↑↑↑↑↑↑----->''');
  if (s != null) debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----trace-----↓↓↓↓↓↓↓↓↓↓----->
$s
<-----↑↑↑↑↑↑↑↑↑↑-----trace-----↑↑↑↑↑↑↑↑↑↑----->
    ''');
}
