# https://adventofcode.com/2024/day/4, part 2

with
  lines_array := str_split(<str>$inp, '\n'),
  line_cnt := len(lines_array),
  line_len := len(lines_array[0]),

  lines := array_unpack(lines_array),

  diags := (
    for i in range_unpack(range(0, line_cnt-2)) union
    (
      with
        d1 := [
          lines_array[i],
          lines_array[i+1][1:] ++ ' ',
          lines_array[i+2][2:] ++ '  ',
        ],

        d2 := [
          lines_array[i],
          ' ' ++ lines_array[i+1][:-1],
          '  ' ++ lines_array[i+2][:-2],
        ],

        d1t := array_agg((
          with strings := array_unpack(d1)
          for j in range_unpack(range(0, line_len)) union
          array_join(array_agg(strings[j]), '')
        )),

        d2t := array_agg((
          with strings := array_unpack(d2)
          for j in range_unpack(range(0, line_len)) union
          array_join(array_agg(strings[j]), '')
        )),

        p1 := (
          for i in range_unpack(range(0, line_len)) union
          if (d1t[i] = 'MAS' or d1t[i] = 'SAM') then i else {}
        )

      select
        if (d2t[p1+2] = 'MAS' or d2t[p1+2] = 'SAM') then 1 else 0
    )
  )


select sum(diags);
