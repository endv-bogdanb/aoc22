import file_system
import gleam/io
import gleam/list
import gleam/set
import grid
import point

fn falling_sand(grid: grid.Grid, sand: point.Point, depth: Int) {
  case do_falling_sand(grid, sand, depth) {
    #(_, point.Point(500, 0)) -> [sand]
    #(new_grid, new_sand) -> [new_sand, ..falling_sand(new_grid, sand, depth)]
  }
}

fn do_falling_sand(
  grid: grid.Grid,
  sand: point.Point,
  depth: Int,
) -> #(grid.Grid, point.Point) {
  case sand.y == depth + 1 {
    True -> #(set.insert(grid, sand), sand)
    False ->
      case
        grid.can_go_down(grid, sand),
        grid.can_go_left(grid, sand),
        grid.can_go_right(grid, sand)
      {
        True, _, _ ->
          do_falling_sand(grid, point.Point(x: sand.x, y: sand.y + 1), depth)
        False, True, _ ->
          do_falling_sand(
            grid,
            point.Point(x: sand.x - 1, y: sand.y + 1),
            depth,
          )
        False, False, True ->
          do_falling_sand(
            grid,
            point.Point(x: sand.x + 1, y: sand.y + 1),
            depth,
          )
        False, False, False -> {
          #(set.insert(grid, sand), sand)
        }
      }
  }
}

pub fn run() {
  let grid =
    file_system.get_fs()
    |> file_system.read_lines()
    |> grid.grid

  let depth = grid.depth(grid)

  // io.debug(grid)
  // io.debug(depth)

  falling_sand(grid, point.Point(500, 0), depth) |> list.length |> io.debug

  Nil
}
