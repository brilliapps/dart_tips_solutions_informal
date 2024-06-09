Some unprofessional quick tests (sorry for function and variable names).
Let the code speak for itself - some simple type tests. Such a set:
For me the important conclusion out of conclusions was:
    if T in a generic class is "String?" - why:  
    //print(T == Object?); // not allowed
    print(T is Object?); true
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
