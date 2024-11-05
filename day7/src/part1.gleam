import file_system
import gleam/int
import gleam/io
import gleam/list
import virtual_file_system.{type VirtualFileSystem, Dir, File}

fn file_system_size(vfs: VirtualFileSystem) -> List(Int) {
  do_file_system_size(vfs, []).1
}

fn do_file_system_size(
  vfs: VirtualFileSystem,
  acc: List(Int),
) -> #(Int, List(Int)) {
  case vfs {
    File(_, _, size) -> #(size, acc)
    Dir(_, _, content) -> {
      let result =
        content
        |> list.fold(#(0, acc), fn(acc, vfs) {
          let result = do_file_system_size(vfs, acc.1)
          #(acc.0 + result.0, result.1)
        })
      case result.0 < 100_000 {
        True -> #(result.0, [result.0, ..result.1])
        False -> result
      }
    }
  }
}

pub fn run() {
  let fs = file_system.get_fs()
  let lines = file_system.read_lines(fs)

  lines
  |> virtual_file_system.fs_tree
  |> file_system_size
  |> int.sum
  |> io.debug
}
