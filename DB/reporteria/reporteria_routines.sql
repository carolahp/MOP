-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: reporteria
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping events for database 'reporteria'
--

--
-- Dumping routines for database 'reporteria'
--
/*!50003 DROP FUNCTION IF EXISTS `WORKDAYS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `WORKDAYS`(first_date DATETIME, second_date DATETIME) RETURNS int
    DETERMINISTIC
BEGIN

DECLARE start_date DATE;
DECLARE end_date DATE;
DECLARE diff INT;
DECLARE NumberOfWeeks INT;
DECLARE RemainingDays INT;
DECLARE firstDayOfTheWeek INT;
DECLARE lastDayOfTheWeek INT;
DECLARE WorkingDays INT;
DECLARE holiday INT;

IF (first_date < second_date) THEN
SET start_date = first_date;
SET end_date = second_date;
ELSE
SET start_date = second_date;
SET end_date = first_date;
END IF;

SET diff = DATEDIFF(end_date, start_date);
SET NumberOfWeeks=FLOOR(diff/7);
SET RemainingDays=MOD(diff,7);

## El primer dia del intervalo no se cuenta, pero el ultimo si
SET firstDayOfTheWeek=DAYOFWEEK(start_date);
SET lastDayOfTheWeek=DAYOFWEEK(end_date);
IF(firstDayOfTheWeek <= lastDayOfTheWeek) THEN
## DATOFWEEK=7 es sabado 
 IF( firstDayOfTheWeek<=7 AND 7 <=lastDayOfTheWeek) THEN SET RemainingDays=RemainingDays-1; END IF;
## DATOFWEEK=1 es domingo 
 IF( firstDayOfTheWeek<=1 AND 1 <=lastDayOfTheWeek) THEN SET RemainingDays=RemainingDays-1; END IF;
 ELSE
	 IF( firstDayOfTheWeek=1) THEN SET RemainingDays=RemainingDays-1;
	   IF (lastDayOfTheWeek=7) THEN  SET RemainingDays=RemainingDays-1; END IF;
	 ELSE SET RemainingDays=RemainingDays-2;
	 END IF;
 END IF;

#Here we count the holidays that had occured during the period where are testing
SELECT COUNT(FECHA) INTO @DESC
FROM feriado
WHERE FECHA BETWEEN start_date AND end_date;
SET holiday=@DESC;
 SET WorkingDays=NumberOfWeeks*5;
#Here we substract the number of holidays from the working week
 IF(RemainingDays>0) THEN RETURN WorkingDays+RemainingDays-holiday;
 ELSE RETURN WorkingDays-holiday; END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-30 20:55:46
