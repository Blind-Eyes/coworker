class Procesador
	def self.analizar_excel(materia, ruta)
		documento = Excel.new(ruta)
		documento.default_sheet = documento.sheets.first
		celda_seccion = documento.cell(5,1)
		seccion = celda_seccion[9..-1]
		
		i = 1

		unless Seccion.where(:nombre => seccion, :materia_id => materia).first
			sec = Seccion.new
			sec.nombre = seccion
			sec.materia_id = materia
			sec.save
		end

		cedula = documento.cell(8,3)
		es = EstudianteSeccion.new
		es.estudiante_cedula = cedula.to_i
		es.materia_id = materia
		es.seccion_nombre = seccion
		es.save 

		while !cedula.blank? 

			cedula = documento.cell(8 + i ,3 )
			break if cedula.to_i == 0
			i +=1
			es = EstudianteSeccion.new
			es.estudiante_cedula = cedula.to_i
			es.materia_id = materia
			es.seccion_nombre = seccion
			es.save 
		end

	end
end