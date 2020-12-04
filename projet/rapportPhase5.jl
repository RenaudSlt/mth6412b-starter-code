### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ b8775230-34b3-11eb-1198-dfab732ce524
include("display.jl")

# ╔═╡ c656a6d0-34b3-11eb-0eb4-41becc0c060b
include("display_img.jl")

# ╔═╡ dd9976d0-34b1-11eb-2d7e-69e0b2b25c6b
md"# MTH6412B - Rapport de la phase 5"

# ╔═╡ b049828e-34b3-11eb-29d2-03d09f5041d5
md" Edward Hallé-Hannan 1843683\
Renaud Saltet 2035899"

# ╔═╡ b449fc2e-34b3-11eb-06a7-79d2ba5e8a71
md" Lien vers le dépôt de la phase 5 : [https://github.com/RenaudSlt/mth6412b-starter-code/tree/phase5/projet](https://github.com/RenaudSlt/mth6412b-starter-code/tree/phase5/projet)"

# ╔═╡ d42336c0-34b3-11eb-39a5-29ea6abbfdfd
md"## Reconstruction d'une image"

# ╔═╡ 39f050b0-35b7-11eb-035c-0965280ba1ef
md"Étant donnée la lenteur de notre implémentation de l'algorithme HK, nous n'avons pu exploiter que l'algorithme RSL dans cette dernière phase.
"

# ╔═╡ 22e348a0-35b7-11eb-0a23-775edb040910
md"#### Modification des instances"

# ╔═╡ 31da00b0-35b7-11eb-30a6-77c33953398e
md"Nous nous sommes vite aperçus que la présence des arêtes de poids nul entre le nœud fictif \\(0\\) et les autres nœuds posait problème avec l'algorithme RSL.\
En effet, lors de la phase de recherche d'un arbre de recouvrement minimal, que ce soit avec la méthode Kruskal ou la méthode Prim, l'arbre de recouvrement renvoyé est celui qui consiste à faire une étoile dont le centre est le nœud \\(0\\) et les rayons sont tous les autres nœuds, puisque cet arbre est de poids nul.\
Or, comme l'algorithme RSL consiste à parcourir cet arbre en préordre, la tournée renvoyée est simplement l'ordre dans lequel les nœuds sont ajoutés au graphe au départ (donc ici \\(1, 2, 3, ..., 600\\)), à un décalage près en fonction du nœud racine choisi.\
Par conséquent, les images reconstruites étaient identiques aux images mélangées (*shuffled*), à un décalage près des colonnes.

Pour résoudre ce problème, nous avons remplacé les arêtes de poids nul par des arêtes de poids \\(10^6\\), c'est-à-dire un poids très supérieur à celui de toutes les autres arêtes. De cette façon, pour obtenir le vrai poids du chemin renvoyé, il suffit de soustraire \\(2\times 10^6\\) au poids de la tournée renvoyée car elle contient nécessairement deux arêtes de poids \\(10^6\\).\
Ainsi, le nœud \\(0\\) remplit uniquement sa fonction qui est de ne pas s'occuper du retour au point de départ. On cherche en effet un chemin de poids minimal et pas une tournée de poids minimal."

# ╔═╡ 3f857410-35b7-11eb-2915-fbc6b3aeb648
md"#### Fichier `main_image.jl`"

# ╔═╡ 599b9a40-35b3-11eb-0768-216a5ad11ffc
md"Le code permettant de lire une instance, de trouver une tournée et de convertir cette tournée en image se trouve dans le fichier `main_image.jl`, affiché à la fin de cette partie. Nous avons créé une fonction `main_image()` qui prend trois arguments :
* une chaîne de caractères `FileName` indiquant le nom de l'instance à reconstruire,
* une chaîne de caractères `algo` indiquant l'algorithme de recouvrement minimal souhaité (Kruskal ou Prim),
* un entier `root_number` indiquant le numéro du nœud racine souhaité dans l'algorithme de recouvrement minimal

Nous verrons à la section **Résultats** que les arguments `algo` et `root_number` peuvent prendre la valeur `\"best\"` si l'on veut exécuter l'algorithme RSL avec les meilleurs paramètres.

La suite de cette partie est dédiée à l'explication du fichier `main_image.jl`.

\

On commence par lire l'instance et la transformer en graphe en prenant le soin de commencer à \\(0\\) et de donner à l'attribut `data` de chaque nœud la valeur de l'indice du nœud."

# ╔═╡ 22e4ba20-35b5-11eb-12c2-450aaf79e797
display("main_image.jl",44,47)

# ╔═╡ a2e87510-35b8-11eb-3cff-9d621681cf74
md"C'est à ce moment que l'on modifie le poids des arêtes de poids nul, en le remplaçant par \\(10^6\\)."

# ╔═╡ b33435d0-35b8-11eb-09d4-89141214580f
display("main_image.jl",56,56)

# ╔═╡ 39fc17de-35b4-11eb-3e0a-63b033b60980
md"Après avoir exécuté l'algorithme RSL, on transforme la tournée `route_nodes` qui est un vecteur de nœuds en vecteur d'entiers."

# ╔═╡ 15286160-35b6-11eb-3a18-d123d1476fb4
display("main_image.jl",106,109)

# ╔═╡ 188c73f0-35b6-11eb-0933-93074b5b120e
md"Puis on effectue une permutation circulaire jusqu'à obtenir le nœud \\(0\\) en premier."

# ╔═╡ 1a476a60-35b6-11eb-08aa-033ec1291a7d
display("main_image.jl",118,120)

# ╔═╡ 45009c40-35b6-11eb-2fe6-01ace5b72ae4
md"On sauvegarde ensuite le tour grâce à la fonction `write_tour()` dans le dossier `/reconstructed_tours` que nous avons créé dans le dossier `/shredder-julia/tsp`."

# ╔═╡ 767bd8c0-35b6-11eb-09f9-8b681c0c1220
display("main_image.jl",127,128)

# ╔═╡ 7e674830-35b6-11eb-2201-9f307c974d30
md"On reconstruit et sauvegarde enfin l'image dans le dossier `/reconstructed` grâce à la fonction `reconstruct_picture()`."

# ╔═╡ 8af082b0-35b6-11eb-2ddd-3503c6ec7a99
display("main_image.jl",131,133)

# ╔═╡ c3378dd0-35b6-11eb-056f-2315754cfc80
md"Voici le fichier complet `main_image.jl`."

# ╔═╡ 39ba53ee-35b4-11eb-008d-9d1d0e4d071f
display("main_image.jl")

# ╔═╡ e7633140-34b3-11eb-290d-e546790180ab
md"## Recherche des meilleurs paramètres"

# ╔═╡ 69a4acb0-35b3-11eb-2bdb-294a300bfe17
md"Les deux paramètres sur lesquels nous avons pu jouer étaient :
* la méthode de recherche d'un arbre de recouvrement minimal (Kruskal ou Prim),
* le nœud racine de cette méthode (de 0 à 600)

Étant donnée la rapidité de notre implémentation de l'algorithme de Prim par rapport à celle de l'algorithme de Kruskal, nous avons pu tester plus de nœuds racines avec la première méthode qu'avec la seconde.

Pour la méthode de Prim, nous avons testé un nœud sur 10, donc 60 nœuds au total pour chaque instance. Pour celle de Kruskal, un nœud sur 200, donc 3 nœuds au total. Il se trouve que pour toutes les instances, la méthode de Kruskal donne de meilleurs résultats en termes de poids de la tournée.

Pour chaque instance, nous avons sauvegardé les tours et les images à chaque amélioration. Nous nous sommes ainsi rendus compte que les images ayant le meilleur poids n'étaient pas toujours celles qui visuellement ressemblaient le plus aux images originales. Nous aborderons cela dans la section **Résultats**.

Tout cela est effectué dans le fichier `rsl_parameters_phase5.jl` qui n'est pas affiché dans ce rapport.

Les résultats sont disponibles dans le dossier `/parameters_optimization` que nous avons créé dans le dossier `/shredder-julia`. Pour chaque instance, on retrouve un dossier `/kruskal` et un dossier `/prim` dans chacun desquels se trouvent un dossier `/images` contenant les images successives et un dossier `/tsp` contenant les tournées successives. Le nom d'une image (`.png`) ou d'une tournée (`.tour`) est composé du nom de l'instance, du poids du chemin obtenu (i.e. après avoir soustrait \\(2\times 10^6\\)) et du nœud racine ayant conduit à ce résultat.

Attention, dans un fichier `.tour`, le poids affiché (header `LENGTH`) est celui *avant* d'avoir soustrait \\(2\times 10^6\\)."

# ╔═╡ 61f97a90-35b3-11eb-3cc3-35439eedba25
md"## Résultats"

# ╔═╡ 7fecf240-35c0-11eb-0964-19267c2b783b
md"Les résultats présentés dans cette section sont reproductibles avec le fichier `main_image.jl`.

Pour reproduire une image en résolvant l'instance mélangée, il faut :
* ouvrir un REPL et se placer dans le dossier mth6412b-starter-code,
* entrer la commande `include(\"projet/main_image.jl\")`,
* entrer la commande `main_image(\"abstract-light-painting\",\"best\",\"best\")` pour exécuter l'algorithme RSL avec les meilleurs paramètres sur l'instance `abstract-light-painting`

On peut aussi remplacer le premier argument `\"best\"` par \"kruskal\" ou \"prim\" si l'on veut l'un ou l'autre algorithme, et remplacer le second argument `\"best\"` par un entier entre 0 et 600 pour choisir le nœud racine.

Attention, la première option `\"best\"` revient pour toutes les instance à l'option `\"kruskal\"` qui est très longue en temps de calcul. L'exécution met plusieurs dizaines de minutes, voire plus d'une heure pour certaines instances. Nous conseillons donc de tester avec l'algorithme de Prim et le meilleur nœud racine, c'est-à-dire en entrant la commande :\
`main_image(\"abstract-light-painting\",\"prim\",\"best\")`

\

Comme nous l'avons évoqué plus haut, les tournées qui ont les meilleurs poids ne sont pas toujours celle qui fournissent l'image la plus proche de l'originale pour un œil humain. Pour chaque instance, nous avons affiché l'image de poids minimal et son poids à droite de l'image originale, puis l'image que nous avons jugé la plus fidèle à l'originale quand celle-ci différait de l'image de poids minimal. Nous n'avons pas considéré une image reflétée comme éloignée de l'image originale.

\

"

# ╔═╡ 0dca4000-35c5-11eb-2d05-c141cd6a0f92
md"**Originale *vs.* poids minimal : `abstract-light-painting` (poids : 12 359 023)**"

# ╔═╡ 85382210-35c5-11eb-0814-cf5c61689166
display_img("abstract-light-painting.png", "comparison")

# ╔═╡ 3afe1960-35c6-11eb-344b-bb374e89fd5e
md"Image la plus fidèle, obtenue avec (`algo=\"prim\",root_number=30`) et de poids 12 421 123"

# ╔═╡ e3e8b402-35c5-11eb-0987-6985e2634874
display_img("abstract-light-painting.png", "visual")

# ╔═╡ a56e2d30-35c6-11eb-1562-7d15a316d8cf
md"

\
**Originale *vs.* poids minimal : `alaska-railroad` (poids : 7 779 637)**"

# ╔═╡ 6ca4b960-35cb-11eb-2180-3f4f56f1f7a7
display_img("alaska-railroad.png", "comparison")

# ╔═╡ c4a7cc5e-35c6-11eb-2ccf-314256b0d823
md"

\
**Originale *vs.* poids minimal : `blue-hour-paris` (poids : 3 989 701)**"

# ╔═╡ 6f2d11f0-35cb-11eb-181e-a9b6ad12a8fd
display_img("blue-hour-paris.png", "comparison")

# ╔═╡ c76df140-35c6-11eb-1f6d-411ae93d433a
md"

\
**Originale *vs.* poids minimal : `lower-kananaskis-lake` (poids : 4 254 147)**"

# ╔═╡ 706766b0-35cb-11eb-3dc7-dba38a3a88c5
display_img("lower-kananaskis-lake.png", "comparison")

# ╔═╡ d8e00990-35c6-11eb-2de3-dd4e86be6e76
md"Image la plus fidèle, obtenue avec (`algo=\"prim\",root_number=20`) et de poids 4 305 709"

# ╔═╡ 8519dcf0-35cb-11eb-2bba-3d2eee789462
display_img("lower-kananaskis-lake.png", "visual")

# ╔═╡ c7eee110-35c6-11eb-11ee-0588e6652928
md"

\
**Originale *vs.* poids minimal : `marlet2-radio-board` (poids : 8 997 767)**"

# ╔═╡ 795db670-35cb-11eb-16a6-cd9e9f1bc353
display_img("marlet2-radio-board.png", "comparison")

# ╔═╡ fc263050-35c6-11eb-0f7d-c5a7b070d7a3
md"Image la plus fidèle, obtenue avec (`algo=\"prim\",root_number=20`) et de poids 9 188 938"

# ╔═╡ 89c144f0-35cb-11eb-2c50-37cd1234df4b
display_img("marlet2-radio-board.png", "visual")

# ╔═╡ d4ae94e0-35c6-11eb-0c40-efd5b4fdd2db
md"

\
**Originale *vs.* poids minimal : `nikos-cat` (poids : 3 077 214)**"

# ╔═╡ 7aafd8ee-35cb-11eb-0e62-fd9ef9b711d9
display_img("nikos-cat.png", "comparison")

# ╔═╡ fd66c69e-35c6-11eb-20b3-55bd6a07b929
md"Image la plus fidèle, obtenue avec (`algo=\"prim\",root_number=20`) et de poids 3 127 465"

# ╔═╡ c1c3fea2-35cc-11eb-36fc-ab37d5bdd774
display_img("nikos-cat.png", "visual")

# ╔═╡ dce0aa40-35c6-11eb-0b4b-9f1b964f7155
md"

\
**Originale *vs.* poids minimal : `pizza-food-wallpaper` (poids : 5 100 665)**"

# ╔═╡ 7ba3d5e2-35cb-11eb-3c96-95b60fc9ee49
display_img("pizza-food-wallpaper.png", "comparison")

# ╔═╡ fe757780-35c6-11eb-3bb4-535a5e874c44
md"Image la plus fidèle, obtenue avec (`algo=\"prim\",root_number=410`) et de poids 5 136 087"

# ╔═╡ 7ca69fe0-35cb-11eb-273b-dbe89b5bc29c
display_img("pizza-food-wallpaper.png", "visual")

# ╔═╡ dd89bb80-35c6-11eb-0e7d-5135bda6b0cc
md"

\
**Originale *vs.* poids minimal : `the-enchanted-garden` (poids : 19 976 343)**"

# ╔═╡ 7dc52f40-35cb-11eb-29ff-930427f1c1aa
display_img("the-enchanted-garden.png", "comparison")

# ╔═╡ ff5242f0-35c6-11eb-3622-31ad3fb8c82f
md"Image la plus fidèle, obtenue avec (`algo=\"prim\",root_number=30`) et de poids 20 010 832"

# ╔═╡ ca05cb70-35cc-11eb-3c6b-e72de0921cf8
display_img("the-enchanted-garden.png", "visual")

# ╔═╡ de3a46d0-35c6-11eb-24ef-b132dc1689e7
md"

\
**Originale *vs.* poids minimal : `tokyo-skytree-aerial`  (poids : 13 642 025)**"

# ╔═╡ 7f224e40-35cb-11eb-1ddd-736b3850c716
display_img("tokyo-skytree-aerial.png", "comparison")

# ╔═╡ 00254a60-35c7-11eb-01d1-2d9f41fe8d05
md"Image la plus fidèle, obtenue avec (`algo=\"prim\",root_number=20`)  et de poids 13 654 601"

# ╔═╡ cbf9fa50-35cc-11eb-3155-4dc381c2fced
display_img("tokyo-skytree-aerial.png", "visual")

# ╔═╡ Cell order:
# ╟─dd9976d0-34b1-11eb-2d7e-69e0b2b25c6b
# ╟─b049828e-34b3-11eb-29d2-03d09f5041d5
# ╟─b449fc2e-34b3-11eb-06a7-79d2ba5e8a71
# ╠═b8775230-34b3-11eb-1198-dfab732ce524
# ╠═c656a6d0-34b3-11eb-0eb4-41becc0c060b
# ╟─d42336c0-34b3-11eb-39a5-29ea6abbfdfd
# ╟─39f050b0-35b7-11eb-035c-0965280ba1ef
# ╟─22e348a0-35b7-11eb-0a23-775edb040910
# ╟─31da00b0-35b7-11eb-30a6-77c33953398e
# ╟─3f857410-35b7-11eb-2915-fbc6b3aeb648
# ╟─599b9a40-35b3-11eb-0768-216a5ad11ffc
# ╠═22e4ba20-35b5-11eb-12c2-450aaf79e797
# ╟─a2e87510-35b8-11eb-3cff-9d621681cf74
# ╠═b33435d0-35b8-11eb-09d4-89141214580f
# ╟─39fc17de-35b4-11eb-3e0a-63b033b60980
# ╠═15286160-35b6-11eb-3a18-d123d1476fb4
# ╟─188c73f0-35b6-11eb-0933-93074b5b120e
# ╠═1a476a60-35b6-11eb-08aa-033ec1291a7d
# ╟─45009c40-35b6-11eb-2fe6-01ace5b72ae4
# ╠═767bd8c0-35b6-11eb-09f9-8b681c0c1220
# ╟─7e674830-35b6-11eb-2201-9f307c974d30
# ╠═8af082b0-35b6-11eb-2ddd-3503c6ec7a99
# ╟─c3378dd0-35b6-11eb-056f-2315754cfc80
# ╠═39ba53ee-35b4-11eb-008d-9d1d0e4d071f
# ╟─e7633140-34b3-11eb-290d-e546790180ab
# ╟─69a4acb0-35b3-11eb-2bdb-294a300bfe17
# ╟─61f97a90-35b3-11eb-3cc3-35439eedba25
# ╟─7fecf240-35c0-11eb-0964-19267c2b783b
# ╟─0dca4000-35c5-11eb-2d05-c141cd6a0f92
# ╟─85382210-35c5-11eb-0814-cf5c61689166
# ╟─3afe1960-35c6-11eb-344b-bb374e89fd5e
# ╟─e3e8b402-35c5-11eb-0987-6985e2634874
# ╟─a56e2d30-35c6-11eb-1562-7d15a316d8cf
# ╟─6ca4b960-35cb-11eb-2180-3f4f56f1f7a7
# ╟─c4a7cc5e-35c6-11eb-2ccf-314256b0d823
# ╟─6f2d11f0-35cb-11eb-181e-a9b6ad12a8fd
# ╟─c76df140-35c6-11eb-1f6d-411ae93d433a
# ╟─706766b0-35cb-11eb-3dc7-dba38a3a88c5
# ╟─d8e00990-35c6-11eb-2de3-dd4e86be6e76
# ╟─8519dcf0-35cb-11eb-2bba-3d2eee789462
# ╟─c7eee110-35c6-11eb-11ee-0588e6652928
# ╟─795db670-35cb-11eb-16a6-cd9e9f1bc353
# ╟─fc263050-35c6-11eb-0f7d-c5a7b070d7a3
# ╟─89c144f0-35cb-11eb-2c50-37cd1234df4b
# ╟─d4ae94e0-35c6-11eb-0c40-efd5b4fdd2db
# ╟─7aafd8ee-35cb-11eb-0e62-fd9ef9b711d9
# ╟─fd66c69e-35c6-11eb-20b3-55bd6a07b929
# ╟─c1c3fea2-35cc-11eb-36fc-ab37d5bdd774
# ╟─dce0aa40-35c6-11eb-0b4b-9f1b964f7155
# ╟─7ba3d5e2-35cb-11eb-3c96-95b60fc9ee49
# ╟─fe757780-35c6-11eb-3bb4-535a5e874c44
# ╟─7ca69fe0-35cb-11eb-273b-dbe89b5bc29c
# ╟─dd89bb80-35c6-11eb-0e7d-5135bda6b0cc
# ╟─7dc52f40-35cb-11eb-29ff-930427f1c1aa
# ╟─ff5242f0-35c6-11eb-3622-31ad3fb8c82f
# ╟─ca05cb70-35cc-11eb-3c6b-e72de0921cf8
# ╟─de3a46d0-35c6-11eb-24ef-b132dc1689e7
# ╟─7f224e40-35cb-11eb-1ddd-736b3850c716
# ╟─00254a60-35c7-11eb-01d1-2d9f41fe8d05
# ╟─cbf9fa50-35cc-11eb-3155-4dc381c2fced
