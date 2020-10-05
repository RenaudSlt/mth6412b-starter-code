using PlutoUI

function display(filename)
  with_terminal() do 
    open(filename, "r") do file
      for line in readlines(file)
        println(stdout, line)
      end
    end
  end
end

function display(filename, line1, line2)
  with_terminal() do 
    open(filename, "r") do file
      lines = readlines(file)
      for i in line1:line2
        println(stdout, lines[i])
      end
    end
  end
end