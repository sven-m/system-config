; extends

; The bundled query marks the "init" keyword itself as @indent.branch,
; which wrongly dedents init's own declaration line (only affects `=`
; reindenting; @indent.begin here cancels it out for that one line while
; leaving the real ancestor-based indent, e.g. from struct_body, intact).
(init_declaration
  "init" @indent.begin
  (#set! indent.immediate)
  (#set! indent.start_at_same_line))
