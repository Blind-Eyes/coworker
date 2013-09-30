# -*- encoding : utf-8 -*-
class InicioController < ApplicationController
  
  layout "externo"

  def index
  end

  def validar
    reset_session
    un = params[:username]
    cl = params[:password]

    if usr = Usuario.autenticar(un, cl)
      session[:usuario] = usr
      /bitacora "El usuario #{usr.descripcion} inicio sesión"/
      session[:rol] = usr.cargo
      redirect_to :action => "bienvenida", :controller => "principal"
      return
    end
   / bitacora "Intento fallido de inicio de sesion con cedula:#{cl} y clave:#{cl}"/
    flash[:mensaje] = "Cédula o clave incorrecta"
    redirect_to :action => "index"
    return
  end

  def olvide_mi_clave
    @titulo_pagina = "Olvidé mi clave"
  end

  def procesar_olvide_mi_clave
    if verify_recaptcha
      cedula = params[:cedula]
      usuario = Usuario.where(:cedula => cedula).first
      unless usuario
        flash[:mensaje] = "Cédula no encontrada"
        redirect_to :action => "olvide_mi_clave"
        return   
      end
      CorreosUsuario.correo_olvide_mi_clave(usuario).deliver
      flash[:mensajeSuccess] = "Correo para recuperar la clave enviado exitósamente"
      redirect_to :action => "index"
      return

    else
      flash[:mensaje] = "El código de verificación fue incorrecto"
      redirect_to :action => "olvide_mi_clave"
      return   
    end
  end
end