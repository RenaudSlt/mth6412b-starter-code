### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 6a686500-2132-11eb-0a1a-6d0bc5b501a9
include("display.jl")

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
md"#### Tests"

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

# ╔═╡ 96f852b0-2132-11eb-24f0-ff3b19e64821
md"## "

# ╔═╡ 979e7dc0-2132-11eb-3b7f-6de3a5e098e7
md"## "

# ╔═╡ 9854fc80-2132-11eb-220e-1331b2d25af9
md"## "

# ╔═╡ 6ee624f0-2132-11eb-28da-8decd97e4ffc


# ╔═╡ Cell order:
# ╟─cc7ea210-2130-11eb-2b97-8523da844f3e
# ╟─2df20810-2132-11eb-022e-135d37088620
# ╟─34337100-2132-11eb-3ec2-df46e3cc07fb
# ╟─392bb820-2132-11eb-0682-59d3f3bc732c
# ╠═6a686500-2132-11eb-0a1a-6d0bc5b501a9
# ╟─8a7ab0ee-2132-11eb-27b6-e14b6729fc3b
# ╟─b1f6e040-2132-11eb-1c11-23ed2e7b6541
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
# ╠═96f852b0-2132-11eb-24f0-ff3b19e64821
# ╠═979e7dc0-2132-11eb-3b7f-6de3a5e098e7
# ╠═9854fc80-2132-11eb-220e-1331b2d25af9
# ╠═6ee624f0-2132-11eb-28da-8decd97e4ffc
