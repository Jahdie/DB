USE equimpment_siganals_accouting; 

-- СОЗДАЕМ ПРЕДСТАВЛЕНИЕ, ПОКАЗЫВАЕМ НЕ УДАЛЕННЫЕ ЗАПИСИ.
CREATE OR REPLACE VIEW v_ports AS
SELECT p.number   Номер_порта,
       sc.number  Номер_шкафа,
       s2.number  Номер_свитча,
       p2.name    Местоположение_шкафа_производство,
       w.name     Местоположение_шкафа_цех,
       c.name     Местоположение_шкафа_участок,
       CASE
           WHEN is_trunc = 1
               THEN s2.ip_adress
           WHEN is_trunc = 0
               THEN s.ip_adress
           END as IP_adress,
       CASE
           WHEN is_trunc = 1
               THEN p.station_id_or_ports_id
           WHEN is_trunc = 0
               THEN s.name
           END as Номер_свитча_или_название_станции
FROM ports as p
         JOIN stations s on p.station_id_or_ports_id = s.id
         JOIN switches s2 on p.station_id_or_ports_id = s2.id
         JOIN switch_cabinets sc on s2.switch_cabinet_id = sc.id
         JOIN locations l on sc.location_id = l.id
         JOIN productions p2 on l.prodaction_id = p2.id
         JOIN workshops w on l.workshop_id = w.id
         JOIN compartments c on l.compartment_id = c.id
WHERE p.date_deleted IS NULL;


-- ВНУТРИ ПРОЦЕДУРЫ СОБИРАЕМ ЗАПРОС И ФИЛЬТРУЕМ ПО НЕОБХОДИМЫМ ПОЛЯМ.
DROP PROCEDURE IF EXISTS pv_ports;
DELIMITER $$
CREATE PROCEDURE pv_ports(number_port int, number_cabinet VARCHAR(10), number_switch INT, loc_prod VARCHAR(40),
                          loc_work VARCHAR(40), loc_compar VARCHAR(40), ip_adress VARCHAR(15))
BEGIN
    SET @X_QUERY := 'select * FROM v_ports WHERE 1=1';

    IF number_port IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Номер_порта = ', number_port);
    END IF;

    IF number_cabinet IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Номер_шкафа = ', '"', number_cabinet, '"');
    END IF;

    IF number_switch IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Номер_свитча = ', number_switch);
    END IF;

    IF loc_prod IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Местоположение_шкафа_производство = ', '"', loc_prod, '"');
    END IF;

    IF loc_work IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Местоположение_шкафа_цех = ', '"', loc_work, '"');
    END IF;

    IF loc_compar IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Местоположение_шкафа_участок = ', '"', loc_compar, '"');
    END IF;

    IF ip_adress IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND IP_adress = ', '"', ip_adress, '"');
    END IF;

    PREPARE _query FROM @X_QUERY;
    EXECUTE _query;
END $$
DELIMITER ;

CALL pv_ports(null, '1', null, null, null, null, null);



-- СОЗДАЕМ ПРЕДСТАВЛЕНИЕ, ПОКАЗЫВАЕМ НЕ УДАЛЕННЫЕ ЗАПИСИ.
CREATE OR REPLACE view v_modules AS
SELECT s.name  Станция,
       mt.name Тип_модуля,
       cf.name Семейство_контроллера,
       mm.name Модель_модуля,
       p.name  Местоположение_станции_производство,
       w.name  Местоположение_станции_цех,
       c.name  Местоположение_станции_участок
FROM modules as m
         JOIN stations s on m.station_id = s.id
         JOIN controller_families cf on m.controller_family_id = cf.id
         JOIN modules_models mm on m.model_id = mm.id
         JOIN locations l on s.location_id = l.id
         JOIN compartments c on l.compartment_id = c.id
         JOIN workshops w on l.workshop_id = w.id
         JOIN productions p on l.prodaction_id = p.id
         JOIN modules_types mt on m.module_type_id = mt.id
WHERE m.date_deleted IS NULL;



-- ВНУТРИ ПРОЦЕДУРЫ СОБИРАЕМ ЗАПРОС И ФИЛЬТРУЕМ ПО НЕОБХОДИМЫМ ПОЛЯМ.
DROP PROCEDURE IF EXISTS pv_modules;
DELIMITER $$
CREATE PROCEDURE pv_modules(station_name VARCHAR(40), module_type VARCHAR(40), family_module VARCHAR(40),
                            model_module VARCHAR(40), loc_prod VARCHAR(40), loc_work VARCHAR(40),
                            loc_compar VARCHAR(40))
BEGIN
    SET @X_QUERY := 'select * FROM v_modules WHERE 1=1';

    IF station_name IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Станция = ', '"', station_name, '"');
    END IF;

    IF module_type IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Тип_модуля = ', '"', module_type, '"');
    END IF;

    IF family_module IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Семейство_контроллера = ', '"', family_module, '"');
    END IF;

    IF loc_prod IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Местоположение_станции_производство = ', '"', loc_prod, '"');
    END IF;

    IF loc_work IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Местоположение_шкафа_цех = ', '"', loc_work, '"');
    END IF;

    IF loc_compar IS NOT NULL THEN
        SET @X_QUERY = concat(@X_QUERY, ' AND Местоположение_шкафа_участок = ', '"', loc_compar, '"');
    END IF;


    PREPARE _query FROM @X_QUERY;
    EXECUTE _query;
END $$
DELIMITER ;

CALL pv_modules(null, 'Аналоговый выходной', null,
                null, null, null, null);