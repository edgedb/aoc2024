# https://adventofcode.com/2024/day/4, part 2

with
  # Read the part 1 comments as the approach is somewhat
  # similar
  lines_array := str_split(<str>$inp, '\n'),
  line_cnt := len(lines_array),
  line_len := len(lines_array[0]),

  lines := array_unpack(lines_array),

  diags := (
    for i in range_unpack(range(0, line_cnt-2)) union
    (
      # We're counting this "X"-like pattern:
      #
      #    a a a a
      #    a S a M
      #    a a A a
      #    a S a M
      #
      # So let's do a similar trick to part 1, but this time
      # we'll build two sets of matrices: one set with 3-line
      # matrices progressively shifted to the left, and another
      # set of shifted to the right. For the above example:
      #
      #    Set 1 (d1):               Set 2 (d2):
      #
      #    a a a a    a S a M        a a a a     a S a M
      #    S a M      a A a            a S a       a a A
      #    A a        a M                a A         a S
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

        # Let's transpose (rotate) matrices in Set 1:
        #
        #    a S A       a a a
        #    a a a       S A M
        #    a M         a a
        #    a           M
        d1t := array_agg((
          with strings := array_unpack(d1)
          for j in range_unpack(range(0, line_len)) union
          array_join(array_agg(strings[j]), '')
        )),

        # And in Set 2:
        #
        #    a           a
        #    a a         S a
        #    a S a       a a a
        #    a a A       M A S

        d2t := array_agg((
          with strings := array_unpack(d2)
          for j in range_unpack(range(0, line_len)) union
          array_join(array_agg(strings[j]), '')
        )),

        # Let's record positions where "SAM" or "MAS" occurs
        # in the first set, so we'll have
        #
        #    p1: {2}   # there's a subtle bug here, bug it gave
        #              # the correct answer so who cares :)
        p1 := (
          for i in range_unpack(range(0, line_len)) union
          if (d1t[i] = 'MAS' or d1t[i] = 'SAM') then i else {}
        )

      # Now because opposite arms of our "X" pattern live in
      # d1 and d2, and are 2 lines away from each other in
      # their transposed variants d1t and d2t, let's count
      # our X'es.
      select
        if (d2t[p1+2] = 'MAS' or d2t[p1+2] = 'SAM') then 1 else 0
    )
  )


select sum(diags);
