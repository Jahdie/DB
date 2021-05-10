USE equimpment_siganals_accouting;

INSERT INTO workshops (name)
VALUES ('ДЦ'),
       ('ИФЦ'),
       ('РО'),
       ('КД'),
       ('СД'),
       ('Курьер'),
       ('Узел откачки № 1'),
       ('Узел откачки № 2'),
       ('Никелевый узел'),
       ('Медный узел');

INSERT INTO compartments (name)
VALUES ('ПСУ 1F'),
       ('ПСУ 2F'),
       ('ПСУ 3F'),
       ('Операторная флотации 1 сек.'),
       ('Операторная флотации 2 сек.'),
       ('Операторная флотации 3 сек.'),
       ('Операторная селективной селекции.'),
       ('Комплекс Nelson № 1'),
       ('Комплекс Nelson № 2'),
       ('Комплекс Nelson № 3');

INSERT INTO productions (name)
VALUES ('Дамба 5'),
       ('ПНС 3'),
       ('НЗ'),
       ('НОФ'),
       ('УСХ 1'),
       ('УФМК'),
       ('МЗ'),
       ('УСХ 2'),
       ('Лебяжье'),
       ('ЦГТС');

INSERT INTO locations (prodaction_id, workshop_id, compartment_id)
VALUES (3, 4, 5),
       (3, 1, 2),
       (3, 4, 6),
       (1, 5, 2),
       (7, 7, 7),
       (8, 8, 8),
       (9, 9, 9),
       (10, 10, 10),
       (5, 6, 1),
       (5, 4, 5);

INSERT INTO switch_cabinets (number, location_id)
VALUES ('9', 1),
       ('7', 3),
       ('9A', 5),
       ('1Б', 4),
       ('3', 6),
       ('4А', 7),
       ('14', 8),
       ('12Б', 9),
       ('1', 10),
       ('11', 2);

INSERT INTO switches_models(model, port_num)
VALUES ('Cisco DD234xx', 24),
       ('Cisco AF23', 32),
       ('Moxa 23FD', 16),
       ('Cisco RFV43F', 8),
       ('MOXA 98HG', 24),
       ('Cisco 3D', 32);

INSERT INTO switches(switch_cabinet_id, number, port_num_id, model_id, ip_adress)
VALUES (2, 1, 1, 1, '192.168.111.1'),
       (1, 5, 3, 3, '192.168.2.123'),
       (4, 21, 5, 5, '192.168.44.134'),
       (6, 11, 2, 2, '192.168.53.66'),
       (5, 15, 4, 4, '192.168.44.234'),
       (3, 14, 6, 6, '192.168.65.199'),
       (8, 12, 5, 1, '192.168.65.197'),
       (9, 3, 4, 1, '192.168.41.222'),
       (10, 13, 6, 1, '192.168.1.58'),
       (2, 8, 6, 1, '192.168.55.202');

INSERT INTO stations(name, ip_adress, location_id)
VALUES ('NOFAC3', '192.32.45.122', 1),
       ('NOFAC6', '192.33.67.2', 2),
       ('KD', '192.125.5.232', 4),
       ('NEL1', '192.52.85.112', 6),
       ('GCU56', '192.62.4.1', 1),
       ('MELN_1-1', '192.45.4.222', 3),
       ('NOFAC1', '192.45.4.2', 7),
       ('NEL4', '192.45.55.22', 8),
       ('OTK', '192.41.42.14', 9),
       ('NOFAC9', '192.4.4.2', 10);

INSERT INTO ports(number, switch_id, is_trunc, station_id_or_ports_id)
VALUES (5, 1, 1, 4),
       (12, 3, 0, 2),
       (6, 2, 0, 4),
       (4, 5, 1, 1),
       (3, 4, 0, 1),
       (20, 6, 0, 3),
       (21, 8, 1, 5),
       (11, 7, 0, 10),
       (13, 9, 0, 9),
       (2, 10, 0, 8);

INSERT INTO controller_families(name)
VALUES ('90-30'),
       ('90-70'),
       ('RX3'),
       ('RX7'),
       ('GENIUS'),
       ('RX3i');

INSERT INTO modules_types(name)
VALUES ('Аналоговый выходной'),
       ('Аналоговый входной'),
       ('Дискретный выходной'),
       ('Дискретный входной');

INSERT INTO modules_models(name)
VALUES ('IC697ALG230'),
       ('IC697BEM731'),
       ('IC697MDL740'),
       ('IC698ETM001');

INSERT INTO modules(module_type_id, model_id, controller_family_id, station_id)
VALUES (1, 2, 1, 2),
       (2, 3, 4, 3),
       (3, 2, 3, 3),
       (4, 4, 4, 4),
       (1, 2, 3, 5),
       (2, 1, 1, 6),
       (4, 4, 4, 7),
       (3, 1, 2, 8),
       (1, 4, 4, 9),
       (2, 4, 4, 10);

INSERT INTO signals_types(name)
VALUES ('Аналоговый выходной'),
       ('Аналоговый входной'),
       ('Дискретный выходной'),
       ('Дискретный входной');

INSERT INTO equimpments_types(name)
VALUES ('Гидроциклонная установка'),
       ('Дробилка'),
       ('Грохот'),
       ('Флотомашина');

INSERT INTO equimpments_names(name)
VALUES ('4-1'),
       ('5'),
       ('7'),
       ('2-10'),
       ('3-12'),
       ('2-22'),
       ('1-1'),
       ('9'),
       ('5-6'),
       ('5-10');

INSERT INTO signals(name, signal_type_id, module_id, equimp_type_id, equimp_name_id, marking)
VALUES ('AC4_M007_MV', 1, 1, 1, 1, '1-2-3 1-2-4'),
       ('AC7_M067_MV', 2, 2, 2, 2, '2-1-2 2-1-3'),
       ('AC8_M004_PV', 3, 3, 3, 3, '3-3-2 3-3-3'),
       ('AC1_M154_PV', 4, 4, 4, 4, '4-1-3 4-1-4'),
       ('AC8_DI004', 1, 4, 1, 7, '5-3-1 5-3-2'),
       ('AC1_M033_MV', 4, 2, 2, 5, '6-5-2 6-5-3'),
       ('AC2_M123_PV', 2, 4, 4, 6, '3-3-2 3-3-3'),
       ('AC8_DI012_PV', 3, 3, 3, 3, '7-1-2 7-3-3'),
       ('AC4_M056_PV', 4, 4, 1, 8, '11-2-2 11-3-3'),
       ('AC8_M004_PV', 3, 3, 3, 9, '12-4-1 12-4-2');
