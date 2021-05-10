USE equimpment_siganals_accouting;

/*ПРОЦЕДУРА УДАЛЕНИЯ СВИТЧА. УСТАНОВКА ДАТЫ В ПОЛЕ DATE_DELETE НЕВОЗМОЖНА, ПОКА НЕ УДАЛЕНЫ СВЯЗИ В ТАБЛИЦЕ PORTS.
  ДЛЯ ЭТОГО С ПОМОЩЬЮ ФУНКЦИИ SUM ПРОВЕРЯЕМ ЕСТЬ ЛИ ЗАПИСИ В СООТВЕТСТВУЮЩИХ ПОЛЯХ. ЕСЛИ ВЕРНЕТСЯ ЗНАЧЕНИЕ NULL,
  ТО ТОГДА ПРОCТАВЛЯЕМ ДАТУ УДАЛЕНИЯ*/
DROP PROCEDURE IF EXISTS pd_switch_delete;
DELIMITER $$
CREATE PROCEDURE pd_switch_delete(deleting_id INT)
BEGIN
    DECLARE sum_switch_cabinet_from_switches INT;
    DECLARE sum_ports_switch_from_ports INT;
    SELECT SUM(s.switch_cabinet_id)
    INTO sum_switch_cabinet_from_switches
    FROM switches s
             LEFT JOIN ports p on s.id = p.switch_id
    WHERE s.id = deleting_id;
    SELECT SUM(p.switch_id)
    INTO sum_ports_switch_from_ports
    FROM ports p
             LEFT JOIN switches s on p.switch_id = s.id
    WHERE s.id = deleting_id;
    IF (sum_ports_switch_from_ports is NULL AND sum_switch_cabinet_from_switches is NULL) THEN
        UPDATE switches SET date_deleted = NOW() WHERE switches.id = deleting_id;
        SELECT 'удалено';
    ELSE
        select 'удалите связи';
    END IF;
END $$
DELIMITER ;

call pd_switch_delete(22);

select p.*
FROM ports p
         LEFT JOIN switches s on p.switch_id = s.id
WHERE s.id = 22;


/*ПРОЦЕДУРА УДАЛЕНИЯ СТАНЦИИ. УСТАНОВКА ДАТЫ В ПОЛЕ DATE_DELETE НЕВОЗМОЖНА, ПОКА НЕ УДАЛЕНЫ СВЯЗИ В ТАБЛИЦЕ MODULES И PORTS.
  ДЛЯ ЭТОГО С ПОМОЩЬЮ ФУНКЦИИ SUM ПРОВЕРЯЕМ ЕСТЬ ЛИ ЗАПИСИ В СООТВЕТСТВУЮЩИХ ПОЛЯХ. ЕСЛИ ВЕРНЕТСЯ ЗНАЧЕНИЕ NULL,
  ТО ТОГДА ПРОCТАВЛЯЕМ ДАТУ УДАЛЕНИЯ*/
DROP PROCEDURE IF EXISTS pd_station_delete;
DELIMITER $$
CREATE PROCEDURE pd_station_delete(deleting_id INT)
BEGIN
    DECLARE sum_switch_id_from_modules INT;
    DECLARE sum_switch_or_station_ports INT;
    SELECT SUM(m.station_id)
    INTO sum_switch_id_from_modules
    FROM modules m
             LEFT JOIN stations s on m.station_id = s.id
    WHERE s.id = deleting_id;
    SELECT SUM(p.station_id_or_ports_id)
    INTO sum_switch_or_station_ports
    FROM ports p
             LEFT JOIN stations s on p.station_id_or_ports_id = s.id
    WHERE s.id = deleting_id
      AND p.is_trunc = 0;
    IF (sum_switch_or_station_ports is NULL AND sum_switch_id_from_modules is NULL) THEN
        UPDATE stations SET date_deleted = NOW() WHERE stations.id = deleting_id;
        SELECT 'удалено';
    ELSE
        select 'удалите связи';
    END IF;
END $$
DELIMITER ;

CALL pd_station_delete(2);


-- ЗАПОЛНЕНИЕ ТАБЛИЦ-СПРАВОЧНИКОВ
DROP PROCEDURE IF EXISTS pi_reference_tables_insert;
DELIMITER $$
CREATE PROCEDURE pi_reference_tables_insert(table_name VARCHAR(20), field_name VARCHAR(40))
BEGIN
    IF table_name = 'workshops' THEN
        INSERT INTO productions(name) VALUES (field_name);
    END IF;
    IF table_name = 'compartments' THEN
        INSERT INTO compartments(name) VALUES (field_name);
    END IF;
    IF table_name = 'workshops' THEN
        INSERT INTO workshops(name) VALUES (field_name);
    END IF;
    IF table_name = 'controller_families' THEN
        INSERT INTO controller_families(name) VALUES (field_name);
    END IF;
    IF table_name = 'modules_models' THEN
        INSERT INTO modules_models(name) VALUES (field_name);
    END IF;
    IF table_name = 'modules_types' THEN
        INSERT INTO modules_types(name) VALUES (field_name);
    END IF;
    IF table_name = 'equimpments_names' THEN
        INSERT INTO equimpments_names(name) VALUES (field_name);
    END IF;
    IF table_name = 'equimpments_types' THEN
        INSERT INTO equimpments_types(name) VALUES (field_name);
    END IF;
END $$;
DELIMITER ;

CALL pi_reference_tables_insert('compartments', 'ПСУ 4F');

-- УДАЛЯЕМ ЗАПИСИ В ТАБЛИЦАХ-СПРАВАЧНИКАХ УСТАНАВЛИВАЯ ДАТУ В ПОЛЕ DATE_DELETED
DROP PROCEDURE IF EXISTS pd_reference_tables_delete;
DELIMITER $$
CREATE PROCEDURE pd_reference_tables_delete(table_name VARCHAR(20), table_id INT)
BEGIN
    IF table_name = 'workshops' THEN
        UPDATE productions SET date_deleted = NOW() WHERE id = table_id;
    END IF;
    IF table_name = 'compartments' THEN
        UPDATE compartments SET date_deleted = NOW() WHERE id = table_id;
    END IF;
    IF table_name = 'workshops' THEN
        UPDATE workshops SET date_deleted = NOW() WHERE id = table_id;
    END IF;
    IF table_name = 'controller_families' THEN
        UPDATE controller_families SET date_deleted = NOW() WHERE id = table_id;
    END IF;
    IF table_name = 'modules_models' THEN
        UPDATE modules_models SET date_deleted = NOW() WHERE id = table_id;
    END IF;
    IF table_name = 'modules_types' THEN
        UPDATE modules_types SET date_deleted = NOW() WHERE id = table_id;
    END IF;
    IF table_name = 'equimpments_names' THEN
        UPDATE equimpments_names SET date_deleted = NOW() WHERE id = table_id;
    END IF;
    IF table_name = 'equimpments_types' THEN
        UPDATE equimpments_types SET date_deleted = NOW() WHERE id = table_id;
    END IF;
END $$;
DELIMITER ;

CALL pd_reference_tables_delete('compartments', 1);