;; Filename: contrived.wat
(module
  (func $add (param $p1 i32) (param $p2 i32) (result i32)
    (i32.add (local.get $p1) (local.get $p2))
  )
  (func $add2 (param $p1 i32) (result i32)

    local.get $p1
    ;; Push the constant 2 onto the stack
    i32.const 2

    ;; Call our old function
    call $add
  )
  (func $add3 (param $p1 i32) (result i32)
    local.get $p1

    ;; Push the constant 3 onto the stack
    i32.const 3

    ;; Call our old function
    call $add
  )
  (export "add2" (func $add2))
  (export "add3" (func $add3))
)
