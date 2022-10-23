import 'dart:math';

/// A sort algorithm that don't compare
/// values but use radix or base of
/// digits or characters
/// We use LowestSignificantDigit for
/// sorting numbers and use
/// HighestSignificantDigit for
/// lexicographical sorting aka
/// alphabetic sorting algorithm
/// O(k x n) where k is the number of significant digits in the
/// largest number and n is the number of integers in the list.

extension RadixSort on List<int> {
/// Optimize to reduce time complexity by skipping sorting algorithm when there is only one element left to sort
  void radixSort() {
    const base = 10;
    var done = false;
    //loop through places
    // Loop through each place value, where place is first 1, then
    // 10, then 100, and so on through the largest place value in
    // the list.
    var place = 1;

// Initialize the unsorted count with however many numbers are in the list.
    var unsortedCount = length;

    // while (!done) {
    // Proceed with another round of sorting as long as there is
    // more than one number left to sort.
    while (unsortedCount > 1) {
      // Start the counting over at the beginning of each round.
      unsortedCount = 0;
      // update done
      done = true;
      //generate buckets with the type of List<List<int>>
      final buckets = List.generate(base, (_) => <int>[]);

      forEach((number) {
        // Find the lowest significant number of the current number
        final remainingDigit = number ~/ place;
        // Truncating division operator
        // 123 ~/ 1 > 123
        // 123 ~/ 10 > 12
        // 123 ~/ 100 > 1
        // 123 ~/ 1000 > 0
        final digit = remainingDigit % base;
        // put digit in the appropriate bucket
        buckets[digit].add(number);
        // check there is other digit in the number
        if (remainingDigit % base > 0) {
          // done = false;
          // If the current number has more significant digits
          // left, then increment the unsorted count.
          unsortedCount++;
        }
      });
      // If all the bucket except 0bucket has only single element then move place to end of significant and sort that element and then expand
      // first simply continue if criteria is met
      // var emptyBucketCount = 0;
      // var singleNumberDigitsLength = 0;
      // for (var index = 1; index < base; index++) {
      //   if (buckets[index].isEmpty) {
      //     emptyBucketCount++;
      //   } else {
      //     if (buckets[index].length == 1) {
      //       singleNumberDigitsLength = buckets[index].first.digit();
      //     }
      //   }
      // }
      // if (emptyBucketCount == 8) {
      //   place *= base * (singleNumberDigitsLength - 1);
      // }

      //iterate to next place
      //advance place
      place *= base;
      clear();
      // since buckets is a list of lists, expand helps you
      // flatten them back into a single-dimensional list.
      addAll(buckets.expand((element) => element));
      print(buckets);
    }
  }
}

extension Digit on int {
  static const _base = 10;

  /// Returns number of digits because int doesn't have length
  /// property.
  int digit() {
    var count = 0;

    var number = this;
    while (number > 0) {
      count++;
      // Truncating division operator : returns int part of
      // division by rounding toward zero.
      number ~/= _base;
    }
    return count;
  }

  /// Return the digit at a given position.
  /// If requested position is greater than [digit()] then it
  /// returns
  /// null. A number is a zero base order.
  int? digitAt(int position) {
    if (position >= digit()) {
      return null;
    }
    var number = this;
    // chopping a digit off the end of the number until the
    // requested digit at the end.
    while (number ~/ pow(_base, position + 1) != 0) {
      number ~/= _base;
    }
    // It's then extracted using the remainder operator.
    // It return last number when divider is the _base.
    return number % _base;
  }
}

extension MsdRadixSort on List<int> {
  /// Given some list of numbers, maxDigits tells you
  /// the number of digits in the largest number.
  int maxDigits() {
    if (isEmpty) return 0;
    return reduce(max).digit();
  }

  /// This method wraps a recursive
  /// helper method.
  void lexicographicalSort() {
    final sorted = _msdRadixSort(this, 0);
    clear();
    addAll(sorted);
  }

  // Returns sorted list and its position is for advancing
  // in digit position in the numbers of the list.The list
  // after first round(position 0) will be the smaller
  // bucket lists.
  // We start with 0 then at every recursive call add
  // position to it.
  List<int> _msdRadixSort(List<int> list, int position) {
    // Base case for recursive call.
    // If list has single element or number of digits in
    // maximum of list is greater than or equal to position
    // we return list.
    // The recursive should halt if there's only one element
    // in the list or if you exceeded max number of digits.
    if (list.length < 2 || list.maxDigits() <= position) {
      return list;
    }
    // Instantiate a two-dimensional list for the buckets.
    final buckets = List.generate(10, (_) => <int>[]);
    // This buckets store number with fewer digits than the
    // current position.Values that goes to priorityBucket
    // will be sorted first.How this algorithm work?
    final priorityList = <int>[];

    // Iterate over list and if digit is at its position is null then
    // add it to priorityList otherwise add it to appropriate
    // bucket.
    for (final number in list) {
      final digit = number.digitAt(position);
      if (digit == null) {
        priorityList.add(number);
        continue;
      }
      buckets[digit].add(number);
    }

    // Then reduce buckets and add priority list before the
    // result and send them back.
    // The higher-order function reduce takes a collection and
    // reduce it to a single value.
    print(buckets);

    final bucketsListResult = buckets.reduce((result, bucket) {
      // If second list is empty we return result.
      if (bucket.isEmpty) return result;
      // Sort bucket at the next position.
      final sortedList = _msdRadixSort(bucket, position + 1);
      // .. to perform a sequence of operation on a same object
      // we use cascades.
      return result..addAll(sortedList);
    });
    // todo rewrite them as a for loop (reduce)
    // final bucketsListResult = <int>[];
    // for (final bucket in buckets) {
    //   if (bucket.isEmpty) continue;
    //   final sortedBucket = _msdRadixSort(bucket, position + 1);
    //   bucketsListResult.addAll(sortedBucket);
    // }

    return priorityList..addAll(bucketsListResult);
  }
}

void main() {
  // final list = [46, 500, 459, 1345, 13, 999];
  // list.lexicographicalSort();
  final words = [88, 410, 1772, 20, 123456789876543210];
  words.radixSort();
  print(words);
}

int totalNumberOfUniqueCharacter(List<String> words) {
  // you can use set to count number of unique character in words
  final Set<int> wordsSet = {};
  for (final word in words) {
    for (int characterUtf16CodeUnit in word.codeUnits) {
      wordsSet.add(characterUtf16CodeUnit);
    }
  }
  return wordsSet.length;
}
