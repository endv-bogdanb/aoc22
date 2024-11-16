import file_system
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import grid.{type Grid}
import path
import point.{type Point}

fn best_path(init: #(Grid, Point, Point)) -> Int {
  let assert Ok(value) =
    do_best_path(
      init.0,
      init.2,
      init.0
        |> dict.to_list
        |> list.filter(fn(value) { value.1 == grid.graphene_to_int("a") })
        |> list.map(fn(value) { value.0 }),
      [],
    )
    |> list.filter(fn(value) { value != 0 })
    |> list.reduce(int.min)

  value
}

fn do_best_path(
  grid: Grid,
  destination: Point,
  starting_points: List(Point),
  acc: List(Int),
) -> List(Int) {
  case starting_points {
    [] -> acc
    [starting_point, ..starting_points] ->
      do_best_path(grid, destination, starting_points, [
        path.path(#(grid, starting_point, destination)),
        ..acc
      ])
  }
}

pub fn run() {
  file_system.get_fs()
  |> file_system.read_lines
  |> grid.lines_to_grid
  |> grid.get_interest_points
  |> best_path
  |> io.debug

  Nil
}
