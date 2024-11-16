import file_system
import gleam/io
import grid
import path

pub fn run() {
  file_system.get_fs()
  |> file_system.read_lines
  |> grid.lines_to_grid
  |> grid.get_interest_points
  |> path.path
  |> io.debug

  Nil
}
