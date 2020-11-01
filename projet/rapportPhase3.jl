### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 65a04322-1490-11eb-1a4b-c37a5389d642
include("display.jl")

# ╔═╡ 15222ee0-1490-11eb-3be1-859208915b9a
md"# MTH6412B - Rapport de la phase 3"

# ╔═╡ 51c25af0-1490-11eb-0b55-5190f4edb3f7
md" Edward Hallé-Hannan 1843683\
Renaud Saltet 2035899"

# ╔═╡ 5a8e3f50-1490-11eb-1fb1-cd877fba1796
md" Lien vers le dépôt de la phase 3 : [https://github.com/RenaudSlt/mth6412b-starter-code/tree/phase3/projet](https://github.com/RenaudSlt/mth6412b-starter-code/tree/phase3/projet)"

# ╔═╡ 61789270-1490-11eb-347f-910bb931a3c5
md" ***"

# ╔═╡ 489a4cd0-1490-11eb-2257-cf5a23f90558
md"## Heuristiques d'accélération"

# ╔═╡ f026fbc0-14a8-11eb-0863-bfc54c5d0e83
md"#### Union via le rang"

# ╔═╡ 31990ce0-1546-11eb-29e3-fd6594533f12
md"L'heuristique d'union via le rang implique tout d'abord l'ajout de l'attribut `rank` au type `NodeTree` dans le fichier `nodetree.jl` (le fichier complet est affiché à la fin de cette sous-partie).

On ajoute l'attribut `rank_` dans la structure `NodeTree` :"

# ╔═╡ 7b701890-1546-11eb-065e-f177826eba4c
display("nodetree.jl",12,17)

# ╔═╡ cb774f20-1546-11eb-2a4a-3da9e2cbd647
md"Puis on modifie le constructeur pour que le rang soit par défaut égal à \\(0\\) :"

# ╔═╡ f5b78070-1546-11eb-2c56-a79a1c95958d
display("nodetree.jl",28,30)

# ╔═╡ fdf24860-1546-11eb-2805-b106f4d96daf
md"On créé enfin les accesseur et mutateur correspondants :"

# ╔═╡ 23fdd0b0-1547-11eb-1bbe-a1858953cf37
display("nodetree.jl",36,36)

# ╔═╡ 307b9980-1547-11eb-32e5-f917a966bb46
display("nodetree.jl",57,60)

# ╔═╡ 9045b1c0-1547-11eb-3581-c37f10664aca
md"Avec ces nouveaux éléments, on peut implémenter l'union via le rang dans l'algorithme de Kruskal. Lors de la fusion de deux composantes connexes, il suffit de remplacer la ligne : "

# ╔═╡ d5a84c50-1547-11eb-34f6-cbd5fcb5e256
display("kruskal_algorithm.jl",70,70)

# ╔═╡ f01a2a40-1547-11eb-1a18-2d60fa9691e2
md"Par les lignes suivantes :"

# ╔═╡ b177023e-1547-11eb-35d0-9fa84028e6ba
display("kruskal_algorithm.jl",65,73)

# ╔═╡ cdfb28f2-1548-11eb-097d-d5ae7713e848
md"Sur l'exemple de cours, les rangs à la fin de l'algorithme sont les suivants, ce qui est bien ce qu'on trouve à la main :"

# ╔═╡ c90097e0-1548-11eb-1aab-b19b9b7f7efe
md"
`a : 0`\
`b : 1`\
`c : 2`\
`d : 0`\
`e : 0`\
`f : 0`\
`g : 1`\
`h : 0`\
`i : 0`\
"

# ╔═╡ 46aac4b0-1547-11eb-2467-5bf41b78b345
md"Voici les fichiers `nodetree.jl` et `kruskal_algorithm.jl` complets :"

# ╔═╡ 51be9d3e-1547-11eb-381d-dd206346c4e8
display("nodetree.jl")

# ╔═╡ 7c3b3b50-1547-11eb-2a05-1b8cc2930d2c
display("kruskal_algorithm.jl")

# ╔═╡ 32165330-1546-11eb-1cc5-e1ea404a432b
md"#### Compression des chemins"

# ╔═╡ 37e4fd20-1546-11eb-17b3-23caa056b17f
md"Les modifications à faire se trouvent dans la fonction `get_root` du fichier `nodetree.jl`. Dejà, la fonction est renommée `get_root!` puisqu'elle modifie l'argument.

Ensuite, au lieu de faire un simple appel à la fonction de façon récursive, on la met en argument de la fonction `set_parent!`, puis on fait un appel à la fonction `get_parent` de façon à ne pas rester bloqué sur le nœud de départ `node` et ainsi modifier le parent de tous les nœuds sur le chemin entre le nœud `node` et sa racine."

# ╔═╡ 88170ce0-1549-11eb-1368-f705b3caf0e1
display("nodetree.jl",77,94)

# ╔═╡ a8fa2880-14a8-11eb-32ba-e78af019c947
md"## Questions théoriques sur le rang"

# ╔═╡ f35aaf80-14a8-11eb-0140-eddea076908e
md" *Montrer que le rang d’un noeud sera toujours inférieur à \\(|S|-1\\).*

Le rang d'un nœud ne peut augmenter que quand on fusionne deux composantes connexes. Or il y a *au plus* \\(|S|-1\\) fusions, donc le rang d'un nœud ne peut dépasser \\(|S|-1\\). "

# ╔═╡ dcf22f60-14a9-11eb-30c7-c591cc3f554f
md"\

*Montrer que le rang d’un noeud sera toujours inférieur à \\(⌊log_2(|S|)⌋\\).*

Il est évident qu'un nœud est toujours de rang inférieur ou égal au rang de son parent. Il suffit donc de montrer ce résultat pour les racines.

Montrons par induction qu'une racine de rang \\(k\\) a au moins \\(2^k\\) nœuds dans sa descendance.
* \\(k=0\\) : une racine de rang \\(0\\) a bien au moins un nœud (elle-même) dans sa descendance.
* \\(k→k+1\\) : supposons que toute racine de rang \\(k\\) ait au moins \\(2^k\\) nœuds dans sa descendance. Une racine de rang \\(k+1\\) est créée seulement en fusionnant deux arbres dont les racines sont toutes les deux de rang \\(k\\). Par hypothèse d'induction, ces racines possèdent au moins \\(2^k\\) nœuds dans leur descendance, donc l'arbre résultant de la fusion a au moins \\(2\times 2^k=2^{k+1}\\) nœuds. Ce qui montre le résultat.

Comme il n'y a que \\(|S|\\) nœuds dans l'arbre, et que les nœuds de rang maximum sont des racines, un nœud \\(s\in S\\) est forcément tel que \\(2^{\mathrm{rang}(s)}\leq|S|\\).

Comme le rang d'un nœud est un entier, cela finit de prouver \\(\mathrm{rang}(s)\leq ⌊log_2(|S|)⌋, \forall s\in S\\). "

# ╔═╡ cb702e00-14a8-11eb-1504-d5d91334db54
md"## Algorithme de Prim"

# ╔═╡ f447cea0-14a8-11eb-2c21-6d0cd4083610
md"Nous avons utilisé des nœuds *marqués*. Pour cela nous avons repris et modifié la structure `MarkedNode` du cours. La modification fondamentale réside dans le remplacement de l'attribut `distance_`, censé indiqué la distance du nœud à la source dans l'algorithme de Dijkstra, par l'attribut `min_weight_`, censé représenté le poids de l'arête légère entre le nœud et un nœud du sous-arbre.

Nous avons également surchargé l'opérateur `<` et ajouté une méthode `popfirst!` qui permet de retirer d'un vecteur de nœuds de type `MarkedNode` le nœud d'attribut `min_weight_` minimum puisque cela sert dans l'algorithme de Kruskal.

Le fichier `markednode.jl` est affiché ci-dessous."

# ╔═╡ 66763800-1af7-11eb-3924-7515fbb44a7d
display("markednode.jl")

# ╔═╡ 638a1490-1af7-11eb-1001-a5f7c7609a0a
md"Notre implémentation de l'algorithme de Prim se trouve dans le fichier 'prim_algorithm.jl' ci-dessous."

# ╔═╡ 140fad50-1afa-11eb-0cba-6bdcdd756ff5
display("prim_algorithm.jl")

# ╔═╡ 1aafd810-1afa-11eb-25f3-af9ce61c8cd5
md"La suite de cette partie est consacrée à l'explication de ce fichier.

On commence par créer une liste vide `visited_nodes` qui contiendra les nœuds déjà visités ainsi qu'une liste de nœuds à visiter `marked_node_queue` que l'on remplit avec les nœuds avec les nœuds de l'arbre interprétés en termes du type `MarkedNode`. On initie le poids du nœud source à \\(0\\)."

# ╔═╡ 2855cd30-1afa-11eb-0cff-810892662fe0
display("prim_algorithm.jl",26,44)

# ╔═╡ 3a8af1f0-1afb-11eb-3a4e-b119ac9eae14
md"La boucle de l'algorithme peut ensuite commencer. À chaque itération, le nœud non visité \\(u\\) de poid minimum est retiré de la liste `marked_nodes_queue`, est tout de suite considéré comme visité et est ajouté à la liste `visited_nodes`."

# ╔═╡ 369f5fe0-1afb-11eb-3588-11d8dc835567
display("prim_algorithm.jl",50,55)

# ╔═╡ 8afcaa20-1afb-11eb-12d3-0b27e75bab0e
md"On a ensuite besoin d'avoir accès aux voisins de \\(u\\). Pour cela nous avons créé la méthode `get_edges_from_node` dans le fichier `graph.jl` qui prend en argument un `AbstractNode` (donc en particulier un `MarkedNode`) et renvoie la liste des arêtes adjacentes à ce nœud."

# ╔═╡ f7d4e450-1afb-11eb-25d7-b3fda4009e39
display("graph.jl",92,107)

# ╔═╡ 944c4800-1afc-11eb-0451-edb926b6f8e5
md"Grâce à cela, on peut boucler sur les arêtes adjacentes au nœud \\(u\\) ce qui permet à la fois d'avoir les voisins de \\(u\\) mais aussi les poids des arêtes.

Pour chaque arête adjacente, on retrouve le `Node` voisin correspondant \\(v\_{node}\\), puis le `MarkedNode` associé \\(v\\) qui se trouve soit dans la liste des nœuds à visiter `marked_nodes_queue` soit dans la liste des nœuds déjà visités `visited_nodes`."

# ╔═╡ 89b4a450-1afc-11eb-277b-db20d756fcb7
display("prim_algorithm.jl",57,74)

# ╔═╡ 571fec10-1afd-11eb-0600-2d102052b263
md"Si \\(v\\) est le parent de \\(u\\), alors l'arête \\((u,v)\\) est l'arête légère à ajouter dans le sous-arbre à cette itération. D'où l'intérêt d'avoir gardé en mémoire les nœuds déjà visités."

# ╔═╡ 1b91fde0-1afe-11eb-1e04-f9ebb0762de1
display("prim_algorithm.jl",76,79)

# ╔═╡ 33eb5c10-1afe-11eb-0338-d5beb2513c2d
md"Ensuite, si le nœud \\(v\\) est déjà visité, on sort de la boucle. Sinon, on le \"relaxe\", c'est-à-dire que l'on change son attribut `min_weight_` seulement si le poids de l'arête \\((u,v)\\) est inférieur à sa valeur actuelle, auquel cas on décrète aussi que \\(v\\) est la parent de \\(v\\)."

# ╔═╡ 5aba5b70-1afe-11eb-3de0-6daf71a406c3
display("prim_algorithm.jl",84,88)

# ╔═╡ c3b33890-1afe-11eb-320e-c313a42befcd
md"Enfin, une fois sorti de la boucle sur les arête adjacentes à \\(u\\), on peut ajouter l'arête légère `edge_to_add` au sous-arbre (sauf à la première itération, i.e. si \\(u\\) est la source). On incrémente également le poids du sous-arbre."

# ╔═╡ ffb799d0-1afe-11eb-0228-95c8f0a48646
display("prim_algorithm.jl",92,96)

# ╔═╡ 935d5242-14a8-11eb-2963-575983bb56e1
md"## Tests"

# ╔═╡ 2afd5440-1aff-11eb-3b9b-39bff8a10b58
md"#### Exemple de cours"

# ╔═╡ 307c7ea0-1aff-11eb-0ae2-770497732d6a
md" Sur l'exemple de cours, nous trouvons le même arbre recouvrant minimal que dans le cours, et un poids total de 37, ce qui est le résultat attendu."

# ╔═╡ fe8fc630-1aff-11eb-2d50-3bff51cea6fc
md"#### Tests unitaires"

# ╔═╡ 0acbf220-1b00-11eb-3760-0f56ac6a6260
md" Nous avons réalisé un certains nombre de tests unitaires dans le fichier `unit_test_phase3` plus bas. Ils permettent dans un premier de tester la fonction `get_edges_from_node` du fichier `graph.jl`, la compression des chemins qui se trouve dans la méthode `get_root!` du fichier `nodeTree.jl`, la méthode `popfirst!` du fichier `markednode.jl`.

Dans un second temps, nous avons voulu vérifier que les algorithmes de Prim et de Kruskal donnaient des arbres de poids égaux pour l'exemple de cours ainsi que pour toutes les instances symétriques (sauf pa561 qui est trop longue à résoudre pour l'algorithme de Kruskal). On ne compare pas les arbres de recouvrement minimaux puisqu'ils peuvent être différents.

Voici le fichier `unit_test_phase3`"

# ╔═╡ 04733b30-1b01-11eb-3b3d-f5e6635a00c3
display("unit_test_phase3.jl")

# ╔═╡ 18b64dd0-1b01-11eb-1658-f77ed9c51e88
md"Le résultat de ces tests est le suivant."

# ╔═╡ 20ca05c0-1b01-11eb-26a0-af5ddb8ee64f
md"
`Test Summary:`\\(\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \\)`| Pass  Total`\
`multiple edge comparison | `\\(\ \ \ \ \ \ \ \\)` 2 `\\(\ \ \ \ \ \ \ \ \ \\)`    2`\
`Test Summary: `\\(\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \\)` | Pass  Total`\
`multiple edge comparison | `\\(\ \ \ \ \ \ \ \\)` 3 `\\(\ \ \ \ \ \ \ \\)` 3`\
`Test Summary:`\\(\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \\)`| Pass  Total`\
`multiple comparison of final weight for kruskal and prim |   13     13`\
`Test.DefaultTestSet(\"multiple comparison of final weight for kruskal and prim\", Any[], 13, false)`\
"

# ╔═╡ 43b741a0-1b02-11eb-1152-2183054749b4
md"Ainsi, nos implémentations des algorithmes de Kruskal et de Prim fournissent bien des arbres de recouvrement minimaux."

# ╔═╡ 150d1160-1b00-11eb-3d39-5940e6fc6411
md"#### Benchmark"

# ╔═╡ 1987eb1e-1b00-11eb-0c9f-4584112a864b
md"Nous avons remarqué que notre implémentation de l'algorithme de Prim était bien plus rapide que celle de l'algorithme de Kruskal. Nous sommes d'ailleurs parvenus à trouver un résultat pour l'instance `pa561`, ce que nous n'avions pas pu faire à la phase 2.

Nous avons fait un graphique montrant l'évolution du temps d'exécution en fonction de la dimension de l'instance pour les deux algorithmes. Ce graphique confirme notre constat. "

# ╔═╡ Cell order:
# ╟─15222ee0-1490-11eb-3be1-859208915b9a
# ╟─51c25af0-1490-11eb-0b55-5190f4edb3f7
# ╟─5a8e3f50-1490-11eb-1fb1-cd877fba1796
# ╟─61789270-1490-11eb-347f-910bb931a3c5
# ╠═65a04322-1490-11eb-1a4b-c37a5389d642
# ╟─489a4cd0-1490-11eb-2257-cf5a23f90558
# ╟─f026fbc0-14a8-11eb-0863-bfc54c5d0e83
# ╟─31990ce0-1546-11eb-29e3-fd6594533f12
# ╟─7b701890-1546-11eb-065e-f177826eba4c
# ╟─cb774f20-1546-11eb-2a4a-3da9e2cbd647
# ╟─f5b78070-1546-11eb-2c56-a79a1c95958d
# ╟─fdf24860-1546-11eb-2805-b106f4d96daf
# ╟─23fdd0b0-1547-11eb-1bbe-a1858953cf37
# ╟─307b9980-1547-11eb-32e5-f917a966bb46
# ╟─9045b1c0-1547-11eb-3581-c37f10664aca
# ╟─d5a84c50-1547-11eb-34f6-cbd5fcb5e256
# ╟─f01a2a40-1547-11eb-1a18-2d60fa9691e2
# ╟─b177023e-1547-11eb-35d0-9fa84028e6ba
# ╟─cdfb28f2-1548-11eb-097d-d5ae7713e848
# ╟─c90097e0-1548-11eb-1aab-b19b9b7f7efe
# ╟─46aac4b0-1547-11eb-2467-5bf41b78b345
# ╠═51be9d3e-1547-11eb-381d-dd206346c4e8
# ╠═7c3b3b50-1547-11eb-2a05-1b8cc2930d2c
# ╟─32165330-1546-11eb-1cc5-e1ea404a432b
# ╟─37e4fd20-1546-11eb-17b3-23caa056b17f
# ╟─88170ce0-1549-11eb-1368-f705b3caf0e1
# ╟─a8fa2880-14a8-11eb-32ba-e78af019c947
# ╟─f35aaf80-14a8-11eb-0140-eddea076908e
# ╟─dcf22f60-14a9-11eb-30c7-c591cc3f554f
# ╟─cb702e00-14a8-11eb-1504-d5d91334db54
# ╟─f447cea0-14a8-11eb-2c21-6d0cd4083610
# ╠═66763800-1af7-11eb-3924-7515fbb44a7d
# ╟─638a1490-1af7-11eb-1001-a5f7c7609a0a
# ╠═140fad50-1afa-11eb-0cba-6bdcdd756ff5
# ╟─1aafd810-1afa-11eb-25f3-af9ce61c8cd5
# ╟─2855cd30-1afa-11eb-0cff-810892662fe0
# ╟─3a8af1f0-1afb-11eb-3a4e-b119ac9eae14
# ╟─369f5fe0-1afb-11eb-3588-11d8dc835567
# ╟─8afcaa20-1afb-11eb-12d3-0b27e75bab0e
# ╟─f7d4e450-1afb-11eb-25d7-b3fda4009e39
# ╟─944c4800-1afc-11eb-0451-edb926b6f8e5
# ╟─89b4a450-1afc-11eb-277b-db20d756fcb7
# ╟─571fec10-1afd-11eb-0600-2d102052b263
# ╟─1b91fde0-1afe-11eb-1e04-f9ebb0762de1
# ╟─33eb5c10-1afe-11eb-0338-d5beb2513c2d
# ╟─5aba5b70-1afe-11eb-3de0-6daf71a406c3
# ╟─c3b33890-1afe-11eb-320e-c313a42befcd
# ╟─ffb799d0-1afe-11eb-0228-95c8f0a48646
# ╟─935d5242-14a8-11eb-2963-575983bb56e1
# ╟─2afd5440-1aff-11eb-3b9b-39bff8a10b58
# ╟─307c7ea0-1aff-11eb-0ae2-770497732d6a
# ╟─fe8fc630-1aff-11eb-2d50-3bff51cea6fc
# ╟─0acbf220-1b00-11eb-3760-0f56ac6a6260
# ╠═04733b30-1b01-11eb-3b3d-f5e6635a00c3
# ╟─18b64dd0-1b01-11eb-1658-f77ed9c51e88
# ╟─20ca05c0-1b01-11eb-26a0-af5ddb8ee64f
# ╟─43b741a0-1b02-11eb-1152-2183054749b4
# ╟─150d1160-1b00-11eb-3d39-5940e6fc6411
# ╟─1987eb1e-1b00-11eb-0c9f-4584112a864b
