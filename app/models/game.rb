class Game < ActiveRecord::Base

  scope :is_available, -> { where("black_player_id = 0 or white_player_id = 0") }
  has_many :timers
  after_create :populate_board!

  def populate_board!
    # black_player_id
    (0..7).each do |i|
      Pawn.create(player_id: self.black_player_id, game_id: self.id, x_position: i, y_position: 1)
    end

    Rook.create(player_id: self.black_player_id, game_id: self.id, x_position: 0, y_position: 0)
    Rook.create(player_id: self.black_player_id, game_id: self.id, x_position: 7, y_position: 0)
    Knight.create(player_id: self.black_player_id, game_id: self.id, x_position: 1, y_position: 0)
    Knight.create(player_id: self.black_player_id, game_id: self.id, x_position: 6, y_position: 0)
    Bishop.create(player_id: self.black_player_id, game_id: self.id, x_position: 2, y_position: 0)
    Bishop.create(player_id: self.black_player_id, game_id: self.id, x_position: 5, y_position: 0)
    Queen.create(player_id: self.black_player_id, game_id: self.id, x_position: 3, y_position: 0)
    King.create(player_id: self.black_player_id, game_id: self.id, x_position: 4, y_position: 0)



    # white_player_id
    (0..7).each do |i|
      Pawn.create(player_id: self.white_player_id, game_id: self.id, x_position: i, y_position: 6)
    end

    Rook.create(player_id: self.white_player_id, game_id: self.id, x_position: 0, y_position: 7)
    Rook.create(player_id: self.white_player_id, game_id: self.id, x_position: 7, y_position: 7)
    Knight.create(player_id: self.white_player_id, game_id: self.id, x_position: 1, y_position: 7)
    Knight.create(player_id: self.white_player_id, game_id: self.id, x_position: 6, y_position: 7)
    Bishop.create(player_id: self.white_player_id, game_id: self.id, x_position: 2, y_position: 7)
    Bishop.create(player_id: self.white_player_id, game_id: self.id, x_position: 5, y_position: 7)
    Queen.create(player_id: self.white_player_id, game_id: self.id, x_position: 3, y_position: 7)
    King.create(player_id: self.white_player_id, game_id: self.id, x_position: 4, y_position: 7)
  end

  has_many :pieces
  has_many :players
  belongs_to :white_player, class_name: 'Player'
  belongs_to :black_player, class_name: 'Player'

  def is_piece_present?(x, y)
    self.pieces.where(x_position: x, y_position: y).any?
  end

  def get_piece(x, y)
    self.pieces.where(x_position: x, y_position: y).take
  end

  def create_timers(time_left)
    self.timers.create(player_id: self.white_player_id,time_left: time_left)
    self.timers.create(player_id: self.black_player_id,time_left: time_left)
  end

  def update_timer(current_player)
    timer = self.timers.where(player_id: 0).last
    if timer != nil
      timer.player_id = current_player.id
      timer.save
    end
  end

  def check?(player)
    check = false
    king = pieces.where(type: 'King', player: player).last
    opponents_pieces = pieces.where(player: opponent_player(player), captured: false)
    if king !=nil
      return opponents_pieces.any? { |piece| piece.valid_move?(king.x_position, king.y_position) }
    end
      return false
  end

  def checkmate?(player)
    if check?(player)
      checkmate = true
      king = pieces.where(type: 'King', player: player).last
      (0..7).each do |x|
        (0..7).each do |y|
          if king.valid_move?(x, y)
            original_x = king.x_position
            original_y = king.y_position
            captured_piece = pieces.where(x_position: x,y_position: y, game_id: id).last
            king.move_to(x, y)
            checkmate = false if !check?(player)
            king.move_to(original_x, original_y)
            if captured_piece != nil
              captured_piece.reload.update_attributes(x_position: x, y_position: y, captured: false)
            end
          end
        end
      end
      return checkmate
    end
    return false
  end

  def stalemate?(player)
    stalemate = false
    if !check?(player)
      stalemate = true
      pieces.where(player_id: player.id, captured: false).each do |piece|
        (0..7).each do |x|
          (0..7).each do |y|
            if piece.valid_move?(x, y)
              original_x = piece.x_position
              original_y = piece.y_position
              captured_piece = pieces.where(x_position: x,y_position: y, game_id: id).last
              piece.move_to(x, y)
              stalemate = false if !check?(player)
              piece.move_to(original_x, original_y)
              if captured_piece != nil
                captured_piece.reload.update_attributes(x_position: x, y_position: y, captured: false)
              end
            end
          end
        end
      end
    end
    stalemate
  end

  def set_default_turn!
    update_attributes(current_turn: white_player_id)
  end

  def current_player_turn
    if current_turn == white_player_id
      return "white"
    else
      return "black"
    end
  end

  def opponent
    current_turn == (white_player_id || 0) ? black_player_id : white_player_id
  end

  def change_turns!
    update_attributes(current_turn: opponent)
  end

  private

  def opponent_player(player)
    player == white_player ? black_player.id : white_player.id
  end

end
