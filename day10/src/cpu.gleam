import gleam/list
import instruction.{type Instruction}

pub fn process_instructions(instructions: List(Instruction)) -> List(Int) {
  do_process_instructions(1, instructions, []) |> list.reverse
}

fn do_process_instructions(
  register: Int,
  instructions: List(Instruction),
  acc: List(Int),
) -> List(Int) {
  case instructions {
    [] -> acc
    [instruction, ..instructions] -> {
      case instruction {
        instruction.Instruction(value, 1) ->
          do_process_instructions(register + value, instructions, [
            register,
            ..acc
          ])

        instruction.Instruction(value, cycle) -> {
          do_process_instructions(
            register,
            [instruction.Instruction(value, cycle - 1), ..instructions],
            [register, ..acc],
          )
        }
      }
    }
  }
}
