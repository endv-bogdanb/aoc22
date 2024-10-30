import gleam/result

pub type Gesture {
  Rock
  Paper
  Scissors
}

pub type Round {
  Round(player1: Gesture, player2: Gesture)
}

pub fn get_rounds(
  input lines: List(String),
  decode decode_round: fn(String) -> Result(Round, Nil),
) -> List(Round) {
  lines |> do_get_rounds(decode: decode_round) |> result.values
}

fn do_get_rounds(
  input lines: List(String),
  decode decode_round: fn(String) -> Result(Round, Nil),
) -> List(Result(Round, Nil)) {
  case lines {
    [] -> []
    [head, ..tail] -> {
      [decode_round(head), ..do_get_rounds(input: tail, decode: decode_round)]
    }
  }
}

pub fn decode_gesture(graphene: String) {
  case graphene {
    "A" | "X" -> Ok(Rock)
    "B" | "Y" -> Ok(Paper)
    "C" | "Z" -> Ok(Scissors)
    _ -> Error(Nil)
  }
}

fn gesture_score(gesture: Gesture) -> Int {
  case gesture {
    Rock -> 1
    Paper -> 2
    Scissors -> 3
  }
}

pub fn round_score(round: Round) -> Int {
  case round.player1, round.player2 {
    Rock, Paper | Paper, Scissors | Scissors, Rock ->
      6 + gesture_score(round.player2)
    Rock, Rock | Paper, Paper | Scissors, Scissors ->
      3 + gesture_score(round.player2)
    Paper, Rock | Scissors, Paper | Rock, Scissors ->
      0 + gesture_score(round.player2)
  }
}
