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
display("nodetree.jl",26,28)

# ╔═╡ fdf24860-1546-11eb-2805-b106f4d96daf
md"On créé enfin les accesseur et mutateur correspondants :"

# ╔═╡ 23fdd0b0-1547-11eb-1bbe-a1858953cf37
display("nodetree.jl",34,34)

# ╔═╡ 307b9980-1547-11eb-32e5-f917a966bb46
display("nodetree.jl",55,58)

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
display("nodetree.jl",70,79)

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


# ╔═╡ 935d5242-14a8-11eb-2963-575983bb56e1
md"## Tests"

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
# ╠═f447cea0-14a8-11eb-2c21-6d0cd4083610
# ╟─935d5242-14a8-11eb-2963-575983bb56e1
