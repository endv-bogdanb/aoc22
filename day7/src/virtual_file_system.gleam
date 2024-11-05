import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type VirtualFileSystem {
  File(id: String, label: String, size: Int)
  Dir(id: String, label: String, content: List(VirtualFileSystem))
}

pub fn replace(
  tree: VirtualFileSystem,
  node: VirtualFileSystem,
) -> VirtualFileSystem {
  case tree, node {
    File(..), File(..) ->
      case tree.id == node.id {
        True -> node
        False -> tree
      }
    Dir(id, label, content), File(..) ->
      Dir(
        id: id,
        label: label,
        content: list.map(content, fn(vfs) { replace(vfs, node) }),
      )
    Dir(id, label, content), Dir(node_id, _, node_content) ->
      case id == node_id {
        True -> Dir(id: id, label: label, content: node_content)
        False ->
          Dir(
            id: id,
            label: label,
            content: list.map(content, fn(vfs) { replace(vfs, node) }),
          )
      }
    File(..), Dir(..) -> tree
  }
}

pub fn get_parent(tree, node) -> VirtualFileSystem {
  case do_get_parent(tree, node) {
    Ok(value) -> value
    Error(Nil) -> panic
  }
}

pub fn do_get_parent(
  tree: VirtualFileSystem,
  node: VirtualFileSystem,
) -> Result(VirtualFileSystem, Nil) {
  case tree, node {
    File(..), File(..) | File(..), Dir(..) | Dir(..), File(..) -> Error(Nil)
    Dir(left_id, left_label, left_content), Dir(right_id, right_label, _) ->
      case
        left_content
        |> list.find(fn(vfs) {
          case vfs {
            File(..) -> False
            Dir(dir_id, dir_label, _) ->
              dir_id == right_id && dir_label == right_label
          }
        })
      {
        Ok(_) -> Ok(Dir(left_id, left_label, left_content))
        Error(Nil) ->
          left_content
          |> list.map(fn(vfs) { do_get_parent(vfs, node) })
          |> result.values
          |> list.first
      }
  }
}

pub fn fs_tree(lines: List(String)) -> VirtualFileSystem {
  let root = Dir(id: "/", label: "/", content: [])
  do_fs_tree(lines, root, root)
}

fn do_fs_tree(
  lines: List(String),
  tree: VirtualFileSystem,
  ctx: VirtualFileSystem,
) -> VirtualFileSystem {
  case lines {
    [] -> tree
    [head, ..tail] -> {
      case head {
        "$ cd /" -> do_fs_tree(tail, tree, ctx)
        "$ ls" -> do_fs_tree(tail, tree, ctx)
        "$ cd .." -> do_fs_tree(tail, tree, get_parent(tree, ctx))
        "$ cd " <> dir_name -> {
          let ctx = case ctx {
            File(..) -> panic
            Dir(_, _, content) ->
              list.find(content, fn(vfs) {
                case vfs {
                  File(..) -> False
                  Dir(_, label, _) -> label == dir_name
                }
              })
          }
          do_fs_tree(tail, tree, case ctx {
            Ok(value) -> value
            Error(Nil) -> panic
          })
        }
        "dir " <> dir_name -> {
          let ctx = case ctx {
            File(..) -> panic
            Dir(id, label, content) -> {
              let content = [
                Dir(id: id <> "/" <> dir_name, label: dir_name, content: []),
                ..content
              ]
              Dir(id: id, label: label, content: content)
            }
          }
          do_fs_tree(tail, replace(tree, ctx), ctx)
        }
        file -> {
          case string.split(file, " ") {
            [size, file_name] -> {
              let size = case int.parse(size) {
                Ok(value) -> value
                Error(Nil) -> panic
              }
              let ctx = case ctx {
                File(..) -> panic
                Dir(id, label, content) -> {
                  let content = [
                    File(
                      id: id <> "/" <> file_name,
                      label: file_name,
                      size: size,
                    ),
                    ..content
                  ]
                  Dir(id: id, label: label, content: content)
                }
              }
              do_fs_tree(tail, replace(tree, ctx), ctx)
            }
            _ -> panic
          }
        }
      }
    }
  }
}
