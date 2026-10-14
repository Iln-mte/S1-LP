# ExedBike - Projet individuel, partie 1

## Modèle de coût Urban

Les 40 observations synthétiques, entre 50 et 2 000 unités cumulées (graine 7 conservée), sont ajustées par le modèle c(q) = 9 682,85 × q^(-0,555228). La descente de gradient programmée minimise l'erreur quadratique des logarithmes, avec un pas de 0,1. Elle atteint le seuil de gradient de 10^-10 après 114 mises à jour ; l'erreur quadratique moyenne log-log vaut 0,00103054.

Le paramètre theta = 0,555228 traduit une baisse du coût avec l'expérience : doubler le volume cumulé multiplie le coût estimé par environ 0,681, soit une baisse de 31,9 %. Le paramètre k = 9 682,85 fixe l'échelle du modèle ; sa valeur théorique à une unité est une extrapolation hors de la plage observée.

La standardisation de log(q) équilibre les courbures associées aux deux paramètres : le conditionnement de la Hessienne passe d'environ 2 871,98 à 1. Elle facilite la convergence de la descente de gradient. Les paramètres sont ensuite reconvertis dans les unités originales.

## Plan de production hebdomadaire

Avec les marges et capacités de l'énoncé, le programme linéaire continu donne 0 Urban, 32,5 Cargo et 65 Sport, pour une marge de 17 875 €/semaine. Les quantités fractionnaires sont autorisées dans le modèle demandé.

| Ressource | Utilisée / disponible | Restante | Prix dual |
|---|---:|---:|---:|
| Main-d'œuvre | 520 / 520 h | 0 h | 31,25 €/h |
| Aluminium | 1 072,5 / 1 100 kg | 27,5 kg | 0 €/kg |
| Temps machine | 260 / 260 h | 0 h | 6,25 €/h |

## Interprétation pour la direction

Au voisinage de ce plan, une heure de travail supplémentaire apporte 31,25 € de marge et une heure-machine 6,25 €. Acheter de l'aluminium supplémentaire seul n'apporte actuellement aucun gain. Ces gains marginaux se comparent aux coûts d'achat et restent valables tant que la structure du plan optimal ne change pas. Le modèle de coût et le plan de production sont deux analyses distinctes : les marges du programme linéaire restent celles de l'énoncé.

Contrôle croisé. Excel confirme le cas Urban/Cargo : 75/30, marge de 15 000 € et prix duaux 25 ; 3,333333 ; 0. Pour les trois produits, le rapport reçu maximise le temps machine (coefficients 2 ; 2 ; 3) au lieu de la marge : il ne valide donc pas le résultat du projet. Les résultats Python sont contrôlés par faisabilité, dualité et perturbation des capacités.
