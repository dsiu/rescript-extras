module NEA = Extras__NonEmptyArray
module O = Option

let expectEq = (~title, ~expectation, ~a, ~b) =>
  Extras__Test.fromPredicate(~category="NonEmptyArray", ~title, ~expectation, () => a() == b)

let add = (x, y) => x + y

let tests = [
  expectEq(
    ~title="fromArray",
    ~expectation="when empty => None",
    ~a=() => []->NEA.fromArray,
    ~b=None,
  ),
  expectEq(
    ~title="fromArray",
    ~expectation="when one item => Some",
    ~a=() => [1]->NEA.fromArray->O.map(NEA.toArray),
    ~b=Some([1]),
  ),
  expectEq(
    ~title="fromArray",
    ~expectation="when many items => Some",
    ~a=() => [1, 2, 3]->NEA.fromArray->O.map(NEA.toArray),
    ~b=Some([1, 2, 3]),
  ),
  expectEq(
    ~title="map",
    ~expectation="",
    ~a=() => NEA.of3(1, 2, 3)->NEA.map(i => i * 2)->NEA.toArray,
    ~b=[2, 4, 6],
  ),
  expectEq(
    ~title="head",
    ~expectation="returns first item",
    ~a=() => NEA.of3(1, 2, 3)->NEA.head,
    ~b=1,
  ),
  expectEq(
    ~title="last",
    ~expectation="returns last item",
    ~a=() => NEA.of3(1, 2, 3)->NEA.last,
    ~b=3,
  ),
  expectEq(
    ~title="reduce",
    ~expectation="when one item, return it",
    ~a=() => NEA.of1(1)->NEA.reduce(add),
    ~b=1,
  ),
  expectEq(
    ~title="reduce",
    ~expectation="when two items, return sum",
    ~a=() => NEA.of2(1, 2)->NEA.reduce(add),
    ~b=3,
  ),
  expectEq(
    ~title="reduce",
    ~expectation="when many items, return sum",
    ~a=() => NEA.of3(1, 2, 3)->NEA.reduce(add),
    ~b=6,
  ),
  expectEq(
    ~title="maxBy",
    ~expectation="return max",
    ~a=() => NEA.of3(1, 2, 3)->NEA.maxBy(Int.compare),
    ~b=3,
  ),
  expectEq(
    ~title="minBy",
    ~expectation="return min",
    ~a=() => NEA.of3(1, 2, 3)->NEA.minBy(Int.compare),
    ~b=1,
  ),
  expectEq(
    ~title="concat",
    ~expectation="",
    ~a=() => NEA.of3(1, 2, 3)->NEA.concat(NEA.of3(1, 2, 3))->NEA.toArray,
    ~b=[1, 2, 3, 1, 2, 3],
  ),
  expectEq(~title="of1", ~expectation="", ~a=() => 4->NEA.of1->NEA.toArray, ~b=[4]),
  expectEq(~title="of2", ~expectation="", ~a=() => NEA.of2(1, 2)->NEA.toArray, ~b=[1, 2]),
  expectEq(~title="of3", ~expectation="", ~a=() => NEA.of3(1, 2, 3)->NEA.toArray, ~b=[1, 2, 3]),
  expectEq(
    ~title="ofMany",
    ~expectation="",
    ~a=() => NEA.ofMany(1, [2, 3, 4, 5])->NEA.toArray,
    ~b=[1, 2, 3, 4, 5],
  ),
]
