mdp

const int max_attack = 10;
const int attack = 6;
const int defense = 6;

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
[first_discard] r=1 & d1 > 0                                            -> (points'=points+1) & (d1'=d1-1);
[first_discard] r=1 & d1 <= 0 & d2 > 0                                  -> (points'=points+1) & (d2'=d2-1);
[first_discard] r=1 & d1 <= 0 & d2 <= 0 & d3 > 0                        -> (points'=points+1) & (d3'=d3-1);
[first_discard] r=1 & d1 <= 0 & d2 <= 0 & d3 <= 0 & d4 > 0              -> (points'=points+1) & (d4'=d4-1);
[first_discard] r=1 & d1 <= 0 & d2 <= 0 & d3 <= 0 & d4 <= 0 & d5 > 0    -> (points'=points+1) & (d5'=d5-1);

// Choose to not discard
[first_discard] r=1 -> true;

// Choose to boost die into second assault
[first_boost] r=2 & defense > 5 & points >= 1 & d4 > 0                                  -> (points'=points-1) & (d4'=d4-1) & (d5'=d5+1);
[first_boost] r=2 & defense > 5 & points >= 2 & d4 <= 0 & d3 > 0                        -> (points'=points-2) & (d3'=d3-1) & (d5'=d5+1);
[first_boost] r=2 & defense > 5 & points >= 3 & d4 <= 0 & d3 <= 0 & d2 > 0              -> (points'=points-3) & (d2'=d2-1) & (d5'=d5+1);
[first_boost] r=2 & defense > 5 & points >= 4 & d4 <= 0 & d3 <= 0 & d2 <= 0 & d1 > 0    -> (points'=points-4) & (d1'=d1-1) & (d5'=d5+1);

// Choose to boost die into wound
[first_boost] r=2 & points >= defense - 5 & d5 > 0                                            -> (points'=points+5-defense) & (d5'=d5-1) & (wounds'=wounds+1);
[first_boost] r=2 & points >= defense - 4 & d5 <= 0 & d4 > 0                                  -> (points'=points+4-defense) & (d4'=d4-1) & (wounds'=wounds+1);
[first_boost] r=2 & points >= defense - 3 & d5 <= 0 & d4 <= 0 & d3 > 0                        -> (points'=points+3-defense) & (d3'=d3-1) & (wounds'=wounds+1);
[first_boost] r=2 & points >= defense - 2 & d5 <= 0 & d4 <= 0 & d3 <= 0 & d2 > 0              -> (points'=points+2-defense) & (d2'=d2-1) & (wounds'=wounds+1);
[first_boost] r=2 & points >= defense - 1 & d5 <= 0 & d4 <= 0 & d3 <= 0 & d2 <= 0 & d1 > 0    -> (points'=points+1-defense) & (d1'=d1-1) & (wounds'=wounds+1);

// Choose to not boost
[first_boost] r=2 -> true;


// Choose to reroll die for second assault
// [second_assault] r=3 & d5 > 0
//         ->1/6: (d5' = 0)// (d0'=d0+1)
//         + 1/6: (d1' = d1 + (defense>1?1:0)) & (wounds' = wounds + (defense<=1?1:0))
//         + 1/6: (d2' = d2 + (defense>2?1:0)) & (wounds' = wounds + (defense<=2?1:0))
//         + 1/6: (d3' = d3 + (defense>3?1:0)) & (wounds' = wounds + (defense<=3?1:0))
//         + 1/6: (d4' = d4 + (defense>4?1:0)) & (wounds' = wounds + (defense<=4?1:0))
//         + 1/6: (d5' = d5 + (defense>5?1:0)) & (wounds' = wounds + (defense<=5?1:0))
//     ;

// Choose to not reroll the die for second assault

[count] r=3 -> true;


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

// [second_assault] r=3 & die_i < attack-1 -> (die_i'= die_i+1);
// [second_assault] r=3 & die_i >=attack-1 -> (die_i'=0) & (r'=4);

[count] r=3 -> (r'=4);

endmodule