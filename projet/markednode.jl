include("node.jl")

import Base.show
import Base.popfirst!
import Base.isless

"""Type représentant un noeud marqué avec une structure d'arbre : structure utile pour prim_algorithm.jl
    - L'attribut min_weight_  contient le poids de l'arête de poids minimal connectant le noeud au sous-arbre
     (c-à-d au noeud dans le sous-arbre le plus près) dans l'algorithme de Prim
    - Si parent_ == nothing => le markedNode est une racine ou un noeud isolé 
"""

mutable struct MarkedNode{T} <: AbstractNode{T}
    name_::String
    data_::T
    visited_::Bool
    min_weight_::Number
    parent_::Union{MarkedNode{T},Nothing}
    children_::Vector{MarkedNode{T}}
end

""" Constructeur :
    - Argument obligatoire : data_
    - Argument facultatif : name_ et min_weight
        name_ = "", par défaut
        min_weight_ = Inf, par défaut
    - Initilisation :
        parent_ = nothing (algorithme de Prim)
"""
function MarkedNode{T}(data_::T; name_::String="", min_weight_::Number=Inf) where T
    MarkedNode(name_, data_, false, max(0.0, min_weight_), nothing, MarkedNode{T}[])
end

""" Accesseur à l'attribut visited_ """
is_visited(node::MarkedNode{T}) where T = node.visited_

""" Accesseur à l'attribut min_weight_ """
get_min_weight(node::MarkedNode{T}) where T = node.min_weight_

""" Accesseur à l'attribut parent_ """
get_parent(node::MarkedNode{T}) where T = node.parent_

""" Accesseur à l'attribut children_ """
get_children(node::MarkedNode{T}) where T = node.children_

""" Renvoie la racine du noeud """
function get_root!(node::MarkedNode{T}) where T  # WARNING : il manquait un point exclamation
    # Node est une racine
    if get_parent(node) === nothing  
        return node 
    # Node n'est pas une racine
    else 
        get_root!(get_parent(node))        
    end
end

""" Mutateur de l'attribut visited_ (irréversible) """
function set_visited!(node::MarkedNode{T}) where T
    node.visited_ = true
    return node
end

""" Mutateur de l'attribut min_weight_ """
function set_min_weight!(node::MarkedNode{T}, weight::Number) where T
    node.min_weight_ = max(0.0, weight)
    return node
end

""" Mutateur de l'attribut parent_
    - Change le parent du noeud en argument 'node'
    - Retire 'node' des enfants du parent précédent si celui-ci existait
    - Ajoute 'node' aux enfants du parent en argument 'parent'
"""
function set_parent!(node::MarkedNode{T}, parent::MarkedNode{T}) where T
    if node.parent_ != nothing
        previous_parent = get_parent(node)
        remove_child!(previous_parent, node)
    end
    node.parent_ = parent
    add_child!(parent, node)
    return node
end

""" Mutateur (ajout) de l'attribut children_
    Utile dans la fonction set_parent!
 """
function add_child!(node::MarkedNode{T}, child::MarkedNode{T}) where T
    push!(node.children_, child)
    return node
end

""" Mutateur (suppression) de l'attribut children_
    Utile dans la fonction set_parent!
"""
function remove_child!(node::MarkedNode{T}, child::MarkedNode{T}) where T
    filter!(x -> x ≠ child, node.children_)
    return node
end

""" Affichage du noeud """
show(node::MarkedNode{T}) where T = println("node $(get_name(node)) of minimum weight to tree $(get_min_weight(node))")

""" Surcharge de `isless` pour comparer les attributs min_weight_ de deux MarkedNodes """
isless(node1::MarkedNode{T}, node2::MarkedNode{T}) where T = isless(get_min_weight(node1), get_min_weight(node2))

""" Retire et renvoie le noeud d'attribut min_weight_ minimal dans un vecteur de MarkedNodes
    -Utilité : permet de simuler le comportement d'une PriorityQueue à partir d'un vecteur standard
    Input : vecteur de MarkedNodes
     Output : noeud d'attribut min_weight_ minimal 
"""
function popfirst!(nodes::Vector{MarkedNode{T}}) where T  
  
  # Si le vecteur est vide, on lance directement l'erreur : permet d'éviter que l'erreur se propage à minimum, findfirst, etc. (plus difficile à déboguer) 
  if (isempty(nodes))
    throw(error("The vector is empty."))
  end

  min_node = minimum(nodes)
  idx = findfirst(x -> x == min_node, nodes)

  # Attention : Modification du vecteur de nodes 
  deleteat!(nodes, idx)
  return min_node
end

""" Fonction utilité pour l'algorithme HK (voir fichier hk_algorithm.jl) 
    -La fonction récusrive retourne les feuilles d'une arbre 

    Input:
        -un noeud de l'arbre
        -une liste qui ajoute les feuilles au fur des appels récurifs
    Ouput:
        -la liste leaves_array remplit avec les feuilles de l'arbre associé à node
"""
function get_leaves!(node::MarkedNode{T}, leaves_array::Array{MarkedNode{T}}) where T

    if isempty(get_children(node))
        push!(leaves_array, node)
        return
    else
        for child in get_children(node)
            get_leaves!(child, leaves_array)
            return
        end
    end
end