import gleam/dict
import gleam/list
import gleam/result
import gleam/set.{type Set}
import grid.{type Grid}
import point.{type Point}

pub fn path(init: #(Grid, Point, Point)) -> Int {
  do_path(init.0, init.2, [[init.1]], set.from_list([init.1]))
}

fn do_path(
  grid: Grid,
  destination: Point,
  solutions: List(List(Point)),
  visited: Set(Point),
) -> Int {
  case solutions {
    [] -> 0
    [solution, ..solutions] -> {
      case is_solution(solution, destination) {
        True -> { solution |> list.length } - 1
        False -> {
          let #(new_solutions, visited) =
            get_new_solutions(grid, solution, visited)
          case new_solutions {
            [] -> do_path(grid, destination, solutions, visited)
            _ ->
              do_path(
                grid,
                destination,
                list.flatten([solutions, new_solutions]),
                visited,
              )
          }
        }
      }
    }
  }
}

fn is_solution(solution: List(Point), destination: Point) -> Bool {
  case solution {
    [head, ..] -> head == destination
    _ -> panic as "It should not reach here"
  }
}

fn get_new_solutions(
  grid: Grid,
  solution: List(Point),
  visited: Set(Point),
) -> #(List(List(Point)), Set(Point)) {
  case solution {
    [] -> panic as "Should not be empty"
    [point, ..] ->
      [
        point.new(point.x - 1, point.y),
        point.new(point.x + 1, point.y),
        point.new(point.x, point.y - 1),
        point.new(point.x, point.y + 1),
      ]
      |> result.values
      |> list.filter(fn(value) {
        dict.has_key(grid, value) && !set.contains(visited, value)
      })
      |> list.map(fn(value) { [value, ..solution] })
      |> list.fold(#([], visited), fn(acc, solution) {
        case is_solution_valid(grid, solution) {
          False -> acc
          True -> {
            let assert Ok(point) = list.first(solution)
            #([solution, ..acc.0], set.insert(acc.1, point))
          }
        }
      })
  }
}

fn is_solution_valid(grid: Grid, solution: List(Point)) -> Bool {
  case solution {
    [p1, p2, ..] -> {
      let assert Ok(p1) = dict.get(grid, p1)
      let assert Ok(p2) = dict.get(grid, p2)
      p1 - p2 <= 1
    }
    _ -> panic as "Should never reach"
  }
}
