import file_system
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import round.{type Gesture, type Round, Paper, Rock, Scissors}

fn get_winning_gesture(gesture: Gesture) -> Gesture {
  case gesture {
    Rock -> Scissors
    Paper -> Rock
    Scissors -> Paper
  }
}

fn get_losing_gesture(gesture: Gesture) -> Gesture {
  case gesture {
    Rock -> Paper
    Paper -> Scissors
    Scissors -> Rock
  }
}

fn decode_round(line: String) -> Result(Round, Nil) {
  case line |> string.trim |> string.split(" ") {
    [a, b] -> {
      case round.decode_gesture(a) {
        Ok(left) -> {
          case b {
            "X" -> Ok(round.Round(left, get_winning_gesture(left)))
            "Y" -> Ok(round.Round(left, left))
            "Z" -> Ok(round.Round(left, get_losing_gesture(left)))
            _ -> Error(Nil)
          }
        }
        Error(Nil) -> Error(Nil)
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
