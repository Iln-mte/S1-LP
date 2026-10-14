% ============================================================================
% Optimisation pour l'IA — Séance 2 — TP2 PPC, Exercice 1
% Les n reines en MiniZinc — Modèle 1 (compact) vu en cours (Modélisation PPC) :
% une variable par colonne, son domaine = la ligne occupée.
% ============================================================================

int: n = 8;  % Question 3 ; remplacer 8 par 4 pour la Question 2.

array[1..n] of var 1..n: q;  % q[i] = ligne de la reine de la colonne i

% --- ETAPE 1 : pas deux reines sur la même ligne ----------------------------
% (déjà écrit — rien à modifier ici)
include "alldifferent.mzn";

% --- ETAPE 2 : pas deux reines sur la même diagonale montante --------------
% Deux reines i != j s'attaquent sur une diagonale montante ssi q[i]+i = q[j]+j.
% Il faut donc que les valeurs (q[i]+i) soient toutes différentes.
% Syntaxe MiniZinc :  alldifferent([ expression | i in 1..n ])
%
constraint alldifferent([q[i] + i | i in 1..n]);

% --- ETAPE 3 : pas deux reines sur la même diagonale descendante -----------
% Même idée avec (q[i]-i).
%
constraint alldifferent([q[i] - i | i in 1..n]);

% --- ETAPE 4 : contrainte "pas sur la même ligne" (déjà donnée ci-dessus) --
constraint alldifferent(q);

solve satisfy;

output ["q = ", show(q)];
