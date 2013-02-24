class Applicant < ActiveRecord::Base
  # attr_accessible :title, :body

  before_create :generate_token

  protected

  def generate_token
    begin
      self.token = SecureRandom.urlsafe_base64
    end while self.class.exists?(:token => token)
  end


end
