import file_system
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import rucksack.{type Rucksack}

fn decode_rucksack(input line: String) -> Rucksack {
  let middle = string.length(line) / 2
  let graphenes = string.to_graphemes(line)
  rucksack.Rucksack([
    list.take(graphenes, up_to: middle),
    list.drop(graphenes, up_to: middle),
  ])
}

pub fn run() {
  let lines = file_system.get_fs() |> file_system.read_lines()

  lines
  |> list.flat_map(fn(value) {
    value
    |> decode_rucksack
    |> rucksack.common_items
    |> list.map(rucksack.item_to_int)
    |> result.values
  })
  |> int.sum
  |> io.debug
}
