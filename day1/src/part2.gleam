import elves
import file_system
import gleam/int
import gleam/io
import gleam/list
import gleam/order

fn sort_asc(a: Int, b: Int) {
  case int.compare(a, b) {
    order.Eq -> order.Eq
    order.Lt -> order.Gt
    order.Gt -> order.Lt
  }
}

pub fn run() {
  let lines = file_system.get_fs() |> file_system.read_lines()

  lines
  |> elves.get_elves_calories
  |> list.sort(sort_asc)
  |> list.take(up_to: 3)
  |> int.sum
  |> io.debug
}
