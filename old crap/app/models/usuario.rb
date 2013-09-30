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

  def es_administrador?
    Administrador.where(:usuario_cedula => cedula).first
  end

  def es_director?
    Director.where(:usuario_cedula => cedula).first
  end

  def es_supervisor?
    Supervisor.where(:usuario_cedula => cedula).first
  end

  def es_auxiliar?
    Auxiliar.where(:usuario_cedula => cedula).first
  end

  def rol
    if ret = es_administrador?
      return ret
    end
    if ret = es_director?
      return ret
    end
    if ret = es_supervisor?
      return ret
    end
    if ret = es_auxiliar?
      return ret
    end
  end
end
