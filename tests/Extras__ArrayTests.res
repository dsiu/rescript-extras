module T = Extras__Test
module A = Extras__Array

let test = (~title, ~expect, ~a, ~b) =>
  T.fromPredicate(~category="Array", ~title, ~expectation=expect, () => {
    let m = a()
    let n = b
    if m != n {
      Console.log("")
      Console.log(`== NOT EQUAL : ${title} ==`)
      Console.log2("a: ", m)
      Console.log2("b: ", n)
    }
    m == n
  })

let unfoldTests = {
  let make = (expectation, seed, generator, expected) =>
    T.fromPredicate(~category="Array", ~title="unfold", ~expectation, () =>
      seed->A.unfold(generator) == expected
    )
  [
    ("multiplicative", 1, i => i < 100 ? Some(i, i * 2) : None, [1, 2, 4, 8, 16, 32, 64]),
    ("multiplicative", 28, i => i < 100 ? Some(i, i * 2) : None, [28, 56]),
    ("multiplicative", 101, i => i < 100 ? Some(i, i * 2) : None, []),
    ("simple range up", 5, i => i <= 20 ? Some(i, i + 5) : None, [5, 10, 15, 20]),
    ("simple range down", 20, i => i > 15 ? Some(i, i - 1) : None, [20, 19, 18, 17, 16]),
  ]->Array.map(((expectation, seed, f, goal)) => make(expectation, seed, f, goal))
}

let tests = {
  [
    test(~title="of1", ~expect="wrap item in an array", ~a=() => 1->A.of1, ~b=[1]),
    test(~title="of1", ~expect="wrap array in array", ~a=() => [1, 2, 3]->A.of1, ~b=[[1, 2, 3]]),
    test(~title="of1", ~expect="wrap None in array", ~a=() => None->A.of1, ~b=[None]),
    test(~title="fromOption", ~expect="if None => empty", ~a=() => None->A.fromOption, ~b=[]),
    test(
      ~title="fromOption",
      ~expect="if Some => array with one item",
      ~a=() => Some(3)->A.fromOption,
      ~b=[3],
    ),
    test(~title="last", ~expect="when empty, return None", ~a=() => []->A.last, ~b=None),
    test(
      ~title="last",
      ~expect="when not empty, return Some",
      ~a=() => [1, 2, 3]->A.last,
      ~b=Some(3),
    ),
    test(~title="head", ~expect="when empty, return None", ~a=() => []->A.head, ~b=None),
    test(~title="head", ~expect="when not empty, return first", ~a=() => [1]->A.head, ~b=Some(1)),
    test(
      ~title="lastIndex",
      ~expect="when more than 1 item, return Some",
      ~a=() => [1, 2, 3]->A.lastIndex,
      ~b=Some(2),
    ),
    test(
      ~title="lastIndex",
      ~expect="when one item, return Some",
      ~a=() => [1]->A.lastIndex,
      ~b=Some(0),
    ),
    test(~title="lastIndex", ~expect="when empty, return None", ~a=() => []->A.lastIndex, ~b=None),
    test(
      ~title="exactlyOneValue",
      ~expect="when empty => None",
      ~a=() => []->A.exactlyOne,
      ~b=None,
    ),
    test(
      ~title="exactlyOneValue",
      ~expect="when one value => Some",
      ~a=() => [3]->A.exactlyOne,
      ~b=Some(3),
    ),
    test(
      ~title="exactlyOneValue",
      ~expect="when empty => None",
      ~a=() => [1, 2]->A.exactlyOne,
      ~b=None,
    ),
    test(
      ~title="prepend",
      ~expect="concats to the beginning",
      ~a=() => [3, 4, 5]->A.prepend([1, 2]),
      ~b=[1, 2, 3, 4, 5],
    ),
    test(~title="filterSome", ~expect="when empty => []", ~a=() => []->A.filterSome, ~b=[]),
    test(
      ~title="filterSome",
      ~expect="when one Some(x) => [x]",
      ~a=() => [Some(3)]->A.filterSome,
      ~b=[3],
    ),
    test(~title="filterSome", ~expect="when one None => []", ~a=() => [None]->A.filterSome, ~b=[]),
    test(
      ~title="filterSome",
      ~expect="keep just the Some values",
      ~a=() => [None, Some(1), Some(2), None]->A.filterSome,
      ~b=[1, 2],
    ),
  ]->Array.concat(unfoldTests)
}
