class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook,:twitter, :google]

  has_many :timers

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

  def join_game
    if @game.white_player_id == 0
      @game.update_attribute(:white_player_id, current_player.id)
    else
      @game.update_attribute(:black_player_id, current_player.id)
    end
  end
end
