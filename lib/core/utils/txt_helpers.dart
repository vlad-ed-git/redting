import 'dart:math';

String clipText({required String txt, int maxChars = 48}) {
  if (txt.length <= maxChars) return txt;
  return "${txt.substring(0, maxChars)}...";
}

String clipWords({required String txt, int maxChars = 48}) {
  if (txt.length <= maxChars) return txt;
  var allWords = txt.split(" ");

  String clipped = allWords[0];

  if (clipped.length > maxChars) {
    return clipText(txt: txt, maxChars: maxChars); // a single long word
  }

  int i = 1;
  while (i < allWords.length) {
    String candidate = "$clipped ${allWords[i]}";
    if (candidate.length > maxChars) {
      break;
    }
    clipped = candidate;
    i++;
  }
  return "$clipped...";
}

String randomWordInList(List<String> aList) {
  final random = Random();
  String iceBreaker =
      aList.isNotEmpty ? aList[random.nextInt(aList.length)] : '';
  return iceBreaker;
}
