using PlutoUI
using Images, FileIO

# Phase 4 : affiche une tournée 
function display_tour(filename)
  img_path = string("affichage_tournees/", filename)
  img = load(img_path)
end

# Phase 5 : affiche une image originale, mélangée ou reconstruite
function display_img(filename, version)
  if version == "original"
    img_path = string("../shredder-julia/images/original/", filename)
  elseif version == "shuffled"
    img_path = string("../shredder-julia/images/shuffled/", filename)
  elseif version == "visual"
    img_path = string("../shredder-julia/images/best_visual/", filename)
  elseif version == "comparison"
    img_path = string("../shredder-julia/images/comparison/", filename)  
  end
  img = load(img_path)
end