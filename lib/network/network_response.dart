/// The result of the network response.
/// Show the result, status and message of the response.
///
/// [message] is use if the response has loading and error statuses.
/// [data] is use if the response has completed status.
class NetworkResponse<T> {
  Status status;
  T? data;
  String? message;

  NetworkResponse.loading(this.message) : status = Status.loading;

  NetworkResponse.completed(this.data) : status = Status.completed;

  NetworkResponse.error(this.message) : status = Status.error;

  NetworkResponse.none() : status = Status.none;

  @override
  String toString() {
    return 'Status : $status \n Message : $message \n Data : $data';
  }
}

enum Status { loading, completed, error, none }

extension StatusExt on Status {
  bool get isLoading => this == Status.loading;

  bool get isCompleted => this == Status.completed;

  bool get isError => this == Status.error;

  bool get isNone => this == Status.none;
}
