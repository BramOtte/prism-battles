dtmc

const int max_attack = 10;
const int attack = 6;
const int defense = 4;

module Dice
// attack: [0..max_attack] init 6;

// d0: [0..max_attack] init 0;
d1: [0..max_attack] init 0;
d2: [0..max_attack] init 0;
d3: [0..max_attack] init 0;
d4: [0..max_attack] init 0;
d5: [0..max_attack] init 0;
wounds: [0..max_attack] init 0;
points: [0..max_attack] init 0;

[first_assault] r=0
        ->1/6: true // (d0'=d0+1)
        + 1/6: (d1' = d1 + (defense>1?1:0)) & (wounds' = wounds + (defense<=1?1:0))
        + 1/6: (d2' = d2 + (defense>2?1:0)) & (wounds' = wounds + (defense<=2?1:0))
        + 1/6: (d3' = d3 + (defense>3?1:0)) & (wounds' = wounds + (defense<=3?1:0))
        + 1/6: (d4' = d4 + (defense>4?1:0)) & (wounds' = wounds + (defense<=4?1:0))
        + 1/6: (d5' = d5 + (defense>5?1:0)) & (wounds' = wounds + (defense<=5?1:0))
    ;


// Choose to discard die
[first_discard] r=1
    ->(d1'=d1 - (d1 > 0 ? 1 : 0))
    & (d2'=d2 - (d1 <= 0 & d2 > 0 ? 1 : 0))
    & (d3'=d3 - (d1 <= 0 & d2 <= 0 & d3 > 0 ? 1 : 0))
    & (d4'=d4 - (d1 <= 0 & d2 <= 0 & d3 <= 0 & d4 > 0 ? 1 : 0))
    & (d5'=d5 - (d1 <= 0 & d2 <= 0 & d3 <= 0 & d4 <= 0 & d5 > 0 ? 1 : 0))
    & (points'=points + ((d1 > 0) | (d2 > 0) | (d3 > 0) | (d4 > 0) | (d5 > 0) ? 1 : 0))
;

// Choose to not discard
[first_discard] r=1 -> true;

// Choose to boost die into second assault
// [first_boost] r=2 & points > 0
//     ->(d4 > 0 & )
// ;

// Choose to boost die into wound



[count] r=2 -> true;


endmodule

module Time
r: [0..2] init 0;
die_i: [0..max_attack] init 0;

[first_assault] r=0 & die_i < attack-1 -> (die_i'=die_i+1);
[first_assault] r=0 & die_i >=attack-1 -> (die_i'=0) & (r'=1);

[first_discard] r=1 & die_i < attack-1 -> (die_i'= die_i+1);
[first_discard] r=1 & die_i >=attack-1 -> (die_i'=0) & (r'=2);

[first_boost] r=2 & die_i < attack-1 -> (die_i'= die_i+1);
[first_boost] r=2 & die_i >=attack-1 -> (die_i'=0) & (r'=3);


[count] r=3 -> (r'=4);

endmodule