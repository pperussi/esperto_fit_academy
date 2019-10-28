class Employee < ApplicationRecord

  belongs_to :gym, optional: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :registerable,


  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  validates :name, :status, :email, presence: { message: 'deve ser preenchido!' }
  validates :gym, presence: { message: 'deve ser preenchido!' }, unless: :admin?
  validates :email, uniqueness: { message: 'Email deve ser unico!' }
  validate :corporative_email_constraint

  enum status: {unactive: 0, active: 1}

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    active_for_authentication? ? super : :account_inactive
  end

  def translate_status
    I18n.t "activerecord.attributes.employee.statuses.#{status}"
  end

  def gym?(gym)
    self.gym == gym
  end

  def authenticate_employee(password, user)
    found_employee = Employee.find_for_authentication(email: user.email)
    found_employee.valid_password?(password)
  end


  private

  def corporative_email_constraint
    corporative_email = /\A([^@\s]+)@espertofit\.com\.br\z/i
    errors.add(:email, "deve ser corporativo!") unless email =~ corporative_email
  end


end
