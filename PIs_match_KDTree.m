%%% cette fonction caucule les K-NN pour  chaque vecteur (colonne) de 'da'
function [links scores matches]=PIs_match_KDTree(da,tree,datatrain,emax)
[INDEX, DIST] = vl_kdtreequery(tree,datatrain,da,'NumNeighbors', 4,'MAXNUMCOMPARISONS', emax); 
scores=DIST;
matches=[1:size(da,2);INDEX];
links=size(matches,2);


 