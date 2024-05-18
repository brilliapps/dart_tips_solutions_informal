//NOT TYPICAL NOT OBVIOUS ASYNC CALLS 
//the most important:
//Any really asynchronous code that is called - it is executed always after the current synchronous block (maybe function/method) of code (where the async code was called) is finished. however if a not "await"-ed async function call that body consists of sync part, await part in the middle and again the sync part, so then after finishing the call of such a function the next instruction after the call have to it's disposal all data/changed properties/ect, but doesn't the part where await was called and not available the synchronous data/changed propertis/etc. 
//But instead of using syntax () {}() where the aforementioned rule applies use Future(function-whatever-sync-async-await-no-await-WHATEEEVER); and the whole part is not available to the synchronous code following the Future() constructor

/// SOME PARTS ARE COMMENTED
/// On the discord i have this confirmation of a popular user there: "async functions run synchronously until the first await"
/// ...code... () async {no-await-code}(); in-this-place-the-function-before-is-fully-finished
///  print('test1D');
///  () async {
///    print('test2D1'); // THIS PART IS CALLED BEFORE print('test3D')
///    await Future(() {}); // BUT THIS PART IS CALLED AFTER print('test3D')
///    print('test2D2'); // AND ALSO THIS PART IS CALLED BEFORE print('test3D')
///  }();
///  for (dynamic i = 10; i < 10000000000; i++) {} // THIS TAKES LIKE 10 SECONDS - with it or without it the same
///  print('test3D');

  //Another surprise: before the first await the code was performed synchronously so it's result is awailable to the 3D point, but 2D2 is not first
  //test1D
  //test2D1
  //test3D
  //test2D2

/// ...code... await () async {no-await-coDe}(); in-this-place-the-function-before-HASN'T-STARTED-YET
/// ...code... Future(() {}); in-this-place-the-function-before-that-was-passed-as-Future-constructor-param-HASN'T-STARTED-YET
/// Also all tests like this don't change the rule await () async {no-await-coe}() #HUUUGE 2 MINUTE SYNC LOOP# in-this-place-the-function-before-HASN'T-STARTED-YET;



import 'dart:io';
import 'dart:async';


main() {
  print('test1');
  () async {
    print('test2');
  }();
  print('test3');

  /// This printed 1, 2, 3 - well i didn't expect that while we are not on the event loop and in sync main() no await, etc.

  print('test1');
  Future(() async {
    print('test22');
  });
  print('test3');

  /// This 1,3 - the 2 was scheduled for much later even after the following code when the main file ended

  print('test1');
  () async {
    print('test23');
  }();
  print('test3');

  /// 1, 3, 2 - make sense - the 2 was slower

  print('test1A');
  Future(() async {
    print('test2A');
  });
  for (dynamic i = 10; i < 10000000000; i++) {}
  print('test3A');

  /// Pretty long 1, 3, 2 - it waits until sync finishes
  /// Let's do it with await but for the not working as i thought it would: () async {print('test23');}();
  /// WHAT IS IMPORTANT THE CRUCIAL test2D WAS PRINTED LAST HERE EVEN WHEN IN THis main() METHOD WAS THIS ONE PRINT "2D" SET
  /// THERE WERE OTHER FUTURES HERE ALL FINISHED AT THE END EXCEPT FOR THIS () async {print('test23');}();
  /// ALL THE 2 (TWOS) ARE AT THE END
  /// On the discord i have this confirmation of a popular user there: "async functions run synchronously until the first await"

  print('test1D');
  () async {
    await Future(() {});
    print('test2D');
  }();
  for (dynamic i = 10; i < 10000000000; i++) {}
  print('test3D');

  print('test1A');
  Future(() async {
    print('test2A');
  });
  for (dynamic i = 10; i < 10000000000; i++) {}
  print('test3A');

  print('test1E');
  Future abc = () async {
    await Future(() {});
    print('test2E');
  }();
  for (dynamic i = 10; i < 10000000000; i++) {}
  print('test3E $abc ${abc.runtimeType}');
  //prints as expected based on the info on the discord
  //test1E
  //test3E Instance of 'Future<Null>' Future<Null>
  //test2E

  () async {
    print('test1F');
    await () async {
      print('test2F');
    }();
    print('test3F $abc ${abc.runtimeType}');
    //prints as expected based on the info on the discord
    //test1F
    //test2F
    //test3F Instance of 'Future<Null>' Future<Null>
  }();

  print('test1G');
  Future(() {
    print('test2G');
  });
  print('test3G');
  //was not sure what to expect - it executes SYNCHRONOUS function with the delay not as with the rule that there must be await or something, prints:
  //test1G
  //test3G
  //test2G  
}
