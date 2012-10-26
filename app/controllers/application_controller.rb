# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  def bitacora(descripcion)
    b = Bitacora.new
    b.descripcion = descripcion
    b.estudiante_cedula = session[:usuario].cedula if session[:usuario]
    b.fecha_hora = Time.now
    b.ip = request.remote_ip
    b.save
  end

  def verificar_autenticado
    unless session[:usuario]
      #bitacora "Intento de acceso sin autenticacion"
      flash[:mensaje] = "Debe autenticarse"
      redirect_to :action => "index", :controller => "inicio"
      return
    end
  end

end
