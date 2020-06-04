class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :orders
  has_many :order_details
  validates :cpf, :first_name, :last_name, presence: true
  validates_format_of :cpf, with: /([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})/i, message: "Inválido"
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  after_create :send_welcome_mail

  scope :admin_users, -> { where(admin: true) }
  scope :not_admin_users, -> { where(admin: false) }

  def send_welcome_mail
    unless guest
      UserMailer.welcome(self).deliver
    end
  end
end
