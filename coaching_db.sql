-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema coaching_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema coaching_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `coaching_db` ;
USE `coaching_db` ;

-- -----------------------------------------------------
-- Table `coaching_db`.`Client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `coaching_db`.`Client` (
  `client_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `created_at` DATETIME NOT NULL,
  PRIMARY KEY (`client_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coaching_db`.`Coach`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `coaching_db`.`Coach` (
  `coach_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `bio` VARCHAR(255) NOT NULL,
  `hourly_rate` DECIMAL(8,2) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`coach_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coaching_db`.`Service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `coaching_db`.`Service` (
  `service_id` INT NOT NULL AUTO_INCREMENT,
  `service_name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(255) NULL,
  `base_price` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`service_id`),
  UNIQUE INDEX `service_name_UNIQUE` (`service_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coaching_db`.`Session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `coaching_db`.`Session` (
  `session_id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `coach_id` INT NOT NULL,
  `session_date` DATE NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `notes` VARCHAR(255) NOT NULL,
  `service_id` INT NOT NULL,
  PRIMARY KEY (`session_id`),
  INDEX `fk_session_client_idx` (`client_id` ASC) VISIBLE,
  INDEX `fk_session_coach_idx` (`coach_id` ASC) VISIBLE,
  INDEX `fk_session_service_idx` (`service_id` ASC) VISIBLE,
  CONSTRAINT `fk_session_client`
    FOREIGN KEY (`client_id`)
    REFERENCES `coaching_db`.`Client` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_session_coach`
    FOREIGN KEY (`coach_id`)
    REFERENCES `coaching_db`.`Coach` (`coach_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_session_service`
    FOREIGN KEY (`service_id`)
    REFERENCES `coaching_db`.`Service` (`service_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coaching_db`.`Package`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `coaching_db`.`Package` (
  `package_id` INT NOT NULL AUTO_INCREMENT,
  `package_name` VARCHAR(100) NOT NULL,
  `sessions_included` INT NOT NULL,
  `package_price` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`package_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coaching_db`.`Coach_Service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `coaching_db`.`Coach_Service` (
  `coach_id` INT NOT NULL,
  `service_id` INT NOT NULL,
  `price_override` DECIMAL(8,2) NULL,
  PRIMARY KEY (`coach_id`, `service_id`),
  INDEX `fk_coach_service_service_idx` (`service_id` ASC) VISIBLE,
  CONSTRAINT `fk_coach_service_coach`
    FOREIGN KEY (`coach_id`)
    REFERENCES `coaching_db`.`Coach` (`coach_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_coach_service_service`
    FOREIGN KEY (`service_id`)
    REFERENCES `coaching_db`.`Service` (`service_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coaching_db`.`Client_Package`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `coaching_db`.`Client_Package` (
  `client_package_id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `package_id` INT NOT NULL,
  `purchase_date` DATE NOT NULL,
  `remaining_sessions` INT NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`client_package_id`),
  INDEX `fk_client_package_client_idx` (`client_id` ASC) VISIBLE,
  INDEX `fk_client_package_package_idx` (`package_id` ASC) VISIBLE,
  CONSTRAINT `fk_client_package_client`
    FOREIGN KEY (`client_id`)
    REFERENCES `coaching_db`.`Client` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_client_package_package`
    FOREIGN KEY (`package_id`)
    REFERENCES `coaching_db`.`Package` (`package_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coaching_db`.`Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `coaching_db`.`Payment` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `amount` DECIMAL(8,2) NOT NULL,
  `payment_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `method` VARCHAR(20) NOT NULL,
  `payment_status` VARCHAR(20) NOT NULL,
  `session_id` INT NULL,
  `client_package_id` INT NULL,
  PRIMARY KEY (`payment_id`),
  INDEX `fk_payment_client_idx` (`client_id` ASC) VISIBLE,
  INDEX `fk_payment_session_idx` (`session_id` ASC) VISIBLE,
  INDEX `fk_payment_client_package_idx` (`client_package_id` ASC) VISIBLE,
  CONSTRAINT `fk_payment_client`
    FOREIGN KEY (`client_id`)
    REFERENCES `coaching_db`.`Client` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_session`
    FOREIGN KEY (`session_id`)
    REFERENCES `coaching_db`.`Session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_client_package`
    FOREIGN KEY (`client_package_id`)
    REFERENCES `coaching_db`.`Client_Package` (`client_package_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coaching_db`.`Review`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `coaching_db`.`Review` (
  `review_id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `coach_id` INT NOT NULL,
  `session_id` INT NULL,
  `rating` INT NOT NULL,
  `comment` VARCHAR(255) NULL,
  `review_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  INDEX `fk_review_client_idx` (`client_id` ASC) VISIBLE,
  INDEX `fk_review_coach_idx` (`coach_id` ASC) VISIBLE,
  INDEX `fk_review_session_idx` (`session_id` ASC) VISIBLE,
  CONSTRAINT `fk_review_client`
    FOREIGN KEY (`client_id`)
    REFERENCES `coaching_db`.`Client` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_coach`
    FOREIGN KEY (`coach_id`)
    REFERENCES `coaching_db`.`Coach` (`coach_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_session`
    FOREIGN KEY (`session_id`)
    REFERENCES `coaching_db`.`Session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
