mdp

const int max_attack = 10;
const int attack;
const int defense;

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
discard: [0..max_attack] init 0;

[first_assault] r=0 & d1+d2+d3+d4+d5+wounds < max_attack
        ->1/6: true
        + 1/6: (d1' = d1 + (defense>1?1:0)) & (wounds' = wounds + (defense<=1?1:0))
        + 1/6: (d2' = d2 + (defense>2?1:0)) & (wounds' = wounds + (defense<=2?1:0))
        + 1/6: (d3' = d3 + (defense>3?1:0)) & (wounds' = wounds + (defense<=3?1:0))
        + 1/6: (d4' = d4 + (defense>4?1:0)) & (wounds' = wounds + (defense<=4?1:0))
        + 1/6: (d5' = d5 + (defense>5?1:0)) & (wounds' = wounds + (defense<=5?1:0))
    ;

[first_assault] r=0 & d1+d2+d3+d4+d5+wounds >= max_attack -> true;

[first_count] r=1 -> (points' = min(max_attack, d1+d2+d3+d4));

// TODO: don't use d6 as discard count
// Choose to boost die to 5
[first_boost] r=2 & d4 > 0                         & defense > 5  & points >= 5+1-4 & d1+d2+d3+d4+d5+discard+5-4 < max_attack -> (points' = points - (5+1-4)) & (discard'=discard+5-4) & (d4'=d4-1) & (d5'=d5+1);
[first_boost] r=2 & d4<=0 & d3 > 0                 & defense > 5  & points >= 5+1-3 & d1+d2+d3+d4+d5+discard+5-3 < max_attack -> (points' = points - (5+1-3)) & (discard'=discard+5-3) & (d3'=d3-1) & (d5'=d5+1);
[first_boost] r=2 & d4<=0 & d3<=0 & d2 > 0         & defense > 5  & points >= 5+1-2 & d1+d2+d3+d4+d5+discard+5-2 < max_attack -> (points' = points - (5+1-2)) & (discard'=discard+5-2) & (d2'=d2-1) & (d5'=d5+1);
[first_boost] r=2 & d4<=0 & d3<=0 & d2<=0 & d1 > 0 & defense > 5  & points >= 5+1-1 & d1+d2+d3+d4+d5+discard+5-1 < max_attack -> (points' = points - (5+1-1)) & (discard'=discard+5-1) & (d1'=d1-1) & (d5'=d5+1);

// Choose to not boost die
[first_boost] r=2 -> true;


[first_discard] r=3 & discard>0 & d1>0                           -> (d1'=d1-1) & (discard'=discard-1);
[first_discard] r=3 & discard>0 & d1<=0 & d2>0                   -> (d2'=d2-1) & (discard'=discard-1);
[first_discard] r=3 & discard>0 & d1<=0 & d2<=0 & d3>0           -> (d3'=d3-1) & (discard'=discard-1);
[first_discard] r=3 & discard>0 & d1<=0 & d2<=0 & d3<=0 & d4>0   -> (d4'=d4-1) & (discard'=discard-1);
[first_discard] r=3 & discard>0 & d1<=0 & d2<=0 & d3<=0 & d4<=0  -> true;
[first_discard] r=3 & discard<=0  -> true;




// Choose to reroll die for second assault
[second_assault] r=4 & d5 > 0
        ->1/6: (d5' = d5-1)// (d0'=d0+1)
        + 1/6: (d5' = d5-1) & (d6'  = min(d6  + max_attack, (defense>6 ?1:0))) & (wounds' = min(max_attack, wounds + (defense<=6 ?1:0)))
        + 1/6: (d5' = d5-1) & (d7'  = min(d7  + max_attack, (defense>7 ?1:0))) & (wounds' = min(max_attack, wounds + (defense<=7 ?1:0)))
        + 1/6: (d5' = d5-1) & (d8'  = min(d8  + max_attack, (defense>8 ?1:0))) & (wounds' = min(max_attack, wounds + (defense<=8 ?1:0)))
        + 1/6: (d5' = d5-1) & (d9'  = min(d9  + max_attack, (defense>9 ?1:0))) & (wounds' = min(max_attack, wounds + (defense<=9 ?1:0)))
        + 1/6: (d5' = d5-1) & (d10' = min(d10 + max_attack, (defense>10?1:0))) & (wounds' = min(max_attack, wounds + (defense<=10?1:0)))
    ;
// Choose to not reroll the die for second assault
[second_assault] r=4 -> true;

[count] r=5 & d1+d2+d3+d4+d5+d6+d7+d8+d9+d10 <= max_attack -> (points' = d1+d2+d3+d4+d5+d6+d7+d8+d9+d10);

[second_boost] r=6 & wounds < max_attack & d10 > 0                                                                            & defense+1-10 >= 0 & points >= defense+1-10-> (points'=points-(defense+1-10)) & (wounds'=wounds+1) & (d10'= d10-1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9 > 0                                                                    & defense+1-9  >= 0 & points >= defense+1-9 -> (points'=points-(defense+1-9 )) & (wounds'=wounds+1) & (d9' = d9 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8 > 0                                                            & defense+1-8  >= 0 & points >= defense+1-8 -> (points'=points-(defense+1-8 )) & (wounds'=wounds+1) & (d8' = d8 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7 > 0                                                    & defense+1-7  >= 0 & points >= defense+1-7 -> (points'=points-(defense+1-7 )) & (wounds'=wounds+1) & (d7' = d7 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6 > 0                                            & defense+1-6  >= 0 & points >= defense+1-6 -> (points'=points-(defense+1-6 )) & (wounds'=wounds+1) & (d6' = d6 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5 > 0                                    & defense+1-5  >= 0 & points >= defense+1-5 -> (points'=points-(defense+1-5 )) & (wounds'=wounds+1) & (d5' = d5 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4 > 0                            & defense+1-4  >= 0 & points >= defense+1-4 -> (points'=points-(defense+1-4 )) & (wounds'=wounds+1) & (d4' = d4 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3 > 0                    & defense+1-3  >= 0 & points >= defense+1-3 -> (points'=points-(defense+1-3 )) & (wounds'=wounds+1) & (d3' = d3 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2 > 0            & defense+1-2  >= 0 & points >= defense+1-2 -> (points'=points-(defense+1-2 )) & (wounds'=wounds+1) & (d2' = d2 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1 > 0    & defense+1-1  >= 0 & points >= defense+1-1 -> (points'=points-(defense+1-1 )) & (wounds'=wounds+1) & (d1' = d1 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1<=0     & points > 0 -> (points' = points-1);


[second_boost] r=6 & wounds < max_attack & d10 > 0                                                                            & (points < defense+1-10 | defense+1-10 < 0)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9 > 0                                                                    & (points < defense+1-9  | defense+1-9  < 0)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8 > 0                                                            & (points < defense+1-8  | defense+1-8  < 0)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7 > 0                                                    & (points < defense+1-7  | defense+1-7  < 0)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6 > 0                                            & (points < defense+1-6  | defense+1-6  < 0)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5 > 0                                    & (points < defense+1-5  | defense+1-5  < 0)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4 > 0                            & (points < defense+1-4  | defense+1-4  < 0)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3 > 0                    & (points < defense+1-3  | defense+1-3  < 0)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2 > 0            & (points < defense+1-2  | defense+1-2  < 0)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1 > 0    & (points < defense+1-1  | defense+1-1  < 0)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1<=0     & points <= 0 -> true;

[second_boost] r=6 & wounds >= max_attack -> true;

[end] r=7 -> true;
[end] r=8 -> true;


endmodule

module Time
r: [0..8] init 0;
die_i: [0..max_attack] init attack;

[first_assault] r=0 & die_i >  1 -> (die_i'=die_i-1);
[first_assault] r=0 & die_i <= 1 -> (die_i'=attack) & (r'=1);

[first_count] r=1 -> (r'=2) & (die_i'=attack);

[first_boost] r=2 & die_i >  1 -> (die_i'= die_i-1);
[first_boost] r=2 & die_i <= 1 -> (die_i'= attack) & (r'=3);

[first_discard] r=3 & die_i >  1 -> (die_i'= die_i-1);
[first_discard] r=3 & die_i <= 1 -> (die_i'=d5) & (r'=4);

[second_assault] r=4 & die_i >  1 -> (die_i'= die_i-1);
[second_assault] r=4 & die_i <= 1 -> (die_i'=attack) & (r'=5);

[count] r=5 -> (r'=6) & (die_i'=min(max_attack, d1+d2+d3+d4+d5+d6+d7+d8+d9+d10));

[second_boost] r=6 & die_i >  1 -> (die_i' = die_i-1);
[second_boost] r=6 & die_i <= 1 -> (die_i' = attack) & (r'=7);

[end] r=7 -> (r'=8);
[end] r=8 -> true;

endmodule


rewards "wounds"
r = 7: wounds;
// r = 9: -999;
endrewards