# dart_tips_solutions_informal
Some needed often difficult to find solutions, tips, etc. focusing on dart and VScode too.

If you have TODO: FIXME: like places in vscode.
https://github.com/microsoft/vscode/issues/9899
and there f.e. vscode-todo-highlight with f.e. // TODO: AND FIXME: highlighting customisation
works nice - you see labels clearly visible in dart

some lint rules might be useful - at leas i needed them
    invalid_use_of_protected_member: error # causes @protected method property to show error not notice which is by default
    missing_override_of_must_be_overridden: error #== operator and hashCode defined in an interface class are not required to be overriden/implemented like other custom methods. @mustBeOverriden annotation is used for this all classes extenging/implementing, even a class B extending a class A and then C extending B. the C must override too  
    must_call_super: error # requires any extending class and probably even extending the extending class implementing calling super.overridenmethod

A situation that happened on web and someone implied that an error couldn't has been catched because it was thrown synchronously or something or a js synchronous future/promise? was used or something instead of asynchronous version. The issue with solutions and some analysis: https://github.com/simolus3/sqlite3.dart/issues/184
Too much to say
