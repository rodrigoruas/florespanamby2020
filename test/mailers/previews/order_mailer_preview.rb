# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/welcome
 def confirmed
     order = Order.where(state: "paid").last
     OrderMailer.confirmed(order)
   end

end
