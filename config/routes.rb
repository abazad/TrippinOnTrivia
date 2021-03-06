Rails.application.routes.draw do
  get 'questions/create_user_question'
  post "questions/create_user_question" => "questions#create_user_question", :as => :create_user_question

  resources :friendships
  devise_for :admins
  resources :charges
  resources :trophies

  resources :questions do
    collection do
      put 'rate_current_question'
      put 'save_user_question'
    end
    resources :answers
  end

  resources :categories do
    resources :trophies
    resources :questions do
      resources :answers
    end
  end

  get 'play/index'
  get 'play/display_spinner'
  get 'play/display_questions'
  get 'play/display_trophy_select'
  get 'play/display_new_game_page'
  get 'play/display_question_rating'
  get 'play/display_full_meter_choice'
  get 'play/display_challenge_trophy_selection'
  get 'play/display_friends'
  get 'play/display_user_profile'
  get 'play/display_game_stats'

  get 'admin/dashboard'

  resources :play do
    collection do
      put 'get_selected_player'
      put 'get_random_category'
      put 'achievement_message_received'
      put 'use_power_up'
      put 'toggle_mute'
      put 'toggle_avatar'
      put 'toggle_searchable'
      put 'play_friend'
      put 'promote_admin'
    end
  end

  resources :challenges do
    collection do
      put 'continue_challenge'
      put 'end_current_challenge'
      put 'set_challenge_trophy_by_id'
    end
  end

  resources :players do
    collection do
      put 'resign_current_player'
      put 'handle_correct_response'
      put 'handle_incorrect_response'
      put 'reset_question_properties'
      put 'set_category_by_id'
    end
  end


  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }
  match 'users/:id' => 'admin#destroy', :via => :delete, :as => :admin_destroy_user
  get 'admin/:id/promote_admin' => 'admin#promote_admin', :as => :admin_promote_admin
  get 'admin/:id/demote_admin' => 'admin#demote_admin', :as => :admin_demote_admin
  get 'admin/:id/promote_reviewer' => 'admin#promote_reviewer', :as => :admin_promote_reviewer
  get 'admin/:id/demote_reviewer' => 'admin#demote_reviewer', :as => :admin_demote_reviewer
  resources :users

  root 'play#index'

end
