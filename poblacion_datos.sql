DELETE FROM SolicitudReserva;
DELETE FROM Parada;
DELETE FROM Viaje;
DELETE FROM Vehiculo;
DELETE FROM Conductor;
DELETE FROM Pasajero;
DELETE FROM Estudiante;
COMMIT;

INSERT INTO Estudiante (id_estudiante, documento_id, nombres, apellidos, universidad, programa, correo, numero_celular)
SELECT 
    level AS id_estudiante,
    1000000000 + level AS documento_id,
    'Conductor_' || level AS nombres,
    'Alpes_' || level AS apellidos,
    'Uniandes' AS universidad,
    'Ingeniería de Sistemas' AS programa,
    'conductor' || level || '@uniandes.edu.co' AS correo,
    '30000000' || LPAD(level, 2, '0') AS numero_celular
FROM dual CONNECT BY level <= 20;

INSERT INTO Conductor (id_conductor)
SELECT level FROM dual CONNECT BY level <= 20;

INSERT INTO Estudiante (id_estudiante, documento_id, nombres, apellidos, universidad, programa, correo, numero_celular)
SELECT 
    20 + level AS id_estudiante,
    2000000000 + level AS documento_id,
    'Pasajero_' || level AS nombres,
    'Estudiante_' || level AS apellidos,
    'Uniandes' AS universidad,
    'Administración' AS programa,
    'pasajero' || level || '@uniandes.edu.co' AS correo,
    '31000000' || LPAD(level, 3, '0') AS numero_celular
FROM dual CONNECT BY level <= 150;

INSERT INTO Pasajero (id_pasajero)
SELECT 20 + level FROM dual CONNECT BY level <= 150;


INSERT INTO Vehiculo (placa, marca, modelo, anio, color, cupos, id_conductor)
SELECT 
    'WHL' || LPAD(level, 3, '0') AS placa,
    CASE MOD(level, 3) WHEN 0 THEN 'Mazda' WHEN 1 THEN 'Renault' ELSE 'Chevrolet' END AS marca,
    'Modelo_' || level AS modelo,
    2018 + MOD(level, 6) AS anio,
    CASE MOD(level, 4) WHEN 0 THEN 'Gris' WHEN 1 THEN 'Blanco' WHEN 2 THEN 'Negro' ELSE 'Rojo' END AS color,
    4 AS cupos,
    level AS id_conductor
FROM dual CONNECT BY level <= 20;

INSERT INTO Viaje (id_viaje, fecha_hora_salida, fecha_hora_llegada, punto_origen, ruta_general, distancia_km, tarifa, estado, cupos_disponibles, placa)
SELECT 
    level AS id_viaje,
    TO_DATE('2026-01-01 07:00:00', 'YYYY-MM-DD HH24:MI:SS') + (level * 12) AS fecha_hora_salida,
    TO_DATE('2026-01-01 07:45:00', 'YYYY-MM-DD HH24:MI:SS') + (level * 12) AS fecha_hora_llegada,
    'Calle ' || (level * 5) || ' #15-20' AS punto_origen,
    'Norte - Uniandes Centro' AS ruta_general,
    ROUND(8 + (level * 1.3), 2) AS distancia_km,       
    5000 + (level * 450) AS tarifa,                  
    CASE MOD(level, 4) WHEN 0 THEN 'Completado' WHEN 1 THEN 'Programado' WHEN 2 THEN 'En curso' ELSE 'Cancelado' END AS estado,
    4 AS cupos_disponibles,
    'WHL' || LPAD(level, 3, '0') AS placa
FROM dual CONNECT BY level <= 20;


INSERT INTO Parada (id_parada, ubicacion, localidad, id_viaje)
SELECT 
    level AS id_parada,
    'Estación Calle ' || (level * 5) AS ubicacion,
    CASE MOD(level, 4) WHEN 0 THEN 'Usaquén' WHEN 1 THEN 'Chapinero' WHEN 2 THEN 'Suba' ELSE 'Teusaquillo' END AS localidad,
    level AS id_viaje
FROM dual CONNECT BY level <= 20;


INSERT INTO SolicitudReserva (estado_solicitud, id_pasajero, id_parada)
SELECT 
    CASE MOD(level, 4) 
        WHEN 0 THEN 'Pendiente' 
        WHEN 1 THEN 'Aceptado' 
        WHEN 2 THEN 'Rechazado' 
        ELSE 'Cancelado' 
    END AS estado_solicitud,
    20 + MOD((TRUNC((level - 1) / 15) * 7) + MOD(level - 1, 15), 150) + 1 AS id_pasajero,
    TRUNC((level - 1) / 15) + 1 AS id_parada
FROM dual CONNECT BY level <= 300;
