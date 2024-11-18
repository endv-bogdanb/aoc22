import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Point {
  Point(x: Int, y: Int)
}

pub fn line_to_points(line: List(String)) -> List(Point) {
  case line {
    [] -> []
    [head, ..line] -> {
      case head |> string.split(",") |> list.map(int.parse) |> result.values {
        [x, y] -> [Point(x, y), ..line_to_points(line)]
        _ -> panic as "Invalid value"
      }
    }
  }
}

pub fn points_to_interval(points: List(Point), acc: List(Point)) -> List(Point) {
  case points {
    [] | [_] -> acc
    [source, destination, ..points] ->
      points_to_interval(
        [destination, ..points],
        list.flatten([interval(destination, minus(source, destination)), acc]),
      )
  }
}

fn interval(destination: Point, diff: Point) -> List(Point) {
  case diff {
    Point(0, 0) -> [minus(diff, destination)]
    _ -> [minus(diff, destination), ..interval(destination, next(diff))]
  }
}

pub fn minus(source: Point, destination: Point) -> Point {
  Point(destination.x - source.x, destination.y - source.y)
}

pub fn next(point: Point) -> Point {
  case point {
    Point(0, 0) -> point
    Point(0, y) ->
      Point(0, case y < 0 {
        True -> y + 1
        False -> y - 1
      })

    Point(x, 0) ->
      Point(
        case x < 0 {
          True -> x + 1
          False -> x - 1
        },
        0,
      )
    Point(_, _) -> panic as "Invalid point"
  }
}
