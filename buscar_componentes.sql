drop procedure buscarComponentes;

delimiter //
CREATE procedure buscarComponentes(
	IN cod_medicamento integer
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS temp_componentes;
	CREATE TEMPORARY TABLE temp_componentes
		SELECT pa.id_principio_activo as codigo,
			   pa.nombre as principio_activo, 
			   c.concentracion 
		FROM medicamento m
		INNER JOIN componente c ON c.id_medicamento = m.id_medicamento
		INNER JOIN principio_activo pa ON c.id_principio_activo= pa.id_principio_activo
		WHERE m.id_medicamento = cod_medicamento;
        
        #SELECT codigo, principio_activo, concentracion FROM temp_componentes;
END//

drop procedure ComponentesBuscados;

delimiter //
CREATE procedure ComponentesBuscados(
	IN cod_medicamento integer
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS mis_componentes;
	CREATE TEMPORARY TABLE mis_componentes
		SELECT pa.id_principio_activo as codigo,
			   pa.nombre as principio_activo, 
			   c.concentracion 
		FROM medicamento m
		INNER JOIN componente c ON c.id_medicamento = m.id_medicamento
		INNER JOIN principio_activo pa ON c.id_principio_activo= pa.id_principio_activo
		WHERE m.id_medicamento = cod_medicamento;
        
        #SELECT codigo, principio_activo, concentracion FROM mis_componentes;
END//
