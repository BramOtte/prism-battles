mdp
// # possible re - rolls of the game
const int k = 2;
module Dice1
    d1 : [-3..3] init 0;
    // The first roll is required
    [firstRoll] r = 0
        ->1/6 : (d1' = -3) 
        + 1/6 : (d1' = -2)
        + 1/6 : (d1' = -1)
        + 1/6 : (d1' = 3)
        + 1/6 : (d1' = 2)
        + 1/6 : (d1' = 1)
    ;
    // Subsequent rolls are optional
    [reRoll] r > 0 & r < k 
        ->1/6 : (d1' = -3) 
        + 1/6 : (d1' = -2)
        + 1/6 : (d1' = -1)
        + 1/6 : (d1' = 3)
        + 1/6 : (d1' = 2)
        + 1/6 : (d1' = 1)
    ;
    [reRoll] r > 0 & r < k -> true ;
    // After k rolls
    [end] r = k -> (d1' =0) ;
endmodule

module Dice2 = Dice1 [ d1 = d2 ] endmodule

module Dice3 = Dice1 [ d1 = d3 ] endmodule

module Roll
r : [0..k+1] init 0;
[ firstRoll ] r = 0 -> (r' = 1) ;
[ reRoll ] r > 0 & r < k -> (r' = r + 1) ;
[ end ] r = k -> (r' = k +1) ;
endmodule

// | d1 + d2 + d3 |
rewards
r = k : pow ( pow ( d1 + d2 +d3 , 2) , 0.5) ;
endrewards