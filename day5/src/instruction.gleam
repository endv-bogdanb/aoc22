import file_streams/file_stream.{type FileStream}
import file_system
import gleam/int
import gleam/list
import gleam/regex

pub type Instruction {
  Instruction(quantity: Int, from: Int, to: Int)
}

pub fn read_instructions(fs: FileStream) -> List(Instruction) {
  fs
  |> file_system.read_lines()
  |> list.map(fn(line) {
    let assert Ok(re) = regex.from_string("\\d+")
    case
      regex.scan(re, line)
      |> list.map(fn(value) {
        case int.parse(value.content) {
          Ok(value) -> value
          Error(Nil) -> 0
        }
      })
    {
      [quantity, from, to] -> Instruction(quantity, from, to)
      _ -> Instruction(0, 0, 0)
    }
  })
}
