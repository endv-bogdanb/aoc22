import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type Monkey {
  Monkey(
    id: Int,
    items: List(Int),
    operation: String,
    check: #(Int, Int, Int),
    inspected: Int,
  )
}

pub fn lines_to_monkeys(lines: List(String)) -> Dict(Int, Monkey) {
  lines
  |> list.chunk(fn(value) { value == "" })
  |> list.filter(fn(value) { list.length(value) > 1 })
  |> do_lines_to_monkeys([])
  |> list.fold(dict.new(), fn(acc, monkey) {
    dict.insert(acc, monkey.id, monkey)
  })
}

fn do_lines_to_monkeys(
  lines: List(List(String)),
  monkeys: List(Monkey),
) -> List(Monkey) {
  case lines {
    [] -> monkeys
    [line, ..lines] ->
      do_lines_to_monkeys(lines, [process_monkey(line), ..monkeys])
  }
}

fn process_monkey(line: List(String)) -> Monkey {
  let #(id, items, operation, check) =
    do_process_monkey(line, #(-1, [], "", #(0, -1, -1)))

  Monkey(id: id, items: items, operation: operation, check: check, inspected: 0)
}

fn do_process_monkey(
  line: List(String),
  acc: #(Int, List(Int), String, #(Int, Int, Int)),
) -> #(Int, List(Int), String, #(Int, Int, Int)) {
  case line {
    [] -> acc
    [head, ..line] -> {
      case head {
        "Monkey " <> id -> {
          let assert Ok(id) =
            int.parse(string.slice(id, 0, string.length(id) - 1))

          do_process_monkey(line, #(id, acc.1, acc.2, acc.3))
        }
        "Starting items: " <> items -> {
          let items =
            items
            |> string.trim
            |> string.split(", ")
            |> list.map(int.parse)
            |> result.values

          do_process_monkey(line, #(acc.0, items, acc.2, acc.3))
        }
        "Operation: new = " <> operation -> {
          do_process_monkey(line, #(acc.0, acc.1, operation, acc.3))
        }
        "Test: divisible by " <> value -> {
          let assert Ok(value) = int.parse(value)
          do_process_monkey(
            line,
            #(acc.0, acc.1, acc.2, #(value, acc.3.1, acc.3.2)),
          )
        }
        "If true: throw to monkey " <> value -> {
          let assert Ok(id) = int.parse(value)
          do_process_monkey(
            line,
            #(acc.0, acc.1, acc.2, #(acc.3.0, id, acc.3.2)),
          )
        }
        "If false: throw to monkey " <> value -> {
          let assert Ok(id) = int.parse(value)
          do_process_monkey(
            line,
            #(acc.0, acc.1, acc.2, #(acc.3.0, acc.3.1, id)),
          )
        }
        _ -> {
          io.debug(head)
          panic as "Invalid pattern"
        }
      }
    }
  }
}

pub fn rounds(
  monkeys: Dict(Int, Monkey),
  number_of_rounds: Int,
  calculate_worry: fn(Monkey, Int) -> Int,
) -> Dict(Int, Monkey) {
  case number_of_rounds {
    0 -> monkeys
    _ ->
      rounds(
        do_round(monkeys, 0, calculate_worry),
        number_of_rounds - 1,
        calculate_worry,
      )
  }
}

fn do_round(
  monkeys: Dict(Int, Monkey),
  id: Int,
  calculate_worry: fn(Monkey, Int) -> Int,
) -> Dict(Int, Monkey) {
  case id == dict.size(monkeys) {
    True -> monkeys
    False -> {
      let assert Ok(monkey) = dict.get(monkeys, id)
      do_round(
        inspect_items(
          monkeys,
          Monkey(
            ..monkey,
            inspected: monkey.inspected + list.length(monkey.items),
          ),
          calculate_worry,
        ),
        id + 1,
        calculate_worry,
      )
    }
  }
}

fn inspect_items(
  monkeys: Dict(Int, Monkey),
  monkey: Monkey,
  calculate_worry: fn(Monkey, Int) -> Int,
) -> Dict(Int, Monkey) {
  case monkey.items {
    [] -> dict.insert(monkeys, monkey.id, monkey)
    [item, ..items] -> {
      let worry = calculate_worry(monkey, item)
      let monkeys = case worry % monkey.check.0 == 0 {
        True -> {
          let assert Ok(monkey) = dict.get(monkeys, monkey.check.1)
          dict.insert(
            monkeys,
            monkey.id,
            Monkey(..monkey, items: list.flatten([monkey.items, [worry]])),
          )
        }
        False -> {
          let assert Ok(monkey) = dict.get(monkeys, monkey.check.2)
          dict.insert(
            monkeys,
            monkey.id,
            Monkey(..monkey, items: list.flatten([monkey.items, [worry]])),
          )
        }
      }

      inspect_items(monkeys, Monkey(..monkey, items: items), calculate_worry)
    }
  }
}

pub fn worry(monkey: Monkey, item: Int) -> Int {
  case monkey.operation {
    "old * old" -> item * item
    "old + old" -> item + item
    "old * " <> value -> {
      let assert Ok(value) = int.parse(value)
      item * value
    }
    "old + " <> value -> {
      let assert Ok(value) = int.parse(value)
      item + value
    }
    _ -> {
      io.debug(monkey.operation)
      panic as "Unhandled operation"
    }
  }
}
