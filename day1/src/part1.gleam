import elves
import file_system
import gleam/int
import gleam/io
import gleam/list

pub fn run() {
  let lines = file_system.get_fs() |> file_system.read_lines()

  lines |> elves.get_elves_calories |> list.reduce(int.max) |> io.debug
}
