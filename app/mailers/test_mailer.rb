class TestMailer < ActionMailer::Base
  def hello
    mail(
      :subject => 'Hello from Postmark',
      :to  => 'contato@floretal.com.br',
      :from => 'contato@floretal.com.br',
      :html_body => '<strong>Hello</strong> dear Postmark user.',
      :track_opens => 'true')
  end
end
