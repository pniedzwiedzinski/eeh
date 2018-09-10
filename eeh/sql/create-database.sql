-- MySQL Script generated by MySQL Workbench
-- Mon Sep 10 10:39:32 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema eeh
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema eeh
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `eeh` DEFAULT CHARACTER SET utf8 ;
USE `eeh` ;

-- -----------------------------------------------------
-- Table `eeh`.`scout`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`scout` (
  `id_scout` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `birthdate` DATETIME NULL,
  `pesel` VARCHAR(11) NULL,
  `address` VARCHAR(200) NULL,
  `phone` VARCHAR(45) NULL,
  PRIMARY KEY (`id_scout`),
  UNIQUE INDEX `id_UNIQUE` (`id_scout` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`user` (
  `id_user` INT NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(45) NOT NULL,
  `password` VARCHAR(200) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `email_confirm` BINARY(1) NOT NULL DEFAULT 0,
  `scout_id` INT NOT NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  INDEX `fk_user_scout1_idx` (`scout_id` ASC),
  CONSTRAINT `fk_user_scout1`
    FOREIGN KEY (`scout_id`)
    REFERENCES `eeh`.`scout` (`id_scout`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`usergroup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`usergroup` (
  `id_usergroup` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `scout_team_id` INT NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`id_usergroup`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`user_membership`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`user_membership` (
  `id_user_membership` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `usergroup_id` INT NOT NULL,
  PRIMARY KEY (`id_user_membership`),
  INDEX `fk_user_membership_user_idx` (`user_id` ASC),
  INDEX `fk_user_membership_usergroup1_idx` (`usergroup_id` ASC),
  CONSTRAINT `fk_user_membership_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `eeh`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_membership_usergroup1`
    FOREIGN KEY (`usergroup_id`)
    REFERENCES `eeh`.`usergroup` (`id_usergroup`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`work_plan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`work_plan` (
  `id_work_plan` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `category` VARCHAR(45) NOT NULL,
  `scout_team_id` INT NOT NULL,
  `start_date` DATETIME NULL,
  `end_date` DATETIME NULL,
  PRIMARY KEY (`id_work_plan`),
  INDEX `fk_work_plan_scout_team1_idx` (`scout_team_id` ASC),
  CONSTRAINT `fk_work_plan_scout_team1`
    FOREIGN KEY (`scout_team_id`)
    REFERENCES `eeh`.`scout_team` (`id_scout_team`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`scout_team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`scout_team` (
  `id_scout_team` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `scoutmaster_user_id` INT NOT NULL,
  `current_work_plan_id` INT NULL,
  PRIMARY KEY (`id_scout_team`),
  INDEX `fk_scout_team_user1_idx` (`scoutmaster_user_id` ASC),
  INDEX `fk_scout_team_work_plan1_idx` (`current_work_plan_id` ASC),
  CONSTRAINT `fk_scout_team_user1`
    FOREIGN KEY (`scoutmaster_user_id`)
    REFERENCES `eeh`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_scout_team_work_plan1`
    FOREIGN KEY (`current_work_plan_id`)
    REFERENCES `eeh`.`work_plan` (`id_work_plan`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`characteristic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`characteristic` (
  `id_characteristic` INT NOT NULL AUTO_INCREMENT,
  `characteristic` LONGTEXT NOT NULL,
  `category` VARCHAR(45) NOT NULL,
  `parent_id` INT NOT NULL,
  `work_plan_id` INT NOT NULL,
  PRIMARY KEY (`id_characteristic`),
  INDEX `fk_characteristic_work_plan1_idx` (`work_plan_id` ASC),
  CONSTRAINT `fk_characteristic_work_plan1`
    FOREIGN KEY (`work_plan_id`)
    REFERENCES `eeh`.`work_plan` (`id_work_plan`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`goal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`goal` (
  `id_goal` INT NOT NULL AUTO_INCREMENT,
  `goal` LONGTEXT NOT NULL,
  `characteristic_id` INT NOT NULL,
  PRIMARY KEY (`id_goal`),
  INDEX `fk_goal_characteristic1_idx` (`characteristic_id` ASC),
  CONSTRAINT `fk_goal_characteristic1`
    FOREIGN KEY (`characteristic_id`)
    REFERENCES `eeh`.`characteristic` (`id_characteristic`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`method`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`method` (
  `id_method` INT NOT NULL AUTO_INCREMENT,
  `method` LONGTEXT NULL,
  `goal_id` INT NOT NULL,
  PRIMARY KEY (`id_method`),
  INDEX `fk_method_goal1_idx` (`goal_id` ASC),
  CONSTRAINT `fk_method_goal1`
    FOREIGN KEY (`goal_id`)
    REFERENCES `eeh`.`goal` (`id_goal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`scouting_troop`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`scouting_troop` (
  `id_scouting_troop` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `scout_team_id` INT NOT NULL,
  PRIMARY KEY (`id_scouting_troop`),
  INDEX `fk_scouting_troop_scout_team1_idx` (`scout_team_id` ASC),
  CONSTRAINT `fk_scouting_troop_scout_team1`
    FOREIGN KEY (`scout_team_id`)
    REFERENCES `eeh`.`scout_team` (`id_scout_team`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`scout_membership`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`scout_membership` (
  `id_scout_membership` INT NOT NULL AUTO_INCREMENT,
  `scout_id` INT NOT NULL,
  `scouting_troop_id` INT NOT NULL,
  `start_date` DATETIME NULL,
  PRIMARY KEY (`id_scout_membership`),
  INDEX `fk_scout_membership_scout1_idx` (`scout_id` ASC),
  INDEX `fk_scout_membership_scouting_troop1_idx` (`scouting_troop_id` ASC),
  CONSTRAINT `fk_scout_membership_scout1`
    FOREIGN KEY (`scout_id`)
    REFERENCES `eeh`.`scout` (`id_scout`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_scout_membership_scouting_troop1`
    FOREIGN KEY (`scouting_troop_id`)
    REFERENCES `eeh`.`scouting_troop` (`id_scouting_troop`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`badge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`badge` (
  `id_badge` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `image_path` VARCHAR(45) NULL,
  `requirements` LONGTEXT NULL,
  PRIMARY KEY (`id_badge`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`grade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`grade` (
  `id_grade` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `requirements` LONGTEXT NULL,
  PRIMARY KEY (`id_grade`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`earned_badges`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`earned_badges` (
  `id_earned_badges` INT NOT NULL AUTO_INCREMENT,
  `scout_id` INT NOT NULL,
  `badge_id` INT NOT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NULL,
  PRIMARY KEY (`id_earned_badges`),
  INDEX `fk_earned_badges_scout1_idx` (`scout_id` ASC),
  INDEX `fk_earned_badges_badge1_idx` (`badge_id` ASC),
  CONSTRAINT `fk_earned_badges_scout1`
    FOREIGN KEY (`scout_id`)
    REFERENCES `eeh`.`scout` (`id_scout`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_earned_badges_badge1`
    FOREIGN KEY (`badge_id`)
    REFERENCES `eeh`.`badge` (`id_badge`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`awarded_grades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`awarded_grades` (
  `id_awarded_grades` INT NOT NULL AUTO_INCREMENT,
  `scout_id` INT NOT NULL,
  `grade_id` INT NOT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NULL,
  PRIMARY KEY (`id_awarded_grades`),
  INDEX `fk_awarded_grades_scout1_idx` (`scout_id` ASC),
  INDEX `fk_awarded_grades_grade1_idx` (`grade_id` ASC),
  CONSTRAINT `fk_awarded_grades_scout1`
    FOREIGN KEY (`scout_id`)
    REFERENCES `eeh`.`scout` (`id_scout`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_awarded_grades_grade1`
    FOREIGN KEY (`grade_id`)
    REFERENCES `eeh`.`grade` (`id_grade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`task`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`task` (
  `id_task` INT NOT NULL AUTO_INCREMENT,
  `task` LONGTEXT NOT NULL,
  `done` BINARY(1) NULL,
  `done_date` DATETIME NULL,
  `scout_id` INT NOT NULL,
  `awarded_grades_id` INT NULL,
  `earned_badges_id` INT NULL,
  PRIMARY KEY (`id_task`),
  UNIQUE INDEX `id_UNIQUE` (`id_task` ASC),
  INDEX `fk_task_scout1_idx` (`scout_id` ASC),
  INDEX `fk_task_awarded_grades1_idx` (`awarded_grades_id` ASC),
  INDEX `fk_task_earned_badges1_idx` (`earned_badges_id` ASC),
  CONSTRAINT `fk_task_scout1`
    FOREIGN KEY (`scout_id`)
    REFERENCES `eeh`.`scout` (`id_scout`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_task_awarded_grades1`
    FOREIGN KEY (`awarded_grades_id`)
    REFERENCES `eeh`.`awarded_grades` (`id_awarded_grades`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_task_earned_badges1`
    FOREIGN KEY (`earned_badges_id`)
    REFERENCES `eeh`.`earned_badges` (`id_earned_badges`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`parent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`parent` (
  `id_parent` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `phone` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`id_parent`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`parenthood`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`parenthood` (
  `id_parenthood` INT NOT NULL AUTO_INCREMENT,
  `parent_id` INT NOT NULL,
  `scout_id` INT NOT NULL,
  PRIMARY KEY (`id_parenthood`),
  INDEX `fk_parenthood_parent1_idx` (`parent_id` ASC),
  INDEX `fk_parenthood_scout1_idx` (`scout_id` ASC),
  CONSTRAINT `fk_parenthood_parent1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `eeh`.`parent` (`id_parent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_parenthood_scout1`
    FOREIGN KEY (`scout_id`)
    REFERENCES `eeh`.`scout` (`id_scout`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`scout_meeting`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`scout_meeting` (
  `id_scout_meeting` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NULL,
  `scouting_troop_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id_scout_meeting`),
  INDEX `fk_scout_meeting_scouting_troop1_idx` (`scouting_troop_id` ASC),
  INDEX `fk_scout_meeting_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_scout_meeting_scouting_troop1`
    FOREIGN KEY (`scouting_troop_id`)
    REFERENCES `eeh`.`scouting_troop` (`id_scouting_troop`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_scout_meeting_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `eeh`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`scout_presence`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`scout_presence` (
  `id_scout_presence` INT NOT NULL AUTO_INCREMENT,
  `scout_id` INT NOT NULL,
  `scout_meeting_id` INT NOT NULL,
  PRIMARY KEY (`id_scout_presence`),
  INDEX `fk_scout_presence_scout1_idx` (`scout_id` ASC),
  INDEX `fk_scout_presence_scout_meeting1_idx` (`scout_meeting_id` ASC),
  CONSTRAINT `fk_scout_presence_scout1`
    FOREIGN KEY (`scout_id`)
    REFERENCES `eeh`.`scout` (`id_scout`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_scout_presence_scout_meeting1`
    FOREIGN KEY (`scout_meeting_id`)
    REFERENCES `eeh`.`scout_meeting` (`id_scout_meeting`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`punctation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`punctation` (
  `id_punctation` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `min` INT NULL,
  `max` INT NULL,
  `multipler` INT NULL,
  `work_plan_id` INT NOT NULL,
  PRIMARY KEY (`id_punctation`),
  INDEX `fk_punctation_work_plan1_idx` (`work_plan_id` ASC),
  CONSTRAINT `fk_punctation_work_plan1`
    FOREIGN KEY (`work_plan_id`)
    REFERENCES `eeh`.`work_plan` (`id_work_plan`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`assigned_point`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`assigned_point` (
  `id_assigned_point` INT NOT NULL AUTO_INCREMENT,
  `punctation_id` INT NOT NULL,
  `scout_id` INT NOT NULL,
  `date` DATETIME NULL,
  `points` INT NULL,
  PRIMARY KEY (`id_assigned_point`),
  INDEX `fk_assigned_point_punctation1_idx` (`punctation_id` ASC),
  INDEX `fk_assigned_point_scout1_idx` (`scout_id` ASC),
  CONSTRAINT `fk_assigned_point_punctation1`
    FOREIGN KEY (`punctation_id`)
    REFERENCES `eeh`.`punctation` (`id_punctation`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assigned_point_scout1`
    FOREIGN KEY (`scout_id`)
    REFERENCES `eeh`.`scout` (`id_scout`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`function`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`function` (
  `id_function` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `color` VARCHAR(7) NOT NULL,
  `target_table` VARCHAR(45) NULL,
  PRIMARY KEY (`id_function`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`acted_function`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`acted_function` (
  `id_acted_function` INT NOT NULL AUTO_INCREMENT,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NULL,
  `function_id` INT NOT NULL,
  `scout_id` INT NOT NULL,
  `target_id` INT NOT NULL,
  PRIMARY KEY (`id_acted_function`),
  INDEX `fk_acted_function_function1_idx` (`function_id` ASC),
  INDEX `fk_acted_function_scout1_idx` (`scout_id` ASC),
  CONSTRAINT `fk_acted_function_function1`
    FOREIGN KEY (`function_id`)
    REFERENCES `eeh`.`function` (`id_function`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_acted_function_scout1`
    FOREIGN KEY (`scout_id`)
    REFERENCES `eeh`.`scout` (`id_scout`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`scout_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`scout_history` (
  `id_scout_history` INT NOT NULL AUTO_INCREMENT,
  `id_scout` INT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `birthdate` DATETIME NULL,
  `pesel` VARCHAR(11) NULL,
  `address` VARCHAR(200) NULL,
  `phone` VARCHAR(45) NULL,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id_scout_history`),
  UNIQUE INDEX `id_UNIQUE` (`id_scout_history` ASC),
  INDEX `fk_scout_history_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_scout_history_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `eeh`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`function_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`function_history` (
  `id_function_history` INT NOT NULL AUTO_INCREMENT,
  `id_function` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `color` VARCHAR(7) NOT NULL,
  `target_table` VARCHAR(45) NULL,
  `date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id_user` INT NOT NULL,
  PRIMARY KEY (`id_function_history`),
  INDEX `fk_function_history_user1_idx` (`user_id_user` ASC),
  CONSTRAINT `fk_function_history_user1`
    FOREIGN KEY (`user_id_user`)
    REFERENCES `eeh`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`acted_function_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`acted_function_history` (
  `id_acted_function_history` INT NOT NULL AUTO_INCREMENT,
  `id_acted_function` INT NOT NULL,
  `start_date` TIMESTAMP NOT NULL,
  `end_date` TIMESTAMP NULL,
  `function_id` INT NOT NULL,
  `scout_id` INT NOT NULL,
  `target_id` INT NOT NULL,
  `date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id_user` INT NOT NULL,
  PRIMARY KEY (`id_acted_function_history`),
  INDEX `fk_acted_function_history_user1_idx` (`user_id_user` ASC),
  CONSTRAINT `fk_acted_function_history_user1`
    FOREIGN KEY (`user_id_user`)
    REFERENCES `eeh`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`scout_membership_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`scout_membership_history` (
  `id_scout_membership_history` INT NOT NULL AUTO_INCREMENT,
  `id_scout_membership` INT NOT NULL,
  `scout_id` INT NOT NULL,
  `scouting_troop_id` INT NOT NULL,
  `start_date` TIMESTAMP NULL,
  `date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id_user` INT NOT NULL,
  PRIMARY KEY (`id_scout_membership_history`),
  INDEX `fk_scout_membership_history_user1_idx` (`user_id_user` ASC),
  CONSTRAINT `fk_scout_membership_history_user1`
    FOREIGN KEY (`user_id_user`)
    REFERENCES `eeh`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`scouting_troop_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`scouting_troop_history` (
  `id_scouting_troop_history` INT NOT NULL AUTO_INCREMENT,
  `id_scouting_troop` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `scout_team_id` INT NOT NULL,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id_user` INT NOT NULL,
  PRIMARY KEY (`id_scouting_troop_history`),
  INDEX `fk_scouting_troop_history_user1_idx` (`user_id_user` ASC),
  CONSTRAINT `fk_scouting_troop_history_user1`
    FOREIGN KEY (`user_id_user`)
    REFERENCES `eeh`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eeh`.`scout_team_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eeh`.`scout_team_history` (
  `id_scout_team_history` INT NOT NULL AUTO_INCREMENT,
  `id_scout_team` INT NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `scoutmaster_user_id` INT NOT NULL,
  `current_work_plan_id` INT NULL,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id_user` INT NOT NULL,
  PRIMARY KEY (`id_scout_team_history`),
  INDEX `fk_scout_team_history_user1_idx` (`user_id_user` ASC),
  CONSTRAINT `fk_scout_team_history_user1`
    FOREIGN KEY (`user_id_user`)
    REFERENCES `eeh`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE USER 'flask' IDENTIFIED BY 'flask';

GRANT ALL ON `eeh`.* TO 'flask';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
