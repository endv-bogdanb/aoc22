import file_system
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import rucksack.{type Rucksack}

fn decode_rucksack(input line: List(String)) -> Rucksack {
  rucksack.Rucksack(compartments: list.map(line, string.to_graphemes))
}

pub fn run() {
  let lines = file_system.get_fs() |> file_system.read_lines()

  lines
  |> list.sized_chunk(3)
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
