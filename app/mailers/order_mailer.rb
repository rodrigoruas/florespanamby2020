class OrderMailer < ApplicationMailer

  def confirmed(order)
    @order = order
    email = order.guest_email 
    mail(to: email, subject: 'Sua compra foi confirmada na Flores Panamby')
  end

  def delivered(order)
  end

  def confirmed_admin(order)
    @order = order
    mail(to: "contato@floretal.com.br", subject: 'ATENÇÃO! COMPRA ')
  end

  def confirmed_yasmin(order)
    @order = order
    mail(to: "yasminwaetge2@hotmail.com", subject: 'ATENÇÃO! COMPRA NA FLORES PANAMBY')
  end

  def confirmed_rodrigo(order)
    @order = order
    mail(to: "rodrigoruas2@gmail.com", subject: 'ATENÇÃO! COMPRA NA FLORES PANAMBY')
  end

  def confirmed_floricultura(order)
    @order = order
    mail(to: "contato@florespanamby.com.br", subject: 'ATENÇÃO! COMPRA FLORES PANAMBY')
  end


  def shipping(order)
    @order = order
    email = order.guest_email 
    mail(to: email, subject: 'Seu pedido está em trânsito')
  end
end
