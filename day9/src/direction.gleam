import gleam/int

pub type Direction {
  Up(Int)
  Down(Int)
  Left(Int)
  Right(Int)
}

pub fn line_to_direction(line: String) -> Direction {
  case line {
    "U " <> value -> {
      let assert Ok(value) = int.parse(value)
      Up(value)
    }
    "D " <> value -> {
      let assert Ok(value) = int.parse(value)
      Down(value)
    }
    "L " <> value -> {
      let assert Ok(value) = int.parse(value)
      Left(value)
    }
    "R " <> value -> {
      let assert Ok(value) = int.parse(value)
      Right(value)
    }
    _ -> panic
  }
}
