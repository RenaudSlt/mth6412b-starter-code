### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 6f2bfb20-04e4-11eb-27f5-13ab53bb3434
include("display.jl")

# ╔═╡ 7140c6d0-04e3-11eb-0a12-53b3c375d2ce
md"# MTH6412B - Rapport de la phase 2 "

# ╔═╡ b32b2a90-04e3-11eb-33db-090692a410c0
md" Edward Hallé-Hannan 1843683\
Renaud Saltet 2035899"

# ╔═╡ d37130ae-04e3-11eb-2322-fd0f422aa7d5
md" Lien vers le dépôt de la phase 2 : [https://github.com/RenaudSlt/mth6412b-starter-code/tree/phase2/projet](https://github.com/RenaudSlt/mth6412b-starter-code/tree/phase2/projet)"

# ╔═╡ d49676d0-04e3-11eb-00c6-bb5a666d47c8
md" ***"

# ╔═╡ ecdbd8f0-05c1-11eb-1952-dded7022edc2


# ╔═╡ 3679e742-04e6-11eb-1c51-51b1e1e95ccd
md"### Structure des composantes connexes "

# ╔═╡ 7c3995f0-04e6-11eb-2cb0-8f1cfbc6afe5
md" Nous avons choisi de représenter une composante connexe comme un arbre puisque c'est sous cette forme qu'elle sera utilisée dans l'algorithme de Kruskal.

La structure d'arbre n'est pas explicitement créée. Nous avons créé un type `NodeTree` héritant du type `AbstractNode` et contenant trois attributs :

* des données de paramètre T
* un nom de type `String`
* un parent qui est aussi un `NodeTree` ou alors `Nothing`

Le type `NodeTree` est implémenté dans le fichier `nodeTree.jl`."

# ╔═╡ c31fd760-04f3-11eb-1b2b-098890ad84d6
display("nodeTree.jl")

# ╔═╡ e4c71b30-04f3-11eb-2797-392469c1f909
md" Deux méthodes remarquables du type `NodeTree` sont `get_root` et `same_tree`. La première permet de trouver la racine d'un noeud par une procédure récursive. La deuxième permet de dire si deux `NodeTrees` appartiennent au même arbre en comparant les racines.

Il nous a ensuite suffit d'ajouter l'accesseur `get_parent` et le mutateur `set_parent!` puisque les autre accesseurs et mutateurs sont hérités du type `AbstractNode`."

# ╔═╡ 41122730-04e6-11eb-1083-a304209afddd
md" *** "

# ╔═╡ 5044d6d2-04e6-11eb-3321-23253a9f779c
md"### Algorithme de Kruskal "

# ╔═╡ a151b52e-04f4-11eb-2e1a-191ea26f1232
md" Notre implémentation de l'algorithme de Kruskal se trouve dans le fichier `kruskal_algorithm.jl`. "

# ╔═╡ 7d14dac0-04e6-11eb-12ec-735cca753dd8
display("kruskal_algorithm.jl")

# ╔═╡ d99a9510-04f4-11eb-2ca9-7d84514893b4
md" La suite de cette partie est consacrée à l'explication de ce fichier.

L'implémentation commence par créer $n$ nœuds de type `NodeTree`, où $n$ est le nombre de nœuds du graphe, qui représentent les $n$ composantes connexes de départ. Cela correspond aux lignes ci-dessous :"

# ╔═╡ 55cf9c20-04f5-11eb-32da-6914e91e9e2f
display("kruskal_algorithm.jl", 26, 31)

# ╔═╡ 4d2a0470-04f5-11eb-2c94-23f9d944557d
md" L'algorithme de Kruskal est ensuite appliqué. L'arête de poids minimal est d'abord retirée grâce à la méthodé `popfirst!` créée à cet effet dans le fichier `edge.jl` comme montré ci-dessous.

Cette méthode nécessite au préalable la surcharge de l'opérateur < pour les objets de type `edge` en comparant les poids."

# ╔═╡ df0334c0-04f5-11eb-0903-3d84c52523ee
display("edge.jl", 68, 83)

# ╔═╡ 5e971e40-04f6-11eb-26b8-7bf11138db84
md" Ensuite, les noeuds de l'arête de poids minimal sont interprétés en termes des `NodeTrees` contenus dans `tree_nodes_array`."

# ╔═╡ 93e3ae10-04f6-11eb-22d1-11fa26e03e3d
display("kruskal_algorithm.jl", 38, 52)

# ╔═╡ a46ced00-04f6-11eb-2620-b3a09b98093e
md" Puis, si ces noeuds ne font pas partie de la même composante connexe, l'arête courrante est ajouté à l'arbre de poids minimal `edges_graph_min` et les composantes connexes sont fusionnée en décrétant que la racine de l'une devient le parent de l'autre.

De cette façon, l'arête ajoutée à l'arbre couvrant *n'est pas* nécessairement l'arête par laquelle les composantes connexes sont fusionnées."

# ╔═╡ 9be93530-04f6-11eb-0921-e92d9a40ab87
display("kruskal_algorithm.jl", 54, 62)

# ╔═╡ eba00c60-04f7-11eb-3998-dfb5e1c9a58f
md" On passe ensuite à l'itération suivante."

# ╔═╡ 4be32a60-04e6-11eb-3c96-b136ecd9b69a
md" *** "

# ╔═╡ 4cfadbf0-04e6-11eb-08fe-8923717ddc25
md"### Tests unitaires et instances "

# ╔═╡ 7dd78e80-04e6-11eb-2a85-61b5df06881d
md" Nous avons testé notre implémentation sur l'exemple des notes de cours à neuf nœuds et quatorze arêtes. Le graphe est construit dans le fichier `exemple_de_cours.jl` ci-dessous et la fonction `kruskal_algorithm` est appelée à la fin du fichier."

# ╔═╡ 342f4f30-058f-11eb-0c59-2fd4bedd5cdb
display("exemple_de_cours.jl")

# ╔═╡ 443af9b2-058f-11eb-0554-dfa20bb58b4f
md" Cela renvoie :"

# ╔═╡ e3899942-058f-11eb-36c0-fb6f16f1e5d0
md"
`>>> 8-element Array{Edge{Nothing},1}:`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"h\"), Node{Nothing}(nothing, \"g\"), 1)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"i\"), Node{Nothing}(nothing, \"c\"), 2)`\
 `>>> Edge{Nothing}(Node{Nothing}(nothing, \"f\"), Node{Nothing}(nothing, \"g\"), 2)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"a\"), Node{Nothing}(nothing, \"b\"), 4)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"f\"), Node{Nothing}(nothing, \"c\"), 4)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"c\"), Node{Nothing}(nothing, \"d\"), 7)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"a\"), Node{Nothing}(nothing, \"h\"), 8)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"e\"), Node{Nothing}(nothing, \"d\"), 9)`
"

# ╔═╡ a46760c0-0590-11eb-16b5-c1500bd98043
md" Nous avons effectué quelques tests unitaires dans le fichier `unit_test_phase2.jl` ci-dessous."

# ╔═╡ 9901beb0-0590-11eb-1d32-3beedde5f61b
display("unit_test_phase2.jl")

# ╔═╡ 562029b0-0590-11eb-28ff-d1f5fb9d81f6
md" Le programme principal `main.jl` ci-dessous permet de lire une instance `.tsp` du dossier `instances` et de renvoyer un arbre de recouvrement minimal du graphe concerné."

# ╔═╡ b0467890-0590-11eb-1353-21781028fc56
display("main.jl")

# ╔═╡ b73e8750-0590-11eb-0d3a-8fc11056cbff
md" Sur l'instance `gr17.tsp`, l'arbre de recouvrement est le suivant : "

# ╔═╡ d077e540-0590-11eb-3122-83c78445f6a8
md"
`>>> 16-element Array{Edge{Nothing},1}:`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"4\"), Node{Nothing}(nothing, \"13\"), 27)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"7\"), Node{Nothing}(nothing, \"8\"), 29)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"7\"), Node{Nothing}(nothing, \"17\"), 29)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"6\"), Node{Nothing}(nothing, \"8\"), 34)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"7\"), Node{Nothing}(nothing, \"13\"), 47)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"3\"), Node{Nothing}(nothing, \"15\"), 53)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"14\"), Node{Nothing}(nothing, \"15\"), 57)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"5\"), Node{Nothing}(nothing, \"11\"), 61)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"1\"), Node{Nothing}(nothing, \"13\"), 70)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"9\"), Node{Nothing}(nothing, \"12\"), 95)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"14\"), Node{Nothing}(nothing, \"17\"), 96)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"3\"), Node{Nothing}(nothing, \"11\"), 110)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"10\"), Node{Nothing}(nothing, \"11\"), 154)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"12\"), Node{Nothing}(nothing, \"16\"), 157)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"4\"), Node{Nothing}(nothing, \"9\"), 175)`\
`>>> Edge{Nothing}(Node{Nothing}(nothing, \"2\"), Node{Nothing}(nothing, \"5\"), 227)`
"

# ╔═╡ 9f9f30e0-05bd-11eb-3a26-091d04addadb
md" Nous avons enfin fait un graphique montrant l'évolution du temps d'exécution en fonction de la dimension de l'instance.

Le temps d'exécution pour une instance donnée est le temps moyen sur dix exécutions.

À cette fin, nous avons utilisé la fonction `timeit` introduite dans le cours et qui se trouve dans le fichier `timeit.jl' ci-dessous."

# ╔═╡ aed0d9a0-05be-11eb-10dd-59286a805c94
display("timeit.jl")

# ╔═╡ bd907c1e-05be-11eb-0574-917b5e8f0dd0
md" Le test est ensuite effectué dans le fichier `benchmark.jl` ci-dessous. Il consiste essentiellement à répéter les instruction du fichier principal `main.jl` sur toutes instances et à sauvegarder les résultats de la fonction `timeit` à chaque fois.

L'instance `pa561.jl` n'a pas été prise en compte puisque que le résultat est trop long à calculer."

# ╔═╡ d6a67390-05be-11eb-37fe-7b60de102e8e
display("benchmark.jl")

# ╔═╡ 1c93c1f0-05bf-11eb-3de6-9b8114a8b1c2
md" Les résultats se trouve à la page suivante. Le premier graphe est en échelle normale et le second en échelle logarithmique. On voit que la tendance n'est pas linéaire, mais pas exponentielle non plus. "

# ╔═╡ Cell order:
# ╟─7140c6d0-04e3-11eb-0a12-53b3c375d2ce
# ╟─b32b2a90-04e3-11eb-33db-090692a410c0
# ╟─d37130ae-04e3-11eb-2322-fd0f422aa7d5
# ╟─d49676d0-04e3-11eb-00c6-bb5a666d47c8
# ╟─ecdbd8f0-05c1-11eb-1952-dded7022edc2
# ╠═6f2bfb20-04e4-11eb-27f5-13ab53bb3434
# ╟─3679e742-04e6-11eb-1c51-51b1e1e95ccd
# ╟─7c3995f0-04e6-11eb-2cb0-8f1cfbc6afe5
# ╠═c31fd760-04f3-11eb-1b2b-098890ad84d6
# ╟─e4c71b30-04f3-11eb-2797-392469c1f909
# ╟─41122730-04e6-11eb-1083-a304209afddd
# ╟─5044d6d2-04e6-11eb-3321-23253a9f779c
# ╟─a151b52e-04f4-11eb-2e1a-191ea26f1232
# ╠═7d14dac0-04e6-11eb-12ec-735cca753dd8
# ╟─d99a9510-04f4-11eb-2ca9-7d84514893b4
# ╠═55cf9c20-04f5-11eb-32da-6914e91e9e2f
# ╟─4d2a0470-04f5-11eb-2c94-23f9d944557d
# ╠═df0334c0-04f5-11eb-0903-3d84c52523ee
# ╟─5e971e40-04f6-11eb-26b8-7bf11138db84
# ╠═93e3ae10-04f6-11eb-22d1-11fa26e03e3d
# ╟─a46ced00-04f6-11eb-2620-b3a09b98093e
# ╠═9be93530-04f6-11eb-0921-e92d9a40ab87
# ╟─eba00c60-04f7-11eb-3998-dfb5e1c9a58f
# ╟─4be32a60-04e6-11eb-3c96-b136ecd9b69a
# ╟─4cfadbf0-04e6-11eb-08fe-8923717ddc25
# ╟─7dd78e80-04e6-11eb-2a85-61b5df06881d
# ╠═342f4f30-058f-11eb-0c59-2fd4bedd5cdb
# ╟─443af9b2-058f-11eb-0554-dfa20bb58b4f
# ╟─e3899942-058f-11eb-36c0-fb6f16f1e5d0
# ╟─a46760c0-0590-11eb-16b5-c1500bd98043
# ╠═9901beb0-0590-11eb-1d32-3beedde5f61b
# ╟─562029b0-0590-11eb-28ff-d1f5fb9d81f6
# ╠═b0467890-0590-11eb-1353-21781028fc56
# ╟─b73e8750-0590-11eb-0d3a-8fc11056cbff
# ╟─d077e540-0590-11eb-3122-83c78445f6a8
# ╟─9f9f30e0-05bd-11eb-3a26-091d04addadb
# ╠═aed0d9a0-05be-11eb-10dd-59286a805c94
# ╟─bd907c1e-05be-11eb-0574-917b5e8f0dd0
# ╠═d6a67390-05be-11eb-37fe-7b60de102e8e
# ╟─1c93c1f0-05bf-11eb-3de6-9b8114a8b1c2
