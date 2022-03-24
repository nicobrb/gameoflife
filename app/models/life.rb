##
# This class represents the Game of Life handler and generator.
class Life
  ##
  # Creates a new Life object. Given a file path, the constructor only accepts txt files, and checks for every sort
  # of syntax error. If the file is correctly written, then a matrix with the generation together with a two variables
  # representing the dimension of the matrix and a generation counter will be initialized.
  # @param [String, #path] the path of the input file
  def initialize(path)
    raise EntryLevelException, "not a txt file" unless path.last(4) == ".txt"
    text = File.open(path).read.split("\n")
    dim = text[1].split(" ")
    raise EntryLevelException, "error in the dimensions line" unless dim.length == 2 and dim.all? {|i| i.to_i > 0}
    righe, colonne = dim[0].to_i, dim[1].to_i
    raise MatrixException, "wrong dimension" unless righe == text.length-2
    matrix = text[2..text.length+1]
    generazione = (text[0].split(" ")[1].delete ":").to_i
    raise EntryLevelException, "Generation in the first line is not correct" unless generazione > 0
    @rows, @cols, @gen = righe, colonne, generazione
    @grid = carica_griglia(matrix, @rows, @cols)
    get_posizione
  end

  ##
  # it clears the console and prints the current generation, with a generation counter and the two variables
  # representing the dimensions
  def get_posizione
    system "cls"
    puts "Generation:#{@gen}"
    puts "#{@rows} #{@cols}"
    (0..@rows - 1).each { |i|
      (0..@cols - 1).each { |j|
        print " #{@grid[i][j]} "
      }
      puts ""
    }
    puts ""
  end

  ##returns the grid array
  def get_grid
    @grid
  end

  ##
  # this method loops through the generations in order to give a sense of continuity
  def genera
    while true
      generatore
      sleep 1
    end
  end

  private

  # this method implements the rules of the Conway's Game Of Life:
  # 1) Any live cell with fewer than two live neighbours dies.
  # 2) Any live cell with two or three live neighbours lives on to the next generation.
  # 3) Any live cell with more than three live neighbours dies.
  # 4) Any dead cell with exactly three live neighbours becomes a live cell.
  # The program sets up a new matrix with all dead entries with the same dimension as the original grid, then in-place
  # adds the live cells. Once terminated, clears the screen, prints the generation and assigns the new matrix to the
  # grid instance variable.
  def generatore
    @gen+=1
      new_grid = carica_mat
      @grid.each_with_index do |riga, y|
        riga.each_with_index do |cella, x|
          contavicini = contavicini(y, x)
          new_grid[y][x] = begin
            if cella.eql?(".")
              [3].include?(contavicini) ? "*" : "."
            else
              [2, 3].include?(contavicini) ? "*" : "."
            end
          end
        end
      end
      @grid = new_grid
      get_posizione
  end

  ##
  # returns an array with every cell in the neighbourhood of a [x,y] cell
  # @param [Integer, #y] Column entry of the cell to analyze
  # @param [Integer, #x] Row entry of the cell to analyze
  def vicinato(y, x)
    (-1..1).inject [] do |values, py|
      (-1..1).each do |px|
        unless py == 0 and px == 0
          i = y + py
          j = x + px
          i = 0 unless i < @rows
          j = 0 unless j < @cols
          values << @grid[i][j]
        end
      end
      values
    end
  end

  ##
  # Analyzes the neighbourhood cells' set of an entry in order to count how many of them are alive
  # @param [Integer, #y] Column entry of the cell to analyze
  # @param [Integer, #x] Row entry of the cell to analyze
  def contavicini(y, x)
    vicinato(y, x).count { |cella| cella == "*" }
  end

  ##
  # Creates an empty matrix (with all dead cells)
  def carica_mat
    Array.new(@rows) { Array.new(@cols, ".") }
  end

  ##
  # Given a matrix object containing a set of strings each of them representing the rows of the matrix extracted from
  # the txt file, it initializes the grid instance value assigning the correct alive/dead cell for each entry.
  # @param [String[], #matrix] array of strings containing the text rows of the matrix given in input
  # @param [Integer, #righe] number of rows, extracted from the txt file
  # @param [Integer, #colonne] number of columns, extracted from the txt file
  def carica_griglia(matrix, righe, colonne)
    new_grid = Array.new(righe) { Array.new(colonne, ".") }

    (0..righe - 1).each { |i|
      raise MatrixException.new, "La riga #{i} presenta un numero errato di colonne" unless matrix[i].length == colonne
      (0..colonne - 1).each { |j|
        raise MatrixException.new, "valore errato in cella #{i}, #{j}" unless (%w[* .].include?(matrix[i][j]))
        new_grid[i][j] = matrix[i][j]
      }
    }
    new_grid
  end
end
