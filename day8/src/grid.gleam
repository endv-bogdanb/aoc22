import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Cell {
  Cell(x: Int, y: Int)
}

pub type Grid {
  Grid(width: Int, height: Int, cells: dict.Dict(Cell, Int))
}

pub fn construct_grid(lines: List(String)) -> Grid {
  let height = list.length(lines)
  let width = case list.first(lines) {
    Error(_) -> panic
    Ok(line) -> string.length(line)
  }

  do_construct_grid(
    lines,
    Grid(width: width, height: height, cells: dict.new()),
    0,
  )
}

fn do_construct_grid(lines: List(String), acc: Grid, y: Int) -> Grid {
  case lines {
    [] -> acc
    [head, ..tail] -> {
      let acc =
        string.to_graphemes(head)
        |> list.map(int.parse)
        |> result.values
        |> list.index_fold(acc, fn(acc, value, x) {
          Grid(..acc, cells: dict.insert(acc.cells, Cell(x, y), value))
        })
      do_construct_grid(tail, acc, y + 1)
    }
  }
}

fn left_sibbling(cell: Cell) {
  Cell(..cell, x: cell.x - 1)
}

fn right_sibbling(cell: Cell) {
  Cell(..cell, x: cell.x + 1)
}

fn up_sibbling(cell: Cell) {
  Cell(..cell, y: cell.y - 1)
}

fn down_sibbling(cell: Cell) {
  Cell(..cell, y: cell.y + 1)
}

pub fn is_cell_visible(grid: Grid, cell: Cell) -> Bool {
  case dict.get(grid.cells, cell) {
    Error(_) -> True
    Ok(value) -> {
      do_is_cell_visible(grid, value, left_sibbling(cell), left_sibbling)
      || do_is_cell_visible(grid, value, right_sibbling(cell), right_sibbling)
      || do_is_cell_visible(grid, value, up_sibbling(cell), up_sibbling)
      || do_is_cell_visible(grid, value, down_sibbling(cell), down_sibbling)
    }
  }
}

fn do_is_cell_visible(
  grid: Grid,
  cell_value: Int,
  cell: Cell,
  get_sibbling: fn(Cell) -> Cell,
) -> Bool {
  case dict.get(grid.cells, cell) {
    Error(_) -> True
    Ok(value) -> {
      case value >= cell_value {
        True -> False
        False ->
          do_is_cell_visible(grid, cell_value, get_sibbling(cell), get_sibbling)
      }
    }
  }
}

pub fn scenic_score(grid: Grid, cell: Cell) -> Int {
  case dict.get(grid.cells, cell) {
    Error(_) -> 0
    Ok(value) -> {
      do_scenic_score(grid, value, left_sibbling(cell), left_sibbling, 0)
      * do_scenic_score(grid, value, right_sibbling(cell), right_sibbling, 0)
      * do_scenic_score(grid, value, up_sibbling(cell), up_sibbling, 0)
      * do_scenic_score(grid, value, down_sibbling(cell), down_sibbling, 0)
    }
  }
}

fn do_scenic_score(
  grid: Grid,
  cell_value: Int,
  cell: Cell,
  get_sibbling: fn(Cell) -> Cell,
  acc: Int,
) -> Int {
  case dict.get(grid.cells, cell) {
    Error(_) -> acc
    Ok(value) ->
      case value >= cell_value {
        True -> acc + 1
        False ->
          do_scenic_score(
            grid,
            cell_value,
            get_sibbling(cell),
            get_sibbling,
            acc + 1,
          )
      }
  }
}
