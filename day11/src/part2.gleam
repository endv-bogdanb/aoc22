import file_system
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import monkey

pub fn run() {
  let monkeys =
    file_system.get_fs()
    |> file_system.read_lines
    |> monkey.lines_to_monkeys

  let divisible =
    dict.to_list(monkeys)
    |> list.fold(1, fn(acc, value) { acc * { value.1 }.check.0 })

  let inspected =
    monkeys
    |> monkey.rounds(10_000, fn(monkey, item) {
      monkey.worry(monkey, item) % divisible
    })
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
