### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 6a686500-2132-11eb-0a1a-6d0bc5b501a9
include("display.jl")

# ╔═╡ 284f3500-2da7-11eb-01bb-8b18721a7ff8
include("display_img.jl")

# ╔═╡ cc7ea210-2130-11eb-2b97-8523da844f3e
md"# MTH6412B - Rapport de la phase 4"

# ╔═╡ 2df20810-2132-11eb-022e-135d37088620
md" Edward Hallé-Hannan 1843683\
Renaud Saltet 2035899"

# ╔═╡ 34337100-2132-11eb-3ec2-df46e3cc07fb
md" Lien vers le dépôt de la phase 4 : [https://github.com/RenaudSlt/mth6412b-starter-code/tree/phase4/projet](https://github.com/RenaudSlt/mth6412b-starter-code/tree/phase4/projet)"

# ╔═╡ 392bb820-2132-11eb-0682-59d3f3bc732c
md" ***"

# ╔═╡ 8a7ab0ee-2132-11eb-27b6-e14b6729fc3b
md"## Algorithme RSL"

# ╔═╡ b1f6e040-2132-11eb-1c11-23ed2e7b6541
md"#### Modifications de l'implémentation de  l'algorithme de Prim"

# ╔═╡ 1277a8e0-2134-11eb-039a-5ff5e9101f4a
md" Nous avons effectué quelques modifications à notre implémentation de l'algorithme de Prim de la phase 3 afin de pouvoir parcourir l'arbre de recouvrement minimal en préordre.

Notre implémentation utilisait des nœuds de type `MarkedNode` qui possèdait un attribut `parent_` mais pas d'attribut `children_`, ce qui est pourtant nécessaire pour un parcours de l'arbre depuis la racine. Nous avons donc ajouté cet attribut ainsi que les accesseurs et mutateurs correspondant."

# ╔═╡ a7a6775e-2135-11eb-15ec-61a5327c4948
display("markednode.jl",13,20)

# ╔═╡ 0f27cfb0-2136-11eb-0dd8-09e166004a49
display("markednode.jl",44,44)

# ╔═╡ 3856b812-2136-11eb-2bbd-7bb39aec3523
display("markednode.jl",87,90)

# ╔═╡ 5134fdb0-2136-11eb-2028-a71ba05faae6
display("markednode.jl",95,98)

# ╔═╡ 5dbdc300-2136-11eb-0413-6b840eec665d
md" La fonction `set_parent!()` a été modifiée en conséquence puisque quand un nœud change de parent il faut l'ajouter aux enfants du nouveau parent et le retirer aux enfants de l'ancien, s'il y en avait un."

# ╔═╡ 96409ea0-2136-11eb-0990-699b7b079c4f
display("markednode.jl",74,82)

# ╔═╡ 2764cc40-2136-11eb-1913-673a2aacca53
md"Nous avons également ajouté la fonction `get_root()` qui n'existait pas. cela va nous servir dans l'algorithme RSL."

# ╔═╡ 16048e40-2136-11eb-02b9-3765334ac3ac
display("markednode.jl",47,55)

# ╔═╡ adbfbee0-2135-11eb-0c86-3b8216c83a47
md" Voici le fichier `markednode.jl` au complet."

# ╔═╡ 106c4120-2137-11eb-38c2-57623a8c8710
display("markednode.jl")

# ╔═╡ 17651330-2137-11eb-21df-158fad47c18e
md" Grâce à la modification de la fonction `set_parent!()`, l'implémentation de l'algorithme de Prim n'a pas changée dans le fichier `prim_algorithm.jl`."

# ╔═╡ 02d2af70-2134-11eb-3475-27ce195b5314
md"#### Modifications de l'implémentation de l'algorithme de Kruskal"

# ╔═╡ 138bb0f0-2134-11eb-2038-9fb25e5c7031
md" Notre implémentation de l'algorithme de Kruskal présentait trois écueils si l'on voulait l'utiliser dans l'algorithme RSL.

Le premier est qu'on ne peut pas naturellement choisir la source. Le deuxième est que la façon dont sont fusionnées les composantes connexes engendre un arbre contenant des arcs qui n'existent pas forcément dans le graphe de départ. Seules les arêtes renvoyées sont correctes. Le troisième est dû à la compression des chemins : le parent de chaque nœud (de type `NodeTree`) est en fait sa racine.

Nous avons contourné le problème de la façon suivante. Un nouveau graphe est crée à partir des nœuds du graphe initial est des arêtes renvoyées par l'algorithme de Kruskal. Ce graphe, qui n'est autre que l'arbre de recouvrement minimal renvoyé par l'algorithme de Kruskal, est donné en argument à l'algorithme de Prim, avec lequel on peut choisir la source.

Tout cela est effectué dans la fonction `kruskal_by_prim()` ajoutée à la fin du fichier `kruskal_algorithm.jl` ci-dessous." 

# ╔═╡ de6733d0-2139-11eb-3efa-cf7d65f4c035
display("kruskal_algorithm.jl")

# ╔═╡ 6a29b4b0-213a-11eb-31b7-a94f1bf72487
md"#### Implémentation de l'algorithme RSL"

# ╔═╡ 7eaa4580-213a-11eb-1848-03a334bc954c
md" Notre implémentation de l'algorithme RSL se trouve dans le fichier `rsl_algorithm.jl` ci-dessous."

# ╔═╡ a1a05070-213a-11eb-20da-3db4af18b8ae
display("rsl_algorithm.jl")

# ╔═╡ a8a75350-213a-11eb-0e57-0b68cb928dfe
md"La suite de cette sous-partie est dédiée à l'explication de ce fichier.

La fonction `preordre()` est définie en dehors de la fonction principale car elle est récursive. Il y a deux différences avec la fonction du cours. La première est qu'au lieu d'afficher les nœuds au fur et à mesure du parcours de l'arbre, on les mémorise dans un vecteur `route` donné en argument. La deuxième est qu'au lieu de parcourir l'enfant de gauche, puis celui de droite comme dans un arbre binaire, on boucle sur tous les enfants puisqu'il y en a un nombre arbitraire."

# ╔═╡ d1b211e0-213a-11eb-0afc-f199dc549093
display("rsl_algorithm.jl",10,16)

# ╔═╡ 89bb6980-213b-11eb-1593-fbdb14bb13b2
md" L'algorithme prend trois arguments : le graphe, l'algorithme permettant de trouver un arbre de recouvrement minimal (Kruskal ou Prim) et un nœud source qui est par défaut le premier nœud du graphe."

# ╔═╡ 8abd702e-213b-11eb-113a-dbfa8afc15b1
display("rsl_algorithm.jl",27,27)

# ╔═╡ dbc83410-213b-11eb-2401-c7381c77649d
md"Après avoir crée un arbre de recouvrement minimal avec la méthode prescrite, on mémorise les nœuds parcourus en pré-ordre dans `route_nodes`, ce qui nous donne une tournée."

# ╔═╡ 0b3466b0-213c-11eb-1d27-f5f82c756a7e
display("rsl_algorithm.jl",29,37)

# ╔═╡ 216f51b0-213c-11eb-0971-031ce9efa055
md"On retrouve enfin les arêtes correspondant à cette tournée, on les mémorise dans `route_edges` et on calcul le cout total, sans oublier de retourner au nœud de départ à la fin."

# ╔═╡ 5bd9d910-213c-11eb-2cd4-f1f4157bb660
display("rsl_algorithm.jl",39,61)

# ╔═╡ 62bdc8f0-214f-11eb-19c3-8b563e1716da
md"#### Premiers tests"

# ╔═╡ 67f14450-214f-11eb-3ffa-d51f5e758c23
md" Nous avons testé l'algorithme avec toutes les instances TSP symétriques en comparant le poids de la tournée renvoyée au poids optimal indiqué sur le site web [http://comopt.ifi.uni-heidelberg.de/software/TSPLIB95/STSP.html](http://comopt.ifi.uni-heidelberg.de/software/TSPLIB95/STSP.html).

Le fichier faisant cela est `results_rsl.jl`. Nous ne l'avons pas affiché dans le rapport car seul son résultat ci-dessous est intéressant. On a ajouté trois points d'exclamation `!!!` quand l'inégalité entre le poids trouvé et double du poids optimal n'était pas respectée. "

# ╔═╡ 084df880-2150-11eb-0811-9365c0f2147c
md"
`Kruskal`\
`bayg29, poids trouvé : 2210, poids optimal : 1610, 2210 <= 2 * 1610`\
`bays29, poids trouvé : 4846, poids optimal : 2020, 4846 > 2 * 2020 !!!`\
`brazil58, poids trouvé : 29282, poids optimal : 25395, 29282 <= 2 * 25395`\
`brg180, poids trouvé : 259290, poids optimal : 1950, 259290 > 2 * 1950 !!!`\
`dantzig42, poids trouvé : 956, poids optimal : 699, 956 <= 2 * 699`\
`fri26, poids trouvé : 1112, poids optimal : 937, 1112 <= 2 * 937`\
`gr120, poids trouvé : 9202, poids optimal : 6942, 9202 <= 2 * 6942`\
`gr17, poids trouvé : 2352, poids optimal : 2085, 2352 <= 2 * 2085`\
`gr21, poids trouvé : 3803, poids optimal : 2707, 3803 <= 2 * 2707`\
`gr24, poids trouvé : 1607, poids optimal : 1272, 1607 <= 2 * 1272`\
`gr48, poids trouvé : 6897, poids optimal : 5046, 6897 <= 2 * 5046`\
`hk48, poids trouvé : 15184, poids optimal : 11461, 15184 <= 2 * 11461`\
`swiss42, poids trouvé : 3282, poids optimal : 1273, 3282 > 2 * 1273 !!!`

`Prim`\
`bayg29, poids trouvé : 2193, poids optimal : 1610, 2193 <= 2 * 1610`\
`bays29, poids trouvé : 5354, poids optimal : 2020, 5354 > 2 * 2020 !!!`\
`brazil58, poids trouvé : 30336, poids optimal : 25395, 30336 <= 2 * 25395`\
`brg180, poids trouvé : 118860, poids optimal : 1950, 118860 > 2 * 1950 !!!`\
`dantzig42, poids trouvé : 916, poids optimal : 699, 916 <= 2 * 699`\
`fri26, poids trouvé : 1136, poids optimal : 937, 1136 <= 2 * 937`\
`gr120, poids trouvé : 9919, poids optimal : 6942, 9919 <= 2 * 6942`\
`gr17, poids trouvé : 2352, poids optimal : 2085, 2352 <= 2 * 2085`\
`gr21, poids trouvé : 3738, poids optimal : 2707, 3738 <= 2 * 2707`\
`gr24, poids trouvé : 1641, poids optimal : 1272, 1641 <= 2 * 1272`\
`gr48, poids trouvé : 7187, poids optimal : 5046, 7187 <= 2 * 5046`\
`hk48, poids trouvé : 14905, poids optimal : 11461, 14905 <= 2 * 11461`\
`pa561.tsp, poids trouvé : 3872, poids optimal : 2763, 3872 <= 2 * 2763`\
`swiss42, poids trouvé : 3398, poids optimal : 1273, 3398 > 2 * 1273 !!!`
"

# ╔═╡ 31516ea0-2151-11eb-2fec-6122b537a0fa
md" On voit que l'inégalité n'est pas respectée pour les instances `bays29`, `brg180` et `swiss42`, que ce soit avec l'algorithme de Kruskal ou celui de Prim, en laissant la source par défaut. Nous avons donc fait un programme permettant de trouver, pour une instance donnée, tous les triplets de nœuds \\(u,v,w\\) tels que \\(c(u,w)>c(u,v)+c(v,w)\\). Ce programme se trouve dans le fichier `condition_rsl.jl` qui n'est pas affiché dans ce rapport. Il se trouve que toutes les instances ont de tels sommets, donc il est normal que l'inégalité entre le poids trouvé et double du poids optimal ne soit pas toujours vérifiée. "

# ╔═╡ 92b578e0-2132-11eb-013e-d5292e2a9796
md"## Algorithme HK"

# ╔═╡ 9a467930-2d9c-11eb-0d2e-272a0f9bd4f6


# ╔═╡ 96f852b0-2132-11eb-24f0-ff3b19e64821
md"## Ajustement des paramètres"

# ╔═╡ 7ac87e00-2d9c-11eb-3edb-49862d16f37c
md"### Paramètres de l'algorithme RSL"

# ╔═╡ 93942600-2d9c-11eb-1bbf-cb067b1b2b0a
md"Les deux paramètres à ajuster dans l'algorithme RSL sont la méthode de recherche d'un arbre de recouvrement minimal (Kruskal ou Prim) et le sommet privilégié (la racine). Étant donné la relative rapidité de l'algorithe RSL, nous avons pu explorer les valeurs possibles de façon exhaustive pour la plupart des instances afin de trouver les meilleurs paramètres pour chacune d'entre elle.

Pour les instances de taille inférieure à 100 (toutes sauf br180, gr120 et pa561) nous avons exploré les valeurs de façon exhaustive, c'est-à-dire les deux algorithmes de recouvrement Kruskal et Prim en prenant tour à tour chaque nœud comme racine.

Pour les deux instances br180 et gr120, nous avons testé les deux algorithmes de recouvrement mais étant donné la lenteur de notre implémentation de la méthode Kruskal et le grand nombre de nœuds nous n'avons pas essayé de prendre chaque nœud comme racine avec la méthode Kruskal.\
Afin de choisir judicieusement les nœuds les plus prometteurs, nous avons essayé sur les petites instances de trouver une relation entre le choix du nœud racine et la valeur de la tournée, ce qui nous aurait permis d'utiliser cette relation pour les grandes instances. Pour cela nous avons tracé le poids de la tournée obtenue en fonction de la somme et de la variance des poids des arêtes incidentes au nœud racine. Cela n'a pas porté ses fruits car on ne distingue aucune tendance sur ces tracés (voir dossier `relation_racine_resultat_rsl` à la racine si besoin).\
Ainsi, pour les instances br180 et gr120 avec la méthode Kruskal, nous avons finalement essayé respectivement un nœud sur 10 et un nœud sur 8 (et tous les nœuds avec la méthode Prim).

Pour la plus grande instance pa561, la méthode Kruskal est exclue puisqu'on n'obtient pas de résultat en temps raisonnable. Nous avons donc essayé un nœud sur 50 avec la méthode Prim.

La recherche des meilleurs paramètres pour chaque instance se fait dans le fichier `rsl_parameters.jl` qui n'est pas affiché dans ce rapport. Les résultats ont été sauvegardés dans un dictionnaire (ci-dessous) contenant pour chaque instance les meilleures paramètres et le poids de la meilleure tournée obtenue."

# ╔═╡ 7202e8f0-2da1-11eb-2667-0507b4c9c2c3
md"
`best_parameters_rsl = Dict(`\
`\"brazil58\" => [\"prim\", 46, 28121],`\
`\"gr17\" => [\"kruskal\", 7, 2210],`\
`\"bayg29\" => [\"kruskal\", 17, 2014],`\
`\"gr120\" => [\"kruskal\", 104, 8982],`\
`\"swiss42\" => [\"kruskal\", 32, 1587],`\
`\"brg180\" => [\"prim\", 130, 75460],`\
`\"pa561.tsp\" => [\"prim\", 450, 3855],`\
`\"gr21\" => [\"prim\", 13, 2968],`\
`\"dantzig42\" => [\"prim\", 4, 890],`\
`\"fri26\" => [\"prim\", 2, 1073],`\
`\"hk48\" => [\"kruskal\", 20, 13939],`\
`\"gr48\" => [\"prim\", 39, 6680],`\
`\"gr24\" => [\"prim\", 13, 1519],`\
`\"bays29\" => [\"kruskal\", 14, 2313])`
"

# ╔═╡ 903ee080-2d9c-11eb-22f9-194f1ce83ccf
md"### Paramètres de l'algorithme HK"

# ╔═╡ 94404480-2d9c-11eb-2d52-4bedd4fe1804


# ╔═╡ 979e7dc0-2132-11eb-3b7f-6de3a5e098e7
md"## Résultats"

# ╔═╡ 83401920-2da2-11eb-357c-8f1d3f8bf278
md"Les résultats présentés dans cette section sont les erreurs relatives avec une tournée optimale et l'affichage des tournées obtenues quand cela est possible.

**Ces résultats sont reproductibles grâce aux fichiers `main_rsl.jl` et `main_hk.jl`.**

Pour cela, il faut :
* ouvrir un REPL et se placer dans le dossier `mth6412b-starter-code`,
* entrer la commande `include(\"projet/main_rsl.jl\")` (pour RSL, sinon `main_hk.jl`),
* entrer la commande `main_rsl(\"gr24.tsp\")` (pour l'instance gr24)

Ainsi, l'algorithme RSL va s'exécuter sur l'instance gr24 avec les meilleurs paramètres retenus dans le dictionnaires `best_parameters_rsl`.

Le résultat s'affiche comme suit :"

# ╔═╡ 01f2ade0-2da4-11eb-0d7c-4952127893e2
md"
`ALGORITHME RSL`

`instance : gr24`\
`meilleurs paramètres : prim avec comme noeud racine 13`\
`résultat : 1519`\
`écart relatif avec une tournée optimale : 19.42%`
"

# ╔═╡ 6adc21b0-2da4-11eb-08ab-f53337b83688
md"Si de plus l'instance est affichable (bayg29, bays29, dantzig42, gr120), la tournée obtenue va s'afficher."

# ╔═╡ 43295630-2d9d-11eb-0cd1-f9c2549fa9e8
md"### Résultats de l'algorithme RSL"

# ╔═╡ e8929140-2da7-11eb-31fd-0bca200d63c9
md"Voici les erreurs relatives avec une tournée optimale pour chaque instance :"

# ╔═╡ fb43e050-2da7-11eb-3a58-8ffac64ed1fb
md"
`bayg29 : 25.09%`\
`bays29 : 14.5%`\
`brazil58 : 10.73%`\
`brg180 : 3769.74%`\
`dantzig42 : 27.32%`\
`fri26 : 14.51%`\
`gr120 : 29.39%`\
`gr17 : 6.0%`\
`gr21 : 9.64%`\
`gr24 : 19.42%`\
`gr48 : 32.38%`\
`hk48 : 21.62%`\
`pa561 : 39.52%`\
`swiss42 : 24.67%`
"

# ╔═╡ 52575470-2da9-11eb-317c-6110f116fb4d
md"Les erreurs relatives sont comprises entre 6% et 40% - sauf sur brg180 - avec globalement une augmentation de l'erreur avec la taille du problème.

L'erreur sur l'instance brg180 est extrêment elevée (3769.74%) ce qui reflète que la tournée obtenue, de poids 75460, n'a rien à voir avec la tournée optimale, de poids 1950."

# ╔═╡ 627d0c12-2da8-11eb-2a81-8d5e5b4dc045
md"Voici l'affichage des tournées obtenus pour les instances bayg29, bays29, dantzig42 et gr120."

# ╔═╡ 852fa560-2da8-11eb-3311-2fff25e4ba54
md"**bayg29**"

# ╔═╡ 497dd0f0-2da8-11eb-0aa0-c7d62f5e8410
display_img("best_tour_RSL_bayg29.png")

# ╔═╡ 9333c010-2da8-11eb-285a-638a346aee85
md"**bays29**"

# ╔═╡ 57c44cd0-2d9d-11eb-3c3b-07c594781c93
display_img("best_tour_RSL_bays29.png")

# ╔═╡ 9acbb850-2da8-11eb-0164-4da7377ac6a4
md"**dantzig42**"

# ╔═╡ 450a4a30-2da8-11eb-212c-85abdfb8b1c7
display_img("best_tour_RSL_dantzig42.png")

# ╔═╡ a1bee50e-2da8-11eb-2031-099d7cc7473f
md"**gr120**"

# ╔═╡ 53a8a910-2da8-11eb-1bcd-d38b469da024
display_img("best_tour_RSL_gr120.png")

# ╔═╡ 4a519cb0-2d9d-11eb-3f6b-ad1e2dcb6a58
md"### Résultats de l'algorithme HK"

# ╔═╡ 58759b70-2d9d-11eb-1f5c-e929ff2c16ce


# ╔═╡ 4b32ade0-2d9d-11eb-2fe1-b75b74680b94
md"### Résultats globaux"

# ╔═╡ 6ee624f0-2132-11eb-28da-8decd97e4ffc


# ╔═╡ Cell order:
# ╟─cc7ea210-2130-11eb-2b97-8523da844f3e
# ╟─2df20810-2132-11eb-022e-135d37088620
# ╟─34337100-2132-11eb-3ec2-df46e3cc07fb
# ╟─392bb820-2132-11eb-0682-59d3f3bc732c
# ╠═6a686500-2132-11eb-0a1a-6d0bc5b501a9
# ╠═284f3500-2da7-11eb-01bb-8b18721a7ff8
# ╟─8a7ab0ee-2132-11eb-27b6-e14b6729fc3b
# ╠═b1f6e040-2132-11eb-1c11-23ed2e7b6541
# ╟─1277a8e0-2134-11eb-039a-5ff5e9101f4a
# ╟─a7a6775e-2135-11eb-15ec-61a5327c4948
# ╟─0f27cfb0-2136-11eb-0dd8-09e166004a49
# ╟─3856b812-2136-11eb-2bbd-7bb39aec3523
# ╟─5134fdb0-2136-11eb-2028-a71ba05faae6
# ╟─5dbdc300-2136-11eb-0413-6b840eec665d
# ╟─96409ea0-2136-11eb-0990-699b7b079c4f
# ╟─2764cc40-2136-11eb-1913-673a2aacca53
# ╟─16048e40-2136-11eb-02b9-3765334ac3ac
# ╟─adbfbee0-2135-11eb-0c86-3b8216c83a47
# ╠═106c4120-2137-11eb-38c2-57623a8c8710
# ╟─17651330-2137-11eb-21df-158fad47c18e
# ╟─02d2af70-2134-11eb-3475-27ce195b5314
# ╟─138bb0f0-2134-11eb-2038-9fb25e5c7031
# ╠═de6733d0-2139-11eb-3efa-cf7d65f4c035
# ╟─6a29b4b0-213a-11eb-31b7-a94f1bf72487
# ╟─7eaa4580-213a-11eb-1848-03a334bc954c
# ╠═a1a05070-213a-11eb-20da-3db4af18b8ae
# ╟─a8a75350-213a-11eb-0e57-0b68cb928dfe
# ╟─d1b211e0-213a-11eb-0afc-f199dc549093
# ╟─89bb6980-213b-11eb-1593-fbdb14bb13b2
# ╟─8abd702e-213b-11eb-113a-dbfa8afc15b1
# ╟─dbc83410-213b-11eb-2401-c7381c77649d
# ╟─0b3466b0-213c-11eb-1d27-f5f82c756a7e
# ╟─216f51b0-213c-11eb-0971-031ce9efa055
# ╟─5bd9d910-213c-11eb-2cd4-f1f4157bb660
# ╟─62bdc8f0-214f-11eb-19c3-8b563e1716da
# ╟─67f14450-214f-11eb-3ffa-d51f5e758c23
# ╟─084df880-2150-11eb-0811-9365c0f2147c
# ╟─31516ea0-2151-11eb-2fec-6122b537a0fa
# ╟─92b578e0-2132-11eb-013e-d5292e2a9796
# ╠═9a467930-2d9c-11eb-0d2e-272a0f9bd4f6
# ╟─96f852b0-2132-11eb-24f0-ff3b19e64821
# ╟─7ac87e00-2d9c-11eb-3edb-49862d16f37c
# ╟─93942600-2d9c-11eb-1bbf-cb067b1b2b0a
# ╟─7202e8f0-2da1-11eb-2667-0507b4c9c2c3
# ╟─903ee080-2d9c-11eb-22f9-194f1ce83ccf
# ╠═94404480-2d9c-11eb-2d52-4bedd4fe1804
# ╟─979e7dc0-2132-11eb-3b7f-6de3a5e098e7
# ╟─83401920-2da2-11eb-357c-8f1d3f8bf278
# ╟─01f2ade0-2da4-11eb-0d7c-4952127893e2
# ╟─6adc21b0-2da4-11eb-08ab-f53337b83688
# ╟─43295630-2d9d-11eb-0cd1-f9c2549fa9e8
# ╟─e8929140-2da7-11eb-31fd-0bca200d63c9
# ╟─fb43e050-2da7-11eb-3a58-8ffac64ed1fb
# ╟─52575470-2da9-11eb-317c-6110f116fb4d
# ╟─627d0c12-2da8-11eb-2a81-8d5e5b4dc045
# ╟─852fa560-2da8-11eb-3311-2fff25e4ba54
# ╟─497dd0f0-2da8-11eb-0aa0-c7d62f5e8410
# ╟─9333c010-2da8-11eb-285a-638a346aee85
# ╟─57c44cd0-2d9d-11eb-3c3b-07c594781c93
# ╟─9acbb850-2da8-11eb-0164-4da7377ac6a4
# ╟─450a4a30-2da8-11eb-212c-85abdfb8b1c7
# ╟─a1bee50e-2da8-11eb-2031-099d7cc7473f
# ╟─53a8a910-2da8-11eb-1bcd-d38b469da024
# ╟─4a519cb0-2d9d-11eb-3f6b-ad1e2dcb6a58
# ╠═58759b70-2d9d-11eb-1f5c-e929ff2c16ce
# ╟─4b32ade0-2d9d-11eb-2fe1-b75b74680b94
# ╠═6ee624f0-2132-11eb-28da-8decd97e4ffc
