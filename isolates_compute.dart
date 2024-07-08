//Isolates - native and web + ultimate solution for all platform.
//The bottom line: Warning for the web we don't work on the copy of the "higher-level-scope objects but on the original as i suspected including the argument passed as Message !!!
//So for a multiplatform code you can't change any higher-level-scope object except for reading data from them with the additional warning: Sometimes you can think you read a property from an object but it is getter, but the getter may set up some property. You must be sure then either you work on a simple higher-level scope object, or you must always investigate if a getter or method does the job but doesn't change any property involved.
//Again it is the same for the object passed as message of the compute method - it is not a copy for web. So you must always be aware of this topic.
//SUMMARY FOR THE ABOVE - IF YOU WRITE FULLY COMPATIBLE MULTIPLATFORM CODE.
//The only way to run for both web and native is compute method which is great but
//- for run() and spawn() BUT ALSO THE compute() method the same result (here spawn).
//As for the compute() IT IS THE ONLY METHOD THAT CAN BE RUN FOR WEB AND NATIVE. FOR NATIVE IT USES ISOLATE BUT FOR WEB CURRENT EVENT LOOP.
//So as the docs also says there is overhead related to it because of copying so it is sort of convenience syntax and they recommend using messaging for heavier longer running stuff.
//So in essence as the docs say copies of objects are copies you will never change the original object on the source isolate but the copy.
//  https://dart.dev/language/isolates#running-an-existing-method-in-a-new-isolate
//  https://api.flutter.dev/flutter/foundation/compute.html
//Now example:

int b = 20;

class A {
  int a = 10;
  c() {
    b++;
  }
}

class H {
  int a;
  H(this.a);
}

void main() async {
  var a = A();

  var h = H(30);

  await compute<H, Object>((Object v) {
    print(a.a);
    a.a = 11;
    a.c();
    print(a.a);
    print(b);
    print('...');
    print(++h.a);
    return v;
  }, h);
  print('=============');

  print(a.a);
  print(b);
  print('...');
  print(h.a);


prints for native all - including compute (see the result for web compute after this):
flutter: 10
flutter: 11
flutter: 21
flutter: ...
flutter: 31
flutter: =============
flutter: 10
flutter: 20
flutter: ...
flutter: 30
Results for the web - compute method (different conclusions at the top):
10
11
21
...
31
=============
11
21
...
31

