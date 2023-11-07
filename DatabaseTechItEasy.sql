DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS television_wall_brackets;
DROP TABLE IF EXISTS remote_controllers CASCADE;
DROP TABLE IF EXISTS televisions;
DROP TABLE IF EXISTS wall_brackets;
DROP TABLE IF EXISTS ci_modules;
-- Ik begrijp nog niet helemaal hoe het werkt met de volgorde en wanneer gebruik van cascade nodig is, hoe het er nu uitziet is min of meer trial and error...

-- tabellen aanmaken

CREATE TABLE users (
	userid INT GENERATED ALWAYS AS IDENTITY,
	username VARCHAR(255),
	password VARCHAR(255)
);

CREATE TABLE remote_controllers (
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(255) UNIQUE,
	brand VARCHAR(255),
	price FLOAT,
	original_stock INT,
	compatible_with VARCHAR(255),
    battery_type VARCHAR(255), 
	bluetooth boolean,
	PRIMARY KEY(id)
);

CREATE TABLE ci_modules (
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(255) UNIQUE,
	type VARCHAR(255),
	price FLOAT,
	PRIMARY KEY(id)
);

CREATE TABLE wall_brackets (
	id SERIAL,
	name VARCHAR(255) UNIQUE,
	brand VARCHAR(255),
	price FLOAT,
	size VARCHAR(255),
	adjustable BOOLEAN,
	PRIMARY KEY(id)
);

-- deze tabel als laatste, zodat de foreign keys waarnaar verwezen wordt al wel bestaan. De variabelen kome uit de uitwerkingen.
CREATE TABLE televisions (
	id SERIAL,
	name VARCHAR(255),
	brand VARCHAR(255),
	type VARCHAR(255),
	price FLOAT,
	original_stock INT,
	sold INT,
	refresh_rate INT,
    screen_type VARCHAR(255),
	screen_quality VARCHAR(255),
	available_size VARCHAR(255),
	smart_tv BOOLEAN,
	wifi BOOLEAN,
	voice_control BOOLEAN,
	hdr BOOLEAN,
	bluetooth BOOLEAN,
	ambi_light BOOLEAN,
	remote_controller_id INT,
	ci_module_id INT,
	PRIMARY KEY(id),
	FOREIGN KEY (remote_controller_id) REFERENCES remote_controllers(id), 
	FOREIGN KEY (ci_module_id) REFERENCES ci_modules(id)
);

-- tussentabel voor veel-op-veel relatie televisions en wall_brackets
CREATE TABLE television_wall_brackets (
	television_id INT,
	wall_bracket_id INT,
	FOREIGN KEY (television_id) REFERENCES televisions(id),
	FOREIGN KEY (wall_bracket_id) REFERENCES wall_brackets(id)
);

-- tabellen vullen

INSERT INTO users (username, password)
VALUES ('MarjetB', 'Firsa2006'), ('HannahD', 'HelloKitty1'), ('RienekeD', 'Olifant75');

-- inhoud tv's en toebehoren komt uit de uitwerkingen; id's die "always generated as identity" zijn,hoeven niet te worden meegegeven.
INSERT INTO remote_controllers (compatible_with, battery_type, name, brand, price, original_stock) 
VALUES ('NH3216SMART', 'AAA', 'Nikkei HD smart TV controller', 'Nikkei', 12.99, 235885), ('43PUS6504/12/L', 'AA', 'Philips smart TV controller', 'Philips', 12.99, 235885),
 ('OLED55C16LA', 'AAA', 'OLED55C16LA TV controller', 'LG', 12.99, 235885);
 
INSERT INTO ci_modules (name, type, price) 
VALUES ('universal CI-module', '23JI12', 32.5); 

INSERT INTO wall_brackets (id, name, size, adjustable, brand, price)
VALUES (1001, 'LG small', '25X32', false, 'LG bracket', 32.23), (1002, 'LG big', '25X32/32X40', true, 'LG bracket', 32.23), (1003, 'Philips small', '25X25', false, 'Philips bracket', 32.23), (1004, 'Nikkei big', '25X32/32X40', true, 'Nikkei bracket', 32.23), (1005, 'Nikkei small', '25X32', false, 'Nikkei bracket', 32.23);  
 
INSERT INTO televisions (id, type, brand, name, price, available_size, refresh_rate, screen_type, screen_quality, smart_tv, wifi, voice_control, hdr, bluetooth, ambi_light, original_stock, sold)
VALUES (1001, 'NH3216SMART', 'Nikkei', 'HD smart TV', 159, 32, 100, 'LED', 'HD ready', true, true, false, false, false, false, 235885, 45896), (1002, '43PUS6504/12/L', 'Philips', '4K UHD LED Smart Tv L', 379, 43, 60, 'LED', 'Ultra HD', true, true, false, true, false, false, 8569452, 5685489), (1003, '43PUS6504/12/M', 'Philips', '4K UHD LED Smart Tv M', 379, 50, 60, 'LED', 'Ultra HD', true, true, false, true, false, false, 345549, 244486), (1004, '43PUS6504/12/S', 'Philips', '4K UHD LED Smart Tv S', 379, 58, 60, 'LED', 'Ultra HD', true, true, false, true, false, false, 6548945, 4485741), (1005, 'OLED55C16LA', 'LG', 'LG OLED55C16LA', 989, 55, 100, 'OLED', 'ULTRA HD',  true, true, true, true, true, false, 50000, 20500);  

-- Koppelen van televisions aan wall_brackets (inhoud komt uit de uitwerkingen, ik heb een kortere notatie gebruikt).

INSERT INTO television_wall_brackets(television_id, wall_bracket_id)
VALUES (1005, 1001), (1005, 1002), (1002, 1003), (1003, 1003), (1004, 1003), (1001, 1004), (1001, 1005);

-- tabellen weergeven
SELECT televisions.id AS tvid, remote_controllers.id AS rmid -- geeft deze variabelen een eigen naam in de tabel i.p.v. alleen id
FROM televisions JOIN remote_controllers 
ON remote_controllers.id = televisions.remote_controller_id; -- in de uitwerkingen staat hier foutief remote_id, dat heb ik aangepast
-- als ik alleen bovenstaand select statement gebruik, krijg ik een lege tabel met 2 kolommen tvid en rmid, maar dus zonder data...
-- ik geloof ook niet dat ik het joinen echt helemaal doorgrond.
SELECT * FROM televisions;
-- als ik dit select statement gebruik, zie ik wel netjes de lijst met tv's en de bijbehorende variabelen, maar remote_controller_id en ci_module_id zijn null en ik begrijp niet waarom.


