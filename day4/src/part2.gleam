import cleaning
import file_system
import gleam/int
import gleam/io
import gleam/list

pub fn run() {
  let lines = file_system.get_fs() |> file_system.read_lines()

  lines
  |> list.map(fn(line) {
    let pair = cleaning.decode_pair(line)
    case cleaning.do_sections_overlap(pair.sections) {
      True -> 1
      False -> 0
    }
  })
  |> int.sum()
  |> io.debug
}
