dart_tips_solutions_informal
Some needed often difficult to find solutions, tips, etc. focusing on dart and VScode too.
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
One of the most important rule for a bit more advanced memory management.
If you have SomeObject? abc = SomeObject(), and f.e. 10 x var efgh = WeakReference(abc); efgh2..., efgh3..., and nothing else (efgh.target is abc object) and then if after that you set abc = null; then right after that efgh.target = abc, but when the dart whenever it "randomly wants", f.e. 5 minutes later, triggers the Garbage Collector then all the 10 variables have their .target == null, efgh.target == null (efgh is still WeakReference instance but .target == null). One my test showed that all related objects to the abc also should dissapear at the same time in one GC only, like abc.some2object,some3object dissapears and there should be no referrence to it in let's say some kind do GC waiting room. 
===================================================================================
Trying to understand in general some important aspect of dispose method. In the process of improving understanding of this, this text may be updated.
I have some trouble with the dispose() method so i need some analisys s. F.e. Listeneable abstract class has not this method but ChangeNotifier does, but in my opionion it would be more understandable from my narrow perspective that the dispose method is required in the Listeneable class. If in ChangeNotifier addListener of the latter adds a listener method to a internal list then removing last pointer to the change notifier would destroy the list so no listener is registered to an existing object. So it makes more sense when we read ChangeNotifier dispose description: "Discards any resources used by the object. After this is called, the object is not in a usable state and should be discarded (calls to addListener will throw after the object is disposed)." In other words if accidently there are more pointers to the ChangeNotifier and you may have forgotten about them the listeners haven't been removed. By calling the dispose method you want to release memory and possibly stop an object "working" UNTILE the last pointer to it is removed WHICH MAY NEVER HAPPEN.
Now the major point:
So When you call the dispose method on a State object you want to unsubscripte from a stream so that the stream is not maintained in memory or kept alive when last pointer to it was removed. You want to cancel any endles timer or animation. You want to take care of any attached stuff to attached stuff and try to release/remove it so that it is not somehow maintained by the framework when all your pointers are lost and you think memory should be released by by the design of the flutter framework their however are still in memory working actively or not.
Also an example of such a ChangeNotifier is in this link https://api.flutter.dev/flutter/widgets/TextEditingController-class.html where they remind you "Remember to dispose of the TextEditingController when it is no longer needed. This will ensure we discard any resources used by the object."

So a bit compatible qoutation from https://www.geeksforgeeks.org/flutter-dispose-method-with-example/ which helps me to understand the WHYs is as i suspected is the main reason not just loosing the last pointer to a variable that we want to "dispose" without calling the dispose() method:
"Situations, where you need to call your dispose() method, could be turning off the notifications, unsubscribing, shutting off the animations, etc. "

====================================================================================
