module Unknown = Extras__Unknown
module OptionEx = Extras__Option

module type T = {
  type t
  type domain
  let isTypeOf: unknown => bool
  let parse: 'a => option<t>
  let equals: (t, t) => bool
  let value: t
  external unwrap: t => domain = "%identity"
}

module Make = (
  C: {
    type domain
    let value: domain
  },
): (T with type domain := C.domain) => {
  type t = C.domain
  let isTypeOf = u => u === C.value->Unknown.make
  let value = C.value
  let parse = u => isTypeOf(u->Unknown.make) ? Some(value) : None
  let equals = (_x, _y) => true
  external unwrap: t => C.domain = "%identity"
}

module Null = Make({
  type domain = Null.t<unknown>
  let value = Null.null
})

module True = Make({
  type domain = bool
  let value = true
})

module False = Make({
  type domain = bool
  let value = false
})

module MakeInt = (
  C: {
    let value: int
  },
) => Make({
  type domain = int
  let value = C.value
})

module MakeString = (
  C: {
    let value: string
    let trimmed: bool
    let caseInsensitive: bool
  },
): (T with type domain := string) => {
  type t = string
  let normalize = {
    let trim = s => C.trimmed ? String.trim(s) : s
    let toLower = s => C.caseInsensitive ? String.toLocaleLowerCase(s) : s
    s => s->trim->toLower
  }
  let value = C.value->normalize
  let isTypeOf = u =>
    u->Unknown.toString->Option.map(normalize)->OptionEx.isSomeAnd(u => u == value)
  let parse = u => isTypeOf(u->Unknown.make) ? Some(value) : None
  let equals = (_x, _y) => true
  external unwrap: t => string = "%identity"
}
