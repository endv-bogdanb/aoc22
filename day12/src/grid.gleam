import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import point.{type Point}

pub type Grid =
  Dict(Point, Int)

pub fn lines_to_grid(lines: List(String)) -> Grid {
  lines
  |> list.index_fold(dict.new(), fn(acc, line, y) {
    line
    |> string.to_graphemes
    |> list.index_fold(acc, fn(acc, graphene, x) {
      case point.new(x, y) {
        Ok(point) -> dict.insert(acc, point, graphene_to_int(graphene))
        Error(Nil) -> panic as "Invalid point coordiates"
      }
    })
  })
}

pub fn graphene_to_int(graphene: String) -> Int {
  let assert Ok(int) =
    graphene
    |> string.to_utf_codepoints
    |> list.map(string.utf_codepoint_to_int)
    |> list.first()
  int
}

pub fn get_interest_points(grid: Grid) -> #(Grid, Point, Point) {
  let assert Ok(starting_point) =
    dict.to_list(grid)
    |> list.find(fn(value) { value.1 == graphene_to_int("S") })

  let assert Ok(destination_point) =
    dict.to_list(grid)
    |> list.find(fn(value) { value.1 == graphene_to_int("E") })

  #(
    grid
      |> dict.insert(starting_point.0, graphene_to_int("a"))
      |> dict.insert(destination_point.0, graphene_to_int("z")),
    starting_point.0,
    destination_point.0,
  )
}
