SELECT p.localidad, COUNT(s.id_solicitud) AS total_solicitudes
FROM Parada p
INNER JOIN SolicitudReserva s ON p.id_parada = s.id_parada
INNER JOIN Viaje v ON p.id_viaje = v.id_viaje
WHERE v.fecha_hora_salida BETWEEN TO_DATE(:P2_FECHA_INICIO, 'YYYY-MM-DD') AND TO_DATE(:P2_FECHA_FIN, 'YYYY-MM-DD')
GROUP BY p.localidad
ORDER BY total_solicitudes DESC

SELECT p.localidad, SUM(v.tarifa) AS ingresos_totales
FROM Viaje v
INNER JOIN Parada p ON v.id_viaje = p.id_viaje
WHERE v.fecha_hora_salida BETWEEN TO_DATE(:P2_FECHA_INICIO, 'YYYY-MM-DD') AND TO_DATE(:P2_FECHA_FIN, 'YYYY-MM-DD')
GROUP BY p.localidad
ORDER BY ingresos_totales DESC

SELECT TO_CHAR(v.fecha_hora_salida, 'YYYY-MM') AS mes, 
       COUNT(v.id_viaje) AS total_viajes
FROM Viaje v
INNER JOIN Vehiculo veh ON v.placa = veh.placa
WHERE (:P_ID_CONDUCTOR IS NULL OR veh.id_conductor = :P_ID_CONDUCTOR)
GROUP BY TO_CHAR(v.fecha_hora_salida, 'YYYY-MM')
ORDER BY mes;