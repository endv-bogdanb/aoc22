import file_system
import gleam/dict
import gleam/io
import grid.{type Cell, type Grid}

fn calculate_visible_trees(grid: Grid) -> Int {
  do_calculate_visible_trees(grid, dict.keys(grid.cells), 0)
}

fn do_calculate_visible_trees(grid: Grid, cells: List(Cell), acc: Int) -> Int {
  case cells {
    [] -> acc
    [head, ..tail] -> {
      case grid.is_cell_visible(grid, head) {
        True -> do_calculate_visible_trees(grid, tail, acc + 1)
        False -> do_calculate_visible_trees(grid, tail, acc)
      }
    }
  }
}

pub fn run() {
  let fs = file_system.get_fs()
  let lines = file_system.read_lines(fs)

  lines |> grid.construct_grid |> calculate_visible_trees |> io.debug

  Nil
}
