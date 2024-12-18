smg

player p1
[first_boost]
endplayer

player p2
[first_boost_p2]
endplayer

const int max_attack = 10;
const int max_defense = 10;


module Dice
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
reroll: [0..max_attack] init 0;

// [Random] First assault
[first_assault] r=0 & d1+d2+d3+d4+d5+wounds < max_attack
        ->1/6: true
        + 1/6: (d1' = d1 + (defense>1?1:0)) & (wounds' = wounds + (defense<=1?1:0))
        + 1/6: (d2' = d2 + (defense>2?1:0)) & (wounds' = wounds + (defense<=2?1:0))
        + 1/6: (d3' = d3 + (defense>3?1:0)) & (wounds' = wounds + (defense<=3?1:0))
        + 1/6: (d4' = d4 + (defense>4?1:0)) & (wounds' = wounds + (defense<=4?1:0))
        + 1/6: (d5' = d5 + (defense>5?1:0)) & (wounds' = wounds + (defense<=5?1:0))
    ;

[first_assault] r=0 & d1+d2+d3+d4+d5+wounds >= max_attack -> true;

[first_count] r=1 -> (points' = min(max_attack, d1+d2+d3+d4+d5));

// Choose to take die into second assault
[first_boost] r=2 & turn=1 & d5 > 0                                 & defense > 5 & points >= 5+1-5 -> (points' = points - (5+1-5))                                           & (d5'=d5-1) & (reroll'=min(max_attack, reroll+1));
[first_boost] r=2 & turn=1 & d5<=0 & d4 > 0                         & defense > 5 & points >= 5+1-4 -> (points' = points - (5+1-4)) & (discard'=min(max_attack, discard+5-4)) & (d4'=d4-1) & (reroll'=min(max_attack, reroll+1));
[first_boost] r=2 & turn=1 & d5<=0 & d4<=0 & d3 > 0                 & defense > 5 & points >= 5+1-3 -> (points' = points - (5+1-3)) & (discard'=min(max_attack, discard+5-3)) & (d3'=d3-1) & (reroll'=min(max_attack, reroll+1));
[first_boost] r=2 & turn=1 & d5<=0 & d4<=0 & d3<=0 & d2 > 0         & defense > 5 & points >= 5+1-2 -> (points' = points - (5+1-2)) & (discard'=min(max_attack, discard+5-2)) & (d2'=d2-1) & (reroll'=min(max_attack, reroll+1));
[first_boost] r=2 & turn=1 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1 > 0 & defense > 5 & points >= 5+1-1 -> (points' = points - (5+1-1)) & (discard'=min(max_attack, discard+5-1)) & (d1'=d1-1) & (reroll'=min(max_attack, reroll+1));

// Choose to not take die into second assault
[first_boost] r=2 & turn=1 -> true;

// Choose to take die into second assault
[first_boost_p2] r=2 & turn=2 & d5 > 0                                 & defense > 5 & points >= 5+1-5 -> (points' = points - (5+1-5))                                           & (d5'=d5-1) & (reroll'=min(max_attack, reroll+1));
[first_boost_p2] r=2 & turn=2 & d5<=0 & d4 > 0                         & defense > 5 & points >= 5+1-4 -> (points' = points - (5+1-4)) & (discard'=min(max_attack, discard+5-4)) & (d4'=d4-1) & (reroll'=min(max_attack, reroll+1));
[first_boost_p2] r=2 & turn=2 & d5<=0 & d4<=0 & d3 > 0                 & defense > 5 & points >= 5+1-3 -> (points' = points - (5+1-3)) & (discard'=min(max_attack, discard+5-3)) & (d3'=d3-1) & (reroll'=min(max_attack, reroll+1));
[first_boost_p2] r=2 & turn=2 & d5<=0 & d4<=0 & d3<=0 & d2 > 0         & defense > 5 & points >= 5+1-2 -> (points' = points - (5+1-2)) & (discard'=min(max_attack, discard+5-2)) & (d2'=d2-1) & (reroll'=min(max_attack, reroll+1));
[first_boost_p2] r=2 & turn=2 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1 > 0 & defense > 5 & points >= 5+1-1 -> (points' = points - (5+1-1)) & (discard'=min(max_attack, discard+5-1)) & (d1'=d1-1) & (reroll'=min(max_attack, reroll+1));

// Choose to not take die into second assault
[first_boost_p2] r=2 & turn=2 -> true;


[first_discard] r=3 & discard>0 & d1>0                                  -> (d1'=d1-1) & (discard'=discard-1);
[first_discard] r=3 & discard>0 & d1<=0 & d2>0                          -> (d2'=d2-1) & (discard'=discard-1);
[first_discard] r=3 & discard>0 & d1<=0 & d2<=0 & d3>0                  -> (d3'=d3-1) & (discard'=discard-1);
[first_discard] r=3 & discard>0 & d1<=0 & d2<=0 & d3<=0 & d4>0          -> (d4'=d4-1) & (discard'=discard-1);
[first_discard] r=3 & discard>0 & d1<=0 & d2<=0 & d3<=0 & d4<=0 & d5>0  -> (d5'=d5-1) & (discard'=discard-1);
[first_discard] r=3 & discard>0 & d1<=0 & d2<=0 & d3<=0 & d4<=0 & d5<=0 -> (discard'=0);
[first_discard] r=3 & discard<=0  -> true;



// [Random] reroll die for second assault
[second_assault] r=4 & reroll > 0
        ->1/6: (reroll' = reroll-1)
        + 1/6: (reroll' = reroll-1) & (d6'  = min(max_attack, d6 + (defense>6 ?1:0))) & (wounds' = min(max_attack, wounds + (defense<=6 ?1:0)))
        + 1/6: (reroll' = reroll-1) & (d7'  = min(max_attack, d7 + (defense>7 ?1:0))) & (wounds' = min(max_attack, wounds + (defense<=7 ?1:0)))
        + 1/6: (reroll' = reroll-1) & (d8'  = min(max_attack, d8 + (defense>8 ?1:0))) & (wounds' = min(max_attack, wounds + (defense<=8 ?1:0)))
        + 1/6: (reroll' = reroll-1) & (d9'  = min(max_attack, d9 + (defense>9 ?1:0))) & (wounds' = min(max_attack, wounds + (defense<=9 ?1:0)))
        + 1/6: (reroll' = reroll-1) & (wounds'=min(max_attack, wounds+1))
    ;
[second_assault] r=4 & reroll <= 0 -> true;

[count] r=5 -> (points' = min(max_attack, d1+d2+d3+d4+d5+d6+d7+d8+d9));

[second_boost] r=6 & wounds < max_attack & d10 > 0                                                                          & points >= 1+max(0, defense-10) -> (points'=points-(1+max(0, defense-10))) & (wounds'=wounds+1) & (d10' = d10-1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9 > 0                                                                 & points >= 1+max(0, defense-9 ) -> (points'=points-(1+max(0, defense-9 ))) & (wounds'=wounds+1) & (d9'  = d9 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8 > 0                                                         & points >= 1+max(0, defense-8 ) -> (points'=points-(1+max(0, defense-8 ))) & (wounds'=wounds+1) & (d8'  = d8 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7 > 0                                                 & points >= 1+max(0, defense-7 ) -> (points'=points-(1+max(0, defense-7 ))) & (wounds'=wounds+1) & (d7'  = d7 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6 > 0                                         & points >= 1+max(0, defense-6 ) -> (points'=points-(1+max(0, defense-6 ))) & (wounds'=wounds+1) & (d6'  = d6 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5 > 0                                 & points >= 1+max(0, defense-5 ) -> (points'=points-(1+max(0, defense-5 ))) & (wounds'=wounds+1) & (d5'  = d5 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4 > 0                         & points >= 1+max(0, defense-4 ) -> (points'=points-(1+max(0, defense-4 ))) & (wounds'=wounds+1) & (d4'  = d4 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3 > 0                 & points >= 1+max(0, defense-3 ) -> (points'=points-(1+max(0, defense-3 ))) & (wounds'=wounds+1) & (d3'  = d3 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2 > 0         & points >= 1+max(0, defense-2 ) -> (points'=points-(1+max(0, defense-2 ))) & (wounds'=wounds+1) & (d2'  = d2 -1);
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1 > 0 & points >= 1+max(0, defense-1 ) -> (points'=points-(1+max(0, defense-1 ))) & (wounds'=wounds+1) & (d1'  = d1 -1);


[second_boost] r=6 & wounds < max_attack & d10 > 0                                                                          & points < 1+max(0, defense-10)-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9 > 0                                                                  & points < 1+max(0, defense-9 )-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8 > 0                                                          & points < 1+max(0, defense-8 )-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7 > 0                                                  & points < 1+max(0, defense-7 )-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6 > 0                                          & points < 1+max(0, defense-6 )-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5 > 0                                  & points < 1+max(0, defense-5 )-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4 > 0                          & points < 1+max(0, defense-4 )-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3 > 0                  & points < 1+max(0, defense-3 )-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2 > 0          & points < 1+max(0, defense-2 )-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1 > 0  & points < 1+max(0, defense-1 )-> true;
[second_boost] r=6 & wounds < max_attack & d10<=0 & d9<=0 & d8<=0 & d7<=0 & d6<=0 & d5<=0 & d4<=0 & d3<=0 & d2<=0 & d1<=0 -> (points' = 0);

[second_boost] r=6 & wounds >= max_attack -> true;

[end] r=7 -> (points'=0) & (discard'=0) & (reroll'=0) & (d1'=0) & (d2'=0) & (d3'=0) & (d4'=0) & (d5'=0) & (d6'=0) & (d7'=0) & (d8'=0) & (d9'=0) & (d10'=0);
[end] r=8 -> true;


endmodule

module Time
turn: [1..2] init 1;
retal: bool init false;

vitality1: [0..6] init 6;
vitality2: [0..6] init 6;

defense1: [0..max_defense] init 6;
defense2: [0..max_defense] init 6;

offense1: [0..max_attack] init 6;
offense2: [0..max_attack] init 6;


attack: [0..max_attack] init 6;
defense: [0..max_attack] init 6;


r: [0..8] init 0;
die_i: [0..max_attack] init 6;

[first_assault] r=0 & die_i >  1 -> (die_i'=die_i-1);
[first_assault] r=0 & die_i <= 1 -> (die_i'=1) & (r'=1);

[first_count] r=1 -> (r'=2) & (die_i'=attack);

[first_boost] r=2 & turn=1 & die_i >  1 -> (die_i'= die_i-1);
[first_boost] r=2 & turn=1 & die_i <= 1 -> (die_i'= attack) & (r'=3);

[first_boost_p2] r=2 & turn=2 & die_i >  1 -> (die_i'= die_i-1);
[first_boost_p2] r=2 & turn=2 & die_i <= 1 -> (die_i'= attack) & (r'=3);

[first_discard] r=3 & die_i >  1 -> (die_i'= die_i-1);
[first_discard] r=3 & die_i <= 1 -> (die_i'=attack) & (r'=4);

[second_assault] r=4 & die_i >  1 -> (die_i'= die_i-1);
[second_assault] r=4 & die_i <= 1 -> (die_i'=attack) & (r'=5);

[count] r=5 -> (r'=6) & (die_i'=attack);

[second_boost] r=6 & die_i >  1 -> (die_i' = die_i-1);
[second_boost] r=6 & die_i <= 1 -> (die_i' = 1) & (r'=7);

[end] r=7 & turn=1 & !retal & vitality2 > wounds -> (r'=0) & (turn'=2) & (vitality2'=vitality2-wounds) & (die_i'=offense2) & (attack'=offense2) & (retal'=true);
[end] r=7 & turn=1 &  retal & vitality2 > wounds -> (r'=0) & (turn'=1) & (vitality2'=vitality2-wounds) & (die_i'=offense2) & (attack'=offense2) & (retal'=false);

[end] r=7 & turn=1 & vitality2 <= wounds -> (r'=8) & (vitality2'=0);


[end] r=7 & turn=2 & !retal & vitality1 > wounds -> (r'=0) & (turn'=1) & (vitality1'=vitality1-wounds) & (die_i'=offense1) & (attack'=offense1) & (retal'=true);
[end] r=7 & turn=2 &  retal & vitality1 > wounds -> (r'=0) & (turn'=2) & (vitality1'=vitality1-wounds) & (die_i'=offense1) & (attack'=offense1) & (retal'=false);


[end] r=7 & turn=2 & vitality1 <= wounds -> (r'=8) & (vitality1'=0);


[end] r=8 -> true;

endmodule
