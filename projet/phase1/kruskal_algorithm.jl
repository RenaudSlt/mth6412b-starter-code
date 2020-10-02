include("graph.jl")
include("node.jl")
include("nodeTree.jl")

""" 
input : graph connexe ayant des sommets et des arcs
output : arbre de recouvrement minimal
"""
function kruskal_algorithm(graph::AbstractGraph)
    
    # Extirpe structure interne graph
    edges_array = copy(get_edges(graph))
    nodes_graph = get_nodes(graph)
    T = typeof(get_data(nodes_graph[i]))
    
    # Genere un vecteur de NodeTree à partir des noeuds du Graph
    tree_nodes_array = NodeTree{T}[] 
    for i = 1:nb_nodes(graph)
        # Ensemble disjoints de NodeTree, puisque parent=nothing pour tous
        append!(tree_nodes_array, NodeTree{T}(get_data(nodes_graph[i]), name_=get_name(nodes_graph[i]), parent_=nothing))
    end

    # Core Algo Kruskal
    edges_graph_minimal = Edge{T}[]
    for i = 1 : nb_edges(graph)
        
        # Arrete de poids minimal   
        temp_edge = popfirst!(edges_array)
        
        # On va chercher les Nodes associes aux sommets de l'Arrete
        temp_node1 = get_node1(temp_edge) 
        temp_node2 = get_node2(temp_edge)

        # On va chercher les index des NodeTree associés aux Nodes
        idx1 = findfirst(x -> x == temp_node1, tree_nodes_array)
        idx2 = findfirst(x -> x == temp_node2, tree_nodes_array)

        # Si les treeNoeuds ne sont pas dans la meme Arbre alors on connecte 
        if !(same_tree(tree_nodes_array[idx1], tree_nodes_array[idx2]))
            
            append!(edges_graph_minimal, temp_edge)
            root_temp1 = get_root(tree_nodes_array[idx1])
            root_temp2 = get_root(tree_nodes_array[idx2])
            idx_root1 = findfirst(x -> x == root_temp1, tree_nodes_array)
            idx_root2 = findfirst(x -> x == root_temp2, tree_nodes_array)

            

            set_parent!(tree_nodes_array[idx_root1], tree_nodes_array[idx_root2] )
            
        end

    end
    
end