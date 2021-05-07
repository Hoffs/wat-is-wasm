(;
  Filename: add.wat
  This is a block comment.
;)
(module
  (func $add (param $p1 i32) (param $p2 i32) (result i32)

    ;; Push parameter $p1 onto the stack
    local.get $p1

    ;; Push parameter $p2 onto the stack
    local.get $p2

    ;; Pop two values off the stack and push their sum
    i32.add

    ;; The top of the stack is the return value
  )

  (func $add_folded (param $p1 i32) (param $p2 i32) (result i32)
    (i32.add (local.get $p1) (local.get $p2))
  )

  (export "add" (func $add))
  (export "add_folded" (func $add_folded))
)
