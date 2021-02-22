DROP PROCEDURE IF EXISTS buscarMedicamentos;
delimiter //
CREATE procedure buscarMedicamentos(
	IN cod_medicamento integer
)
	BEGIN
		DECLARE total_medicamentos INT DEFAULT 0;
        DECLARE total_componentes INT DEFAULT 0;
        DECLARE temp_nombre VARCHAR(45);
        DECLARE temp_total INT DEFAULT 0;
        DECLARE encontrados INT DEFAULT 0;
		DECLARE indice INT DEFAULT 0;
        DECLARE id INT(11);

		DROP TEMPORARY TABLE IF EXISTS medicamentos_iguales;
        DROP TEMPORARY TABLE IF EXISTS mis_componentes;
        DROP TEMPORARY TABLE IF EXISTS temp_componentes;
		
        CREATE TEMPORARY TABLE medicamentos_iguales(
			id_medicamento INT(11),
            nombre VARCHAR(45)
		);
        
        CREATE TEMPORARY TABLE mis_componentes(
			codigo INT(11),
            principio_activo VARCHAR(45),
            concentracion VARCHAR(45)
        );
        
		CREATE TEMPORARY TABLE temp_componentes(
			codigo INT(11),
            principio_activo VARCHAR(45),
            concentracion VARCHAR(45)
        );
        
		SELECT COUNT(*) FROM medicamento INTO total_medicamentos;
		SET indice = 0;
        
        INSERT INTO  mis_componentes SELECT pa.id_principio_activo as codigo,
					 pa.nombre as principio_activo, 
					 c.concentracion 
		FROM medicamento m
		INNER JOIN componente c ON c.id_medicamento = m.id_medicamento
		INNER JOIN principio_activo pa ON c.id_principio_activo= pa.id_principio_activo
		WHERE m.id_medicamento = cod_medicamento;
                
        SELECT COUNT(*) FROM mis_componentes INTO total_componentes;
        
		IF total_componentes > 0 THEN
			WHILE indice < total_medicamentos DO 
			
				SELECT id_medicamento, nombre INTO id, temp_nombre FROM medicamento LIMIT indice,1;
                
                DELETE from temp_componentes WHERE codigo != 0;
                
				INSERT INTO  temp_componentes SELECT pa.id_principio_activo as codigo,
						   pa.nombre as principio_activo, 
						   c.concentracion 
				FROM medicamento m
				INNER JOIN componente c ON c.id_medicamento = m.id_medicamento
				INNER JOIN principio_activo pa ON c.id_principio_activo= pa.id_principio_activo
				WHERE m.id_medicamento = id;
				
				SELECT COUNT(*) FROM temp_componentes INTO temp_total;
                
				IF temp_total > 0 AND temp_total <= total_componentes THEN
                    
					SET encontrados = 0;
                    
					SELECT COUNT(*) INTO encontrados FROM mis_componentes
                    INNER JOIN temp_componentes
                    ON mis_componentes.codigo = temp_componentes.codigo AND mis_componentes.concentracion = temp_componentes.concentracion;
						
					IF encontrados = total_componentes AND id != cod_medicamento  THEN
						INSERT INTO medicamentos_iguales(id_medicamento, nombre) VALUES(id, temp_nombre);
					END IF;
					
				END IF;
				
				SET indice = indice + 1;
			END WHILE;
        END IF;
        
        
        SELECT id_medicamento, nombre FROM medicamentos_iguales;
        
		DROP TEMPORARY TABLE IF EXISTS medicamentos_iguales;
        DROP TEMPORARY TABLE IF EXISTS mis_componentes;
        DROP TEMPORARY TABLE IF EXISTS temp_componentes;
END//

call buscarMedicamentos(17);
