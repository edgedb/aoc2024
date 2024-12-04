# https://adventofcode.com/2024/day/4, part 1

with
  lines_array := str_split(<str>$inp, '\n'),
  line_cnt := len(lines_array),
  line_len := len(lines_array[0]),
  line_len_iter := range_unpack(range(0, line_len)),

  lines := array_unpack(lines_array),

  diags := (
    for i in range_unpack(range(0, line_cnt - 3)) union
    [
      lines_array[i],
      lines_array[i+1][1:] ++ ' ',
      lines_array[i+2][2:] ++ '  ',
      lines_array[i+3][3:] ++ '   ',
    ] union [
      lines_array[i],
      ' ' ++ lines_array[i+1][:-1],
      '  ' ++ lines_array[i+2][:-2],
      '   ' ++ lines_array[i+3][:-3],
    ]
  ),

  to_transpose := {lines_array, diags},
  transposed := (
    for ttt in to_transpose union (
      with tt := array_unpack(ttt)
      for j in range_unpack(range(0, line_len)) union
      array_join(array_agg(tt[j]), '')
    )
  ),

  all_lines := lines union transposed,

select sum(
  count(re_match_all('XMAS', all_lines))
  + count(re_match_all('SAMX', all_lines))
);
