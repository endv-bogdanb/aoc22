import file_system
import gleam/io
import gleam/list
import virtual_file_system.{type VirtualFileSystem, Dir, File}

const remove_at_least = 6_728_267

fn file_system_size(vfs: VirtualFileSystem) -> Int {
  do_file_system_size(vfs, 70_000_000).1
}

fn do_file_system_size(vfs: VirtualFileSystem, acc: Int) -> #(Int, Int) {
  case vfs {
    File(_, _, size) -> #(size, acc)
    Dir(_, _, content) -> {
      let result =
        content
        |> list.fold(#(0, acc), fn(acc, vfs) {
          let result = do_file_system_size(vfs, acc.1)
          #(acc.0 + result.0, result.1)
        })
      case result.0 >= remove_at_least && result.0 < result.1 {
        True -> #(result.0, result.0)
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
  |> io.debug
}
