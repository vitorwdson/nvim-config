(call_expression
  (selector_expression
    operand: (_) @_operand (#match? @_operand "([dD][bB]([pP][oO][oO][lL])?([cC][oO][nN][nN]([eE][cC][tT][iI][oO][nN])?)?)|([sS][qQ][lL])")
    field: (field_identifier) @_field (#any-of? @_field "Exec" "Query" "QueryRow" "QueryContext" "QueryRowContext"))
  (argument_list
    (raw_string_literal) @sql (#offset! @sql 0 1 0 -1))
)
