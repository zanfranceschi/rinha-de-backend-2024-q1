-- MySQL dump 10.13  Distrib 8.2.0, for macos14.0 (arm64)
--
-- Host: localserver    Database: rinhadb
-- ------------------------------------------------------
-- Server version	8.2.0

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
-- Current Database: `rinhadb`
--

/*!40000 DROP DATABASE IF EXISTS `rinhadb`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rinhadb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rinhadb`;

--
-- Table structure for table `OrleansMembershipTable`
--

DROP TABLE IF EXISTS `OrleansMembershipTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OrleansMembershipTable` (
  `DeploymentId` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Address` varchar(45) NOT NULL,
  `Port` int NOT NULL,
  `Generation` int NOT NULL,
  `SiloName` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `HostName` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Status` int NOT NULL,
  `ProxyPort` int DEFAULT NULL,
  `SuspectTimes` varchar(8000) DEFAULT NULL,
  `StartTime` datetime NOT NULL,
  `IAmAliveTime` datetime NOT NULL,
  PRIMARY KEY (`DeploymentId`,`Address`,`Port`,`Generation`),
  CONSTRAINT `FK_MembershipTable_MembershipVersionTable_DeploymentId` FOREIGN KEY (`DeploymentId`) REFERENCES `OrleansMembershipVersionTable` (`DeploymentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrleansMembershipTable`
--

LOCK TABLES `OrleansMembershipTable` WRITE;
/*!40000 ALTER TABLE `OrleansMembershipTable` DISABLE KEYS */;
/*!40000 ALTER TABLE `OrleansMembershipTable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OrleansMembershipVersionTable`
--

DROP TABLE IF EXISTS `OrleansMembershipVersionTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OrleansMembershipVersionTable` (
  `DeploymentId` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Version` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`DeploymentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrleansMembershipVersionTable`
--

LOCK TABLES `OrleansMembershipVersionTable` WRITE;
/*!40000 ALTER TABLE `OrleansMembershipVersionTable` DISABLE KEYS */;
/*!40000 ALTER TABLE `OrleansMembershipVersionTable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OrleansQuery`
--

DROP TABLE IF EXISTS `OrleansQuery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OrleansQuery` (
  `QueryKey` varchar(64) NOT NULL,
  `QueryText` varchar(8000) NOT NULL,
  PRIMARY KEY (`QueryKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrleansQuery`
--

LOCK TABLES `OrleansQuery` WRITE;
/*!40000 ALTER TABLE `OrleansQuery` DISABLE KEYS */;
INSERT INTO `OrleansQuery` VALUES ('CleanupDefunctSiloEntriesKey','\n    DELETE FROM OrleansMembershipTable\n    WHERE DeploymentId = @DeploymentId\n        AND @DeploymentId IS NOT NULL\n        AND IAmAliveTime < @IAmAliveTime\n        AND Status !=3;\n'),('ClearStorageKey','\n    call ClearStorage(@GrainIdHash, @GrainIdN0, @GrainIdN1, @GrainTypeHash, @GrainTypeString, @GrainIdExtensionString, @ServiceId, @GrainStateVersion);'),('DeleteMembershipTableEntriesKey','\n    DELETE FROM OrleansMembershipTable\n    WHERE DeploymentId = @DeploymentId AND @DeploymentId IS NOT NULL;\n    DELETE FROM OrleansMembershipVersionTable\n    WHERE DeploymentId = @DeploymentId AND @DeploymentId IS NOT NULL;\n'),('GatewaysQueryKey','\n    SELECT\n        Address,\n        ProxyPort,\n        Generation\n    FROM\n        OrleansMembershipTable\n    WHERE\n        DeploymentId = @DeploymentId AND @DeploymentId IS NOT NULL\n        AND Status = @Status AND @Status IS NOT NULL\n        AND ProxyPort > 0;\n'),('InsertMembershipKey','\n    call InsertMembershipKey(@DeploymentId, @Address, @Port, @Generation,\n    @Version, @SiloName, @HostName, @Status, @ProxyPort, @StartTime, @IAmAliveTime);'),('InsertMembershipVersionKey','\n    INSERT INTO OrleansMembershipVersionTable\n    (\n        DeploymentId\n    )\n    SELECT * FROM ( SELECT @DeploymentId ) AS TMP\n    WHERE NOT EXISTS\n    (\n    SELECT 1\n    FROM\n        OrleansMembershipVersionTable\n    WHERE\n        DeploymentId = @DeploymentId AND @DeploymentId IS NOT NULL\n    );\n\n    SELECT ROW_COUNT();\n'),('MembershipReadAllKey','\n    SELECT\n        v.DeploymentId,\n        m.Address,\n        m.Port,\n        m.Generation,\n        m.SiloName,\n        m.HostName,\n        m.Status,\n        m.ProxyPort,\n        m.SuspectTimes,\n        m.StartTime,\n        m.IAmAliveTime,\n        v.Version\n    FROM\n        OrleansMembershipVersionTable v LEFT OUTER JOIN OrleansMembershipTable m\n        ON v.DeploymentId = m.DeploymentId\n    WHERE\n        v.DeploymentId = @DeploymentId AND @DeploymentId IS NOT NULL;\n'),('MembershipReadRowKey','\n    SELECT\n        v.DeploymentId,\n        m.Address,\n        m.Port,\n        m.Generation,\n        m.SiloName,\n        m.HostName,\n        m.Status,\n        m.ProxyPort,\n        m.SuspectTimes,\n        m.StartTime,\n        m.IAmAliveTime,\n        v.Version\n    FROM\n        OrleansMembershipVersionTable v\n        -- This ensures the version table will returned even if there is no matching membership row.\n        LEFT OUTER JOIN OrleansMembershipTable m ON v.DeploymentId = m.DeploymentId\n        AND Address = @Address AND @Address IS NOT NULL\n        AND Port = @Port AND @Port IS NOT NULL\n        AND Generation = @Generation AND @Generation IS NOT NULL\n    WHERE\n        v.DeploymentId = @DeploymentId AND @DeploymentId IS NOT NULL;\n'),('ReadFromStorageKey','SELECT\n        PayloadBinary,\n        UTC_TIMESTAMP(),\n        Version\n    FROM\n        OrleansStorage\n    WHERE\n        GrainIdHash = @GrainIdHash\n        AND GrainTypeHash = @GrainTypeHash AND @GrainTypeHash IS NOT NULL\n        AND GrainIdN0 = @GrainIdN0 AND @GrainIdN0 IS NOT NULL\n        AND GrainIdN1 = @GrainIdN1 AND @GrainIdN1 IS NOT NULL\n        AND GrainTypeString = @GrainTypeString AND GrainTypeString IS NOT NULL\n        AND ((@GrainIdExtensionString IS NOT NULL AND GrainIdExtensionString IS NOT NULL AND GrainIdExtensionString = @GrainIdExtensionString) OR @GrainIdExtensionString IS NULL AND GrainIdExtensionString IS NULL)\n        AND ServiceId = @ServiceId AND @ServiceId IS NOT NULL\n        LIMIT 1;'),('UpdateIAmAlivetimeKey','\n    -- This is expected to never fail by Orleans, so return value\n    -- is not needed nor is it checked.\n    UPDATE OrleansMembershipTable\n    SET\n        IAmAliveTime = @IAmAliveTime\n    WHERE\n        DeploymentId = @DeploymentId AND @DeploymentId IS NOT NULL\n        AND Address = @Address AND @Address IS NOT NULL\n        AND Port = @Port AND @Port IS NOT NULL\n        AND Generation = @Generation AND @Generation IS NOT NULL;\n'),('UpdateMembershipKey','\n    START TRANSACTION;\n\n    UPDATE OrleansMembershipVersionTable\n    SET\n        Version = Version + 1\n    WHERE\n        DeploymentId = @DeploymentId AND @DeploymentId IS NOT NULL\n        AND Version = @Version AND @Version IS NOT NULL;\n\n    UPDATE OrleansMembershipTable\n    SET\n        Status = @Status,\n        SuspectTimes = @SuspectTimes,\n        IAmAliveTime = @IAmAliveTime\n    WHERE\n        DeploymentId = @DeploymentId AND @DeploymentId IS NOT NULL\n        AND Address = @Address AND @Address IS NOT NULL\n        AND Port = @Port AND @Port IS NOT NULL\n        AND Generation = @Generation AND @Generation IS NOT NULL\n        AND ROW_COUNT() > 0;\n\n    SELECT ROW_COUNT();\n    COMMIT;\n'),('WriteToStorageKey','\n    call WriteToStorage(@GrainIdHash, @GrainIdN0, @GrainIdN1, @GrainTypeHash, @GrainTypeString, @GrainIdExtensionString, @ServiceId, @GrainStateVersion, @PayloadBinary);');
/*!40000 ALTER TABLE `OrleansQuery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contas`
--

DROP TABLE IF EXISTS `contas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` varchar(2500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contas`
--

LOCK TABLES `contas` WRITE;
/*!40000 ALTER TABLE `contas` DISABLE KEYS */;
INSERT INTO `contas` VALUES (1,'{\"id\":1,\"limite\":100000,\"saldo\":0,\"extrato\":[]}'),(2,'{\"id\":2,\"limite\":80000,\"saldo\":0,\"extrato\":[]}'),(3,'{\"id\":3,\"limite\":1000000,\"saldo\":0,\"extrato\":[]}'),(4,'{\"id\":4,\"limite\":10000000,\"saldo\":0,\"extrato\":[]}'),(5,'{\"id\":5,\"limite\":500000,\"saldo\":0,\"extrato\":[]}');
/*!40000 ALTER TABLE `contas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transacoes`
--

DROP TABLE IF EXISTS `transacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transacoes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conta_id` int DEFAULT NULL,
  `content` varchar(1024) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_conta_id` (`conta_id`),
  CONSTRAINT `fk_conta_id` FOREIGN KEY (`conta_id`) REFERENCES `contas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47265 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transacoes`
--

LOCK TABLES `transacoes` WRITE;
/*!40000 ALTER TABLE `transacoes` DISABLE KEYS */;
/*!40000 ALTER TABLE `transacoes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'rinhadb'
--
/*!50003 DROP PROCEDURE IF EXISTS `InsertMembershipKey` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `InsertMembershipKey`(
    in    _DeploymentId NVARCHAR(150),
    in    _Address VARCHAR(45),
    in    _Port INT,
    in    _Generation INT,
    in    _Version INT,
    in    _SiloName NVARCHAR(150),
    in    _HostName NVARCHAR(150),
    in    _Status INT,
    in    _ProxyPort INT,
    in    _StartTime DATETIME,
    in    _IAmAliveTime DATETIME
)
BEGIN
    DECLARE _ROWCOUNT INT;
    START TRANSACTION;
    INSERT INTO OrleansMembershipTable
    (
        DeploymentId,
        Address,
        Port,
        Generation,
        SiloName,
        HostName,
        Status,
        ProxyPort,
        StartTime,
        IAmAliveTime
    )
    SELECT * FROM ( SELECT
        _DeploymentId,
        _Address,
        _Port,
        _Generation,
        _SiloName,
        _HostName,
        _Status,
        _ProxyPort,
        _StartTime,
        _IAmAliveTime) AS TMP
    WHERE NOT EXISTS
    (
    SELECT 1
    FROM
        OrleansMembershipTable
    WHERE
        DeploymentId = _DeploymentId AND _DeploymentId IS NOT NULL
        AND Address = _Address AND _Address IS NOT NULL
        AND Port = _Port AND _Port IS NOT NULL
        AND Generation = _Generation AND _Generation IS NOT NULL
    );

    UPDATE OrleansMembershipVersionTable
    SET
        Version = Version + 1
    WHERE
        DeploymentId = _DeploymentId AND _DeploymentId IS NOT NULL
        AND Version = _Version AND _Version IS NOT NULL
        AND ROW_COUNT() > 0;

    SET _ROWCOUNT = ROW_COUNT();

    IF _ROWCOUNT = 0
    THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
    SELECT _ROWCOUNT;
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

