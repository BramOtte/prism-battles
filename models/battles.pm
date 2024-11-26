dtmc

const int max_attack = 10;
const int attack = 6;
const int defense = 4;

module Dice
// attack: [0..max_attack] init 6;

d0: [0..max_attack] init 0;
d1: [0..max_attack] init 0;
d2: [0..max_attack] init 0;
d3: [0..max_attack] init 0;
d4: [0..max_attack] init 0;
d5: [0..max_attack] init 0;
wounds: [0..max_attack] init 0;

[first_assault] r=0
        ->1/6: (d0'=d0+1)
        + 1/6: (d1'=d1+1)
        + 1/6: (d2'=d2+1)
        + 1/6: (d3'=d3+1)
        + 1/6: (d4'=d4+1)
        + 1/6: (d5'=d5+1)
    ;

[count] r=1 -> (wounds' = wounds
        + (defense <= 5 ? d5 : 0)
        + (defense <= 4 ? d4 : 0)
        + (defense <= 3 ? d3 : 0)
        + (defense <= 2 ? d2 : 0)
        + (defense <= 1 ? d1 : 0)
    );


endmodule

module Time
r: [0..2] init 0;
die_i: [0..max_attack] init 0;

[first_assault] r=0 & die_i < attack-1 -> (die_i'=die_i+1);
[first_assault] r=0 & die_i >=attack-1 -> (die_i'=0) & (r'=1);

[count] r=1 -> (r'=2);

endmodule