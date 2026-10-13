# TD1 - ExedBike : résolution du programme linéaire

## Question 1 - Formulation et forme standard

On note `u` et `c` les quantités hebdomadaires de vélos Urban et Cargo. Ce sont des variables continues non négatives dans le modèle demandé. Les marges unitaires sont respectivement de 120 € et de 200 €.

Le programme linéaire est :

```text
Maximiser Z = 120u + 200c

sous les contraintes :
  4u +  6c <= 480   (heures de main-d'œuvre)
  6u + 15c <= 900   (kilogrammes d'aluminium)
  2u +  2c <= 240   (heures-machine)
  u >= 0, c >= 0
```

Pour passer à la forme standard, on introduit trois variables d'écart non négatives : `e1` représente les heures de travail restantes, `e2` les kilogrammes d'aluminium restants et `e3` les heures-machine restantes.

```text
  4u +  6c + e1 = 480
  6u + 15c + e2 = 900
  2u +  2c + e3 = 240

  u, c, e1, e2, e3 >= 0

Maximiser Z = 120u + 200c
```

Pour construire les tableaux du simplexe, l'équation de l'objectif s'écrit `Z - 120u - 200c = 0`. La colonne `Z`, toujours égale à 0 pour les contraintes et à 1 pour la ligne de l'objectif, n'est pas affichée dans les tableaux.

## Question 2 - Tableaux et pivots successifs

### Tableau initial

En prenant `u = c = 0`, on obtient `e1 = 480`, `e2 = 900` et `e3 = 240`. La base initiale `(e1, e2, e3)` est donc admissible.

| Base | u | c | e1 | e2 | e3 | Second membre |
|---|---:|---:|---:|---:|---:|---:|
| e1 | 4 | 6 | 1 | 0 | 0 | 480 |
| e2 | 6 | 15 | 0 | 1 | 0 | 900 |
| e3 | 2 | 2 | 0 | 0 | 1 | 240 |
| Z | -120 | -200 | 0 | 0 | 0 | 0 |

La convention utilisée consiste à faire entrer une variable dont le coefficient est négatif dans la ligne `Z`. Nous choisissons ici le coefficient le plus négatif.

### Premier pivot : c entre, e2 sort

Le coefficient le plus négatif est `-200`, dans la colonne `c` : **Cargo entre en base**.

On divise chaque second membre par le coefficient strictement positif de cette colonne :

| Ligne | Rapport | Valeur |
|---|---|---:|
| e1 | 480 / 6 | 80 |
| e2 | 900 / 15 | 60 |
| e3 | 240 / 2 | 120 |

Le plus petit rapport est 60 : **e2 sort de la base**. Le pivot vaut **15**.

En notant `L1`, `L2`, `L3` les lignes des contraintes et `LZ` la ligne de l'objectif, on effectue les opérations suivantes. Après la première opération, toutes les autres utilisent la nouvelle ligne `L2` normalisée.

```text
L2 <- L2 / 15
L1 <- L1 - 6L2
L3 <- L3 - 2L2
LZ <- LZ + 200L2
```

| Base | u | c | e1 | e2 | e3 | Second membre |
|---|---:|---:|---:|---:|---:|---:|
| e1 | 8/5 | 0 | 1 | -2/5 | 0 | 120 |
| c | 2/5 | 1 | 0 | 1/15 | 0 | 60 |
| e3 | 6/5 | 0 | 0 | -2/15 | 1 | 120 |
| Z | -40 | 0 | 0 | 40/3 | 0 | 12000 |

La solution de base est alors `u = 0`, `c = 60`, `e1 = 120`, `e2 = 0`, `e3 = 120`, avec une marge de **12 000 €**. Le coefficient `-40` dans la colonne `u` permet encore d'améliorer l'objectif.

### Deuxième pivot : u entre, e1 sort

**Urban entre en base**. Le test des rapports dans sa colonne donne :

| Ligne | Rapport | Valeur |
|---|---|---:|
| e1 | 120 / (8/5) | 75 |
| c | 60 / (2/5) | 150 |
| e3 | 120 / (6/5) | 100 |

Le plus petit rapport est 75 : **e1 sort de la base**. Le pivot vaut **8/5**.

Après normalisation, les autres opérations utilisent la nouvelle ligne `L1` :

```text
L1 <- (5/8)L1
L2 <- L2 - (2/5)L1
L3 <- L3 - (6/5)L1
LZ <- LZ + 40L1
```

| Base | u | c | e1 | e2 | e3 | Second membre |
|---|---:|---:|---:|---:|---:|---:|
| u | 1 | 0 | 5/8 | -1/4 | 0 | 75 |
| c | 0 | 1 | -1/4 | 1/6 | 0 | 30 |
| e3 | 0 | 0 | -3/4 | 1/6 | 1 | 30 |
| Z | 0 | 0 | 25 | 10/3 | 0 | 15000 |

Il n'y a plus de coefficient négatif dans la ligne `Z` : **l'optimalité est atteinte**. Cette ligne représente l'égalité :

```text
Z + 25e1 + (10/3)e2 = 15000
```

Comme `e1` et `e2` sont non négatifs, toute solution admissible vérifie `Z <= 15000`. La solution de base obtenue atteint cette borne.

## Question 3 - Solution optimale et interprétation économique

Les variables hors base sont `e1 = e2 = 0`. On lit donc :

```text
u = 75 Urban
c = 30 Cargo
e3 = 30 heures-machine restantes

Z = 120 × 75 + 200 × 30 = 15000 €/semaine
```

| Ressource | Consommation | Disponible | Restante | Saturée ? |
|---|---|---:|---:|---|
| Main-d'œuvre | 4 × 75 + 6 × 30 = 480 h | 480 h | 0 h | Oui |
| Aluminium | 6 × 75 + 15 × 30 = 900 kg | 900 kg | 0 kg | Oui |
| Temps machine | 2 × 75 + 2 × 30 = 210 h | 240 h | 30 h | Non |

**Le plan optimal consiste à produire 75 Urban et 30 Cargo**, pour une marge de **15 000 € par semaine**. La main-d'œuvre et l'aluminium limitent la production ; il reste du temps machine disponible.

Les coefficients des variables d'écart dans la dernière ligne donnent les prix duaux :

| Ressource | Prix dual | Interprétation |
|---|---:|---|
| Main-d'œuvre | 25 €/h | Une heure supplémentaire augmente localement la marge optimale de 25 €. |
| Aluminium | 10/3 €/kg, soit environ 3,33 €/kg | Un kilogramme supplémentaire augmente localement la marge optimale d'environ 3,33 €. |
| Temps machine | 0 €/h | Une heure-machine supplémentaire seule n'apporte aucun gain au plan actuel. |

Ces valeurs supposent que l'on modifie une seule capacité à la fois et que la base optimale reste valable. Elles aident à évaluer un achat de capacité en comparant le gain de marge au coût de cette capacité.

On peut également vérifier l'optimalité avec le vecteur dual `(25, 10/3, 0)` :

```text
Urban : 4 × 25 + 6 × (10/3) + 2 × 0 = 120
Cargo : 6 × 25 + 15 × (10/3) + 2 × 0 = 200

Valeur duale = 480 × 25 + 900 × (10/3) + 240 × 0 = 15000
```

Le plan primal et le vecteur dual sont admissibles et ont la même valeur : cela confirme l'optimalité.

## Question 4 - Différence avec le programme à trois produits

La gamme réelle ajoute le modèle **Sport**, donc une troisième variable de décision. Elle utilise aussi d'autres capacités : **520 h de main-d'œuvre, 1 100 kg d'aluminium et 260 h de temps machine**. Il faut donc modifier le modèle complet, et pas seulement ajouter une colonne au tableau précédent.

La méthode du simplexe reste applicable avec trois produits. En revanche, les tableaux contiennent davantage de coefficients, les calculs deviennent plus longs et la représentation graphique en deux dimensions ne suffit plus. La résolution pas à pas réalisée ici sert à comprendre le choix des pivots, les contraintes actives et les prix duaux.

L'entreprise a intérêt à utiliser un solveur pour recalculer rapidement le plan lorsque les marges, les ressources ou le catalogue changent. Il applique la méthode de façon systématique, limite les erreurs arithmétiques et fournit les informations de sensibilité. Il reste nécessaire de vérifier la formulation et d'interpréter les résultats.
