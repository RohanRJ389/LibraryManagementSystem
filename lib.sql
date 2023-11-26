-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: lib
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `ISBN_Number` varchar(13) NOT NULL,
  `Author` varchar(255) NOT NULL,
  `Book_Title` varchar(255) NOT NULL,
  `Language` varchar(50) NOT NULL,
  `genre` varchar(255) DEFAULT NULL,
  `Publisher_ID` int DEFAULT NULL,
  `library_id` int DEFAULT NULL,
  PRIMARY KEY (`ISBN_Number`),
  KEY `Publisher_ID` (`Publisher_ID`),
  KEY `library_id` (`library_id`),
  CONSTRAINT `book_ibfk_1` FOREIGN KEY (`Publisher_ID`) REFERENCES `publisher` (`Publisher_ID`),
  CONSTRAINT `book_ibfk_2` FOREIGN KEY (`library_id`) REFERENCES `library` (`Library_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES ('103','S L Bhyrappa','Grihabhanga','Kannada','Historical, Fiction',10,1),('105','S L Bhyrappa','Vamshavriksha','Kannada','Fiction',10,1),('12345','JK R','HP DH','ENG','horror',1,1),('4444','Babu mosai','Shrilok homeless','Bengali','Adventure, mystery',3,3),('500','H G Wells','Invisible Man','English','Adventure',4,1),('5555','Agatha Christae','ABC Murders','English','Horror, Mystery',7,1),('784653123','ANUTer','ITITLE','ENlisgh','horror,comedy',2,2),('888','shiva','dbms','kannada','educational',7,1),('999999','Rick ','PJO','ENG','Comedy,fantasy',1,1);
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_copies`
--

DROP TABLE IF EXISTS `book_copies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_copies` (
  `ISBN_Number` varchar(13) DEFAULT NULL,
  `number_available` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_copies`
--

LOCK TABLES `book_copies` WRITE;
/*!40000 ALTER TABLE `book_copies` DISABLE KEYS */;
INSERT INTO `book_copies` VALUES ('12345',1),('784653123',4),('999999',12),('666',-2),('4444',16),('5555',4),('500',3),('888',5),('101',4),('102',5),('103',5),('105',5);
/*!40000 ALTER TABLE `book_copies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrow`
--

DROP TABLE IF EXISTS `borrow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrow` (
  `ISBN_Number` varchar(13) NOT NULL,
  `Member_ID` int NOT NULL,
  `Return_Date` date DEFAULT NULL,
  `Due_Date` date DEFAULT NULL,
  `Fine` decimal(10,2) DEFAULT NULL,
  `date_lent` date DEFAULT NULL,
  PRIMARY KEY (`ISBN_Number`,`Member_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrow`
--

LOCK TABLES `borrow` WRITE;
/*!40000 ALTER TABLE `borrow` DISABLE KEYS */;
INSERT INTO `borrow` VALUES ('101',7,NULL,'2023-11-24',NULL,'2023-11-21'),('4444',1,'2023-11-20','2023-11-23',NULL,'2023-11-20'),('500',3,'2023-11-26','2023-11-23',30.00,'2023-11-20'),('5555',1,NULL,'2023-11-23',NULL,'2023-11-20'),('666',3,'2023-11-30','2023-11-19',110.00,'2023-11-16'),('888',1,'2023-11-28','2023-11-23',50.00,'2023-11-20');
/*!40000 ALTER TABLE `borrow` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `on_borrow_book` AFTER INSERT ON `borrow` FOR EACH ROW BEGIN
    UPDATE book_copies
    SET number_available = number_available - 1
    WHERE ISBN_Number = NEW.ISBN_Number;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `CalculateFineTrigger` BEFORE UPDATE ON `borrow` FOR EACH ROW BEGIN
    DECLARE fine_days INT;
    DECLARE fine_amount DECIMAL(10, 2);
    DECLARE due_date DATE;

    IF NEW.Return_Date > OLD.Due_Date THEN
        SET fine_days = DATEDIFF(NEW.Return_Date, OLD.Due_Date);

        -- Calculate fine amount using the CalculateFine function
        SET fine_amount = CalculateFine(fine_days);

        -- Update the Fine column in the borrow table
        SET NEW.Fine = fine_amount;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `on_return_book` AFTER UPDATE ON `borrow` FOR EACH ROW BEGIN
    IF NEW.Return_Date IS NOT NULL THEN
        -- Book is returned, increase count in book_copies
        UPDATE book_copies
        SET number_available = number_available + 1
        WHERE ISBN_Number = NEW.ISBN_Number;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `library`
--

DROP TABLE IF EXISTS `library`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library` (
  `Library_ID` int NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Library_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library`
--

LOCK TABLES `library` WRITE;
/*!40000 ALTER TABLE `library` DISABLE KEYS */;
INSERT INTO `library` VALUES (1,'Central Library','Main Street, City Center'),(2,'West Branch','West Avenue, Suburbia'),(3,'East Branch','East Boulevard, Suburbia');
/*!40000 ALTER TABLE `library` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `Member_ID` int NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Member_ID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,'John Smith','john.smith@example.com'),(2,'Alice Johnson','alice.johnson@example.com'),(3,'Bob Williams','bob.williams@example.com'),(4,'Emma Davis','emma.davis@example.com'),(5,'Charlie Brown','charlie.brown@example.com'),(6,'Leo DiCaprio','jackdrowned@sea.com'),(7,'shaik tabassum','shaiktabassum1606@gmail.com');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publisher` (
  `Publisher_ID` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Block_No` varchar(10) DEFAULT NULL,
  `Street` varchar(255) DEFAULT NULL,
  `City` varchar(255) DEFAULT NULL,
  `Pincode` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`Publisher_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES (1,'ABC Publications','Block A','Main Street','City Center','12345'),(2,'XYZ Books','Block B','West Avenue','Suburbia','54321'),(3,'TechPress','Block C','East Boulevard','Suburbia','98765'),(4,'Book Haven','Block D','Downtown Street','Downtown','67890'),(5,'Innovative Publishers','Block E','South Street','South City','45678'),(6,'Academic Press','Block F','North Avenue','North City','87654'),(7,'Global Books','Block G','Central Road','Central City','23456'),(8,'Intellect Publishers','Block H','Sunset Boulevard','Sunset City','78901'),(9,'Knowledge World','Block I','Moonlight Street','Moonlight City','34567'),(10,'Digital Press','Block J','Star Avenue','Star City','01234'),(11,'GoodBook Publications','33','Bookers street','Manchaster',''),(12,'Madman Books','Block 53','Temple street','Ramnagara','778877');
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `Employee_ID` int NOT NULL,
  `Contact_Number` varchar(20) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Designation` varchar(255) DEFAULT NULL,
  `library_id` int DEFAULT NULL,
  PRIMARY KEY (`Employee_ID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `fk_library` (`library_id`),
  CONSTRAINT `fk_library` FOREIGN KEY (`library_id`) REFERENCES `library` (`Library_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (101,'123-456-7890','john.smith@library.com','John Smith','Librarian',NULL),(102,'987-654-3210','alice.johnson@library.com','Alice Johnson','Assistant Librarian',NULL),(103,'111-222-3333','bob.williams@library.com','Bob Williams','Library Assistant',NULL),(104,'333-444-5555','emma.davis@library.com','Emma Davis','Library Clerk',NULL),(105,'555-666-7777','charlie.brown@library.com','Charlie Brown','Library Technician',NULL);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-26 19:06:20
