pub type Point {
  Point(x: Int, y: Int)
}

pub fn new(x: Int, y: Int) -> Result(Point, Nil) {
  case x < 0 || y < 0 {
    True -> Error(Nil)
    False -> Ok(Point(x: x, y: y))
  }
}
