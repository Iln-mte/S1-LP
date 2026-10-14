# TP2 - PPC avec MiniZinc

Les trois modèles ont été complétés et exécutés avec Gecode.

## Exercice 1 - Les n reines

### Question 1

Les trois contraintes interdisent deux reines sur une même ligne ou diagonale. Les colonnes sont déjà gérées par la représentation : une variable par colonne.

```minizinc
constraint alldifferent(q);
constraint alldifferent([q[i] + i | i in 1..n]);
constraint alldifferent([q[i] - i | i in 1..n]);
```

### Question 2

Pour n = 4, l'énumération avec `-a` donne 2 solutions :

```text
q = [3, 1, 4, 2]
q = [2, 4, 1, 3]
```

C'est le nombre attendu : ces deux placements sont symétriques.

### Question 3

Pour n = 8, l'énumération avec `-a` donne 92 solutions. Les rotations et les réflexions sont comptées séparément, car aucune contrainte de suppression des symétries n'a été ajoutée.

Le fichier des reines est laissé avec `n = 8`, conformément à cette question.

## Exercice 2 - Sudoku

### Question 1

```minizinc
constraint forall(i in 1..N)(
  alldifferent([cell[i,j] | j in 1..N])
);
constraint forall(j in 1..N)(
  alldifferent([cell[i,j] | i in 1..N])
);
constraint forall(bi,bj in 0..2)(
  alldifferent([cell[bi*3+i,bj*3+j] | i,j in 1..3])
);
```

Ces contraintes imposent les chiffres de 1 à 9 une fois chacun dans chaque ligne, colonne et bloc.

### Question 2

La résolution sans `-a` donne la grille suivante. L'énumération avec `-a` confirme qu'elle est l'unique solution.

```text
5 3 4 6 7 8 9 1 2
6 7 2 1 9 5 3 4 8
1 9 8 3 4 2 5 6 7
8 5 9 7 6 1 4 2 3
4 2 6 8 5 3 7 9 1
7 1 3 9 2 4 8 5 6
9 6 1 5 3 7 2 8 4
2 8 7 4 1 9 6 3 5
3 4 5 2 8 6 1 7 9
```

La grille obtenue est identique à celle du cours.

### Question 3 - Bonus

Les contraintes suivantes ont été ajoutées au modèle :

```minizinc
constraint forall(i in 1..N)(sum(j in 1..N)(cell[i,j]) = 45);
constraint forall(j in 1..N)(sum(i in 1..N)(cell[i,j]) = 45);
constraint forall(bi,bj in 0..2)(
  sum(i,j in 1..3)(cell[bi*3+i,bj*3+j]) = 45
);
```

Le résultat ne change pas : même grille et toujours une seule solution. Chaque ligne, colonne et bloc contient déjà les chiffres de 1 à 9, dont la somme vaut 45 ; ces contraintes sont donc redondantes.

## Exercice 3 - Ordonnancement ExedBike

### Question 1

```minizinc
constraint disjunctive(s, dur);
constraint makespan = max(e);
solve minimize makespan;
```

### Question 2

Le makespan optimal est de 12 h. Il atteint la borne inférieure 3 + 5 + 4 = 12 h, car une seule ligne traite les trois lots sans chevauchement.

Ordonnancement optimal obtenu :

| Lot | Début | Fin |
| --- | --- | --- |
| Cargo | 0 h | 5 h |
| Sport | 5 h | 9 h |
| Urban | 9 h | 12 h |

Les autres ordres sans temps mort donnent également 12 h.

### Question 3

Avec CP-SAT/OR-Tools, on crée un `IntervalVar` pour chaque lot, puis on impose `NoOverlap` sur ces intervalles. Avec MiniZinc, on déclare les débuts et les durées, puis `disjunctive(s, dur)` impose directement le non-chevauchement : la formulation déclarative est plus courte pour cette instance, avec le même optimum.
