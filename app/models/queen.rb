class Queen < Piece

  def valid_move?(destination_x, destination_y)
    valid = super(destination_x, destination_y)
    valid && (
      horizontal(destination_y) || 
      vertical(destination_x) || 
      diagonal(destination_x, destination_y)
      )
  end
  
  def unicode_symbol
    if self.get_color == WHITE
      return "&#9813;"
    else
      return "&#9819;"
    end
  end

end
