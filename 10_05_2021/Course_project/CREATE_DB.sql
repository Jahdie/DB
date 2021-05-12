DROP DATABASE IF EXISTS equimpment_siganals_accouting; -- Учет оборудования и сигналов
CREATE DATABASE equimpment_siganals_accouting;
USE equimpment_siganals_accouting;

-- ТАБЛИЦА-СПРАВОЧНИК ЦЕХОВ
DROP TABLE IF EXISTS workshops;
CREATE TABLE workshops
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    name         VARCHAR(40) COMMENT 'Название цеха',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.'
);

-- УЧАСТОК, ПСУ и т.д
DROP TABLE IF EXISTS compartments;
CREATE TABLE compartments
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    name         VARCHAR(40) COMMENT 'Название участка, ПСУ и т.д.',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.'
);

-- НАЗВАНИЕ ПРОИЗВОДСТВА
DROP TABLE IF EXISTS productions;
CREATE TABLE productions
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    name         VARCHAR(40) COMMENT 'Название производства (НОФ, ДАМБА5 и т.д).',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.'
);

-- МЕСТОПОЛОЖЕНИЕ СТАНЦИЙ И ШКАФОВ
DROP TABLE IF EXISTS locations;
CREATE TABLE locations
(
    id             INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created   DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted   DATETIME              DEFAULT NULL,
    prodaction_id  INT UNSIGNED NOT NULL COMMENT 'ID производства.',
    workshop_id    INT UNSIGNED NOT NULL COMMENT 'ID цеха',
    compartment_id INT UNSIGNED NOT NULL COMMENT 'ID устка, ПСУ и т.д.',
    note           TEXT                  DEFAULT NULL COMMENT 'Примечание.',
    FOREIGN KEY (prodaction_id) REFERENCES productions (id),
    FOREIGN KEY (workshop_id) REFERENCES workshops (id),
    FOREIGN KEY (compartment_id) REFERENCES compartments (id)
);

-- КОММУТАЦИОННЫЕ ШКАФЫ
DROP TABLE IF EXISTS switch_cabinets;
CREATE TABLE switch_cabinets
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    number       VARCHAR(10)  NOT NULL COMMENT 'Номер шкафа (может содержать буквенное значение).',
    location_id  INT UNSIGNED NOT NULL COMMENT 'Месторасположение шкафа.',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.',
    FOREIGN KEY (location_id) REFERENCES locations (id)
);


-- ТАБЛИЦА-СПРАВОЧНИК МОДЕЛЕЙ СВИТЧЕЙ
DROP TABLE IF EXISTS switches_models;
CREATE TABLE switches_models
(
    id           INT UNSIGNED     NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME         NOT NULL DEFAULT NOW(),
    date_deleted DATETIME                  DEFAULT NULL,
    model        VARCHAR(40),
    port_num     TINYINT UNSIGNED NOT NULL COMMENT 'Количество портов на свитче',
    note         TEXT                      DEFAULT NULL COMMENT 'Примечание.'
);

-- СВИТЧИ
DROP TABLE IF EXISTS switches;
CREATE TABLE switches
(
    id                INT UNSIGNED     NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created      DATETIME         NOT NULL DEFAULT NOW(),
    date_deleted      DATETIME                  DEFAULT NULL,
    switch_cabinet_id INT UNSIGNED              DEFAULT NULL COMMENT 'ID шкафа',
    number            TINYINT UNSIGNED NOT NULL UNIQUE COMMENT 'Номер свитча',
    port_num_id       INT UNSIGNED     NOT NULL COMMENT 'ID количество портов на свитче',
    model_id          INT UNSIGNED     NOT NULL COMMENT 'ID модель свитча.',
    ip_adress         VARCHAR(15)      NOT NULL UNIQUE COMMENT 'IP-адресс свитча',
    note              TEXT                      DEFAULT NULL COMMENT 'Примечание.',
    INDEX number_idx (number),
    FOREIGN KEY (model_id) REFERENCES switches_models (id),
    FOREIGN KEY (switch_cabinet_id) REFERENCES switch_cabinets (id),
    FOREIGN KEY (port_num_id) REFERENCES switches_models (id)
);


-- СТАНЦИИ (ПРОЕКТЫ)
DROP TABLE IF EXISTS stations;
CREATE TABLE stations
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    name         VARCHAR(40)  NOT NULL COMMENT 'Название станции (проекта).',
    ip_adress    VARCHAR(15)  NOT NULL UNIQUE COMMENT 'IP-адресс станции.',
    location_id  INT UNSIGNED NOT NULL COMMENT 'Месторасположение шкафа.',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.',
    FOREIGN KEY (location_id) REFERENCES locations (id)
);

-- ПОРТЫ СВИТЧЕЙ
DROP TABLE IF EXISTS ports;
CREATE TABLE ports
(
    id                     INT UNSIGNED     NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created           DATETIME         NOT NULL DEFAULT NOW(),
    date_deleted           DATETIME                  DEFAULT NULL,
    number                 TINYINT UNSIGNED NOT NULL COMMENT 'Номер порта.',
    switch_id              INT UNSIGNED              DEFAULT NULL COMMENT 'ID свитча',
    is_trunc               BIT              NOT NULL COMMENT 'Проверка транк это или хост.',
    station_id_or_ports_id INT UNSIGNED              DEFAULT NULL COMMENT 'Либо ID порта, либо ID станции', /*Если is_trunc = 0,
    ставим id станции, если is_trunk = 1, ставим id порта свитча с которым связан этот порт',*/
    note                   TEXT                      DEFAULT NULL COMMENT 'Примечание.',
    INDEX number_idx (number),
    FOREIGN KEY (switch_id) REFERENCES switches (id),
    FOREIGN KEY (station_id_or_ports_id) REFERENCES stations (id)
);

-- СЕМЕЙСТВО КОНТРОЛЛЕРОВ
DROP TABLE IF EXISTS controller_families;
CREATE TABLE controller_families
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    name         VARCHAR(40)  NOT NULL COMMENT 'Семейство контроллеров',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.'
);

-- ТИПЫ MOДУЛЕЙ
DROP TABLE IF EXISTS modules_types;
CREATE TABLE modules_types
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    name         VARCHAR(40)  NOT NULL COMMENT 'Типы модулей',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.'
);

-- МОДЕЛИ MOДУЛЕЙ
DROP TABLE IF EXISTS modules_models;
CREATE TABLE modules_models
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    name         VARCHAR(40)  NOT NULL COMMENT 'Модели модулей',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.'
);

-- МОДУЛИ В СТАНЦИЯХ
DROP TABLE IF EXISTS modules;
CREATE TABLE modules
(
    id                   INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created         DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted         DATETIME              DEFAULT NULL,
    module_type_id       INT UNSIGNED NOT NULL COMMENT 'ID типы модулей',
    controller_family_id INT UNSIGNED NOT NULL COMMENT 'ID семейство контроллеров',
    model_id             INT UNSIGNED NOT NULL COMMENT 'ID модели модулей',

    station_id           INT UNSIGNED          DEFAULT NULL COMMENT 'ID станции',
    note                 TEXT                  DEFAULT NULL COMMENT 'Примечание.',
    FOREIGN KEY (module_type_id) REFERENCES modules_types (id),
    FOREIGN KEY (model_id) REFERENCES modules_models (id),
    FOREIGN KEY (controller_family_id) REFERENCES controller_families (id),
    FOREIGN KEY (station_id) REFERENCES stations (id)
);

-- ТИПЫ СИГНАЛОВ
DROP TABLE IF EXISTS signals_types;
CREATE TABLE signals_types
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    name         VARCHAR(40)  NOT NULL COMMENT 'Типы сигналов',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.'
);

-- ТИПЫ ОБОРУДОВАНИЯ
DROP TABLE IF EXISTS equimpments_types;
CREATE TABLE equimpments_types
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    name         VARCHAR(40)  NOT NULL COMMENT 'Типы оборудования.',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.'
);

-- НАИМЕНОВАНИЯ ОБОРУДОВАНИЯ
DROP TABLE IF EXISTS equimpments_names;
CREATE TABLE equimpments_names
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    name         VARCHAR(40)  NOT NULL COMMENT 'Наименование оборудования.',
    note         TEXT                  DEFAULT NULL COMMENT 'Примечание.'
);

-- СИГНАЛЫ
DROP TABLE IF EXISTS signals;
CREATE TABLE signals
(
    id             INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created   DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted   DATETIME              DEFAULT NULL,
    name           VARCHAR(40)  NOT NULL COMMENT 'Псевдоним сигнала',
    signal_type_id INT UNSIGNED NOT NULL COMMENT 'ID типы сигналов',
    module_id      INT UNSIGNED NOT NULL COMMENT 'ID модуля',
    equimp_type_id INT UNSIGNED NOT NULL COMMENT 'ID типа оборудования',
    equimp_name_id INT UNSIGNED NOT NULL COMMENT 'ID наименования оборудования',
    marking        VARCHAR(40)           DEFAULT NULL COMMENT 'Маркировка жил кабеля.',
    note           TEXT                  DEFAULT NULL COMMENT 'Примечание.',
    INDEX name_idx (name),
    FOREIGN KEY (signal_type_id) REFERENCES signals_types (id),
    FOREIGN KEY (module_id) REFERENCES modules (id),
    FOREIGN KEY (equimp_type_id) REFERENCES equimpments_types (id),
    FOREIGN KEY (equimp_name_id) REFERENCES equimpments_names (id)
);

-- EGD (ETHERNET GLOBAL DATA)
DROP TABLE IF EXISTS egd;
CREATE TABLE egd
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_created DATETIME     NOT NULL DEFAULT NOW(),
    date_deleted DATETIME              DEFAULT NULL,
    `from`       INT UNSIGNED          DEFAULT NULL COMMENT 'ID станции',
    `to`         INT UNSIGNED          DEFAULT NULL COMMENT 'ID станции',
    ref_adress   INT UNSIGNED NOT NULL COMMENT 'Адресс ссылки',
    length       INT UNSIGNED NOT NULL COMMENT 'Длинна адрессов',
    FOREIGN KEY (`from`) REFERENCES stations (id),
    FOREIGN KEY (`to`) REFERENCES stations (id)
);