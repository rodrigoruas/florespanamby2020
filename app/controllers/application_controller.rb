class ApplicationController < ActionController::Base
  before_action :navbar
  protect_from_forgery with: :exception
  protect_from_forgery :except => :receive_guest
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!
  # before_action :set_raven_context

  def configure_permitted_parameters
   # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :cpf, :birthday, :phone, :address, :admin])

   # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def navbar
    @categories = Category.where(navbar: true).sort_by{|category| category.navbar_order}.reverse
  end

  private

  # def set_raven_context
  #   Raven.user_context(id: session[:current_user_id]) # or anything else in session
  #   Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  # end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
     # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def get_user
    if current_user
      current_user
    else
      user = User.where(guest_id: session.id)
      user == [] ? create_guest_user : user.first
    end  
  end

  def create_guest_user
    u = User.new(:first_name => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com", guest: true, guest_id: session.id)
    u.save!(:validate => false)
    u
  end

end
