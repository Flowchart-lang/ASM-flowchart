; Assembly-style pseudo-code version of the Python flowchart interpreter.
; Renamed as ASM-flowchart

SECTION .data
    variables:       ; Dictionary to hold variables
    program_lines:   ; List of program lines
    current_line_index: 0
    loop_stack:      ; Stack for loop start indexes
    execution_stack: ; Stack for condition execution flags
    commands_table:  ; Dictionary of built-in commands

SECTION .text

START:
    ; Entry point: Parse CLI arguments
    CMP argc, 3
    JL usage_error
    CMP argv[1], "-r"
    JE set_run_mode
    CMP argv[1], "-s"
    JE set_step_mode
    JMP usage_error

set_run_mode:
    MOV step_by_step, 0
    JMP load_file

set_step_mode:
    MOV step_by_step, 1
    JMP load_file

usage_error:
    PRINT "Usage: ASM-flowchart -r <file.fcl> or ASM-flowchart -s <file.fcl>"
    EXIT 1

; -------------------
; Load Program File
; -------------------
load_file:
    CALL file_exists, argv[2]
    CMP eax, 0
    JE file_not_found
    CALL read_file_lines, argv[2]
    FILTER remove_comments_and_empty
    CMP first_line, "START"
    JNE error_start_missing
    CMP last_line, "END"
    JNE error_end_missing
    JMP execute_program

file_not_found:
    PRINT "Error: File not found"
    EXIT 1

error_start_missing:
    PRINT "Error: Program must begin with START"
    EXIT 1

error_end_missing:
    PRINT "Error: Program must end with END"
    EXIT 1

; -------------------
; Execution Loop
; -------------------
execute_program:
    PUSH execution_stack, 1  ; True initially
    MOV current_line_index, 0

exec_loop:
    CMP current_line_index, program_lines.length
    JGE program_done

    MOV line, program_lines[current_line_index]
    SPLIT line INTO command, args

    CMP step_by_step, 1
    JNE skip_step_pause
    PRINT "[STEP] ", current_line_index+1, ": ", line
    CALL wait_for_enter
skip_step_pause:

    CMP TOP(execution_stack), 1
    JE exec_command
    CALL handle_skipped_line, command
    JMP next_line

exec_command:
    LOOKUP commands_table, command
    JZ unknown_command
    CALL command_func, args
    JMP next_line

unknown_command:
    PRINT "Error: Unknown command"
    EXIT 1

next_line:
    INC current_line_index
    JMP exec_loop

program_done:
    EXIT 0

; -------------------
; Command Implementations
; -------------------
command_START:
    RET

command_END:
    PRINT "[SYSTEM] Program finished."
    MOV current_line_index, program_lines.length
    RET

command_PRINT:
    PARSE args INTO parts (split by '+', ignoring strings)
    RESOLVE all parts to values
    PRINT concatenated result
    RET

command_SET:
    SPLIT args at '=' INTO var_name, value_expr
    RESOLVE value_expr to value
    STORE variables[var_name], value
    RET

command_INPUT:
    GET user_input
    STORE variables[args], user_input
    RET

command_INCREMENT:
    LOAD var_name from args
    ADD variables[var_name], 1
    RET

command_IF:
    EVAL condition(args) INTO condition_met
    PUSH execution_stack, condition_met
    CMP condition_met, 0
    JE jump_to_ENDIF
    RET

command_ELSE:
    POP execution_stack
    PUSH execution_stack, 0
    CALL jump_to_ENDIF
    RET

command_ENDIF:
    POP execution_stack
    RET

command_WHILE:
    EVAL condition(args) INTO condition_met
    CMP condition_met, 1
    JE store_loop_start
    CALL jump_to_ENDWHILE
    RET
store_loop_start:
    PUSH loop_stack, current_line_index
    RET

command_ENDWHILE:
    POP loop_start FROM loop_stack
    MOV current_line_index, loop_start-1
    RET

command_IMPORT:
    RET  ; No runtime effect

; -------------------
; End of ASM-flowchart
; -------------------
