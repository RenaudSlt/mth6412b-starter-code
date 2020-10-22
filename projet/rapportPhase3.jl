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
md"### Heuristiques d'accélération"

# ╔═╡ f026fbc0-14a8-11eb-0863-bfc54c5d0e83


# ╔═╡ 8fc75a40-14a8-11eb-0989-b394a583dc01
md" *** "

# ╔═╡ a8fa2880-14a8-11eb-32ba-e78af019c947
md"### Questions théoriques sur le rang"

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

# ╔═╡ 91189262-14a8-11eb-278a-57100492d404
md" *** "

# ╔═╡ cb702e00-14a8-11eb-1504-d5d91334db54
md"### Algorithme de Prim"

# ╔═╡ f447cea0-14a8-11eb-2c21-6d0cd4083610


# ╔═╡ 92bc0930-14a8-11eb-24b8-25ed62df9b62
md" *** "

# ╔═╡ 935d5242-14a8-11eb-2963-575983bb56e1
md"### Tests"

# ╔═╡ Cell order:
# ╟─15222ee0-1490-11eb-3be1-859208915b9a
# ╟─51c25af0-1490-11eb-0b55-5190f4edb3f7
# ╟─5a8e3f50-1490-11eb-1fb1-cd877fba1796
# ╟─61789270-1490-11eb-347f-910bb931a3c5
# ╠═65a04322-1490-11eb-1a4b-c37a5389d642
# ╟─489a4cd0-1490-11eb-2257-cf5a23f90558
# ╠═f026fbc0-14a8-11eb-0863-bfc54c5d0e83
# ╟─8fc75a40-14a8-11eb-0989-b394a583dc01
# ╟─a8fa2880-14a8-11eb-32ba-e78af019c947
# ╟─f35aaf80-14a8-11eb-0140-eddea076908e
# ╟─dcf22f60-14a9-11eb-30c7-c591cc3f554f
# ╟─91189262-14a8-11eb-278a-57100492d404
# ╟─cb702e00-14a8-11eb-1504-d5d91334db54
# ╠═f447cea0-14a8-11eb-2c21-6d0cd4083610
# ╟─92bc0930-14a8-11eb-24b8-25ed62df9b62
# ╟─935d5242-14a8-11eb-2963-575983bb56e1
