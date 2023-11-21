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
One of the most important rule for a bit more advanced memory management, gc, Finalizer class, WeakReference class, dispose() method of widget.
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
D. Maybe the last but not least. Finalizers and GCs vs. running methods RIGHT NOW, f.e. async/await code execution stopped by never finished Future but the method is stoping nothing else elsewhere, the method is not passed by reference somewhere else as an argument like in addListener(), and what's important such method with no "this" reference inside !!!. Let's ignore isolates, and sync methods, because it needs more time to measure. But let's focus on a simple async method that is not finished for a very long time will finalizer or gc work at all?: ................................................................ ........................................................................................ .................................................................................................. ........................................................................................ ..................................................................................................
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
