import file_system
import gleam/dict
import gleam/io
import grid.{type Cell, type Grid}

fn calculate_house_spot(grid: Grid) -> Int {
  do_calculate_house_spot(grid, dict.keys(grid.cells), 0)
}

fn do_calculate_house_spot(grid: Grid, cells: List(Cell), acc: Int) -> Int {
  case cells {
    [] -> acc
    [head, ..tail] -> {
      let scenic_score = grid.scenic_score(grid, head)
      case scenic_score > acc {
        True -> do_calculate_house_spot(grid, tail, scenic_score)
        False -> do_calculate_house_spot(grid, tail, acc)
      }
    }
  }
}

pub fn run() {
  let fs = file_system.get_fs()
  let lines = file_system.read_lines(fs)

  lines |> grid.construct_grid |> calculate_house_spot |> io.debug

  Nil
}
