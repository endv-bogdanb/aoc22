import gleam/list
import gleam/set
import gleam/string

pub type Rucksack {
  Rucksack(compartments: List(List(String)))
}

pub fn common_items(rucksack: Rucksack) -> List(String) {
  case
    rucksack.compartments
    |> list.map(set.from_list)
    |> list.reduce(set.intersection)
  {
    Ok(value) -> set.to_list(value)
    Error(Nil) -> []
  }
}

pub fn item_to_int(graphene: String) -> Result(Int, Nil) {
  case string.to_utf_codepoints(graphene) {
    [codepoint] -> {
      let result = string.utf_codepoint_to_int(codepoint)
      let value = result - 97 + 1
      Ok(case value < 0 {
        True -> result - 65 + 27
        False -> value
      })
    }
    _ -> Error(Nil)
  }
}
