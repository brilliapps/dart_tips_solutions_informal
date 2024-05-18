/// SOME PARTS ARE COMMENTED
/// THIS IS UNPROFESSIONAL UNPOLISHED TESTS FILE FOR FUNCTION RECURSION CALL ERRORS
/// AND PROBABLY AT THE BOTTOM THE SOLUTION TO A MORE DEMANDING SITUATION (functionSyncAsync())

import 'dart:io';
import 'dart:async';

int counter = 0;
functionOne() {
  counter++;
  functionOne();
}

functionTwo() async {
  counter++;
  try {
    /// FIXME: SOMETHING STRANGE - IT IS ABLE TO BE CALLED MANY TIMES EVEN IF IT IS THROWING
    /// This looks as a Dart feature, like the call was compounded with
    /// two aspects sync and async and logically the code is fully performed synchronically FIRST
    /// as it is when you are aware of it by writing readable code.
    /// READ ALL BECAUSE I A BIT CHANGE MY MIND AFTER MORE HYPHOTHETICAL ANALYSIS.
    /// BUT IT SEEMS THAT "UNDER THE HOOD" THERE IS SOMETHING SIMILAR HAPPENING allowing for many synchronous calls (even with await)
    /// until the first synchornous StackOverflow (too many recursions)
    /// but finally in the meantime many async exceptions are thrown reaching the StackOverflow.
    /// The problem is that the supposed to be sync stackoverflow occurs after all the async exceptions (no async exception after the sync that)
    /// It could be explained that while this is done on the event loop isolate it is called with literally no any sorf of delay finishing in time even though you could expect a delay from the async.
    /// More on two isolates: So it is also possible it is the other way around - as synchronous calls are HERE (not always must be the case) on the main loop but async on the event loop, they could throw
    /// but the stack overflow occurs on the async calls. And all the async aspect are thrown on the event loop
    /// FIXME: let's do some little await before the exception message is printed here if the sync vs async order changes it is as written here
    /// As i can see the later called async part of the code in the main.dart file throws the same way when the delay is added so
    /// it additionally seems that the event loop has it's own max number of methods/parts-of-code in the queue
    await functionTwo();
  } catch (e) {
//    await Future.delayed(Duration(microseconds: 1), () {
//      print('delayed future');
//    });
    print(
        'functionTwo() inside the method body catch/rethrow: first what is thrown: $e');
    rethrow;
  }
}

int counterB = 0;
functionOneB() {
  counterB++;
  try {
    functionTwoB();
  } catch (e) {
    // throws sooner or later
    print(
        'functionTwoB() inside the method body catch/rethrow: first what is thrown: $e');
    rethrow;
  }
}

functionTwoB() async {
  counterB++;
  try {
    functionOneB();
  } catch (e) {
    print(
        'functionOneB() inside the method body catch/rethrow: first what is thrown: $e');
    rethrow;
  }
}

/// FIXME: DON'T KNOW EXACTLY WHAT DETERMINES HOW MUCH CALLS ARE ALLOWED - MAYBE TIME OF RECURSIVE CALLS WHICH SEEMS NOT TO BE THE CASE FO THE functionTwo() - allowed greater numbe of calls for something seemed more advanced, but there are some gaps involved in the async like htis little break in the consecutive async calls seems to relief the processor which allows for more calling.
/// 0 - timer

functionSync() {}

functionAsync() async {}

int counterC = 0;
functionSyncAsync() async {
  /// prevent from calling this method when the previous call is not finished - see the while() loop - like never ends
  //counterC = 0;
  functionSync();
  await () async {
    while (true) {
      counterC++;
      if (counterC > 1000000) {
        break;
      }
      await functionAsync();
      functionSync();
    }
  }();
}

main() {
  //int werwer = 0;
  //while (true) {
  //  try {
  //    werwer++;
  //    /*not await */ Future.delayed(Duration(milliseconds: 100000), () {
  //      /// INFO THIS ONE DOESN'T PRINT BECAUSE WHILE IS ON THE MAIN LOOP AND THE EVENT LOOP WAITS UNTIL THE SYNCHRONOUS PART FINISHED
  //      /// THIS IS SOMETHING I'VE FORGOTTEN AND NOW AFTER THESE TESTS I RECALLED
  //      /// !!!!! THE CRUCIAL CONCLUSION IS - IT DIDN'T THROW BUT DON'T KNOW HOW IT IS ADDED TO THE EVENT LOOP UNDER THE HOOD.
  //      /// I IMAGINE IT SHOULD BE ADDED TO SOME LIST AND IF IT WAS TOO MANY ELMEENTS IT WOULD THROW BUT IT WOULDN'T
  //      /// NEVERTHELESS THIS IS CERTAIN - ONLY THE RECURSIVE CALL ASPECT PLAYS ROLE HERE
  //      /// AND SEE functionTwo() ANALYSIS IN THE METHOD BODY - THAT PROBABLY SYNC ASPECT STOPS WITH TOO MANY RECURSIONS BUT THE SCHEDULED ASYNC ASPECT SUBCALLS THROW EARLIER (SHOULD LATER AS THE FOLLOWING TESTS SHOW BUT)
  //      print('delayed future');
  //    });
  //  } catch (e) {
  //    print(
  //        'Here we are - how many methods on the event loop? werwer = $werwer');
  //    rethrow;
  //  }
  //}
//

  // Recursion tests
  try {
    functionOne();
  } catch (e) {
    print('functionOne(): first what is thrown: $e');
  }
  print(
      'functionOne(): Counter is $counter it was at one time 47509, the numbers differ each call');
//  () async {
//    try {
//      await functionTwo();
//    } catch (e) {
//      print('functionTwo(): first what is thrown: $e');
//    }
//    print(
//        'functionTwo(): Counter is $counter it was at one time 64263, the numbers differ each call - async allows for more.');
//  }();
//  () async {
//    try {
//      await functionTwoB();
//    } catch (e) {
//      print('functionOneB() with functionTwoB(): first what is thrown: $e');
//    }
//    print(
//        'functionOneB() with functionTwoB(): Counter is $counterB it was at one time 29979, the numbers differ each call, this combination allows for less. The more code the less recursion and/or different methods taking part in recursion calls, allowed? not the most important');
//  }();

  () async {
    try {
      await functionSyncAsync();
    } catch (e) {
      print('functionSyncAsync(): first what is thrown: $e');
    }
    print(
        'functionSyncAsync(): CounterC is $counterC it was at one time 47509, the numbers differ each call');
  }();
}
