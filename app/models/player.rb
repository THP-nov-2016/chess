class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook,:twitter, :google]
  
  has_many :timers
  has_many :pieces
  has_many :games
  
  def self.from_omniauth(auth)
    
    where(provider: auth.provider, uid: auth.uid.to_s).first_or_create do |player|
      player.provider = auth.provider
      player.uid = auth.uid.to_s
      if player.provider == "twitter"
        player.email = "#{auth.info.nickname}@twitter.com"
      else
        player.email = auth.info.email
      end
      player.password = Devise.friendly_token[0,20]
    end
  end

  def join_game!(game)
    if game.white_player_id == 0
      game.update_attributes(:white_player_id => id)
    else
      game.update_attributes(:black_player_id => id)
    end
    game.pieces.each do |piece|
      piece.update_attributes(:player_id => id) if piece.player_id == 0
    end
  end

  def add_win!
    win_count = self.wins + 1
    self.update_attributes(:wins => win_count)
  end

  def add_draw!
    draw_count = self.draws + 1
    self.update_attributes(:draws => draw_count)
  end

  def add_loss!
    loss_count = self.losses + 1
    self.update_attributes(:losses => loss_count)
  end

end
