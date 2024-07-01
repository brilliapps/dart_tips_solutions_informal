abstract mixin class AsyncClass<T> {
  /// important for me - it's ok: as tested on my dart tips tricks page this is declared in more than one places but only one instance is visible everywhere even if one overrides the other. Also no problem with casting to the child class because you can cast to ancestor class only.
  final Completer<T> _initCompleter = Completer<T>();
  Future<T> operator ~() {
    //return this as AsyncClassFutureMixin - error;
    return _initCompleter.future;
  }
}

/// Concept (even if wrong), @Async macro applied for this class might return the following code:
/// The only way to have any [MyAsyncClass] is to create instance of the class [MyAsyncClassFuture] - if you "await" it (MyAsyncClass abc = await MyAsyncClassFuture()) you get fully aynchronously inited [MyAsyncClass]
/// [_MyAsyncClass] is private so that you can instantiate it on your own
/// In the constructor body is something like this to show how to init your async class:
/// example - may be done in many ways
/// you just have to finish with _initCompleter.complete(); or _initCompleter.completeError();
/// Future(() async {/*do your async stuff */_initCompleter.complete();});
/// Advanced tip, not recommended. You could also to this (if no single await is inside this function before the _initCompleter.complete() then the method is completed synchronously as tested in my github dart page and as the   Type get runtimeType => MyAsyncClass; of future enforces the [MyAsyncClassFuture] class to be seen as normal [MyAsyncClass] (still future)) the non awaited [MyAsyncClassFuture] is silently finished synchronously and the line after the desired [MyAsyncClass] is compleletely finished:
///() async {/*do your async stuff */_initCompleter.complete();}();

@Async()
final class MyAsyncClass with AsyncClass<MyAsyncClass> {
  MyAsyncClass() {
    /// example - may be done in many ways
    /// you just have to finish with _initCompleter.complete(); or _initCompleter.completeError();
    Future(() async {
      /*do your async stuff */ _initCompleter.complete(this);
    });

    /// Advanced tip, not recommended. You could also to this (if no single await is inside this function before the _initCompleter.complete() then the method is completed synchronously as tested in my github dart page and as the   Type get runtimeType => MyAsyncClass; of future enforces the [MyAsyncClassFuture] class to be seen as normal [MyAsyncClass] (still future)) the non awaited [MyAsyncClassFuture] is silently finished synchronously and the line after the desired [MyAsyncClass] is compleletely finished:
    () async {
      /*do your async stuff */ _initCompleter.complete(this);
    }();
  }

  /// This you must call [MyAsyncClassFuture]
  /// Example code - to be overiden by something real.
  /// As i tested casting as AsyncClass will not cause Object.runtimeType to be AsyncClass but operator "is _MyAsyncClass" == true. In exactly this empty private _MyAsyncClass class case no difference between you cast it or not
  /// Macros should change this:
  /// @Await() MyAsyncClass ert =  MyAsyncClassFuture();
  /// into something like this
  /// MyAsyncClass ert =  await MyAsyncClassFuture();
  /// Without it it would be this instance returned which is normally unfinished Future
  /// All depending how this class will be implemented Future<...>, FutureOr<...>
  // final Completer<MyAsyncClass> _initCompleter = Completer<MyAsyncClass>();
}

abstract mixin class AsyncClassFutureMixin<T> implements Future<MyAsyncClass> {
  /// important for me - it's ok: as tested on my dart tips tricks page this is declared in more than one places but only one instance is visible everywhere even if one overrides the other. Also no problem with casting to the child class because you can cast to ancestor class only.
  late final Completer<MyAsyncClass> _initCompleter = Completer<MyAsyncClass>();

  Type get runtimeType => MyAsyncClass;

  Stream<MyAsyncClass> asStream() => _initCompleter.future.asStream();
  Future<MyAsyncClass> catchError(Function onError,
          {bool test(Object error)?}) =>
      _initCompleter.future.catchError(onError, test: test);
  Future<R> then<R>(FutureOr<R> onValue(MyAsyncClass value),
          {Function? onError}) =>
      _initCompleter.future.then(onValue, onError: onError);

  /// [Edit] No lint error - answer from discord! implements Future (Future<dynamic>) changed to Future<_MyAsyncClass>. The old problem Lint error incompatible with docs? or something FutureOr<_MyAsyncClass> onTimeout()? must have been changed to FutureOr<dynamic> onTimeout()? then cast to FutureOr<_MyAsyncClass> Function()?
  Future<MyAsyncClass> timeout(Duration timeLimit,
          {FutureOr<MyAsyncClass> onTimeout()?}) =>
      _initCompleter.future.timeout(timeLimit, onTimeout: onTimeout);
  Future<MyAsyncClass> whenComplete(FutureOr<void> action()) =>
      _initCompleter.future.whenComplete(action);
}

/// An instantiable non-future [MyAsyncClass] instance but the class that can be created only by the [MyAsyncClassFuture] that is a [Future] that can be awaited
//final class _MyAsyncClass extends MyAsyncClass {
//  _MyAsyncClass() : super();
//}

/// The only way to have any [MyAsyncClass] is to create instance of this class [MyAsyncClassFuture] - if you await it (MyAsyncClass abc = await MyAsyncClassFuture()) you get fully aynchronously inited [MyAsyncClass]
final class MyAsyncClassFuture extends MyAsyncClass
    with AsyncClassFutureMixin<MyAsyncClass> {
  MyAsyncClassFuture() : super() {}

  examples() {
    () async {
      /*return not Future*/ MyAsyncClass();
      await MyAsyncClassFuture(); 
      await ~MyAsyncClass(); // returns not MyAsyncClassFuture (as previously - error) but _initCompleter.future Future<MyAsyncClass>

      // As shown earlier Instead of this:
      @Await()
      MyAsyncClass ert = MyAsyncClass();
      // it could be this - no need for macro (not ert2, just ert):
      MyAsyncClass ert2 = await ~MyAsyncClass();
    }();

    /// Usage, macro will change the following line to MyAsyncClass ert = await MyAsyncClassFuture(); But you can use it without @Await then it will not change it anything but work normally not awaiting until the _initCompleter will be finished. Also as descrbed in one of the classes you can possibly finish the completer synchronously but certain condition must be met then even not awaited class will be inited synchronously - more difficult to achieve and needless normally but possible.
    /// Unfortunately meta tags/macros are applied to declarations only not like to @Await() MyAsyncClassFuture()
    //@Await()
    //MyAsyncClass ert = MyAsyncClass();
    //() async {
    //    await MyAsyncClassFuture();
    //    await ~MyAsyncClass();
    //    //but for the below the class MyAsyncClassFuture would have to have no stuff in the constructor nor additional [Completer], just implementing the Future interface plus runtimeType overriden as it can be instantiated but must be seen as not the future Type but the original class it inherits from.
    //    await (MyAsyncClass() as MyAsyncClassFuture);
    //}();
    ////this and similar wont work:
    ////  @Await() () {MyAsyncClassFuture();}();
    //
    //~MyAsyncClass();
    //Await; MyAsyncClass();
    //Await(); MyAsyncClass();

    //this won't work:
    //@Await()
    //MyAsyncClass();
    //

    // Probably some simingly nice looking solution (not tested but no errors in VsCode). To simplify i could do it different way (still not the best but - using some operator i don't know the meaning of).

    //final class MyAsyncClass implements AsyncClass {
    //  MyAsyncClassFuture operator ~() => this as MyAsyncClassFuture;
    //  //...
    //}
  }
}
