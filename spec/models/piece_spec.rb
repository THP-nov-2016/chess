require 'rails_helper'

RSpec.describe Piece, type: :model do

  let(:white_player) { FactoryGirl.create(:player, email: 'blah@blah.com', password: 'SPACECAT') }
  let(:black_player) { FactoryGirl.create(:player, email: 'meow@meow.com', password: 'MONORAILCAT') }
  let(:game) { FactoryGirl.create(:game, white_player_id: white_player.id, black_player_id: black_player.id) }

  describe "King#valid_move?" do

    let(:king) { FactoryGirl.create(:king, game_id: game.id, player_id: black_player.id) }
    
    subject { king.valid_move?(destination_x, destination_y) }

    context "valid move" do
      let(:destination_x) { 5 }
      let(:destination_y) { 5 }

      it "should return true if the move is valid" do
        expect(subject).to eq(true)
      end
    end

    context "invalid move" do
      let(:destination_x) { 7 }
      let(:destination_y) { 7 }

      it "should return false if the king tries to move too far" do
        expect(subject).to eq(false)
      end
    end

    context "no move" do
      let(:destination_x) { 4 }
      let(:destination_y) { 4 }

      it "should return false if the king tries to move on top of itself" do
        expect(subject).to eq(false)
      end
    end

  end

  describe 'a King' do
    it 'should be a King' do
      king = FactoryGirl.create(:king, player_id: black_player.id)
      expect(king.type).to eq 'King'
    end
  end

  describe 'a Pawn' do

    let(:pawn) { FactoryGirl.create(:pawn, x_position: 2, y_position: 1, game_id: game.id, player_id: black_player.id) }

    it 'should be a pawn' do
      pawn = FactoryGirl.create(:pawn, player_id: black_player.id)
      expect(pawn.type).to eq 'Pawn'
    end
  end

  describe "Piece#valid_move?" do

    let(:piece) { FactoryGirl.create(:piece, game_id: game.id, player_id: white_player.id) }

    subject { piece.valid_move?(7, 4) }

    it "should return true if the piece is not obstructed" do
      expect(subject).to eq(true)
    end

    it "should return false if the piece is obstructed" do
      FactoryGirl.create(:piece, x_position: 6, y_position: 4, game_id: game.id, player_id: black_player.id)
      expect(subject).to eq(false)
    end

    it "should return false if a piece of the same color is occupying the destination" do
      FactoryGirl.create(:piece, x_position: 7, y_position: 4, game_id: game.id, player_id: white_player.id)
      expect(subject).to eq(false)
    end

  end

  describe "Piece#is_obstructed?" do

    let(:piece) { FactoryGirl.create(:piece, x_position: 4, y_position: 4, game_id: game.id, player_id: white_player.id) }

    subject { piece.is_obstructed?(destination_x, destination_y) }

    context "up" do
      let(:destination_x) { 4 }
      let(:destination_y) { 7 }

      it "should return false if it's not vertically blocked" do
        expect(subject).to eq(false)
      end

      it "should return true if it's vertically blocked" do
        FactoryGirl.create(:piece, x_position: 4, y_position: 6, game_id: game.id, player_id: black_player.id)
        expect(subject).to eq(true)
      end
    end

    context "down" do
      let(:destination_x) { 4 }
      let(:destination_y) { 0 }

      it "should return false if it's not vertically blocked" do
        expect(subject).to eq(false)
      end

      it "should return true if it's vertically blocked" do
        FactoryGirl.create(:piece, x_position: 4, y_position: 1, game_id: game.id, player_id: black_player.id)
        expect(subject).to eq(true)
      end
    end

    context "right" do
      let (:destination_x) { 7 }
      let (:destination_y) { 4 }

      it "should return false if it's not horizontally blocked" do
        expect(subject).to eq(false)
      end

      it "should return true if it's horizontally blocked" do
        FactoryGirl.create(:piece, x_position: 6, y_position: 4, game_id: game.id, player_id: black_player.id)
        expect(subject).to eq(true)
      end
    end

    context "left" do
      let (:destination_x) { 0 }
      let (:destination_y) { 4 }

      it "should return false if it's not horizontally blocked" do
        expect(subject).to eq(false)
      end

      it "should return true if it's horizontally blocked" do
        FactoryGirl.create(:piece, x_position: 1, y_position: 4, game_id: game.id, player_id: black_player.id)
        expect(subject).to eq(true)
      end
    end

    context "up and right" do
      let (:destination_x) { 7 }
      let (:destination_y) { 7 }

      it "should return false if it's not diagonally blocked" do
        expect(subject).to eq(false)
      end

      it "should return true if it's diagonally blocked" do
        FactoryGirl.create(:piece, x_position: 6, y_position: 6, game_id: game.id, player_id: black_player.id)
        expect(subject).to eq(true)
      end
    end

    context "up and left" do
      let (:destination_x) { 1 }
      let (:destination_y) { 7 }

      it "should return false if it's not diagonally blocked" do
        expect(subject).to eq(false)
      end

      it "should return true if it's diagonally blocked" do
        FactoryGirl.create(:piece, x_position: 2, y_position: 6, game_id: game.id, player_id: black_player.id)
        expect(subject).to eq(true)
      end
    end

    context "down and right" do
      let (:destination_x) { 7 }
      let (:destination_y) { 1 }

      it "should return false if it's not diagonally blocked" do
        expect(subject).to eq(false)
      end

      it "should return true if it's diagonally blocked" do
        FactoryGirl.create(:piece, x_position: 6, y_position: 2, game_id: game.id, player_id: black_player.id)
        expect(subject).to eq(true)
      end
    end

    context "down and left" do
      let (:destination_x) { 0 }
      let (:destination_y) { 0 }

      it "should return false if it's not diagonally blocked" do
        expect(subject).to eq(false)
      end

      it "should return true if it's diagonally blocked" do
        FactoryGirl.create(:piece, x_position: 1, y_position: 1, game_id: game.id, player_id: black_player.id)
        expect(subject).to eq(true)
      end
    end

  end
  
end
