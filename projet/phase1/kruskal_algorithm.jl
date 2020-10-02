""" 
input : graph connexe
output : arbre de recouvrement minimal
"""
function kruskal_algorithm(graph)
    
    # Extirpe structure interne graph
    edges_array = edges(graph)
    nodes_graph = nodes(graph)

    # Genere vecteur un de TreeNode à partir des noeuds du Graph
    tree_nodes_array = TreeNode{T}[]  #WARNING : changement d'attribut sur ces TreeNode directement
    for i = 1:nb_nodes(graph)
        append!(tree_nodes_array, TreeNode(nodes_graph[i]))
    end

    # Core Algo Kruskal
    edges_graph_minimal = Edge{T}[]
    for i = 1 : nb_edges(graph)
        
        # Arrete de poids minimal   
        temp_edge = popfirst!(edges_array)
        
        # On va chercher les treeNodes associes aux sommets de l'Arrete
        tree_node1, tree_node2 = get_tree_nodes(temp_edge)

        # Si les treeNoeuds ne sont pas dans la meme Arbre alors on connecte 
        if !(same_tree(tree_node1, tree_node2))
            append!(edges_graph_minimal, temp_edge)
            
        end

    end
    
end