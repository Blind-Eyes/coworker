# -*- encoding : utf-8 -*-
class CorreosUsuario < ActionMailer::Base
  default from: "info@entregas.com"

  def correo_olvide_mi_clave(usr)
    @usuario = usr
    mail(:to => usr.correo, :subject => "Recuperación de clave")
  end
end
