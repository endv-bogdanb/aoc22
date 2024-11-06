import direction.{type Direction, Down, Left, Right, Up}
import gleam/int
import gleam/list

pub type Point {
  Point(x: Int, y: Int)
}

pub type Rope =
  List(Point)

pub fn follow(rope: Rope, directions: List(Direction)) -> List(Point) {
  do_follow(rope, directions, [Point(0, 0)])
}

fn do_follow(
  rope: Rope,
  directions: List(Direction),
  visited: List(Point),
) -> List(Point) {
  case directions {
    [] -> visited
    [direction, ..directions] -> {
      let #(rope, visited) = move(rope, direction, visited)
      do_follow(rope, directions, visited)
    }
  }
}

pub fn move(
  rope: Rope,
  direction: Direction,
  visited: List(Point),
) -> #(Rope, List(Point)) {
  let rope = move_head(rope, direction)
  let rope = adjust_body(rope)
  let visited = case list.first(list.drop(rope, list.length(rope) - 1)) {
    Ok(value) -> [value, ..visited]
    Error(Nil) -> panic
  }
  case direction {
    Up(0) | Down(0) | Left(0) | Right(0) -> #(rope, visited)
    Up(value) -> move(rope, Up(value - 1), visited)
    Down(value) -> move(rope, Down(value - 1), visited)
    Left(value) -> move(rope, Left(value - 1), visited)
    Right(value) -> move(rope, Right(value - 1), visited)
  }
}

fn move_head(rope: Rope, direction: Direction) -> Rope {
  case rope {
    [] -> panic
    [head, ..tail] ->
      case direction {
        Up(0) | Down(0) | Left(0) | Right(0) -> rope
        Up(_) -> [Point(..head, y: head.y + 1), ..tail]
        Down(_) -> [Point(..head, y: head.y - 1), ..tail]
        Left(_) -> [Point(..head, x: head.x - 1), ..tail]
        Right(_) -> [Point(..head, x: head.x + 1), ..tail]
      }
  }
}

fn adjust_body(rope: Rope) -> Rope {
  case rope {
    [] -> []
    [value] -> [value]
    [head, tail, ..rest] -> {
      case is_adjent(head, tail) {
        True -> [head, ..adjust_body([tail, ..rest])]
        False -> {
          let tail =
            Point(
              x: tail.x + int.clamp({ head.x - tail.x } * 1, -1, 1),
              y: tail.y + int.clamp({ head.y - tail.y } * 1, -1, 1),
            )
          [head, ..adjust_body([tail, ..rest])]
        }
      }
    }
  }
}

fn is_adjent(head: Point, tail: Point) -> Bool {
  int.absolute_value(tail.x - head.x) < 2
  && int.absolute_value(tail.y - head.y) < 2
}
