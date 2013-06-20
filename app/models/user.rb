class User < ActiveRecord::Base

  validates :name,     presence: true,
                       uniqueness: true
  validates :email,    presence: true,
                       uniqueness: true,
                       format: { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :password_hash, presence: true

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def password=(pass)
    @password = BCrypt::Password.create(pass)
    self.password_hash = @password
  end

  def self.create(params={})
    @user = User.new(params)
    @user.password = params[:password]
    @user.save!
    @user
  end

  def self.authenticate(params={})
    user = User.find_by_email(params[:user][:email])
    (user && user.password == params[:user][:password]) ? user : nil
  end

end
