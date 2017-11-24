module Devise::Models::Recoverable

  def set_reset_password_token
raw, enc = '1234567' #Devise.token_generator.generate(self.class, :reset_password_token)

    self.reset_password_token = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    raw
  end

end
