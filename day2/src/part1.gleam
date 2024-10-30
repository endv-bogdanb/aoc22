import file_system
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import round.{type Round}

fn decode_round(line: String) -> Result(Round, Nil) {
  case line |> string.trim |> string.split(" ") {
    [a, b] -> {
      case round.decode_gesture(a), round.decode_gesture(b) {
        Ok(a), Ok(b) -> Ok(round.Round(a, b))
        _, _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

pub fn run() {
  let lines = file_system.get_fs() |> file_system.read_lines()

  lines
  |> round.get_rounds(decode: decode_round)
  |> list.map(round.round_score)
  |> int.sum
  |> io.debug
}
