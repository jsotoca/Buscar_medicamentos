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
        CREATE TEMPORARY TABLE medicamentos_iguales(
			id_medicamento INT(11),
            nombre VARCHAR(45)
		);
        
		SELECT COUNT(*) FROM medicamento INTO total_medicamentos;
		SET indice = 0;
        
        call ComponentesBuscados(cod_medicamento);
        SELECT COUNT(*) FROM mis_componentes INTO total_componentes;
        
		IF total_componentes > 0 THEN
			WHILE indice < total_medicamentos DO 
			
				SELECT id_medicamento, nombre INTO id, temp_nombre FROM medicamento LIMIT indice,1;
				call buscarComponentes(id);
				
				SELECT COUNT(*) FROM temp_componentes INTO temp_total;
				
				IF temp_total > 0 THEN
					SET encontrados = 0;
				
					SELECT COUNT(*) INTO encontrados
					FROM
					(SELECT * FROM mis_componentes
					UNION ALL  
					SELECT * FROM temp_componentes) data
					GROUP BY codigo, principio_activo, concentracion
					HAVING count(*) != total_componentes;
					
					IF encontrados > 0 AND id != cod_medicamento  THEN
						INSERT INTO medicamentos_iguales(id_medicamento, nombre) VALUES(id, temp_nombre);
					END IF;
					
				END IF;
				
				SET indice = indice + 1;
			END WHILE;
        END IF;
        
        
        SELECT id_medicamento, nombre FROM medicamentos_iguales;
END//


call buscarMedicamentos(16);
