import file_streams/file_stream.{type FileStream}
import gleam/string

pub fn get_fs() -> FileStream {
  let assert Ok(fs) = file_stream.open_read("input.txt")
  fs
}

pub fn read_lines(fs: FileStream) -> List(String) {
  case file_stream.read_line(fs) {
    Error(_) -> []
    Ok(line) -> {
      [string.trim(line), ..read_lines(fs)]
    }
  }
}
