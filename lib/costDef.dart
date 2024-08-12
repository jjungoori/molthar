import 'sysClasses.dart';

void printCost(List<Cost> costs){
  for(int i = 0; i < costs.length; i ++){
    for(int l = 0 ; l < costs[i].mats.length; l ++){
      print(costs[i].mats[l].toString() + ", ");
    }
    print("\n");
  }
}

List<Cost> findCombinations(int m, {int n = -1}) {
  List<Cost> result = [];

  void backtrack(List<int> current, int remainingSum, int start) {
    // n이 -1인 경우 숫자의 개수에 제한을 두지 않습니다.
    if (remainingSum == 0 && (n == -1 || current.length <= n)) {
      result.add(Cost(mats: List.from(current), crystal: 0)); // crystal 값을 0으로 초기화
      return;
    }

    if (remainingSum < 0) return;

    for (int i = start; i <= 8; i++) {
      current.add(i);
      backtrack(current, remainingSum - i, i);
      current.removeLast();
    }
  }

  backtrack([], m, 1);
  return result;
}

List<Cost> sameN(int n) {
  List<Cost> result = [];

  for (int i = 1; i <= 8; i++) {
    // 같은 숫자 i로 이루어진 리스트 생성
    List<int> mats = List.filled(n, i);
    // Cost 객체로 변환하여 결과 리스트에 추가
    result.add(Cost(mats: mats, crystal: 0));
  }

  return result;
}

List<Cost> sameNAnd66(int n) {
  List<Cost> result = [];

  for (int i = 1; i <= 8; i++) {
    // 같은 숫자 i로 이루어진 리스트 생성
    List<int> mats = List.filled(n, i);
    // Cost 객체로 변환하여 결과 리스트에 추가
    result.add(Cost(mats: mats+[6,6], crystal: 0));
  }

  return result;
}

List<Cost> same2and2(){
  List<Cost> result = [];
  for(int i = 1; i <= 8; i++){
    for(int l = 1; l <= 8; l++){
      result.add(Cost(mats: [i, i, l, l]));
    }
  }
  return result;
}

List<Cost> generateEvenCosts(int n) {
  List<Cost> result = [];
  List<int> evenNumbers = [2, 4, 6, 8];

  void backtrack(List<int> current, int start) {
    if (current.length == n) {
      result.add(Cost(mats: List.from(current), crystal: 0));
      return;
    }

    for (int i = start; i < evenNumbers.length; i++) {
      current.add(evenNumbers[i]);
      backtrack(current, i);
      current.removeLast();
    }
  }

  backtrack([], 0);
  return result;
}

List<Cost> generateOddCosts(int n) {
  List<Cost> result = [];
  List<int> evenNumbers = [1, 3, 5, 7];

  void backtrack(List<int> current, int start) {
    if (current.length == n) {
      result.add(Cost(mats: List.from(current), crystal: 0));
      return;
    }

    for (int i = start; i < evenNumbers.length; i++) {
      current.add(evenNumbers[i]);
      backtrack(current, i);
      current.removeLast();
    }
  }

  backtrack([], 0);
  return result;
}

List<Cost> generateConsecutiveCosts(int n) {
  if (n < 1 || n > 8) {
    throw ArgumentError('n must be between 1 and 8');
  }

  List<Cost> result = [];

  for (int start = 1; start <= 9 - n; start++) {
    List<int> mats = List.generate(n, (index) => start + index);
    result.add(Cost(mats: mats, crystal: 0));
  }

  return result;
}


List<Cost> sum3to20 = findCombinations(20, n: 3);
List<Cost> sum3to10 = findCombinations(10, n: 3);
List<Cost> sum3to7 = findCombinations(7, n: 3);
List<Cost> sumnto10 = findCombinations(10);

List<Cost> same2 = sameN(2);
List<Cost> same3 = sameN(3);
List<Cost> same4 = sameN(4);
List<Cost> same2And66 = sameNAnd66(2);

List<Cost> same22 = same2and2();

List<Cost> odd3 = generateOddCosts(3);
List<Cost> even3 = generateEvenCosts(3);

List<Cost> n123 = generateConsecutiveCosts(3);
List<Cost> n12345 = generateConsecutiveCosts(5);