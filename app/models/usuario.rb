# -*- encoding : utf-8 -*-
class Usuario < ActiveRecord::Base
	set_primary_key :cedula
  has_many :auxiliar

  def nombre_completo 
    "#{nombre} #{apellido}"
  end

  def descripcion
    "#{cedula} - #{nombre} #{apellido}"
  end

  def self.autenticar(username, password)
    #Usuario.where(:cedula => cedula, :clave => clave).first
    
    clave_digest = Digest::MD5.hexdigest(password)
    Usuario.where(:username => username, :password => clave_digest).first

    #Usuario.where(["cedula = ? AND clave = MD5(?)", cedula, clave]).first
  end

  /def es_estudiante?
    Estudiante.where(:usuario_cedula => cedula).first
  end

  def es_docente?
    Docente.where(:usuario_cedula => cedula).first
  end

  def es_administrador?
    Administrador.where(:usuario_cedula => cedula).first
  end

  def es_estudiante_admin?
    Estudiante.where(:usuario_cedula => cedula).first && Administrador.where(:usuario_cedula => cedula).first
  end

  def es_estudiante_docente?
    Estudiante.where(:usuario_cedula => cedula).first && Docente.where(:usuario_cedula => cedula).first
  end

  def es_docente_admin?
    Docente.where(:usuario_cedula => cedula).first && Administrador.where(:usuario_cedula => cedula).first
  end

  def rol
    if ret = es_estudiante?
      return ret
    end
    if ret = es_docente?
      return ret
    end
    if ret = es_administrador?
      return ret
    end
  end/
end
