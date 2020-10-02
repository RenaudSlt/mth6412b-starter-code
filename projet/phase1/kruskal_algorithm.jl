include("graph.jl")
include("node.jl")
include("nodeTree.jl")
include("edge.jl")

""" 
input : graph connexe ayant des sommets et des arcs
output : ensemble d'arêtes formant le recouvrement minimal
"""
function kruskal_algorithm(graph::AbstractGraph)
    
    # Extirpe structure interne graph
    edges_array = copy(get_edges(graph))
    nodes_graph = get_nodes(graph)
    T = typeof(get_data(nodes_graph[1]))
    
    # Genere un vecteur de NodeTree à partir des noeuds du Graph
    tree_nodes_array = NodeTree{T}[] 
    for i = 1:nb_nodes(graph)
        # Ensemble disjoints de NodeTree, puisque parent=nothing pour tous
        push!(tree_nodes_array, NodeTree{T}(get_data(nodes_graph[i]), name_=get_name(nodes_graph[i]), parent_=nothing))
    end

    # Coeur de l'algorithm de Kruskal
    edges_graph_min = Edge{T}[]
    for i = 1 : nb_edges(graph)
        
        # Ârrete de poids minimal   
        edge_min = popfirst!(edges_array)
        show(edge_min)

        # On va chercher les Nodes associes aux sommets de l'ârrete minimal
        graph_node1 = get_node1(edge_min)
        graph_node2 = get_node2(edge_min) 

        # On va chercher les index des NodeTree associés aux Nodes
        idx1 = findfirst(x -> x == graph_node1, tree_nodes_array)
        idx2 = findfirst(x -> x == graph_node2, tree_nodes_array)

        # Tree nodes associés par réréfence 
        tree_node1 = tree_nodes_array[idx1]
        tree_node2 = tree_nodes_array[idx2]

        # Si les treeNoeuds ne sont pas dans la même composante connexe, alors on ajoute l'arc et on connecte les deux treeNodes 
        if !(same_tree(tree_node1, tree_node2))
            
            push!(edges_graph_min, edge_min)
            
            # Connect root of tree_node1 to the root of tree_node2
            set_parent!(get_root(tree_node1), get_root(tree_node2) )

        end

    end
    
    return edges_graph_min
end