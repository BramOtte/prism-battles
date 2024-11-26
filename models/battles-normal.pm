dtmc

const int attack = 6;
const int defense = 6;

module Dice
    d1: [0..5] init 0;
    [first_assault] r=0
        ->1/6: (d1'=0)
        + 1/6: (d1'=1)
        + 1/6: (d1'=2)
        + 1/6: (d1'=3)
        + 1/6: (d1'=4)
        + 1/6: (d1'=5)
    ;
    [second_assault] r=1 & d1=5
        ->1/6: (d1'=0)
        + 1/6: (d1'=6)
        + 1/6: (d1'=7)
        + 1/6: (d1'=8)
        + 1/6: (d1'=9)
        + 1/6: (d1'=10)
    ;
    [second_assault] r=1 & d1=5 -> true;

    [second_assault] r=1 & d1!=5 -> true;
endmodule

module Dice2 = Dice [d1 = d2] endmodule
module Dice3 = Dice [d1 = d3] endmodule
module Dice4 = Dice [d1 = d4] endmodule




module Roll
    r: [0..7] init 0;
    d: [0..attack] init 0
    [first_assault] r=0 -> (r'=1) & (d'=0);

    [first_discard] r=1 & d < attack -> (d'=d+1);
    [first_discard] r=1 & d >= attack -> (d'=0) & (r'=2);

    [first_boost] r=2 & d < attack -> (d'=d+1);
    [first_boost] r=2 & d >= attack -> (d'=0) & (r'=3);


    [second_assault] r=3 -> (r'=4);

    [second_discard] r=4 & d < attack -> (d'=d+1);
    [second_discard] r=4 & d >= attack -> (d'=0) & (r'=5);

    [second_boost] r=5 & d < attack -> (d'=d+1);
    [second_boost] r=5 & d >= attack -> (d'=0) & (r'=6);


    [end] r=6 -> (r'=7);
    // [] r=2 -> (r'=2);

endmodule


rewards "wounds"
r=2 & d1>=defense: 1;
r=2 & d2>=defense: 1;
r=2 & d3>=defense: 1;
r=2 & d4>=defense: 1;


endrewards