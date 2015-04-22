class PlayController < ApplicationController
  before_action :authenticate_user!

  SPINNER_DEGREES = 360

  def index

  end

  def display_friends
    @users = User.all
    render :layout => false
  end

  def display_spinner

    current_user.active_player.update_attribute(:going_for_trophy, false)
    if current_user.active_player.current_question.present?
      detect_cheating
    end
    current_user.active_player.check_win
  end

  def display_new_game_page
    current_user.active_player = current_user.players.create(meter: 0, isActivePlayer: true)

    current_user.active_player.get_random_opponent_from_group
  end

  def display_questions

    if current_user.active_player.challenges.first.nil?
      current_user.active_player.current_question = current_user.active_player.current_category.questions.all.shuffle[0]
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def display_trophy_select
    @categories = Category.all
    current_user.active_player.update_attribute(:going_for_trophy, true)
    current_user.active_player.update_attribute(:meter, 0)
  end

  def display_full_meter_choice
    current_user.active_player.update_attribute(:meter, 0)
    if current_user.active_player.has_opponent
      Challenge.make_new_challenge(current_user.active_player)
    end
  end

  def get_random_category
    rotations = params[:rotations].to_i
    degree = rotations % SPINNER_DEGREES
    current_user.active_player.set_category_by_degree(degree)
    render nothing: true
  end

  def play_friend
    user = User.find(params[:id])
    current_user.active_player.set_user_as_opponent(user)
    render nothing: true
  end

  def achievement_message_received
    current_user.update_attribute(:has_new_achievement, false)
    render nothing: true
  end

  def get_selected_player
    current_user.active_player = current_user.players.find(params[:player_id])
    render nothing: true
  end

  def use_power_up
    current_user.update_attribute(:points, current_user.points - 1)
    render nothing: true
  end

  def toggle_mute
    current_user.change_muted_status
    render :nothing => true
  end
end
