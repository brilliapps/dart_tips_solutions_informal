dart_tips_solutions_informal
===================================================================================
Some needed often difficult to find solutions, tips, etc. focusing on dart and VScode too.
===================================================================================
Shon Connery: very naish https://pub.dev/packages/webcrypto
===================================================================================
If you access unexisten element of a List - it throws. If Map returns null;
===================================================================================
Isolates - for run and spawn the same result (here spawn).
So as the docs also says there is overhead related to it because of copying so it is sort of convenience syntax and they recommend using messaging for heavier longer running stuff.
So in essence as the docs say copies of objects are copies you will never change the original object on the source isolate but the copy.
  https://dart.dev/language/isolates#running-an-existing-method-in-a-new-isolate
  https://api.flutter.dev/flutter/foundation/compute.html
Now example:

int b = 20;

class A {
  int a = 10;
  c() {
    b++;
  }
}

void main() async {
  var a = A();

  await Isolate.spawn<void>((void v) {
    print(a.a);
    a.a = 11;
    a.c();
    print(a.a);
    print(b);
  }, Void);
  print('=============');
  print(a.a);
  print(b);

prints:
flutter: 10
flutter: 11
flutter: 21
flutter: 10
flutter: 20


===================================================================================
You can apply a macro to an entire file/library (have no detailed knowledge to distinguish between them)
@MyMacro();
library;

you can't investigate the method body but you can use augmented(); method which somehow performes the old stuff.
augment void foo() {
  print('start foo');
  augmented();
  print('end foo');
}
===================================================================================
avoiding non recursive calls patterns, for f.e. nested map (also a flat Map)
can be found here:
https://github.com/brilliapps/Condition/blob/main/lib/condition_data_managging.dart
find synchronous example with solution solving a "good-feature-but-a-problem" where you cannot add elements on an iterable element such as a List:
calculateSizeOfValueInBytesForSomeRelevantTypes(Object? value)
for a combination of sync and async list of elements that can change.:
void /*bool?*/ _executeElementsInTheQueue()
===================================================================================
important about mixin - if there are two declarations in mixin and with class that mixes with the mixin, the declaration/value in the class (not mixin) has higher priority
it is as if the class overriden the mixin value,
but in a class extending the class that mixes with the mixin but doesn't redeclare the property the mixin takes the priority - logical
read all examples
And the good news is that wherever you call the property overriden or not by the mixin - this is the same object, not that in some circumstances one object from the same declaration and a different one from another but one object as examples show.
Also problem solved with   print((ertetet() as ertetet2).wer.toString()); because exception: type 'ertetet' is not a subtype of type 'ertetet2' in type cast


you can't do something like that in a mixin, and wait until it will be declared in a class it the mixin is mixed in.
/// ignore: undefined_identifier
int methodtest() => unexistentpropertyignore;


mixin werwerwerwerwer {
  late Map wer = <String, String>{"werwerwerwre": 'werwerewr'};
}

class ertetet with werwerwerwerwer {
  Map wer = <String, String>{"tttttttttttttttttt": 'werwerewr'};
  ertetet() {
    /// nothing changes
    print(_wer.toString());
  }
}

class ertetet2 extends ertetet {
  ertetet2() : super();
}

main() {
// below prints two times prints {werwerwerwre: werwerewr}
  print(ertetet2().wer.toString());
  return;

///the second example

mixin werwerwerwerwer {
  late Map wer = <String, String>{"werwerwerwre": 'werwerewr'};
}

class ertetet {
  Map wer = <String, String>{"tttttttttttttttttt": 'werwerewr'};
}

class ertetet2 extends ertetet with werwerwerwerwer {
  ertetet2() : super();
}

main() {
  print(ertetet2().wer.toString());
// prints two times: {werwerwerwre: werwerewr}
  return;


mixin werwerwerwerwer {
  late Map wer = <String, String>{"werwerwerwre": 'werwerewr'};

  /// ignore: undefined_identifier
  int methodtest() => unexistentpropertyignore;
}

class ertetet {
  int unexistentpropertyignore = 10;
  Map wer = <String, String>{"tttttttttttttttttt": 'werwerewr'};
}

class ertetet2 extends ertetet with werwerwerwerwer {
  ertetet2() : super();
}

main() {
  print(ertetet2().wer.toString());
  print(ertetet2().methodtest().toString());
  return;

main.dart:150:23: Error: The getter 'unexistentpropertyignore' isn't defined for the class 'werwerwerwerwer'.
 - 'werwerwerwerwer' is from 'package:darttests/main.dart' ('main.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'unexistentpropertyignore'.
  int methodtest() => unexistentpropertyignore;

and finally in short and with a quick change to the previous code (class gets priority over mixin):
class ertetet2 extends ertetet with werwerwerwerwer {
  Map wer = <String, String>{"uuuuuuuuuuuuuuu": 'werwerewr'};
  ertetet2() : super();
}

main() {
  print(ertetet2().wer.toString());
peinrs: {uuuuuuuuuuuuuuu: werwerewr}

===================================================================================

Some unprofessional quick tests (sorry for function and variable names).
Let the code speak for itself - some simple type tests. Such a set:
Answer got on discord: https://stackoverflow.com/questions/50188729/checking-what-type-is-passed-into-a-generic-method
For me the important conclusion out of conclusions was:
    if T in a generic class is "String?" - why:  
    //print(T == Object?); // not allowed
    print(T is Object?); always true
    print(T is String?); == false


class abchhhhh<T> {
  abchhhhh() {
    print(T.runtimeType.toString());
    print(T == Null);
    print(T == String);
    print(T == Object);
    //print(T == Object?); not allowed
    print("one: ${T is Object?}");
    print("two: ${T is String?}");
    print(T is String);
    print('===============');
  }
}

main() {
  var ertretetertrett = abchhhhh<Object?>();
  abchhhhh<Object>();
  var ertretetertrett2 = abchhhhh<String?>();
  var ertretetertrett3 = abchhhhh<String>();
  print(ertretetertrett.runtimeType.toString());
  //print(T == Object?); not allowed
  print(ertretetertrett is Object?);
  Object? abc7777;
  print(abc7777.runtimeType);
  abc7777 = 10;
  return;

Results (count the number of prints) see the marked as important:

Type
false
false
false
one: true
two: false
false
===============
Type
false
false
true
one: true
two: false
false
===============
Type
false
false
false
one: true
two: false
false
===============
Type
false
true
false
one: true
two: false
false
===============
abchhhhh<Object?>
true
Null



===================================================================================
! Monitor to update - understand the process and correct this piece of info if necessary.
https://dart.academy/asynchrony-primer-for-dart-and-flutter/
I sometimes write wrongly in my doc like "the main isolate", "the event loop isolate".
But as far as i can see for each isolate there is an event loop (the main isolate which starts with the main() method - when it generally finishes then on the same main isolate the event loop starts to work - this would explain maybe why the current synchronous function/piece of code must fihish first and any non awaited future is executed and it is not done paralelly like on the separate event loop isolate or something similar - here not far below i write about it and tests performed):
Especially
"Each has its own memory space, which prevents the need for memory locking to avoid race conditions, and each has its own event queues and operations. For many apps, this main isolate is all a coder needs to be concerned about, but it is possible to spawn new isolates to run long or laborious computations without blocking the program's main isolate."
===================================================================================
Hoped that cast OF ASDFASDF2() to ASDFASDF WILL CHANGE IT RUNTIME TYPE BUT NOT.
class ASDFASDF {
  ASDFASDF();
}

class ASDFASDF2 extends ASDFASDF {
  ASDFASDF2() : super();
}

main() {
  print(ASDFASDF2().runtimeType.toString()); // prints ASDFASDF2
  print((ASDFASDF2() as ASDFASDF).runtimeType.toString()); // prints ASDFASDF2

===================================================================================
NOT TYPICAL NOT OBVIOUS ASYNC CALLS 
More tests here (still this "project") https://github.com/brilliapps/dart_tips_solutions_informal/blob/main/async-await-future-not-obvious-situations-tests.dart
the most important:
Any really asynchronous code that is called - it is executed always after the current synchronous block (maybe function/method) of code (where the async code was called) is finished. however if a not "await"-ed async function call that body consists of sync part, await part in the middle and again the sync part, so then after finishing the call of such a function the next instruction after the call have to it's disposal all data/changed properties/ect, but doesn't the part where await was called and not available the synchronous data/changed propertis/etc. 
But instead of using syntax () {}() where the aforementioned rule applies use Future(function-whatever-sync-async-await-no-await-WHATEEEVER); and the whole part is not available to the synchronous code following the Future() constructor

/// SOME PARTS ARE COMMENTED
/// On the discord i have this confirmation of a popular user there: "async functions run synchronously until the first await"
/// ...code... () async {no-await-code}(); in-this-place-the-function-before-is-fully-finished
  print('test1D');
  () async {
    print('test2D1');
    await Future(() {
      print('test2D1B');
    });
    print('test2D2');
  }();
  for (dynamic i = 10; i < 10000000000; i++) {}
  print('test3D');

  //Another surprise: before the first await the code was performed synchronously so it's result is awailable to the 3D point, but 2D2 is not first
  //test1D
  //test2D1
  //test3D
  //test2D1B
  //test2D2


  () async {
    print('testH1');
    await () {
      print('testH2');
    }();
    print('testH3');
  }();
  print('testH4');
  // prints: testH1, testH2, testH4, testH3
  // suprising conlusion: sync method preceded with await keyword is awaited but not the way you might expect, because while testJ3 is after J4 but you would like to see j2 also after j4, but it is before j4

  () async {
    print('testJ1');
    await () async {
      print('testJ2');
    }();
    print('testJ3');
  }();
  print('testJ4');
  // prints testJ1 testJ2 testJ4 testJ3
  // suprising conlusion: sync method preceded with await keyword is awaited but not the way you might expect, because while testH3 is after H4 but you would like to see h2 also after h4, but it is before h4

  () async {
    print('testK1');
    await () async {
      await () {
        print('testK2');
      }();
    }();
    print('testK3');
  }();
  print('testK4');
  // prints testK1 testK2 testK4 testK3
  // the same order - again suprised - expected 2 and 3 after 4

  () async {
    print('testT1');
    await () {
      print('testT2');
      return Future(() {});
    }();
    print('testT3');
  }();
  print('testT4');
  // exactly like with ...H preceding example (that with testH1)



/// ...code... await () async {no-await-coDe}(); in-this-place-the-function-before-HASN'T-STARTED-YET
/// ...code... Future(() {}); in-this-place-the-function-before-that-was-passed-as-Future-constructor-param-HASN'T-STARTED-YET
/// Also all tests like this don't change the rule await () async {no-await-coe}() #HUUUGE 2 MINUTE SYNC LOOP# in-this-place-the-function-before-HASN'T-STARTED-YET;
/// Analyse the examples - there is more details to it


===================================================================================
https://developer.mozilla.org/en-US/docs/Glossary/Recursion
Some poor quality (+poor descripiton) tests and solutions about recursive calls here https://github.com/brilliapps/dart_tips_solutions_informal/blob/main/recursion_errors_tests_solutions.dart ((still this "project"))
Recursive calls to avoid StackOverflow (too many recursion): in dart run... it was allowed to make like 45000 recursive calls fo simple method for sync calls and like 65000 for async.
And as far as i know the number may vary probably also because of complexity of a function. Regardless of the complexity:
If you have something like a queue of methods both sync and async to be called with groups first sync and the below example and the sync may be finished synchronously 
with no single async, but it maybe that finally there is an async method, and there may be groups of sync/async (the below example works for even async first).
And it is important, that the following proposal allows you adding methods to the queue even before the calling is finishes (it is possible while async method may finish much later than typical sync)
Here is a simple, simplified, initial pattern !!! with no break/end for the while () loop - you must enforce it - the functionSync deals with a group of sync only methods, and functionAsync with a group of async, 
if then now is called sync group, when the first async method appears in the queue we finish the async and go another while loop iteration.
Any while's break, and locking the functionSyncAsync() from second call when it's previous async aspect not finished is left to you, Reader
This is an example non-recurcive flat almost endless recursive calls until all methods in the queue are called and recursive and enforces synchronous finish if all methods in the queue are sync 


functionSyncAsync() {
  /// prevent from calling this method when the previous call is not finished - see the while() loop - like never ends
  functionSync();
  () async {
    while (true) {
      await functionAsync();
      functionSync();
    }
  }();
}


===================================================================================
From discord: how to run dart run 'some dart code as string' i anwered like this
Probably the best answer is no but you could use https://pub.dev/packages/dart_eval package do your own dart file that accepts a dart code from a parram and run it in a similar to the following way dart run main.dart -a 'print("werwer")'. Not tested, just an idea in which direction you could go to achieve this.

https://pub.dev/packages/dart_eval

But someone answered this which is interesting
you can do this
echo "void main() => print('hello world');" > /tmp/dartfile && dart /tmp/dartfile && rm /tmp/dartfile

===================================================================================
From discord Dart official channel: 
when you have FutureOr<int> cde() => 10
if you
int wer = await cde();
then it WILL await in the sense it will enforce using the event loop (as i know) it even though the return value is int not Future.
===================================================================================
Maybe obvious to some, but when you have an object and you cast it to another type and assign to the different type another variable;
Does this original not-casted variable/pointer to the object is identical() with the latter? YES IT IS IDENTICAL:
class A {}

class B extends A {}

class C extends A {}

void main() {
  B b = B();
  A aa = b as A;
  A a = b as A;
  print(identical(a, aa)); // checked:returns true
  print(identical(a, b)); // checked: returns true
}

results were:
true
true

===================================================================================
Maybe good on the event loop - maybe important when implementing isolates.
https://dart.cn/articles/archive/event-loop
===================================================================================
mastering totally lints is for me a necessity to work with the still incoming (now is 02.2024) integrated-seamles-code-generators called macros where for example an 10 + SomeCustomInteger(10) wouldn't cause lint error in Vscode for example, then macro would change the code of a marked method so that it doesn't throw compilation error. So the final goal is to cause accept int lint values only + SomeCustomInteger()
Can be done this way?
CAN BE DONE!?
I DON'T KNOW NOW :).

Read all, 

the bottom line below there is an article on medium.com on custom_lint dart package but read all to understand better what and why

we go here (the most important rule.dart)

https://github.com/dart-lang/linter/blob/main/doc/writing-lints.md

from here:

https://github.com/dart-lang/linter?tab=readme-ov-file#linter-for-dart

earlier from here - analyzer plugins

https://dart.dev/tools/analysis#plugins

And this is important there is link to pub dev

where the custom_lint is the most liked and at the top and ...

where earlier this link was seen

https://medium.com/@gil.bassi/how-to-create-a-custom-lint-rule-for-flutter-49ce16210c28

we just could finish but: but also i have this in my browser tab:

https://github.com/passsy/dart-lint

maybe related to this https://pub.dev/packages/lint
===================================================================================
Not the most important but recent:
https://stackoverflow.com/questions/24762414/is-there-anything-like-a-struct-in-dart/76391196#76391196
Struct sort of lightweight class is not used everywhere, syntax like struct abc {int x = 10; int y = 12} - probably
The point is you can do something similar using record newer feature of dart (more on that in the link there):
typedef University = ({
  String name,
  String field,
});

===================================================================================
Macros next but now:
Some educative insights of customizable overriding of non extendable classes num, int, String, double, bool, Object (classes wrapping) - there should be repo somewhere around here now or soon :)

  /// FIXME: Copy all here to github repo with tips
  /// // The bottom line - int accepts int returns int, double accepts int or double but not num!!! and returns double
  /// // num is default and allowed - no int or double required:
  /// class Fq<T extends num> {
  ///         final T base;
  ///         const Fq(this.base);
  ///         // Implementation goes here...
  ///         String toString() => "Instance of 'Foo<$T>'";
  ///       }
  ///
  ///
  /// void main() {
  ///   num werwrerte=5.5;
  ///   // default bottom type num and also can be passed num, so not int or double is required
  ///   Fq<num>(werwrerte);
  /// }
  ///
  /// however we need to accept Num for Dbl because it couldn't be overriden, yet thinking
  /// SO WE [Edit: don't have to] HAVE TO OVERRITE clamp for double but here it must return U so that there is no error.
  /// TODO: [Edit: ] we need to add a third fourth W, X generic params instead for being strict or now and for int W, X will be bound to int, Int, but for double W, X will be bound to Num
  /// FIXME: to the Edit just above: notice that double does't accept num, but here Dbl will accept Num as param, but the returned value will be correct type.
  ///
  /// below IntStrict accepts int only in some cases,
  /// class IntStrict
  ///  extends IntOrDoubleStrict<int, IntStrict, IntStrict>
  ///
  /// /// Now double can accept ints but not nums also for methods like clamp that have num as param but are overriden in double class also won't allow num while officially num is allowed
  /// /// To copy the behaviour or not accepting the null itself we now have a class That is before double and num so is not num:
  /// /// DblStrict is to accept num but it throws if num is passed, to copy the normal behaviour
  /// /// See the part num, IntOrDoubleStrict - it is not "num, NumStrict"
  /// class DblStrict
  ///  extends IntOrDoubleStrict<double, DblStrict, IntOrDoubleStrict>
  ///
  /// end of FIXME:
  ///
  ///
  ///
  /// // exhaustiveness below calling examples all num, int, double pass the function
  /// sdfgdgsdfg(num abc) {
  ///   // only this is good
  ///   switch(abc) {
  ///     case int(): break;
  ///     case double(): break;
  ///   }
  ///   // only this is good
  ///   switch(abc) {
  ///     case num(): break;
  ///   }
  ///   // good but int must be first
  ///   switch(abc) {
  ///     case int(): break;
  ///     case num(): break;
  ///   }
  ///   // good but int never reached
  ///   switch(abc) {
  ///     case num(): break;
  ///     case int(): break;
  ///   }
  /// }
  /// gdgfhdfhgfh(){
  ///   sdfgdgsdfg(2.2 as num);
  ///   sdfgdgsdfg(2.2);
  ///   sdfgdgsdfg(10);
  ///
  /// }
  ///
  ///
  ///
  ///
  /// // yes:
  /// num werwer = 0; // not cast into int or something - it is still null
  /// // yes:
  /// num werwer2 = werwer * 12.2;
  /// // no: int wer=10.clamp(5, 8.7);
  /// // no: int wer=5.5.clamp(5, 10);
  /// // yes
  /// int wer = 10.clamp(5, 10);
  /// // also no:
  /// // int wer2 = 4.clamp(5, 8.7);
  /// // so clamp for int must be accept int, double num
  /// double wer4 = 2.2.clamp(5, 8.7);
  /// // no: double wer33 = 2 as num;
  /// // no like previous: double wer5 = 1.1.clamp(2, wer3);
  ///
  ///
  /// // Let's repeat it (+1 extra) for Num, Dbl, Int
  ///
  /// // no: Int werRR=Int(10).clamp(Int(5), Dbl(8.7));
  /// // no: Int werwww=Dbl(5.5).clamp(Int(5), Int(10));
  /// // yes
  /// Int werR = Int(10).clamp(Int(5), Int(10));
  /// // also no:
  /// // Int wer2=Int(4).clamp(Int(5), Dbl(8.7));
  /// // so clamp for int must be accept int, double num
  /// Dbl wer4R = Dbl(2.2).clamp(Int(5), Dbl(8.7));
  /// // no: Dbl wer33 = Int(2) as Num; // also no as Int, only as Dbl works
  /// // nolike previous (wer33 must have been Num for a while): Dbl wer5 = Dbl(1.1).clamp(Int(2), wer3);
  /// // But this extra one more unique not copied works as wanted:
  /// Dbl wer5 = Dbl(1.1).clamp(Int(2), (Int(2) as Num) as Dbl);
  ///
  ///
  ///
  ///
  /*u*/ num/*=u*/ clamp(
          /*w*/ num/*=w*/ lowerLimit, /*w*/ num/*=w*/ upperLimit) =>
      /*cnum*/ base.clamp(lowerLimit /*b*/, upperLimit /*b*/) /*c*/ /*numasu*/;



===================================================================================
Just quick glance on macros, no time now:
Warning! example looks like it works with no buildrunner, etc but macro_prototype project may be related to it.
As was pointed on Discord: "Some macros do work now with just --enable-experiment=macros, and this repo has some instructions for getting set up." NOTICE that the discord version mentioned below is missing part " <script>"
a preview channel (dart) was mentioned maybe 25 january 2024. is this the same as beta?
Don't click from here https://github.com/dart-lang/language/blob/main/working/macros/feature-specification.md
we got to a better link:
So first this may be better link than others with some initial info from there:
dart --enable-experiment=macros <script>, but the implementations do not yet support all the examples here so you should expect errors.LOOKS PROMISING!
https://github.com/dart-lang/language/tree/main/working/macros/example

from there go to lib and f.e. interited widget

https://github.com/jakemac53/macros_example/
This is i guess based on this:
https://github.com/jakemac53/macro_prototype
and there link to api:
https://jakemac53.github.io/macro_prototype/doc/api/index.html
===================================================================================
For me ro make sure all is as expected: Had some problems with sealed classes and switch() exhaustive checking so quick tests with explanation. 
The point is for the below code that i was afraid that the below check is not enough for exhaustivess but it is, also true if SL2 had extending non sealed/abstract classes. Always true; 
See the entire code not to miss anything.
int someint2 = switch (slinstance) {
    SL1() => 1,
    SL2() => 2
  };
All is as i understood it should work so i must have overlooked something. Notice SL slinstance = SL11(); is SL if a function param is SL this is base for exhaustive checking. Also when you remove sealed from SL1 SL2, this also works as expected as i imagined. Not all combinations are tested but can be made sure everything should logically work.

sealed class SL {}

sealed class SL1 extends SL {
  SL1();
}

sealed class SL2 extends SL {
  SL2();
}

final class SL11 extends SL1 {
  SL11();
}

final class SL12 extends SL1 {
  SL12();
}

void main() {
  SL slinstance = SL11();

  // Start understanding from first to the last not somewhere from the middle.
  int someint = switch (slinstance) {
    SL2() => 2,
    SL1() => 3
  }; // ok only because both SL1 AND SL2 are here
  int someint2 = switch (slinstance) {
    SL1() => 1,
    SL2() => 2
  }; // SL2 not needed because SL2 is sealed and has not instance
  int someint3 =
      switch (slinstance) { SL11() => 2, SL12() => 3 }; // also accepted

===================================================================================
Recently asked on Discord about non existing try/catch expression (not what you have in a block {} but what you get using => like someFunction() => 10; ), got suggestion and came up with an example - the code is ridiculous this is example:
It could be like this (i mean syntax, the sense of the folowing code is ridiculous, not tested):
List a = [5, 10];
List b = [4, for (final i in a) (j) {try {throw '';} catch (e) {return j;}}(i), 11];
List b = [4, for (final i in a) someFunction(i), 11];
===================================================================================
"Sync* methods are too slow." Not read yet, just from discord: something like 80% speed of others - could still be used, something like 35% of something faster but the same result) - worth watching.
https://github.com/dart-lang/sdk/issues/32102#issuecomment-364467924
===================================================================================
Java has some additional type hinting flavour for f.e. methods, example of something similar (or not similar - had no time to investigate deeper)
class Foo<T, U> {
  T bar<U>(String foo) {
    return foo as T;
  }
}
===================================================================================
VsCode: I wanted to replace all debugPrint(); to debugPrint(SomeClass('string hello')); after a couple of improvements could be able to do a regex for replacing that works in about a little bit more than 99,8% cases - exactly one must have corrected manually which seemed to be faster than improving the regex even more. So some conclusions:
In VsCode something like this worked for replace (Regex option on), as Vscode is written in React as far as i remember so js syntax should work well and it did suprisingly well and intuitively SO THIS SEEMS TO ME THE ADVANTAGE OF VSCODE - IT REALLY JUST WORKED AND DIDN'T NEED TO LEARN MORE BASICALLY - ONLY THE LOOK BEHIND SYNTAX:
from:
debugPrint\(((.|[\s\t\n\r])*?)(?<!\()\);
to:
debugPrint('${ConditionDebugPrint($1)}');
was able to correctly replace f.e exactly this with \n \t, etc:
    debugPrint(
        rrrr); 
    debugPrint('${ConditionDebugPrint(
        rrrr)}'); 
=====================================================================================
There is a class ConditionIsolateNoParallelFunctionCalls<T> (or the name has change since :) ). 
https://github.com/brilliapps/Condition/blob/main/lib/condition_data_managging.dart
While a Pool class from the pool package was discovered by me after i started work on the class i decided to implement it anyway so i write about the Pool class for you to rather choose more dart team way. 
so when as an argument of a "function nr 1" you pass an anonymous function "object" called "function nr 2" that the ...2 was earlier assigned to a variable or property, then you can preserve the identity of the object when it is used in the "function nr 1", and if you have in the "function nr 1" another pointer to the "function nr 2" from some different source f.e. Stream sent an event with the function nr 2. So when you compare both objects they are identical (identical is 100% unfailing) and indentityHashCode function shows the same value (like 99.9% cases one per 50000 random object comparison may fail).
But if you use as function nr 2 a regular method defined like this class abc {regularmethod() {}} and pass to function nr 1 directly like this functionnr1(abcinstance.regularmethod) then it will get another identity inside "function nr 1". If you compare this abcinstance.regularmethod with a pointer to the method from another source like Stream, or whatever, the two objects won't be identical, wont be the same. The identity() operator will return false and identityHashCode too.
The topic of identity comparison and 100% unfailingless of it is discussed below in this file somewhere because of GC or someting else.

Some months later code, may be not precisely related:
class functionOrMethodIdenticalCheck {
  Function function = () {};
  methodOne() {}
}

class abc1 {}

class abc2 {
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    //if (!(super == (other))) return false;
    return true;
  }

  /// This method contains example approximate implementation code. See operator == description for this class - this shouldn't return 10 like here (it is possible but don't do that), but you should understand what hashcode is for, etc. so go to this class == operator description
  /// Caution about @mustBeOverriden annotation here, read all carefully! By default dart won't require you to override operators and hashCode so this annotation enfoces that but it will require to implement it in each class extending class that already implemented interface with this method. So you must in first implementation of this method add @mustCallSuper and in a class extending the class just return only what super.overriden method returns like return super == object; for == operator or return super.hashCode; for hashCode method  @override
  @override
  int get hashCode => Object.hashAll([1]);
}

main() {
  print('1');
  Set abc8 = {22222, 3, 22222};
  print(abc8); //{22222, 3}
  Set abcd8 = {Object(), Object()};
  print(abcd8); //{Instance of 'Object', Instance of 'Object'}
  var dddd8 = Object();
  Set abcde8 = {dddd8, dddd8};
  print(abcde8); //{Instance of 'Object'}
  Set abcd82 = {abc1(), abc1()};
  print(abcd82); //{Instance of 'abc1', Instance of 'abc1'}
  var dddd9 = abc1();
  Set abcde9 = {dddd9, dddd9};
  print(abcde9); // {Instance of 'abc1'}
  Set abcd83 = {abc2(), abc2()};
  print(abcd83); // {Instance of 'abc2'}
  // to the above see operator ==, hashCode and Set doc - explicitly says to remind you hashCode is for speed, if two
  // So the doc points to checking first == second hashcode
  // "The default Set implementation, LinkedHashSet, considers objects indistinguishable if they are equal with regard to Object.== and Object.hashCode.  var dddd10 = abc2();"
  var dddd10 = abc2();
  Set abcde10 = {dddd10, dddd10};
  print(abcde10); // {Instance of 'abc2'}
  print('2');
  var eerq1 = functionOrMethodIdenticalCheck();
  var eerq2 = functionOrMethodIdenticalCheck();
  print(Set.from([
    eerq1.methodOne,
    eerq1.methodOne
  ])); //{Closure: () => dynamic from Function 'methodOne':.}
  print(Set.from([eerq1.function, eerq1.function])); //{Closure: () => Null}
  print(Set.from([
    eerq1.methodOne,
    eerq2.methodOne
  ])); //{Closure: () => dynamic from Function 'methodOne':., Closure: () => dynamic from Function 'methodOne':.}
  print(Set.from([
    eerq1.function,
    eerq2.function
  ])); //{Closure: () => Null, Closure: () => Null}

===================================================================================
First some quick novelty there is from 3.3.0 extension type, asked on dart discord official, but if you add implements int it is going to sort of copy the features from int like operator "<", "==", if you not implement you need to write your code for the operators.
[Edit:][start]
This issue tells it all.
https://github.com/dart-lang/sdk/issues/54293
Summary it tells that after some fixes, There may be implemented in some distant future that `b = b + a` or `Int b = 10` will be possible (they may be not quick to do that now in December 2023). At least one known dart dev is aware of the would-be feature and stuff involved:
```dart
extension type Int(int i) implements int {
  Int operator +(int other) {
    return Int(i + other);
  }
}

void main() {
  int a = 2;
  Int b = Int(8); // coulndn't Int b = 8? and silently cast as Int?

  b = b + a; // wrong, but Int + operator overriden returns Int
  b = a + b; // wrong, because a is int, but couldn't it be silently cast to Int? [Edit: a dev called it type coercion - when type from context is clear]
  a = a + b; // good as expected.
  print(b + a); // ok, somewhere toString is called for sure.
}
```

[Edit:][stop]
Some updates from discord - for privacy resons no mentioning nicknames, etc.:
extension type IntWrapper(int i) {}
foo() => IntWrapper(1).i + 2;
foo() => IntWrapper(1) as int + 2;
extension type IntWrapper2(int i) implements int {}
foo() => IntWrapper2(1) + 2;
me:And this would be correct too with the IntWrapper2 : 2 + IntWrapper2(1) ; i know the answer may be obvious for some but i ask like a 5-year old 🙂
someone:this seems to be the case yep
===================================================================================
Educationally more than needed. Function param in class Constructor or method/function definition. Take note to such details like you can pass a function or null when f.e. Function()? has the "?" question mark.
Based on attemted Extending Future class - discoverd feature - a param can be a function with returned type - there is two syntaxes: accepted and allowed but not recommended syntax
which can be seen from this linter rule description https://dart.dev/tools/linter-rules/use_function_type_syntax_for_parameters (fun fact in the official docs old syntax was used at the time of writing this stuff here.)
Here is the code, at the stage it was not tested but with no errors (edit: finally too much to implement and too difficult so class ConditionSynchronousFutureWithInfo<T> extends SynchronousFuture<T> was enough to do):
class ConditionFutureWithSynchronousInfo<T> extends Future<T> {
ConditionFutureWithSynchronousInfo(super.computation);
//educationally would-worked another syntax ConditionFutureWithSynchronousInfo.delayed(duration, [FutureOr<T> computation()?]) : super.delayed(duration, computation);
ConditionFutureWithSynchronousInfo.delayed(duration, [FutureOr<T> Function()? computation]) : super.delayed(duration, computation);
.......
}
You could also replace it with something looking nicer:
typedef SomeFancyFunctionType<T> = FutureOr<T> Function()?;
and then in the constructor of our interest:
ConditionFutureWithSynchronousInfo.delayed(duration, [SomeFancyFunctionType<T> computation]) : super.delayed(duration, computation);
/// Btw, having problems with extending Future class if your really want to use it asynchronously (event lopp) you can use some workarounds like (not tested) await Future(() => ConditionSynchronousFutureWithInfo(() {...})); or more custom stuff like scheduleMicrotask() {} or a Timer(); using the main constructor for example. Also there is Completer.sync constructor (now SynchronousCompleter) but not needed here you can't also extend the class with no trouble.
===================================================================================
unique id [finally solved with no id but WeakReference or possible other options?] of every object - topic + solution to the problem:
SEE ALSO BELOW TESTS FOCUSING ON EXPANDO AND THE GC WHICH IS RELATED TO THIS HERE.
identityHashCode method is to give you a unique number assigned to an object that is not simple type like int,String. However based on interpretation from a link:
https://github.com/dart-lang/sdk/issues/41454
!!!!!
IMPORTANT: after presenting on the Discord the code with comments some user said about identical operator (identical() checks if the two references to objects are pointing to the same object by comparing the memory address). Now you can read further.
PROBABLY FIRST CONCLUSIVE CODE - READ COMMENTS AND DEBUGPRINT MESSAGES - the identical works fine, even if identity hashcodes (with some core dart non identity hashcodes as you can see from the code) may fail. So in rare occasions when you want f.e. for non extendable Function class object have totaly unique id (identity hashcode may fail as mentioned) then you need to add to the function or Function some totally unique custom number/id which you can achieve through extesion on Function {} syntax or using Expando on objects or both. Why the need for that? F.e. a function may contain strong references (not WeakReference references) to some objects especially in the form of "this" which when last pointer to such an object was supposed to be lost but it isn't might be still kept in the function that is kept somewhere else. If so GC for the objects of interest like the mentioned "this" may never be Garbage Collected which may cause memory hight-level-programming/secondary "leaks". Instead of keeping the reference to the function a uniuque-across-the-entire-app id could help to allow an incoming method/function to be used or rejected if the unique id is not the same. It is important when you allow only a unique function instance to be called but you don't want to keep reference to it but you can keep the function id. 
The ultimate proving point code:
  int? anotherindentityhashcode;
  List? anotherList;

  final indentityhashcodes = <int>{};
  final lists = <List>{};
  debugPrint('werwerwerwerwewerwerwerwerwerwerwerwewewerrew');
  while (true) {
    anotherList = [];
    anotherindentityhashcode = identityHashCode(anotherList);
    bool successfullyAdded = indentityhashcodes.add(anotherindentityhashcode!);
    if (!successfullyAdded) {
      debugPrint(
          'Two duplicate hashCodes occured, the number of hashcodes:${indentityhashcodes.length} but the number of lists: ${lists.length}; both numbers should be the same.');
      break;
    } else {
      lists.add(anotherList);
    }
  }

  /// No we need to check out whether operator identical returns true for two different objects with the same hashcode:
  for (int i = 0; i < indentityhashcodes.length; i++) {
    if (anotherindentityhashcode == indentityhashcodes.elementAt(i)) {
      debugPrint(
          'We found the element that has the same indentity hashcode result (both results are: $anotherindentityhashcode, ${indentityhashcodes.elementAt(i)}) of identical for both objects that belong to the equal identity hashcode: ${identical(anotherList, lists.elementAt(i))}. Morover the custom NON-identityHashcode getter called hashCode returns for anotherList.hashCode=${anotherList.hashCode}, but for lists.elementAt(i).hashCode=${lists.elementAt(i).hashCode}. As they are equal and the identical operator (identical(anotherList, lists.elementAt(i))) returns false as it should dart uses something else to distinquish the two objects like i could imagine a simple counter giving each object an always unique number that is checked f.e. when all sorts of hashcode fail');
    }
  }

// So the hashcode may be equal but the identical operator works fine and says as it should that the both objects are not equal. This seems to be possible only because there exists one more hidden id like ultimateIdentityHashCode that is checked agains when anything else fails.


///
///

The previous texts:




new - to focus on it first:
  This will stop after about 50000 on average (as expected not an issue):
  final hashcodes = <int>{};while (hashcodes.add(identityHashCode([])));

  But this will never stop as expected ():
  final NOThashcodes = <List>{};while (NOThashcodes.add([]));

  So you don't have to worry that f.e. 'qwesdfawefwa' and '2werewr342342' will get the same identity hash code and while they are different they will be treated as the same. There is additional checking event if two the same lists like [] and [] but are different objects so dart team cared that something else is checked.

  And remembeer you are obliged for your custom class to override non identity hashcode so hashCode getter always when you override the "==" operator so int, String, etc have this additional equality comparison so it is not possible that two differnt strings are qual.

  So i "inform" myself it is designed as it should be.
!!!!!
  !!!!BUT SOME INFORMATION ON DISCORD SUGGEST THE identical operator uses identityHashcode only - really? Not some hidden unique number?
  This i must checkout if it can happen i assume NOT!!!!

  However the point is if you in rare circumstances cannot get an absolutely unique id of an object you must implement what you can do in various ways - custom variable in a class, some static property idCounter, also Type/class extension or Expando class on objects.
!!!!!!!!

You cannot rely on identityHashCode. It almost always will return different numbers when it should, but it may happen once upon about 50000 times as i checked (just stupid number) that it will return the same number for two differen object when it normally wouldn't. THIS IS MY CURRENT IMPLEMENTATION AND what is important:
After an interesting discussion on dart discord this was not an obvious thing, otherwise it would be clear (at the end identityHashCode hascode is not expected to always return uniuqe hashcode). No simple answer. Only what we have is the https://github.com/dart-lang/sdk/issues/41454
So WHAT SOMETIMES MAY BE NEEDED IS TO IMPLEMENT YOUR OWN IDENTITY LIKE COUNTER starting from 0 incrementing each time an object you want to give an additional unique across the entire app id arrives and is of particular interest (the object). Such solutions may be more local what might assure there will be no iterations
Also some excerpts from my questions on discord that led me to this solutions with my line of thinking:
  Little question if i can: As the identity hash code seems to be generated somewhat randomly, can such a code like this below EVER return the same number for identityHashCode(......) call?
  List list1 = []; debugPrint('identityHashcode: ${identityHashCode(list1)}');
  List list2 = []; debugPrint('identityHashcode: ${identityHashCode(list2)}');
  example return:
  flutter: identityHashcode: 891610123
  flutter: identityHashcode: 160067589

------
------
------ SEE HERE YOU WERE SENT FROM THE BEGINNING OF THIS MAJOR PART
----------- WITHING THIS SECTION BUT ANOTHER ASPECT
------
EXPANDO VS GC FULL MAIN.DART TESTING CODE BASED ON FLUTTER CREATE AND REMOVED ALL FLUTTER RUNAPP STUFF.

!!! IT IS IMPORTANT YOU READ THE MANY COMMENTS IN THE ORDER AS THEY OCCUR ESPECIALLY IN THE MAIN FUNCTION BODY AND ANAYSE THE CODE.

import 'package:flutter/material.dart';
import 'dart:async';

//=====================================================
class WhatPreventsOrNotGC_TestsForExpandoOrFinalizers {
  Expando<Object> expandoTest = Expando();
  late final WeakReference<Function> weakReferenceTest;
  WhatPreventsOrNotGC_TestsForExpandoOrFinalizers();
}

/// This class is to check if Expando will prevent GC
class MethodOrFunctionAddedToExpandoObject {
  late WeakReference<MethodOrFunctionAddedToExpandoObject>
      thisButWeakReference = WeakReference(this);

  methodWithThis() {
    this;
  }

  methodWithNoThis() {
    debugPrint('abc');
  }

  methodWithNoThisButWeakReference() {
    var thisButWeakReference2 = this.thisButWeakReference;
    // returns precisely local variable with no reference to this;
    return thisButWeakReference2;
  }

  Function clauseGetterWithThis() {
    return () {
      this;
    };
  }

  Function clauseGetterWithNoThis() {
    return () {
      debugPrint('abc2');
    };
  }

  Function clauseGetterWithThisButWeakReference() {
    return () {
      var thisButWeakReference2 = this.thisButWeakReference;
      // returns precisely local variable with no reference to this;
      return thisButWeakReference2;
    };
  }
}

/// For unknown reason var anObjectThatWillEndureVeryLong = Object(); caused variable not to be visible when it should be. So the class so that it can be traced.
class SimpleObject extends Object {
  SimpleObject();
}

void main() {
  // THE BOTTOM LINE WITH WARNING:
  // First, childish tip if i was a beginner and still am, TIP!: WeakReference and Expando is fine, nice and cute as to the GC, really! For one Object a WeakReference is better. For many elements, Expando may be a bit better, read all, Set<WeakReference> - you need to check cyclically for elements having .targer == null and remove them from the list if so. In case of expando this will be removed automatically, but you need to assign an additional value like the least would be: someexpando[importantobject]=true; - that is not a big deal.
  // THE OBJECTS RELATED TO EXPANDO (THERE IS ONE ENOUGH TEST WITH WEAKREFERENCE TELLING ALL - WORKS THE SAME AS TO THE GC AS EXPANDO) CLASS ARE GCED NICE EXPANDO[ABC]=CDE; - ABC AND CDE ARE GC-ED NICE;
  // BUT, IF EXPANDO OBJECT IS A PROPERTY OF ANOTHER OBJECT LIKE OBJECT1.expandoproperty THEN OBJECT1 (100MB RAM F.E.) MAY NEVER BE GCED.
  // SO KEEP EXPANDO OBJECT AWAY FROM IMPORTANT CLASSES MAKE THEM F.E. A STATIC PROPERTY OF ANOTHER SIMPLE CLASS USED ONLY FOR THIS PURPOSE.
  // WARNING! TO REMIND YOU, AN OBJECT WITH ITS METHOD JUST BEING EXECUTED ALSO IN ASYNC MODE, ALSO WHEN SOME "AWAIT" IS LASTING FOR MUCH LONGER, SUCH OBJECT WILL NEVER BE GC-ED EVEN WITH NO REFERENCE TO "THIS". IT JUST WON'T BE ALLOWED TO BE GCED UNTIL THE METHOD FINISHES.
  // WARNING! for now IT can be assumed that Timer doesn't react to GC triggered artificially and a finished timer object may not be collected for very long and didn't see such a gcing at all. In simple quick situations it may gc variables kept in it but when code is more complicated it doesn't.
  // Edit: SOLUTION!!! For example prepare a local-scope nullable variable to the object you want it to be collected like from an example below "SomeType? cde = abc" - all before the Timer() is created and use the cde, and if it is one-time Timer set cde=null the end of the Timer called function body
  // Soluiton: Also for Timer.periodic correspondingly do the cde = null (or abc if you decided on abc) when you are going to cancel the Timer or even it is never cancelled Timer do cde = null when it is no longer needed.
  //
  //
  //
  // GC tests for educative understanding:
  var abc = WhatPreventsOrNotGC_TestsForExpandoOrFinalizers();
  // The Timer is to only ensure that abc cannot be GC-ed for one minute;
  WhatPreventsOrNotGC_TestsForExpandoOrFinalizers? cde = abc;
  Timer(Duration(milliseconds: 60000), () {
    // Confirmed: just refering to abc (there was no more code here at the beginning); like this prevents the gc for Duration(milliseconds: ??????????) time;
    cde; // this dummy code ensures that pointer to cde/abc object persist in the global app scope at least for 60000 ms.
    // Ofcourse you may set abc=null and not use cde at all but only if you know the "abc" pointer won't be use elsewhere after the time 60000ms time elapses, which when abc used as local variable may happen when there is "await" construction that finishes later than the 60000 and then the abc is used again but it is null but object was expected. So this is just example of the recommended solution.
    cde = null;
  });
  // ----------------------------------------
  // As mentioned in the SimpleObject (extends Object) description - just Object was not displayed in the Flutter devTools but it works the same for Object and SimpleObject
  // So first there are two SimpleObject instances then after GC only one is left because aVeryShorLivedObject is Garbage Collected as expected
  var anObjectThatWillEndureVeryLong = SimpleObject();
  // The Timer is to only ensure that anObjectThatWillEndureVeryLong cannot be GC-ed for the very long Duration time;
  Timer(Duration(milliseconds: 5000000), () {
    // Confirmed: just refering to anObjectThatWillEndureVeryLong (there was no more code here at the beginning); like this prevents the gc for Duration(milliseconds: ??????????) time;
    anObjectThatWillEndureVeryLong;
  });

  // See anObjectThatWillEndureVeryLong desc. This object will should normally be ready for removing by the GC just the main method finished. Ready for removing is not removing itself. The GC may remove it after much much time.
  SimpleObject? aVeryShorLivedObject = SimpleObject();

  // Can the MethodOrFunctionAddedToExpandoObject() be GC-ed before the above Duration elapses?
  // Info all the results below had their GC triggered artificially to see the results:
  // --------------------------------------------------------
  // To bear in mind: As mentioned in the SimpleObject (extends Object) description - just Object was not displayed in the Flutter devTools but it works the same for Object and SimpleObject
  // --------------------------------------------------------
  // TESTED: RESULT: The below MethodOrFunctionAddedToExpandoObject() instance will be GC-ed after long time because the last reference to anObjectThatWillEndureVeryLong is maintained thanks to the earlier [Timer]()
  // pointer abc/whatprevent:1, ponterless methodorfunc:1 GC < 1 min the same; GC > 1 min the same, anObjectThatWillEndureVeryLong in an Expando[] keeps both objects non GCable.
  // Another conlusion is that as long as there is pointer to anObjectThatWillEndureVeryLong the expando lives on even though abc = null or last pointer to it was lost. So as the next example will show we need to remove pointer to anObjectThatWillEndureVeryLong also for expando to be garbage collected too.
  //abc.expandoTest[anObjectThatWillEndureVeryLong] =
  //    MethodOrFunctionAddedToExpandoObject().methodWithThis;
  // --------------------------------------------------------
  // TESTED: RESULT: The below MethodOrFunctionAddedToExpandoObject() instance will be GC-ed successfuly immediately after main() method body execution finishes (Ofcourse if you trigger the GC artificially immediately or you wait much longer)
  // pointer abc/whatprevent:1, ponterless methodorfunc:1 GC < 1 min abc/whatprevent:1, ponterless methodorfunc:!!!0!!!; GC > 1 min the same, aVeryShorLivedObject in an Expando[] - pointerless MethodOrFunctionAddedToExpandoObject() GCed as expected
  //abc.expandoTest[aVeryShorLivedObject] =
  //    MethodOrFunctionAddedToExpandoObject().methodWithThis;
  // Quick equivalent test for a [WeakReference] - the same.
  // WeakReference below the same as expando - The MethodOrFunctionAddedToExpandoObject() dissapears after first GC trigger no need to test other covarieties.
  //abc.weakReferenceTest =
  //    WeakReference(MethodOrFunctionAddedToExpandoObject().methodWithThis);

  // --------------------------------------------------------
  // AS TO EXPANDO (THE SAME RULE FOR WEAKREFERENCE INSTANCE)
  // KNOWING ALL THIS NO NEED TO TEST NEITHER NON-THIS NOR WEAK-REFERENCED-THIS METHODS BECAUSE "THIS" METHOD IS THE WORST CASE SCENARIO
  // BUT WE NEED TO LOOK AT THE ANONYMOUS FUNCTIONS, HOW WILL THEY FARE?
  // --------------------------------------------------------
  // TESTED: RESULT: The below MethodOrFunctionAddedToExpandoObject() instance will be GC-ed after long time because the last reference to anObjectThatWillEndureVeryLong is maintained thanks to the earlier [Timer]()
  // AS EXPECTED: THE SAME AS non-anonymous .methodWithThis method pointer abc/whatprevent:1, ponterless methodorfunc:1 GC < 1 min the same; GC > 1 min the same, anObjectThatWillEndureVeryLong in an Expando[] keeps both objects non GCable.
  //abc.expandoTest[anObjectThatWillEndureVeryLong] =
  //    MethodOrFunctionAddedToExpandoObject().clauseGetterWithThis();
  // --------------------------------------------------------
  // TESTED: RESULT: The below MethodOrFunctionAddedToExpandoObject() instance will be GC-ed successfuly immediately after main() method body execution finishes (Ofcourse if you trigger the GC artificially immediately or you wait much longer)
  // pointer abc/whatprevent:1, ponterless methodorfunc:1 GC < 1 min abc/whatprevent:1, ponterless methodorfunc:!!!0!!!; GC > 1 min the same, aVeryShorLivedObject in an Expando[] - pointerless MethodOrFunctionAddedToExpandoObject() GCed as expected
  //abc.expandoTest[aVeryShorLivedObject] =
  //    MethodOrFunctionAddedToExpandoObject().clauseGetterWithThis();
  // --------------------------------------------------------

  //runApp(const MyApp());
  //
}

------
------
------
------
------


  
With respects to privacy of other users try to cite my questions, and some relevant of exerpts from other users.
me
Oh 🙂 We might have lost the point, haven't we? My apologies. Maybe i would try to remind my code because i may have not convey the idea best. List list1 = []; debugPrint('identityHashcode: ${identityHashCode(list1)}');
  List list2 = []; debugPrint('identityHashcode: ${identityHashCode(list2)}');   This code produces different identity hash code each time it is run. Let's say we do flutter run with this code billions of times. Is it a big chance that the identity hashcode will be the same at least once.

me
It is logical. hyphotetically It would also imply that with 1000000000000000000000 objects (yeah, just for example) in a dart application dart would have to iterate through all identity hash codes? So better to implement own counter for lesse number of objects 10000000 it will be faster.

me
Because if you generate the identity hashcode randomly not starting from 1, then another object gets 2 then anothe 3, but it generates random numbers, then if you have 100000000000 objects you have to check if new identity hashcode is already taken in any object in among the 10000000000 objects. That checking would take lot of time possibly.

me
But if you use counter from 0 , 1, 2, 3 ... and so on you know that the next number for the next object will be 4 and you don't need to iterate to check if any random number is already taken. Sorry i finished my thoughts from my previous message.

!!!!!!!!!!!!!!!!!!!
Someone said (i respect privacy) i agree with that if it is what he meant i mean - there is something more for identical() operator than just identity hashcode - i imagined a hidden counter but dart has more controll over any variable because it allows for Finalizer class or WeakReference - there is some additional hidden information when a variable is created or pointer.
The `identical()` function works by comparing pointers under the hood

Me:
So while it wasn't said here when we create a new object like from code i showed a new identity hashcode is created then it is checked if it is already used (100000000 objects), if it is used another is created and again 100000000 objects, and if it wasn't found this one can be used 😉



neat.
==================================================================================
In progress so on the top: https://dart.dev/language/concurrency#implementing-a-simple-worker-isolate says that "If you’re using Flutter, you can use Flutter’s compute function instead of Isolate.run(). On the web, the compute function falls back to running the specified function on the current event loop." When we go to https://api.flutter.dev/flutter/foundation/compute.html we read: On web platforms this will run callback on the current eventloop. On native platforms this will run callback in a separate isolate. Can we do something about it? Investigating in progress..........................
==================================================================================
If you have TODO: FIXME: like places in vscode.
https://github.com/microsoft/vscode/issues/9899
and there f.e. vscode-todo-highlight with f.e. // TODO: AND FIXME: highlighting customisation
works nice - you see labels clearly visible in dart
==================================================================================
some lint rules might be useful - at leas i needed them
    invalid_use_of_protected_member: error # causes @protected method property to show error not notice which is by default
    missing_override_of_must_be_overridden: error #== operator and hashCode defined in an interface class are not required to be overriden/implemented like other custom methods. @mustBeOverriden annotation is used for this all classes extenging/implementing, even a class B extending a class A and then C extending B. the C must override too  
    must_call_super: error # requires any extending class and probably even extending the extending class implementing calling super.overridenmethod
==================================================================================
A situation that happened on web non-native the same method but two main different platform. ... And someone implied that an error couldn't has been catched because it was thrown synchronously or something or a js synchronous future/promise? was used or something instead of asynchronous version. The issue with solutions and some analysis: https://github.com/simolus3/sqlite3.dart/issues/184
So when a method return future and in body has such a piece of code:

completer.complete(db.select(query));

you could change it into
... completer = ....;
dynamic result;
  try {
    result = db.select(query);
  } catch (e) {
    completer.completeError(e.toString());
    return;
  }
  completer.complete(result);

Also a very short version of both the above and entire method that also worked that the method returns like this select(String query) => Future(() => db.select(query)); or couple of similar syntaxes like: method() async {return db.select(query);}, etc.
==================================================================================
sort of existing class expanding, or existing objects expanding. Weak referrences are mentioned in one answer, just i has had a look and possibly it is as if after some object removal what you have added to a class or object (don't remember) will be garbage-collected later-on. It's fine but good to know well.   
extension, expando, remembering weak referrences
https://github.com/vandadnp/flutter-tips-and-tricks/blob/main/tipsandtricks/using-expando-in-dart/using-expando-in-dart.md
https://stackoverflow.com/questions/13358018/what-is-the-dart-expando-feature-about-what-does-it-do
https://stackoverflow.com/questions/66835676/how-to-add-object-to-existing-class-code-in-dart

===================================================================================
Read below about weakreferences, garbage collector, etc.
Why to you need to complete a Completer or Future must be finished not just it's LAST existing pointer to be set to null?
Because setting to null won't finish the completer (tested), so any Future (not tested) too.
What if 100000000 pending methods has async/await for one such a future? The methods will never complete and resources won't ever be released.
So especially if such unfinished completer or future is assigned to a property of another object, make sure it is comlete() -ed or completeError() - ed. before you loose last pointer to an object handling it

===================================================================================
One of the most important rule for a bit more advanced memory management, gc, Finalizer class, WeakReference class, dispose() method of widget.
WE ARE TALKING OF FINALIZER CLASS NOT NATIVEFINALIZER CLASS.
Before start reading. If you have your code perfect in relation to GC, Finalize, WeakReference (you need to understand exactly how these work) and so on, if you want to make sure you want to make sure to prolong the life of an object before it is GC-ed, etc. you may inside the object set Timer(maybe periodic) that will be canceled or expire naturally, and the timer calls that will have a method that does nothing except that in it it has reference to "this" or other object you don't want to be gc-ed - make sure to cancel the timer for the object to be gced,  
One of the simple conclusions but it is much more to that (see all this section) is that the GC triggers finalizers but it may not seem so when like some conditions are met it will try to do it immediately but if not it is scheduled for the closest GC action. Some details below or below the below.
Important Finalizer class: finalizers are not certain to be called. And my finalizers were triggered not immediately when last strong pointer (non WeakReference) had just been lost like abc = null but right after some "await Future.delayed(const Duration(milliseconds: 5000)); passed (sort of async pause)". It was called in a method that was in turn called in a main async body method with await. And then i added couple sequences of await Future delayed with some debugPrints. and only after all main method finished after a minute the Finalizer started to work. So especially looking at it from "async {}" body code it seems that a finalizer might be called after an independent method is fully finished because i removed all awaits from main method and the last one in the method called from main that registering finalizers had one await but it had no impact on the main file and before the await finished both main finished and finalizers from that second method were called after setting the finalizer related variable to null, but the second method inished after main finished (after all however the second method finised it's code fully which was checked by debugPrint but finalizers were trigger before that). SO IT WAS PROBABLY THE MAIN METHOD THAT DECIDED THAT A FINALIZER CAN BE TRIGGERED. So not checking now but there may be a method calling method and that calling another method - tree of methods. Is it the first top method that must be finished (main has runApp(const MyApp()); which didn't interrupt finalizer trigger) and only then the finalizer is triggered? So shortly speaking. To make it behave more predictable if you want to have a finalizer triggered when it's finalized abc is set to null: abc = null then you plan with all tree of related methods to be FINISHED completely in a way that you know the finalizers are not triggered too late or are finally triggered ever at all not stopped by an never finished await/Future sequence for example. Apart from that i can imagine that a finalizer might possibly be not triggered immediately when the aforementioned conditions are met because the event loop may be bloated with awaiting queue of events that need to be handled first and i could also imagine that independent isolates/js workers may not block the finalizers from the current isolate. Some assumptions are based on logic and are placed here not to spend to much time on research. All here seems enough for practical use and be efficient enough.      
!!!So you normally expect a finalizer to be called right after a variable is set to null!!!
But because it is said by dart developers that this doesn't need to happen, if it is abnormality that a finalizer is not triggered your code must accept that. But based on available tools let's try to lessen the probability of a finalizer not to be triggered (btw, as i can see first GC can be triggered long-long after a finalizer was succesfully runed and finished so both are not related directly).
Before this, you need to remember that when you flutter run your app especially with --debug flag, then when your app has started you see immediately http:// link to flutter devtools when you have memory tab at the top. then after clicking it you have a garbage collector button called GC. You can trigger the garbage collector anytime you want not waiting for dart to do it as if randomly.
Also probably after this section some dispose() topic can be discussed, which is related.
If you have SomeObject? abc = SomeObject(), and f.e. 10 x var efgh = WeakReference(abc); efgh2..., efgh3..., and nothing else (efgh.target is abc object) and then if after that you set abc = null; then right after that efgh.target = abc, but when the dart whenever it "randomly wants", f.e. 5 minutes later, triggers the Garbage Collector then all the 10 variables have their .target == null, efgh.target == null (efgh is still WeakReference instance but .target == null). One my test showed that all related objects to the abc also should dissapear at the same time in one GC only, like abc.some2object,some3object dissapears and there should be no referrence to it in let's say some kind do GC waiting room. 
But what if you want the abc.someproperty not to be immedtiately GC-ed before you perform some action on it. 2 ways to do that:
1. You create a method with reccomended name: dispose(); when you perform an action on someproperty, then you set abc = null. It will be GC-ed as already set.
2. The worst probably: But you forget to call dispose()? You keep the .someproperty elsewhere in a variable or List for example. But you don't know that abc dissapeared.
3. Check if 100% correct tip: You Attach a Finalizer class object to the abc with the .someproperty as second argument (the token), but when abc=null then immediately before GC finalizer a method of the finalizer gets the .someproperty and you may perform action on the .someproperty. Some suggestions might be. If you want to reuse the property you may start storing it elsewhere, otherwise it will be GCed.
So as far i can understand it is possible to implement dispose() like behaviour with no implementing the method but using Finalizer class.
WARNING! As already said make sure to use WeakReferences so that when you set the mentioned abc = null when you are certain that when the GC is triggered the object that was in the abc variable/pointer has no strong pointer to it elsewhere so the object can be GC and not take memory f.e. all WeakReferecne object .target property will be set to null.
WARNING Ad. 3. Make sure there is:
A. no endless periodic timer that in it's attached method a this object is called, but you may use the WeakReference pointing to the this object (.target - yes .target may be null suddenly) in the timer method instead,
B. the same can be said of subscribing to a stream. So you can use the mentioned Finalizer class way to cancel a timer or cancel subscription to a stream. AND THIS YOU NEED TO FIGURE OUT FOR YOURSELF what exactly and how to do it because it's more complicated and here you have simplified tips.
C. It may be that you registered a closure (anonymous method as far as i know) in some other way (like addListener method of some [Listenable] implementers like ChangeNotifier or completely custom fancy way) an the closure can contain reference to this object. The closure must be removed for the finalizer and later GC could work by f.e. caloing removeListener() method of listenable or possibly calling dispose() of the mentioned ChangeNotifier (possibly because not tested or docs check out and it is logical to assume that dispose() removes all listeners). Also good to remember that Animation class and similar may need to take care of such listeners.
D. Any unfinished async method of finalized object that the method has no reference to this in it's body prevents this from being both finalized and garbage collected. More: Maybe the last but not least. Finalizers and GCs vs. running methods RIGHT NOW, f.e. async/await code execution stopped by never finished Future but the method is stoping nothing else elsewhere, the method is not passed by reference somewhere else as an argument like in addListener(), and what's important such method with no "this" reference inside !!!. Let's ignore isolates, and sync methods, because it needs more time to measure. But let's focus on a simple async method that is not finished for a very long time will finalizer or gc work at all?: ................................................................ ........................................................................................ ..................................................................................................
important conclusions: based on such simple code: class SomeClassForFinalizerTests {SomeClassForFinalizerTests() {abcabc();} abcabc() async {await Future.delayed(const Duration(milliseconds: 500000));}} it can be concluded that any triggered GC won't gc any instance of SomeClassForFinalizerTests until await the method is not finished which is easier to be noticed on long async await. As you can see there is not "this" in the called body method and in the constructor where it was called the body of the constructor finished immediately as it is no async await - just synchronous quick call. After the method finally finished GC manually was called in the mentioned here Flutter devtools, and the SomeClassForFinalizerTests object was gd-ed and dissapeared. What is important the parent method in this case main with async body with some awaits after SomeClassForFinalizerTests was created finished it's body execution (again, meethod main()) and the SomeClassForFinalizerTests() method finished much later and only after the GC was possible. 
The below conclusions has a bit deeper approach of analysis but i noticed during experiments that those tests were no relevant and useful because for such immediate gc like outcome is enought to implement dispose like methods or just care writing some additional helper code. the GC with finalizers is for some delays when you forget to set the last pointer to a finalized object to null. And you always need to remember that the finalizer may never be called anyway. This is always last resort to finalize something and to make sure all is GC in a heavily consuming resources application.
.........................................................................................
These are old conclusions and this was not what was important, but i leave it here.
Some initial conclusions. In one case main() has await that lasts longer than some finalized object asyn method called synchronically in the class constructor but we are not await until it ends it ends in the background, but finishes earlier that the main() method - this triggers finalizers attached to the finalized object, but if the future finishes later only triggering manually gc like in flutter devtools there is the button GC then finalizers are triggered or dart will do it in undefinite future - like in an hour. So dart tries to finalize immediately for Finalize class but if it cannot do it like parent method finished it's code execution too early then it is waiting for the GC to trigger and finalize. The object is set to null relevant method/classes with finalizers and the finalized object mentioned future fihishes earlier than main()/any other parent(?) method body, but to remind you there is different scenario described earlier and both conditions probably must be always met to trigger finalizer early not waiting for the GC that may never start. That caused finalisers to trigger immediately, but if main finished earlier than the last mentioned awaits it would delay triggerring the finalizer not immediately. It is described earlier here how it works but here we have from sort of two different approaches. 
 ........................................................................................ ..................................................................................................
EDIT: JUST READ ON DART DISCORD OFFICIAL, MAYBE INTERESTING MAYBE NOT: https://github.com/dart-lang/language/blob/main/working/macros/example/lib/auto_dispose.dart AND https://github.com/dart-lang/sdk/issues/43490
===================================================================================
Trying to understand in general some important aspect of dispose method. In the process of improving understanding of this, this text may be updated.
I have some trouble with the dispose() method so i need some analisys s. F.e. Listeneable abstract class has not this method but ChangeNotifier does, but in my opionion it would be more understandable from my narrow perspective that the dispose method is required in the Listeneable class. If in ChangeNotifier addListener of the latter adds a listener method to a internal list then removing last pointer to the change notifier would destroy the list so no listener is registered to an existing object. So it makes more sense when we read ChangeNotifier dispose description: "Discards any resources used by the object. After this is called, the object is not in a usable state and should be discarded (calls to addListener will throw after the object is disposed)." In other words if accidently there are more pointers to the ChangeNotifier and you may have forgotten about them the listeners haven't been removed. By calling the dispose method you want to release memory and possibly stop an object "working" UNTILE the last pointer to it is removed WHICH MAY NEVER HAPPEN.
Now the major point:
So When you call the dispose method on a State object you want to unsubscripte from a stream so that the stream is not maintained in memory or kept alive when last pointer to it was removed. You want to cancel any endles timer or animation. You want to take care of any attached stuff to attached stuff and try to release/remove it so that it is not somehow maintained by the framework when all your pointers are lost and you think memory should be released by by the design of the flutter framework their however are still in memory working actively or not.
Also an example of such a ChangeNotifier is in this link https://api.flutter.dev/flutter/widgets/TextEditingController-class.html where they remind you "Remember to dispose of the TextEditingController when it is no longer needed. This will ensure we discard any resources used by the object."

So a bit compatible qoutation from https://www.geeksforgeeks.org/flutter-dispose-method-with-example/ which helps me to understand the WHYs is as i suspected is the main reason not just loosing the last pointer to a variable that we want to "dispose" without calling the dispose() method:
"Situations, where you need to call your dispose() method, could be turning off the notifications, unsubscribing, shutting off the animations, etc. "

====================================================================================
Isolates, compute, some gem read from official dart discord names/nicks removed because of possible privacy issues: 
Someone1 : Are isolates condidered expensive to create and delete? If I periodically receive an external command to perform a particular task (say, a couple of times a minute), would it be out of the ordinary to spin up an isolate for each task?
Someone2
If you use Isolate.run or Isolate.spawn, it should be way more than fine. Especially if only a few times a minute. The isolates spawned using this method are spawned in the same isolate group, so they share the same code as the spawning isolate, reducing their start up cost and time. 

Apart from that, compute function runs in isolate on native platforms, but on the web on the event loop. It may take some time the isolates will be brought to Wasm. Also some not carefully reviewed by me sources imply Wasm is not yet isolates/threads ready, yet some more official table of features implied the oposite to me - i am not an wasm insider.
i
