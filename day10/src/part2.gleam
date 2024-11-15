import cpu
import file_system
import gleam/io
import gleam/list
import gleam/string_builder
import instruction

pub fn run() {
  let fs = file_system.get_fs()
  let lines = file_system.read_lines(fs)

  lines
  |> list.map(instruction.line_to_instruction)
  |> cpu.process_instructions
  |> list.index_fold(string_builder.new(), fn(crt, value, cycle) {
    let cycle = cycle % 40

    let crt = case value - 1 <= cycle && cycle <= value + 1 {
      True -> string_builder.append(crt, "#")
      False -> string_builder.append(crt, " ")
    }

    case cycle {
      39 -> {
        io.debug(string_builder.to_string(crt))
        string_builder.new()
      }
      _ -> crt
    }
  })

  Nil
}
