enum ViewState {
  idle,
  busy, 
  empty,
  error,
}

enum ViewStateErrorType {
  defaultError,
  networkTimeOutError,
  unauthorizedError 
}

class ViewStateError {
  ViewStateErrorType _errorType;
  String message;
  String errorMessage;

  ViewStateError(this._errorType, {this.message, this.errorMessage}) {
    _errorType ??= ViewStateErrorType.defaultError;
    message ??= errorMessage;
  }

  ViewStateErrorType get errorType => _errorType;

  get isDefaultError => _errorType == ViewStateErrorType.defaultError;
  get isNetworkTimeOut => _errorType == ViewStateErrorType.networkTimeOutError;
  get isUnauthorized => _errorType == ViewStateErrorType.unauthorizedError;

  @override
  String toString() {
    return 'ViewStateError{errorType: $_errorType, message: $message, errorMessage: $errorMessage}';
  }
}