abstract interface class AsyncClass<T> {
  final Completer<T> _initCompleter = Completer<T>();
  T operator ~() {
    return this as T;
  }
}

final class MyAsyncClass extends AsyncClass<MyAsyncClass> {
  MyAsyncClass() {
    Future(() async {
      /*do your async stuff */ _initCompleter.complete();
    });
  }

  final Completer<MyAsyncClass> _initCompleter = Completer<MyAsyncClass>();
}

final class MyAsyncClassFuture extends MyAsyncClass
    implements Future<MyAsyncClass> {
  Type get runtimeType => MyAsyncClass;

  MyAsyncClassFuture() : super() {
  }

  Stream<MyAsyncClass> asStream() => _initCompleter.future.asStream();
  Future<MyAsyncClass> catchError(Function onError,
          {bool test(Object error)?}) =>
      _initCompleter.future.catchError(onError, test: test);
  Future<R> then<R>(FutureOr<R> onValue(MyAsyncClass value),
          {Function? onError}) =>
      _initCompleter.future.then(onValue, onError: onError);

  Future<MyAsyncClass> timeout(Duration timeLimit,
          {FutureOr<MyAsyncClass> onTimeout()?}) =>
      _initCompleter.future.timeout(timeLimit, onTimeout: onTimeout);
  Future<MyAsyncClass> whenComplete(FutureOr<void> action()) =>
      _initCompleter.future.whenComplete(action);

  examples() {
    () async {
      /*returns not Future*/ MyAsyncClass();
      await MyAsyncClassFuture();
      await ~MyAsyncClass(); // returns MyAsyncClassFuture

      // As shown earlier Instead of this:
      MyAsyncClass ert = MyAsyncClass();
      // it could be this - no need for macro (not ert2, just ert):
      MyAsyncClass ert2 = await ~MyAsyncClass();
    }();

}
