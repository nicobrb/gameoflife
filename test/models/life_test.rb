require "test_helper"

class LifeTest < ActiveSupport::TestCase
  test "Raise EntryLevelException because the dimension line contains syntax errors" do
    assert_raise(EntryLevelException){
      Life.new(Rails.root.join("test/testfiles/wrongsize.txt").to_s)
    }
  end

  test "Raise MatrixException because the matrix contains a wrong char" do
    assert_raise(MatrixException){
      Life.new(Rails.root.join("test/testfiles/wrongsymbol.txt").to_s)
    }
  end

  test "Raise EntryLevelException because of the wrong number of rows" do
    assert_raise(MatrixException){
      Life.new(Rails.root.join("test/testfiles/wrongrows.txt").to_s)
    }
  end

  test "Raise MatrixException because of the wrong number of columns" do
    assert_raise(MatrixException){
      Life.new(Rails.root.join("test/testfiles/wrongcolumns.txt").to_s)
    }
  end

  test "Raise EntryLevelException because the generation is not a positive integer" do
    assert_raise(EntryLevelException){
      Life.new(Rails.root.join("test/testfiles/wronggeneration.txt").to_s)
    }
  end

  test "Correct initialization" do
    gol = Life.new(Rails.root.join("test/testfiles/gol.txt").to_s)
    assert_equal(gol.get_grid,
                 [%w[. . . . . . * * * . . . * * . . . * * * . . . . . * * *],
                  %w[. . * * . . . . * * . . . . * * . . . . * * . . . . * *],
                  %w[. . * . . . . . * * * * * * * * . . . . * * * * . . . *],
                  %w[. . * . . . . . * * * * * * * * . . . . * * * * . . . *],
                  %w[. . * . . . . . * * * * * * * * . . . . * * * * . . . *],
                  %w[. . . * . . . . . . . . . . . . . . . . . . . . . . . .],
                  %w[. . . * . . * * * . . . * * * * . . . * * * * . . . * *],
                  %w[. . . . . . * * * * * * * * * * * * * * * * * * * * * .]])
  end
  test "Correct generation" do
    gol = Life.new(Rails.root.join("test/testfiles/gol.txt").to_s)
    gol.send(:generatore)
    assert_equal(gol.get_grid,
                 [%w[. . . . . . * . . . . . . . . . . . . . . . . * . . . .],
                  %w[* . * * . . . . . . . . . . . * * . * . . . . . . * . .],
                  %w[* * * . . . . * . . . . . . . . * . . * . . . * . . . *],
                  %w[* * * * . . . * . . . . . . . . * . . * . . . . * . * *],
                  %w[. . * * . . . . * . . . . . . * . . . . * . . * . . . .],
                  %w[. . * * . . . . . . * . . . . . . . . * . . . * . . * *],
                  %w[. . . . . . * . . . * . . . . . . * . . . . . . * . * *],
                  %w[. . . . . * . . . . * . . . . . . . . . . . . * * . . .]]
)
  end

end
