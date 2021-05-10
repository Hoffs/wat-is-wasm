(module
  ;; Import function to push address marks, push one at start
  ;; and push second at the end, then once 2 addresses are pushed
  ;; slice between those (inclusive) is the "result" of the iteration.
  (import "funcs" "markAddress" (func $markaddr (param i32)))

  ;; Create memory with a size of 1 page (= 64KiB)
  ;; that is growable to up to 100 pages.
  (memory $mem 1 100)

  ;; Export that memory
  (export "memory" (memory $mem))

  ;; FizzBuzz
  (global $flagaddr (mut i32) (i32.const 0))

  ;; Adds flag to input number
  (func $addflagaddr (param $in i32) (result i32)
    local.get $in
    global.get $flagaddr
    i32.or
  )

  ;; Input is:
  ;; - i32 for memory location of fizz
  ;; - i32 for memory location of buzz
  ;; - i32 for memory location of output
  ;; - i32 for number until which to run fizzbuzz
  (func $fizzbuzz
    (param $fizzloc i32)
    (param $buzzloc i32)
    (param $outloc i32)
    (param $range i32) (result)

    (local $iter i32)
    (local $temp i32)

    ;; because this isnt actually constant expr, make it mutable global and populate it
    ;; flag for whether i32 is a address
    (global.set $flagaddr (i32.shl (i32.const 1) (i32.const 31)))

    ;; block surrounds loop because we need a place to jump to,
    ;; if we jump to 0 - loop, we end up at the start of the loop
    ;; again. So block just provides a place to jump to outside the
    ;; loop.
    (local.set $iter (i32.const 1))
    (block
      (loop
      ;; break if iter > range
      (br_if 1 (i32.gt_u (local.get $iter) (local.get $range)))

      (call $markaddr (local.get $outloc))

      ;; x % 3 => fizz, x % 5 => buzz
      (i32.rem_u (local.get $iter) (i32.const 3))
      i32.eqz

      ;; result of x % 5 shifted left by one
      (i32.rem_u (local.get $iter) (i32.const 5))
      i32.eqz
      i32.const 1
      i32.shl

      ;; remainder of 3 and 5, 0b...[x % 5 == 0][x % 3 == 0]
      i32.or

      ;; store result in temp
      local.tee $temp

      ;; if 0, neither fizz or buzz
      i32.eqz
      (if
        (then
          ;; put number at outloc and incremenet by 4
          local.get $outloc
          local.get $iter
          i32.store

          (local.set $outloc (i32.add (local.get $outloc) (i32.const 4)))
        )
      )

      ;; 0b0..X[0/1] & 0b0..01 => 0b0..0[0/1]
      ;; if bit 0 is 1, then fizz
      (i32.and (i32.const 1) (local.get $temp))
      (if
        (then
          ;; put fizz address at output location and increment out location by 4 bytes
          local.get $outloc
          local.get $fizzloc
          call $addflagaddr
          i32.store

          (local.set $outloc (i32.add (local.get $outloc) (i32.const 4)))
        )
      )

      ;; shift right by 1 to get result of [x % 5], if => 1, buzz
      (i32.shr_u (local.get $temp) (i32.const 1))
      (if
        (then
          ;; put buzz address at output location and increment out location by 4 bytes
          local.get $outloc
          local.get $buzzloc
          call $addflagaddr
          i32.store

          (local.set $outloc (i32.add (local.get $outloc) (i32.const 4)))
        )
      )

      (call $markaddr (local.get $outloc))

      ;; store flag marking the end of the iteration
      local.get $outloc
      (i32.shl (i32.const 1) (i32.const 30))
      i32.store
      (local.set $outloc (i32.add (local.get $outloc) (i32.const 4)))

      ;; increment iterator
      (local.set $iter (i32.add (local.get $iter) (i32.const 1)))

      ;; jump back to start of loop
      br 0
      )
    )

    ;; store -1 marking end of output
    (i32.add (local.get $outloc) (i32.const 4))
    i32.const -1
    i32.store
  )
  (export "fizzbuzz" (func $fizzbuzz))
)
