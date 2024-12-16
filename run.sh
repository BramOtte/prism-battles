set -e

defense=6
attack=6
folder=out/strats/$defense-$attack

mkdir -p out/models
mkdir -p $folder

cat models/battles.pm models/battles-wounds.pm > out/models/battles-wounds.pm
cat models/battles.pm models/battles-reroll.pm > out/models/battles-reroll.pm


prism models/battles.pm -const defense=$defense,attack=$attack -exportstates $folder/states.sta -exportlabels $folder/labels.lab
prism out/models/battles-wounds.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/rmax.tra:type=induced,mode=reduce  -prop 1  -cuddmaxmem 2g -javamaxmem 2g
prism out/models/battles-reroll.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/rmax.tra:type=induced,mode=reduce  -prop 1  -cuddmaxmem 2g -javamaxmem 2g

prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/pmax1.tra:type=induced,mode=reduce -prop 2  -cuddmaxmem 2g -javamaxmem 2g
prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/pmax2.tra:type=induced,mode=reduce -prop 3  -cuddmaxmem 2g -javamaxmem 2g
prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/pmax3.tra:type=induced,mode=reduce -prop 4  -cuddmaxmem 2g -javamaxmem 2g
prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/pmax4.tra:type=induced,mode=reduce -prop 5  -cuddmaxmem 2g -javamaxmem 2g
prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/pmax5.tra:type=induced,mode=reduce -prop 6  -cuddmaxmem 2g -javamaxmem 2g
prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/pmax6.tra:type=induced,mode=reduce -prop 7  -cuddmaxmem 2g -javamaxmem 2g
prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/pmax7.tra:type=induced,mode=reduce -prop 8  -cuddmaxmem 2g -javamaxmem 2g
prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/pmax8.tra:type=induced,mode=reduce -prop 9  -cuddmaxmem 2g -javamaxmem 2g
prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/pmax9.tra:type=induced,mode=reduce -prop 10 -cuddmaxmem 2g -javamaxmem 2g
prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/pmax10.tra:type=induced,mode=reduce -prop 11 -cuddmaxmem 2g -javamaxmem 2g
prism models/battles.pm models/battles.pctl -const defense=$defense,attack=$attack -exportstrat $folder/maxreroll.tra:type=induced,mode=reduce -prop 12 -cuddmaxmem 2g -javamaxmem 2g
