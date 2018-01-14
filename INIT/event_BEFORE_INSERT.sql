DROP TRIGGER IF EXISTS `DbMysql11`.`event_BEFORE_INSERT`;

DELIMITER $$
USE `DbMysql11`$$
CREATE TRIGGER `DbMysql11`.`event_BEFORE_INSERT` BEFORE INSERT ON `event` FOR EACH ROW
BEGIN
	IF (NEW.date <= CURRENT_DATE()) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Event date cannot be earlier than current date';
	END IF;
    
	IF (NEW.date < NEW.sale_date) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Event date cannot be earlier than sale date';
	END IF;
    
	IF (SELECT NOT EXISTS (
		SELECT 1 FROM City WHERE NEW.city_id = city_id AND NEW.country_id = country_id
			)
        ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: city_id is not corresponded to country_id';
	END IF;
END
$$
DELIMITER ;