import file_streams/file_stream.{type FileStream}
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/regex
import gleam/string
import instruction.{type Instruction}

pub type Crane =
  Dict(Int, List(String))

pub type CraneType {
  M9000
  M9001
}

pub fn read_crane(fs: FileStream) -> Crane {
  do_read_crane(fs, [])
  |> list.fold(dict.new(), fn(acc: dict.Dict(Int, List(String)), value) {
    case dict.size(acc) {
      0 ->
        case regex.from_string("[0-9]") {
          Error(_) -> acc
          Ok(re) ->
            re
            |> regex.scan(content: value)
            |> list.map(fn(value) {
              case int.parse(value.content) {
                Ok(value) -> #(value, [])
                Error(Nil) -> #(0, [])
              }
            })
            |> dict.from_list
        }
      _ ->
        read_crane_stack(value)
        |> list.fold(acc, fn(acc, value) {
          case dict.get(acc, value.0) {
            Error(Nil) -> acc
            Ok(lst) -> dict.insert(acc, value.0, [value.1, ..lst])
          }
        })
    }
  })
}

fn do_read_crane(fs: FileStream, acc: List(String)) -> List(String) {
  case file_stream.read_line(fs) {
    Error(_) -> acc
    Ok(line) -> {
      case string.trim(line) {
        "" -> acc
        _ -> do_read_crane(fs, [line, ..acc])
      }
    }
  }
}

fn read_crane_stack(line: String) -> List(#(Int, String)) {
  do_read_crane_stack(string.to_graphemes(line), [], 1)
}

fn do_read_crane_stack(
  graphenes: List(String),
  acc: List(#(Int, String)),
  index: Int,
) -> List(#(Int, String)) {
  case graphenes {
    [] -> acc
    _ -> {
      let head = list.take(graphenes, up_to: 3)
      let tail = list.drop(graphenes, up_to: 4)
      case head {
        ["[", value, "]"] -> {
          do_read_crane_stack(tail, [#(index, value), ..acc], index + 1)
        }
        _ -> do_read_crane_stack(tail, acc, index + 1)
      }
    }
  }
}

pub fn move(
  crane: Crane,
  instruction: Instruction,
  crane_type: CraneType,
) -> Crane {
  case dict.get(crane, instruction.from), dict.get(crane, instruction.to) {
    Ok(from), Ok(to) -> {
      let head = list.take(from, instruction.quantity)
      let crane =
        dict.insert(
          crane,
          instruction.from,
          list.drop(from, instruction.quantity),
        )

      dict.insert(
        crane,
        instruction.to,
        list.concat(case crane_type {
          M9000 -> [list.reverse(head), to]
          M9001 -> [head, to]
        }),
      )
    }
    _, _ -> crane
  }
}
