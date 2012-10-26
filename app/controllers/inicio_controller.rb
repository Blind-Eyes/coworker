# -*- encoding : utf-8 -*-
class InicioController < ApplicationController
  
  layout "externo"

  def index
  end

  def validar
    reset_session
    un = params[:usuario][:username]
    cl = params[:usuario][:clave]
    if !un || !cl
      flash[:mensaje] = "Cédula o clave incorrecta"
      redirect_to :action => "index"
      
    end
    if usr = Usuario.autenticar(un, cl)
      session[:usuario] = usr
      /bitacora "El usuario #{usr.descripcion} inicio sesión"/
      
      session[:rol] = usr.cargo

      redirect_to :action => "bienvenida", 
      :controller => "principal"
      return
/
       if session[:usuario].es_estudiante_admin?
        redirect_to :action => "bienvenida", :controller => "principal"
        return
      end
      if session[:usuario].es_estudiante_docente?
        redirect_to :action => "bienvenida", :controller => "principal"
        return
      end
      if session[:usuario].es_docente_admin?
        redirect_to :action => "bienvenida", :controller => "principal"
        return
      end
      if session[:usuario].es_estudiante?
        redirect_to :action => "estudiante", :controller => "principal"
        return
      end
      if session[:usuario].es_docente?
        redirect_to :action => "docente", :controller => "principal"
        return
      end
      if session[:usuario].es_administrador?
        redirect_to :action => "index", :controller =>"configuracion"
        return
      end/
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
      #captcha is valid
    else
      #captcha is invalid
    end
    unless params[:usuario] &&
      params[:usuario][:cedula]
      bitacora "Faltan parametros en olvide mi clave"
      flash[:mensaje] = "Faltan parametros"
      redirect_to :action => "index"
      return   
    end

    cedula = params[:usuario][:cedula]

    usuario = Usuario.where(:cedula => cedula).first

    unless usuario
      bitacora "Intento fallido de recuperacion de clave con cedula:#{cedula}"
      flash[:mensaje] = "Cédula no encontrada"
      redirect_to :action => "index"
      return   
    end

    CorreosUsuario.correo_olvide_mi_clave(usuario).deliver
    bitacora "Se envio un correo al usuario #{usuario.nombre_completo} para recuperar su clave"
    flash[:mensaje] = "Correo enviado exitósamente para recuperar la clave"
    redirect_to :action => "index"
    return

  end
end