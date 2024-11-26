mdp

const int max_attack = 10;
const int attack = 10;
const int defense = 10;

module Dice
// attack: [0..max_attack] init 6;

// d0: [0..max_attack] init 0;
d1: [0..max_attack] init 0;
d2: [0..max_attack] init 0;
d3: [0..max_attack] init 0;
d4: [0..max_attack] init 0;
d5: [0..max_attack] init 0;

d6: [0..max_attack] init 0;
d7: [0..max_attack] init 0;
d8: [0..max_attack] init 0;
d9: [0..max_attack] init 0;
d10: [0..max_attack] init 0;


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

// // Choose to boost die into wound
// [first_boost] r=2 & points >= defense - 5 & d5 > 0                                            -> (points'=points+5-defense) & (d5'=d5-1) & (wounds'=wounds+1);
// [first_boost] r=2 & points >= defense - 4 & d5 <= 0 & d4 > 0                                  -> (points'=points+4-defense) & (d4'=d4-1) & (wounds'=wounds+1);
// [first_boost] r=2 & points >= defense - 3 & d5 <= 0 & d4 <= 0 & d3 > 0                        -> (points'=points+3-defense) & (d3'=d3-1) & (wounds'=wounds+1);
// [first_boost] r=2 & points >= defense - 2 & d5 <= 0 & d4 <= 0 & d3 <= 0 & d2 > 0              -> (points'=points+2-defense) & (d2'=d2-1) & (wounds'=wounds+1);
// [first_boost] r=2 & points >= defense - 1 & d5 <= 0 & d4 <= 0 & d3 <= 0 & d2 <= 0 & d1 > 0    -> (points'=points+1-defense) & (d1'=d1-1) & (wounds'=wounds+1);

// Choose to not boost
[first_boost] r=2 -> true;


// Choose to reroll die for second assault
[second_assault] r=3 & d5 > 0
        ->1/6: (d5' = d5-1)// (d0'=d0+1)
        + 1/6: (d5' = d5-1) & (d6'  = d6  + (defense>6 ?1:0)) & (wounds' = wounds + (defense<=6 ?1:0))
        + 1/6: (d5' = d5-1) & (d7'  = d7  + (defense>7 ?1:0)) & (wounds' = wounds + (defense<=7 ?1:0))
        + 1/6: (d5' = d5-1) & (d8'  = d8  + (defense>8 ?1:0)) & (wounds' = wounds + (defense<=8 ?1:0))
        + 1/6: (d5' = d5-1) & (d9'  = d9  + (defense>9 ?1:0)) & (wounds' = wounds + (defense<=9 ?1:0))
        + 1/6: (d5' = d5-1) & (d10' = d10 + (defense>10?1:0)) & (wounds' = wounds + (defense<=10?1:0))
    ;
// Choose to not reroll the die for second assault
[second_assault] r=3 -> true;

[count] r=4 -> (points' = d1+d2+d3+d4+d5+d6+d7+d8+d9+d10);

[second_boost] r=5 & d10 > 0                                                                            & points > 0 -> (points' = points - (points > defense-10 ? defense+1-10 : 0)) & (wounds' = wounds + (points > defense-10 ? 1 : 0)) & (d10'= d10-1);
[second_boost] r=5 & d10<=0 & d9 > 0                                                                    & points > 0 -> (points' = points - (points > defense-9  ? defense+1-9  : 0)) & (wounds' = wounds + (points > defense-9  ? 1 : 0)) & (d9' = d9 -1);
[second_boost] r=5 & d10<=0 & d9<=0 & d8 > 0                                                            & points > 0 -> (points' = points - (points > defense-8  ? defense+1-8  : 0)) & (wounds' = wounds + (points > defense-8  ? 1 : 0)) & (d8' = d8 -1);
[second_boost] r=5 & d10<=0 & d9<=0 & d8<=0 & d7 > 0                                                    & points > 0 -> (points' = points - (points > defense-7  ? defense+1-7  : 0)) & (wounds' = wounds + (points > defense-7  ? 1 : 0)) & (d7' = d7 -1);
[second_boost] r=5 & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6 > 0                                            & points > 0 -> (points' = points - (points > defense-6  ? defense+1-6  : 0)) & (wounds' = wounds + (points > defense-6  ? 1 : 0)) & (d6' = d6 -1);
[second_boost] r=5 & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5 > 0                                    & points > 0 -> (points' = points - (points > defense-5  ? defense+1-5  : 0)) & (wounds' = wounds + (points > defense-5  ? 1 : 0)) & (d5' = d5 -1);
[second_boost] r=5 & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4 > 0                            & points > 0 -> (points' = points - (points > defense-4  ? defense+1-4  : 0)) & (wounds' = wounds + (points > defense-4  ? 1 : 0)) & (d4' = d4 -1);
[second_boost] r=5 & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3 > 0                    & points > 0 -> (points' = points - (points > defense-3  ? defense+1-3  : 0)) & (wounds' = wounds + (points > defense-3  ? 1 : 0)) & (d3' = d3 -1);
[second_boost] r=5 & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2 > 0            & points > 0 -> (points' = points - (points > defense-2  ? defense+1-2  : 0)) & (wounds' = wounds + (points > defense-2  ? 1 : 0)) & (d2' = d2 -1);
[second_boost] r=5 & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1 > 0    & points > 0 -> (points' = points - (points > defense-1  ? defense+1-1  : 0)) & (wounds' = wounds + (points > defense-1  ? 1 : 0)) & (d1' = d1 -1);
[second_boost] r=5 & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1<=0     & points > 0 -> (points' = points-1);
[second_boost] r=5 & points <= 0 -> true;


[end] r=6 -> true;


endmodule

module Time
r: [0..7] init 0;
die_i: [0..max_attack] init attack;

[first_assault] r=0 & die_i >  1 -> (die_i'=die_i-1);
[first_assault] r=0 & die_i <= 1 -> (die_i'=attack) & (r'=1);

[first_discard] r=1 & die_i >  1 -> (die_i'= die_i-1);
[first_discard] r=1 & die_i <= 1 -> (die_i'=attack) & (r'=2);
// repeat first discard <attack> times

[first_boost] r=2 & die_i >  1 -> (die_i'= die_i-1);
[first_boost] r=2 & die_i <= 1 -> (die_i'= d5) & (r'=3);

[second_assault] r=3 & die_i >  1 -> (die_i'= die_i-1);
[second_assault] r=3 & die_i <= 1 -> (die_i'=attack) & (r'=4);

[count] r=4 -> (r'=5);

[second_boost] r=5 & die_i > 1 -> (die_i' = die_i-1);
[second_boost] r=5 & die_i <= 1 -> (die_i' = 0) & (r'=6);

[end] r=6 -> (r'=7);

endmodule


rewards "wounds"
r = 6: wounds;
endrewards

rewards "dice"
true: d1+d2+d3+d4+d5+d6+d7+d8+d9+d10;
endrewards