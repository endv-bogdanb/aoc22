import crane
import file_system
import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import instruction

pub fn run() {
  let fs = file_system.get_fs()

  let crane = crane.read_crane(fs)
  let instructions = instruction.read_instructions(fs)

  instructions
  |> list.fold(crane, fn(acc, instruction) {
    crane.move(acc, instruction, crane.M9001)
  })
  |> dict.values
  |> list.map(list.first)
  |> result.values
  |> list.reduce(fn(a, b) { a <> b })
  |> result.unwrap("")
  |> io.debug
}
