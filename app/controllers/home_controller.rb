class HomeController < ApplicationController
  def index
     @text = File.open("C:/Users/nicol/Documents/gol.txt").read.split("\n")
     @matrix = @text[2..@text.length+1]
     @gen = (@text[0].split(" ")[1].delete ":").to_i
     @dim = @text[1].split(" ")
     @rows = @dim[0].to_i
     @cols = @dim[1].to_i
     @@life ||= Life.new(@cols, @rows, @gen, @matrix)
     @grid = @@life.grid
  end

  def start
    cells = []
    if params[:load] == 'true'
      params[:cells].to_hash.values.each do |col, row|
        cells.push([col.to_i, row.to_i])
      end
      @@life.load cells
    end
    @grid = @@life.execute
  end
end
