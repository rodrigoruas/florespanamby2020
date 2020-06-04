class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user  # Instance variable => available in view
    mail(to: @user.email, subject: 'Bem vindo a Flor & Tal')
  end

   def hello
    mail(
      :subject => 'Hello from Postmark',
      :to  => 'contato@floretal.com.br',
      :from => 'contato@floretal.com.br',
      :html_body => '<strong>Hello</strong> dear Postmark user.',
      :track_opens => 'true')
  end
end
