# https://adventofcode.com/2024/day/4, part 1

with
  # OK, easy stuff -- read the incoming challenge,
  # split the lines, save how many lines we have,
  # how long is the line.
  lines_array := str_split(<str>$inp, '\n'),
  line_cnt := len(lines_array),
  line_len := len(lines_array[0]),

  # Unpack an array of lines into a set of lines --
  # easier to work with sets than with arrays!
  lines := array_unpack(lines_array),

  # This is the interesting bit! We need to find
  # "XMAS" and "SAMX" letters spelled *diagonally*
  # in a matrix of letters, e.g.
  #
  #    a a a a a
  #    X a a a a
  #    a M a a a
  #    a a A a a
  #    a a a S a
  #    a a a a a
  #
  # (except the that incoming matrix is way way bigger)
  #
  # We can simplify our goal by shifting rows, so instead
  # of diagonal lookup we'll do a linear one. So out of the
  # above matrix we'll have 3:
  #
  #    a a a a a    X a a a a    a M a a a
  #    X a a a      M a a a      a A a a
  #    M a a        A a a        a S a
  #    A a          S a          a a
  #
  # Note that we only need to have 4-linex matrices here
  # because we're looking only for 4 letter words!
  # Now what...
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

  # And now the second trick, let's flip those matrices
  # their sides! So at the end of this step we'll have:
  #
  #    a            a            a
  #    a a          a a          a a
  #    a a a        a a a        a a a
  #    a a a a      a a a a      M A S a
  #    a X M A      X M A S      a a a a
  #
  # We're getting somewhere! Now let's just combine all
  # shifted and transposed matrices with the original
  # matrix also transposed (to search for *vertical* words).
  to_transpose := {lines_array, diags},
  transposed := (
    for ttt in to_transpose union (
      with tt := array_unpack(ttt)
      for j in range_unpack(range(0, line_len)) union
      array_join(array_agg(tt[j]), '')
    )
  ),

  # And finally add one more matrix to the mix -- the
  # original and unmodified one to parse *horizontal*
  # words.
  all_lines := lines union transposed,

# The finish line: just count how many times every line
# of every matrix we've prepared has the "XMAS" and "SAMX"
# words in them!
select sum(
  count(re_match_all('XMAS', all_lines))
  + count(re_match_all('SAMX', all_lines))
);
