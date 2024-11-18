import gleam/int
import gleam/list
import gleam/set.{type Set}
import gleam/string
import point.{type Point}

pub type Grid =
  Set(Point)

pub fn grid(lines: List(String)) -> Grid {
  lines
  |> list.map(string.split(_, " -> "))
  |> list.map(point.line_to_points)
  |> list.flat_map(point.points_to_interval(_, []))
  |> set.from_list
}

pub fn depth(grid: Grid) -> Int {
  let assert Ok(depth) =
    set.to_list(grid)
    |> list.map(fn(value) { value.y })
    |> list.reduce(int.max)
  depth
}

pub fn can_go_down(grid: Grid, sand: Point) -> Bool {
  !set.contains(grid, point.Point(sand.x, sand.y + 1))
}

pub fn can_go_left(grid: Grid, sand: Point) -> Bool {
  !set.contains(grid, point.Point(sand.x - 1, sand.y + 1))
}

pub fn can_go_right(grid: Grid, sand: Point) -> Bool {
  !set.contains(grid, point.Point(sand.x + 1, sand.y + 1))
}
