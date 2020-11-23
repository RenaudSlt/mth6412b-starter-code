include("graph.jl")
include("node.jl")
include("nodetree.jl")
include("edge.jl")
include("prim_algorithm.jl")

""" Algorithme de Kruskal supporté par une structure de donnée NodeTree{T} dans nodeTree.jl
    -Fonctionnement : 
        1) arcs de poids minimaux sont choisis itérativement,
        2) si les noeuds n1 et n2 de l'arc minimal n'appartiennent pas à la même composante connexe,
         l'arc min est ajoutée à l'ensemble, sinon on passe à l'arête suivante
        NOTE : on vérifie que deux n1 et n2 appartiennent pas à la même composante connexe avec la structure
        NodeTree{T}, c'est-à-dire qu'on compare les racines des deux sommets n1 et n2

    -Input : Graph connexe ayant des sommets et des arcs
    -Output : Ensemble d'arêtes formant le recouvrement minimal, poids de l'arbre recouvrant minimal
"""
compress = true
function kruskal_algorithm(graph::Graph{T}) where T
    
    ### Initialisation ###

    # Accède aux arêtes et aux noeuds du graph
    edges_array = copy(get_edges(graph))
    nodes_graph = get_nodes(graph)
    #T = typeof(get_data(nodes_graph[1]))  #T : type générique et homogène à tous les arêtes et noeuds
    
    # Genere un vecteur de NodeTree à partir des noeuds du Graph : les NodeTree sont instanciés à partir des Node
    tree_nodes_array = NodeTree{T}[] 
    for i = 1:nb_nodes(graph)
        # Ensemble disjoints de NodeTree, puisque parent=nothing pour tous
        push!(tree_nodes_array, NodeTree{T}(get_data(nodes_graph[i]), name_=get_name(nodes_graph[i]), parent_=nothing))
    end

    ### Algorithme ### 

    edges_graph_min = Edge{T}[]
    weight = 0
    for i = 1 : nb_edges(graph)
        
        # Arête de poids minimal   
        edge_min = popfirst!(edges_array)

        # On va chercher les Nodes associes aux sommets de l'ârrete minimal
        graph_node1 = get_node1(edge_min)
        graph_node2 = get_node2(edge_min) 
        
        #show(graph_node1)
        #show(graph_node2)
        #println("")


        # On va chercher les index des NodeTree associés aux Nodes
        idx1 = findfirst(x -> x == graph_node1, tree_nodes_array)
        idx2 = findfirst(x -> x == graph_node2, tree_nodes_array)

        # Tree nodes associés par réréfence 
        tree_node1 = tree_nodes_array[idx1]
        tree_node2 = tree_nodes_array[idx2]

        # Si les treeNoeuds ne sont pas dans la même composante connexe, alors on ajoute l'arc 
        # et on connecte les deux treeNodes 
        if !(same_tree(tree_node1, tree_node2; compression=compress))
            
            push!(edges_graph_min, edge_min)

            # Ajout du poids dans le poids total
            weight += get_weight(edge_min)
            
            # Union via le rang : TODO rajouté détail 
            rank1 = get_rank(get_root!(tree_node1;compression=compress))
            rank2 = get_rank(get_root!(tree_node2;compression=compress))
            if rank1 > rank2
                set_parent!(get_root!(tree_node2;compression=compress), get_root!(tree_node1;compression=compress))
            else
                set_parent!(get_root!(tree_node1;compression=compress), get_root!(tree_node2;compression=compress))
                if rank1 == rank2
                    set_rank!(get_root!(tree_node2;compression=compress), rank2 + 1)
                end
            end
        end

    end
    
    # Ensemble d'arêtes qui forme le recouvrement minimal
    return edges_graph_min, weight
end




""" Se sert de l'algorithme de Prim pour retourner un graphe de MarkedNode dont on choisit la source
    - Input : . 'graph', le graphe connexe
              . 'source', la racine souhaitée de l'arbre de recouvrement
    - Output : . ensemble d'arêtes formant l'arbre de recouvrement minimal
               . poids de l'arbre de recouvrement minimal
               . vecteur de MarkedNodes formant l'arbre de recouvrement minimal
"""
function kruskal_by_prim(graph::Graph{T}, source::Node{T}=get_nodes(graph)[1]) where T
    edges, weight = kruskal_algorithm(graph)
    nodes = get_nodes(graph)

    # Application de l'algorithme de Prim sur l'arbre renvoyé par Kruskal en tant que graphe
    minimal_graph = Graph("minimal_graph", nodes, edges)
    prim_algorithm(minimal_graph, source)
end

