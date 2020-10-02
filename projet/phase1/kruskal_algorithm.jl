include("graph.jl")
include("node.jl")
include("nodeTree.jl")
include("edge.jl")

""" Algorithme de Kruskal supporté par une structure de donnée NodeTree{T} dans nodeTree.jl
    -Fonctionnement : 
        1) arcs de poids minimaux sont choisis itérativement,
        2) si les noeuds n1 et n2 de l'arc minimal n'appartiennent pas à la même composante connexe,
         l'arc min est ajoutée à l'ensembe, sinon il est simplement delete
        NOTE : on vérifie que deux n1 et n2 appartiennent pas à la même composante connexe avec la structure
        NodeTree{T}, c'est-à-dire qu'on compare les racines de des deux sommets n1 et n2

    -Input : Graph connexe ayant des sommets et des arcs
    -Output : Ensemble d'arêtes formant le recouvrement minimal
"""
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
    for i = 1 : nb_edges(graph)
        
        # Ârrete de poids minimal   
        edge_min = popfirst!(edges_array)

        # On va chercher les Nodes associes aux sommets de l'ârrete minimal
        graph_node1 = get_node1(edge_min)
        graph_node2 = get_node2(edge_min) 


        # On va chercher les index des NodeTree associés aux Nodes
        idx1 = findfirst(x -> x == graph_node1, tree_nodes_array)
        idx2 = findfirst(x -> x == graph_node2, tree_nodes_array)

        # Tree nodes associés par réréfence 
        tree_node1 = tree_nodes_array[idx1]
        tree_node2 = tree_nodes_array[idx2]

        # Si les treeNoeuds ne sont pas dans la même composante connexe, alors on ajoute l'arc 
        # et on connecte les deux treeNodes 
        if !(same_tree(tree_node1, tree_node2))
            
            push!(edges_graph_min, edge_min)
            
            # La racine de tree_node1 devient l'enfant de la racine de  tree_node2
            set_parent!(get_root(tree_node1), get_root(tree_node2) )
        end

    end
    
    # Ensemble d'arêtes qui forme le recouvrement minimal
    return edges_graph_min
end