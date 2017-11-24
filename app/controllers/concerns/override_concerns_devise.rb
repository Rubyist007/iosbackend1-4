module Devise::Models::Recoverable

  def set_reset_password_token
    raw = [1,1,1,1,1,1]
    raw.map! { rand(10) }
    enc = Devise.token_generator.digest(User, :reset_password_token, raw)

    self.reset_password_token = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    raw
  end

end
