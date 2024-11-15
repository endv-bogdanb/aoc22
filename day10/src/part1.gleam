import cpu
import file_system
import gleam/io
import gleam/list
import instruction

pub fn run() {
  let fs = file_system.get_fs()
  let lines = file_system.read_lines(fs)

  lines
  |> list.map(instruction.line_to_instruction)
  |> cpu.process_instructions
  |> list.index_fold(0, fn(signal, value, cycle) {
    let cycle = cycle + 1
    case cycle {
      20 | 60 | 100 | 140 | 180 | 220 -> signal + { value * cycle }
      _ -> signal
    }
  })
  |> io.debug

  Nil
}
