; Full replacement for the swift locals query bundled with the grammar (a file
; here, rather than under after/, takes runtimepath precedence and overrides it;
; after/ can only append, via "; extends").
;
; Two problems with the bundled query, both of which break anything that reads
; locals -- nvim-dap-virtual-text in particular:
;
;   1. It captures no value bindings at all, only imports and function names,
;      so no Swift variable is ever recognised.
;   2. It lists (property_declaration) as @local.scope. A declaration is not a
;      scope containing itself, and consumers that check "is this definition's
;      scope the one we're stopped in" therefore discard every let/var unless
;      the cursor is on the declaration line itself.
;
; Keep the rest in sync if the grammar's copy gains anything new.

(import_declaration
  (identifier) @local.definition.import)

(function_declaration
  name: (simple_identifier) @local.definition.function)

; let x = ..., var x = ..., and `for x in ...`
(pattern
  bound_identifier: (simple_identifier) @local.definition.var)

; tuple destructuring: let (a, b) = ... -- the inner patterns carry no
; bound_identifier field, so match them structurally instead
(pattern
  (pattern
    (simple_identifier) @local.definition.var))

; if let x = ..., guard let x = ...
(if_statement
  bound_identifier: (simple_identifier) @local.definition.var)

(guard_statement
  bound_identifier: (simple_identifier) @local.definition.var)

; Function parameters. `name` is the internal name (the `n` of `count n: Int`),
; which is what lldb reports; the external label is deliberately not captured.
(parameter
  name: (simple_identifier) @local.definition.parameter)

; Closure parameters: { element in ... }
(lambda_parameter
  name: (simple_identifier) @local.definition.parameter)

; Scopes -- as bundled, minus (property_declaration); see note above.
[
  (statements)
  (for_statement)
  (while_statement)
  (repeat_while_statement)
  (do_statement)
  (if_statement)
  (guard_statement)
  (switch_statement)
  (function_declaration)
  (class_declaration)
  (protocol_declaration)
] @local.scope
