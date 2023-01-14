class MyTest;
  typedef enum logic {front, back} face_t;

  logic [1:0]  dat1;
  logic [1:0]  dat2;
  rand face_t face;

  covergroup cg;
    option.per_instance = 1;

    bin1: coverpoint dat1 {
      bins s = {[0:1]};
      bins l = {[2:3]};
    }

    bin2: coverpoint dat2 {
      bins s = {[0:1]};
      bins l = {[2:3]};
    }

    bins_cnd1: coverpoint dat1 iff (face == front);

    bins_cnd2: coverpoint dat1 {
      bins zero = {0} iff (face == front);
      bins int_num[] = {[1:$]};
    }

    all_dats: cross dat1, dat2;                 // All combinations of dat1 x dat2, that is 16 combinations.

    all_bins: cross bin1, bin2;                 // All combinations of bin1 x bin2, that is 4 combinations.

    dat_bin: cross dat1, bin2;                  // Combination of variable x bin

    useOfBinsof: cross bin1, bin2 {
      bins bin1_is_s = binsof(bin1.s);                                         // <s, s>, <s.l>
      bins bin_s_and_s = binsof(bin1.s) && binsof(bin2.s);                     // <s, s>
      bins bin_s_or_s  = binsof(bin1.s) || binsof(bin2.s);                     // <s, s>, <s, l>, <l, s>
      bins bin_not_l   = !binsof(bin1.l);                                      // <s, s>, <s, l>
      bins bin_paren   = (binsof(bin1.s) || binsof(bin2.s)) && binsof(bin2.l); // <s, l>
      // Bins for the combinations that are not specified will be generated automatically.
      // <l, l>
    }

    cbins_v: cross dat1, dat2 {
      bins bin1_0 = binsof(dat1) intersect {[0:2]}; // A bin covers all combinations below:
                                                    // <0, 0>, <0, 1>, <0, 2>, <0, 3>
                                                    // <1, 0>, <1, 1>, <1, 2>, <1, 3>
                                                    // <2, 0>, <2, 1>, <2, 2>, <2, 3>
    // Bins will be automatically created for the combinations below
    // <3, 0>, <3, 1>, <3, 2>, <3, 3>
    }

    cbins_b_0: cross bin1, bin2 {
      bins bin0 = binsof(bin1) intersect {0}; // Equivalent to binsof(bin1.s)
                                              // <s, s>, <s, l>
      // <l, s>, <l, l>
    }

    cbins_b_1: cross bin1, bin2 {
      bins bin0 = binsof(bin1) intersect {[0:1]}; // Equivalent to binsof(bin1.s)
                                                  // <s, s>, <s, l>
      // <l, s>, <l, l>
    }

    cbins_b_2: cross bin1, bin2 {
      bins bin0 = binsof(bin1) intersect {[0:2]}; // Equivalent to binsof(bin1.s) || binsof(bin1.l)
                                                  // <s, s>, <s, l>, <l, s>, <l, l>
      // No auto bin
    }

    useOfIgn: cross dat1, dat2 {
      ignore_bins ign = binsof (dat1) intersect {[0:2]} ||   //<0, 0>, <0, 1>, <0, 2>, <0, 3>,
                        binsof (dat2) intersect {[0:1]};     //<1, 0>, <1, 1>, <1, 2>, <1, 3>,
                                                             //<2, 0>, <2, 1>, <2, 2>, <2, 3>,
                                                             //<3, 0>, <3, 1>
      // Automatically Created cross bins
      // <3, 2>, <3, 3>
    }

    cond1: cross bin1, bin2 iff (face == front); // Collect coverage only when face == front

    cond2: cross bin1, bin2 {
      bins bin1s = binsof(bin1.s) iff (face == front); // Collect coverage only when face == front
      // Other bins are always collected
    }

    cond3: cross bins_cnd1, dat2; //bins_cnd1 has iff

    cond4: cross bins_cnd2, dat2; //bins_cnd2 has a bin with iff
  endgroup

  function new();
    cg = new;
  endfunction

  function void run();
    for (int i = 0; i < 2**$size(dat1); i++) begin
      for (int j = 0; j < 2**$size(dat2); j++) begin
        for (int k = 0; k < 2**$size(face); k++) begin
          dat1 = i;
          dat2 = j;
          face = face_t'(k);
          cg.sample();
        end
      end
    end
  endfunction
endclass

program top;
  initial begin
    MyTest myTest;

    myTest = new;
    myTest.run();
  end
endprogram