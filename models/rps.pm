csg

player player1 m1 endplayer
player player2 m2 endplayer

// first player
module m1

	[r1] true -> true; // rock 
	[p1] true -> true; // paper	
	[s1] true -> true; // scissors
	
endmodule

// second player constructed through renaming
module m2 = m1[r1=r2,p1=p2,s1=s2] endmodule

// module to record who wins
module recorder

	win : [-1..2];
	
	[r1,r2] true -> (win'=0);
	[r1,p2] true -> (win'=2);
	[r1,s2] true -> (win'=1);
	
	[p1,r2] true -> (win'=1);
	[p1,p2] true -> (win'=0);
	[p1,s2] true -> (win'=2);
	
	[s1,r2] true -> (win'=2);
	[s1,p2] true -> (win'=1);
	[s1,s2] true -> (win'=0);

endmodule