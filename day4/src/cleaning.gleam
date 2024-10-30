import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Section {
  Section(start: Int, end: Int)
}

pub type Pair {
  Pair(sections: List(Section))
}

pub fn decode_pair(line: String) {
  Pair(
    sections: line
    |> string.split(",")
    |> list.map(fn(value) {
      case value |> string.split("-") |> list.map(string.trim) {
        [start, end] -> {
          case int.parse(start), int.parse(end) {
            Ok(start), Ok(end) -> Ok(Section(start, end))
            _, _ -> Error(Nil)
          }
        }
        _ -> Error(Nil)
      }
    })
    |> result.values,
  )
}

pub fn are_sections_contained(sections: List(Section)) -> Bool {
  case sections {
    [s1, s2] -> {
      is_section_contained(s1, s2) || is_section_contained(s2, s1)
    }
    _ -> False
  }
}

fn is_section_contained(s1: Section, s2: Section) -> Bool {
  s1.start <= s2.start && s2.end <= s1.end
}

pub fn do_sections_overlap(sections: List(Section)) -> Bool {
  case sections {
    [s1, s2] -> {
      is_section_overlap(s1, s2) || is_section_overlap(s2, s1)
    }
    _ -> False
  }
}

fn is_section_overlap(s1: Section, s2: Section) -> Bool {
  s1.start <= s2.start
  && s2.start <= s1.end
  || s1.start <= s2.end
  && s2.end <= s1.end
}
