(call_expression
  (selector_expression
    operand: (_) @_operand (#match? @_operand "([dD][bB]([pP][oO][oO][lL])?([cC][oO][nN][nN]([eE][cC][tT][iI][oO][nN])?)?)|([sS][qQ][lL])")
    field: (field_identifier) @_field (#any-of? @_field "Exec" "Query" "QueryRow" "QueryContext" "QueryRowContext"))
  (argument_list
    (raw_string_literal) @injection.content (#set! injection.language "sql")))

(short_var_declaration
  left: (_) @_operand (#match? @_operand "(query)|(Query)")
  right: (_
    (raw_string_literal) @injection.content (#set! injection.language "sql")))

(assignment_statement
  left: (_) @_operand (#match? @_operand "(query)|(Query)")
  right: (_
    (raw_string_literal) @injection.content (#set! injection.language "sql")))

