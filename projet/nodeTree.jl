include("node.jl")
import Base.==

"""Type représentant une composante connexe acyclique 
    -Le type représente un arbre non-équilibré, c'est-à-dire qu'un nombre arbitraire
     de NodeTree peut réréfer à un autre NodeTree en tant que parent
    -L'attribut enfants_ est omis, puisque la structure est intimement utilisé avec l'algorithme de Kruskal,
    où nous nous intéressons à déterminer si deux noeuds appartiennent à une même composante connnexe par 
    l'entremise d'un root
    -Si parent_ == nothing => le NodeTree est une racine
"""
mutable struct NodeTree{T} <: AbstractNode{T}
    data_::T
    name_::String
    parent_::Union{NodeTree{T}, Nothing} 
end


""" Constructeur :
    -Argument obligatoire : data_
    -Argument facultatif : name_  et parent_
        name_ = "", par défaut
        parent_ = nothing, par défaut
"""
function NodeTree{T}(data_::T; name_::String="", parent_::Union{NodeTree{T}, Nothing}=nothing) where T
    return NodeTree(data_, name_, parent_)
end

"""Accède au noeud parent d'un noeud"""
get_parent(node::NodeTree{T}) where T = node.parent_

"""Ajuste le noeud parent d'un noeud (node1) en tant qu'un autre noeud (node2)
Input : 
    -child : un NodeTree à lequel on affecte son attribut parent_ au NodeTree parent en argument
    -parent : le NodeTree qui est affecté à child
Output:
    -le NodeTree child modifié
""" 
function set_parent!(child::NodeTree{T}, parent::NodeTree{T}) where T 
   child.parent_ = parent
   return child
end

"""Retourne le noeud racine d'une composante composante_connexe (NodeTree)
    -La méthode est recursive. C'est-à-dire qu'on appelle la fonction jusqu'à ce qu'on atteigne
    une racine (lorsque get_parent(node)==nothing).

Input : 
    -un NodeTree quelconque
Output : 
    -Si !(node_temp === nothing) => le noeud a une racine
    -Si (node_temp === nothing) => le noeud est une racine
"""
function get_root(node::NodeTree{T}) where T 

    if get_parent(node) === nothing  # Il est une racine
        return node 
    else
        get_root(get_parent(node))
    end

end


"""Vérifie si deux noeuds appartiennent aux mêmes arbres en comparant leur noeud racine"""
function same_tree(node1::NodeTree{T}, node2::NodeTree{T}) where T 
    root_tree1 = get_root(node1)
    root_tree2 = get_root(node2)
    return root_tree1 == root_tree2 
end