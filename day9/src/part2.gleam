import direction
import file_system
import gleam/io
import gleam/list
import gleam/set
import rope

pub fn run() {
  let lines = file_system.get_fs() |> file_system.read_lines
  let rope = [
    rope.Point(x: 0, y: 0),
    rope.Point(x: 0, y: 0),
    rope.Point(x: 0, y: 0),
    rope.Point(x: 0, y: 0),
    rope.Point(x: 0, y: 0),
    rope.Point(x: 0, y: 0),
    rope.Point(x: 0, y: 0),
    rope.Point(x: 0, y: 0),
    rope.Point(x: 0, y: 0),
  ]

  lines
  |> list.map(direction.line_to_direction)
  |> rope.follow(rope, _)
  |> set.from_list
  |> set.to_list
  |> list.length
  |> io.debug

  Nil
}
