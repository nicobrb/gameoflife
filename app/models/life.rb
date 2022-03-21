
class Life
  attr_accessor :grid, :cols, :rows

  def initialize(cols, rows, gen, matrix)
    @cols = cols
    @rows = rows
    @gen = gen
    @grid = load_mat
    @grid = load_grid(matrix)
  end

  def load(cells)
    cells.each { |y, x| grid[y][x] = 1 }
  end

  def neighbors_count(y, x)
    neighbors(y, x).count { |cell| cell == 1 }
  end

  def execute
    new_grid = load_mat
    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        count = neighbors_count(y, x)
        new_grid[y][x] = begin
          if cell.eql?(".")
            [3].include?(count) ? "*" : "."
          else
            [2, 3].include?(count) ? "*" : "."
          end
        end
      end
    end

    @grid = new_grid
  end


  private

  def neighbors(y, x)
    (-1..1).inject [] do |values, py|
      (-1..1).each do |px|
        unless py == 0 and px == 0
          i = y + py
          j = x + px
          i = 0 unless i < rows
          j = 0 unless j < cols
          values << grid[i][j]
        end
      end
      values
    end
  end

  def load_mat
    Array.new(rows) { Array.new(cols, ".") }
  end

  def load_grid(matrix)
    @new_grid = load_mat
    (0..@rows - 1).each { |i|
      (0..@cols - 1).each { |j|
        @new_grid[i][j] = matrix[i][j]
      }
    }
    @grid = @new_grid
  end
end