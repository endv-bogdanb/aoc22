import file_system
import gleam/io
import gleam/list
import gleam/string
import message

pub fn run() {
  let fs = file_system.get_fs()
  let lines = file_system.read_lines(fs)

  lines
  |> list.map(fn(value) {
    message.sequence(value, fn(sequence: String) {
      string.length(sequence) == 14
    })
  })
  |> io.debug
}
