import gleam/int

pub type Instruction {
  Instruction(value: Int, cycles: Int)
}

pub fn line_to_instruction(line: String) -> Instruction {
  case line {
    "noop" -> Instruction(value: 0, cycles: 1)
    "addx " <> value -> {
      let assert Ok(value) = int.parse(value)
      Instruction(value: value, cycles: 2)
    }
    _ -> panic
  }
}
