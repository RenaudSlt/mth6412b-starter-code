include("graph.jl")
include("node.jl")
include("nodeTree.jl")
include("markednode.jl")
include("edge.jl")
include("prim_algorithm.jl")
include("kruskal_algorithm.jl")

function hk_algorithm_old(graph::Graph{T}, algo_MST::String, source::Node{T}=get_nodes(graph)[2], initial_step_size::Float64=1.0, step_size_method::String="simple", stop_criterion::String="null") where T

  # Initialisation
  n = nb_nodes(graph)
  k = 0 # WARNING k=0 division
  π = zeros(n)
  v = zeros(n)
  v_prev = zeros(n)
  best_v = zeros(n)
  total_π = zeros(n)
  w = 0
  W = -Inf
  t = initial_step_size
  one_tree_obtained = false  # Flag : critère arrêt
  step_size_min_obtained = false  # Flag : critère arrêt
  sub_optimal_one_tree_obtained = false # Flag : critère arrêt maison


  # Initialisation pour méthode des périodes
  if step_size_method == "period"
    τ = 2.0
    period_length = fld(n,2)  # partie entière de n/2
    period_counter = 0
    first_period_exception = true
  end

  graph_copy = deepcopy(graph)
  best_one_tree = deepcopy(graph) # On initialise ce best_one_tree pour le retrouver à la fin de la bouche
  best_special_node = get_nodes(best_one_tree)[1]

    # Boucle principale
    while (one_tree_obtained==false && step_size_min_obtained==false)
    
    
        # Transformation des poids en c_ij + π_i + π_j
        update_weights!(graph_copy, t.*( (0.7 .* v) + (0.3 .* v_prev )))
        π = π + t.*( (0.7 .* v) + (0.3 .* v_prev ))

        # Détermine le noeud special qui est enlevé du graph pour faire le MST et le noeud source pour partir l'algo MST
        n_special = rand(1:n) 
        n_source = rand(1:n)
        while n_special == n_source
        n_source = rand(1:n)
        end
        special_node = get_nodes(graph_copy)[n_special]
        source = get_nodes(graph_copy)[n_source]

        # Copie profonde du graph_pi
        graph_without_one = deepcopy(graph_copy) # DEEPCOPY PEUT-ÊTRE PAS NÉCESSAIRE
        remove_node_from_graph!(graph_without_one, special_node) 

        # On récolte les arêtes enlevées
        removed_edges = Edge{T}[]

        for edge in get_edges(graph_copy)
            if edge ∉ get_edges(graph_without_one)
            push!(removed_edges, edge)
            end
        end

        special_node_min_edge1 = popfirst!(removed_edges) 
        special_node_min_edge2 = popfirst!(removed_edges)
        while special_node_min_edge1 == special_node_min_edge2
        special_node_min_edge2 = popfirst!(removed_edges)
        end
        # Calcul d'un arbre de recouvrement minimal sur les noeuds {2,3,...,n}
        if algo_MST == "kruskal"
        minimal_edges, minimal_weight, minimal_subtree = kruskal_by_prim(graph_without_one, source)
        elseif algo_MST == "prim"
        minimal_edges, minimal_weight, minimal_subtree = prim_algorithm(graph_without_one, source)
        end

        # 1-Tree : on réajoute le noeud special, qui avait été enlevée, ainsi que les deux arcs minimal
        #nodes_one_tree = push!(get_nodes(graph_without_one), special_node)
        nodes_one_tree = get_nodes(graph_copy)
        push!(minimal_edges, special_node_min_edge1)
        push!(minimal_edges, special_node_min_edge2)

        # On effectue une deepcopy pour éviter les modifications à l'interne des attributs
        one_tree = Graph("minimal_graph", deepcopy(nodes_one_tree), deepcopy(minimal_edges)) 
        cost_one_tree = minimal_weight + get_weight(special_node_min_edge1) + get_weight(special_node_min_edge2) 

        # Mise à jour de w_prev, w, W et v
        w_prev = w
        w = cost_one_tree - 2*sum(π)
        W = max(W, w)

        v_prev = v
        v = get_degrees(one_tree) .- 2 

        # On sauvegarde le meilleur one-tree
        if W == max(W,w)
            best_one_tree = one_tree
            best_v = v
            best_special_node = special_node
        end

        # Flag pour critères d'arrêt 
        # PREMIER CRITÈRE ARRÊT : Flag pour critères d'arrêt 
        if v == zeros(n)
            one_tree_obtained = true
            best_one_tree = one_tree
            break
        end

        # DEUXIÈME CRITÈRE ARRÊT : 
        v_valid, number_of_ones = v_score(v)
        if k >= 25000 && (v_valid) && (number_of_ones <= n/4) 
        sub_optimal_one_tree_obtained = true
        best_one_tree = one_tree
        break
        end

    

        # Choix d'une taille de pas
        if  step_size_method == "simple"
            t = initial_step_size/(k+1)
    
        elseif step_size_method == "period"
            if period_counter >= period_length # t=cte tant est aussi longtemps que period_counter=period_length
            period_counter = 0 # on remet le compteur à 0 qu'il y ait une amélioration ou pas
            if w <= w_prev  # Si pas d'amélioration, on divise la taille de la période et t
                    period_length = fld(period_length,2) # ou τ
                    t /= τ
                    if first_period_exception
                        first_period_exception = false
                    end
            end
            end
        
            # Cas de la première période sans échec
            if first_period_exception
                if w > w_prev  # Si amélioration, on grandit t
                    t *= τ
                else
                    first_period_exception = false
                end
            end
            period_counter += 1
        end
  
    # Mise à jour de k
    k += 1
    end # while
  
    # Post-processing pour retrouver le coût de la tournée avec les poids du graph initial
    show(one_tree)
    update_weights!(one_tree, -total_π)

    println("Meilleur one tree :")
    println(" Special node: ", best_special_node)
    show(best_one_tree)
    println(" ")
    for i = 1 : length(v)
        println("noeud ", i, " degree :", best_v[i])
    end
    println("FIN meilleur one tree.")
    println(" ")


    update_weights!(best_one_tree, -total_π)
    final_cost = 0
    for edge in get_edges(one_tree)
    for edge in get_edges(best_one_tree)
        final_cost += get_weight(edge)
    end

    return one_tree, final_cost, one_tree_obtained
    return best_one_tree, final_cost, one_tree_obtained
end #function
  
  
""" Fonction utilité sur les degrées du vecteur v """
function v_score(v::Vector{Float64})
number_of_ones = 0
valid = true
for i = 1:length(v)
    if abs(v[i])>1
    valid = false
    return valid, number_of_ones
    elseif abs(v[i])==1
    number_of_ones += 1
    end
end
return valid, number_of_ones
end
  
  """ Fonction utilité : reconstruire """




