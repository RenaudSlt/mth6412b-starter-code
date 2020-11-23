using PlutoUI
using Images, FileIO


# specify the path to your local image file
function display_img(filename)
  img_path = string("affichage_tournees/", filename)
  img = load(img_path)
end