import gleam/string

pub fn sequence(input: String, is_sequence: fn(String) -> Bool) -> Int {
  do_sequence(string.to_graphemes(input), is_sequence, "", 1)
}

fn do_sequence(
  input: List(String),
  is_sequence: fn(String) -> Bool,
  sequence: String,
  index: Int,
) -> Int {
  case input {
    [] -> {
      case is_sequence(sequence) {
        True -> index
        False -> -1
      }
    }
    [head, ..tail] -> {
      case string.contains(sequence, head) {
        True -> {
          do_sequence(
            tail,
            is_sequence,
            string.drop_left(sequence, up_to: index_of(sequence, head) + 1)
              <> head,
            index + 1,
          )
        }
        False -> {
          let sequence = sequence <> head
          case is_sequence(sequence) {
            True -> index
            False -> do_sequence(tail, is_sequence, sequence, index + 1)
          }
        }
      }
    }
  }
}

fn index_of(input: String, value: String) -> Int {
  do_index_of(string.to_graphemes(input), value, 0)
}

fn do_index_of(input: List(String), value: String, acc: Int) -> Int {
  case input {
    [] -> -1
    [head, ..tail] -> {
      case head == value {
        True -> acc
        False -> do_index_of(tail, value, acc + 1)
      }
    }
  }
}
