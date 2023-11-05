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
Why to you need to complete a Completer or Future must be finished not just it's LAST existing pointer to be set to null?
Because setting to null won't finish the completer (tested), so any Future (not tested) too.
What if 100000000 pending methods has async/await for one such a future? The methods will never complete and resources won't ever be released.
So especially if such unfinished completer or future is assigned to a property of another object, make sure it is comlete() -ed or completeError() - ed. before you loose last pointer to an object handling it



 
