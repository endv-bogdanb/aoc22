import file_system
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import monkey

pub fn run() {
  let inspected =
    file_system.get_fs()
    |> file_system.read_lines
    |> monkey.lines_to_monkeys
    |> monkey.rounds(20, fn(monkey, item) { monkey.worry(monkey, item) / 3 })
    |> dict.to_list
    |> list.map(fn(value) { { value.1 }.inspected })
    |> list.sort(int.compare)
    |> io.debug()

  inspected
  |> list.drop(up_to: list.length(inspected) - 2)
  |> list.fold(1, fn(acc, value) { acc * value })
  |> io.debug()

  Nil
}
