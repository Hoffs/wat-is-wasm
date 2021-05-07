;; Filename: funcimport.wat
(module

  ;; A function with no parameters and no return value.
  (type $log (func (param) (result)))

  ;; Expect a function called `log` on the `funcs` module
  (import "funcs" "log" (func $log))

  ;; Our function with no parameters and no return value.
  (func $doLog (param) (result)

    ;; Call the imported function
    call $log
  )
  (export "doLog" (func $doLog))
)
