//PROBABLY FIRST CONCLUSIVE CODE (EXAMPLE DEBUG PRINT BELOW THE CODE) - READ COMMENTS AND DEBUGPRINT MESSAGES - the identical works fine, even if identity hashcodes (with some core dart non identity hashcodes as you can see from the code) may fail. So in rare occasions when you want f.e. for non extendable Function class object have totaly unique id (identity hashcode may fail as mentioned) then you need to add to the function or Function some totally unique custorm number/id which you can achieve through extesion on Function {} syntax or using Expando on objects or both.
//The ultimate proving point code:
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

//EXAMPLE DEBUG PRINT FROM THE CODE
//flutter: Two duplicate hashCodes occured, the number of hashcodes:45797 but the number of lists: 45797; both numbers should be the same.
//flutter: We found the element that has the same indentity hashcode result (both results are: 536373741, 536373741) of identical for 
//both objects that belong to the equal identity hashcode: false. Morover the custom NON-identityHashcode getter
//called hashCode returns for anotherList.hashCode=536373741, but for lists.elementAt(i).hashCode=536373741.
//As they are equal and the identical operator (identical(anotherList, lists.elementAt(i))) returns false as 
//it should dart uses something else to distinquish the two objects like i could imagine a simple counter 
//giving each object an always unique number that is checked f.e. when all sorts of hashcode fail

