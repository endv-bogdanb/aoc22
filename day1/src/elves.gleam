import gleam/int

pub fn get_elves_calories(lines: List(String)) -> List(Int) {
  case lines {
    [] -> []
    [head, ..tail] -> {
      case head {
        "" -> [0, ..get_elves_calories(tail)]
        _ ->
          case int.parse(head) {
            Ok(value) -> {
              let calories = get_elves_calories(tail)
              case calories {
                [] -> [value]
                [head, ..tail] -> [head + value, ..tail]
              }
            }
            Error(Nil) -> get_elves_calories(tail)
          }
      }
    }
  }
}
