(module
  ;; Import function to push address marks, push one at start
  ;; and push second at the end, then once 2 addresses are pushed
  ;; slice between those is the "result" of the iteration.
  (import "funcs" "markAddress" (func $markaddr (param i32)))

  ;; Create memory with a size of 1 page (= 64KiB)
  ;; that is growable to up to 100 pages.
  (memory $mem 1 100)

  ;; allows to cheat a bit and prefill memory with string data
  (data (i32.const 0) "fizz")
  (data (i32.const 4) "buzz")

  ;; Export that memory
  (export "memory" (memory $mem))


  ;; Input is:
  ;; - i32 for number until which to run fizzbuzz
  (func $fizzbuzz
    (param $range i32) (result)

    (local $outloc i32)
    (local $iter i32)
    (local $temp i32)

    ;; block surrounds loop because we need a place to jump to,
    ;; if we jump to 0 - loop, we end up at the start of the loop
    ;; again. So block just provides a place to jump to outside the
    ;; loop.
    (local.set $outloc (i32.const 16))
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
          ;; put number at outloc and increment by 1, limited to 1 byte
          local.get $outloc
          local.get $iter
          i32.store8

          (local.set $outloc (i32.add (local.get $outloc) (i32.const 1)))
        )
      )

      ;; 0b0..X[0/1] & 0b0..01 => 0b0..0[0/1]
      ;; if bit 0 is 1, then fizz
      (i32.and (i32.const 1) (local.get $temp))
      (if
        (then
          ;; copy memory range of "fizz" from 0, length 4 to $outloc
          local.get $outloc
          i32.const 0
          i32.const 4
          memory.copy

          (local.set $outloc (i32.add (local.get $outloc) (i32.const 4)))
        )
      )

      ;; shift right by 1 to get result of [x % 5], if => 1, buzz
      (i32.shr_u (local.get $temp) (i32.const 1))
      (if
        (then
          ;; copy memory range of "buzz" from 4, length 4 to $outloc
          local.get $outloc
          i32.const 4
          i32.const 4
          memory.copy

          (local.set $outloc (i32.add (local.get $outloc) (i32.const 4)))
        )
      )

      (call $markaddr (local.get $outloc))

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
