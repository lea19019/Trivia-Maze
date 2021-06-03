-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema gamedb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema gamedb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `gamedb` DEFAULT CHARACTER SET utf8 ;
USE `gamedb` ;

-- -----------------------------------------------------
-- Table `gamedb`.`common_lookup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gamedb`.`common_lookup` ;

CREATE TABLE IF NOT EXISTS `gamedb`.`common_lookup` (
  `common_lookup_id` INT NOT NULL AUTO_INCREMENT,
  `common_lookup_question_categories` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`common_lookup_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gamedb`.`questions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gamedb`.`questions` ;

CREATE TABLE IF NOT EXISTS `gamedb`.`questions` (
  `question_id` INT NOT NULL AUTO_INCREMENT,
  `question_text` VARCHAR(120) NOT NULL,
  `common_lookup_id` INT NOT NULL,
  PRIMARY KEY (`question_id`),
  INDEX `fk_questions_common_lookup_idx` (`common_lookup_id` ASC) VISIBLE,
  CONSTRAINT `fk_questions_common_lookup`
    FOREIGN KEY (`common_lookup_id`)
    REFERENCES `gamedb`.`common_lookup` (`common_lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gamedb`.`images`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gamedb`.`images` ;

CREATE TABLE IF NOT EXISTS `gamedb`.`images` (
  `images_id` INT NOT NULL AUTO_INCREMENT,
  `images_blob` BLOB NOT NULL,
  PRIMARY KEY (`images_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gamedb`.`answers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gamedb`.`answers` ;

CREATE TABLE IF NOT EXISTS `gamedb`.`answers` (
  `answers_id` INT NOT NULL AUTO_INCREMENT,
  `questions_question_id` INT NOT NULL,
  `answers_text` VARCHAR(45) NOT NULL,
  `answers_true` TINYINT NOT NULL,
  `images_images_id` INT NULL,
  PRIMARY KEY (`answers_id`),
  INDEX `fk_answers_questions1_idx` (`questions_question_id` ASC) VISIBLE,
  INDEX `fk_answers_images1_idx` (`images_images_id` ASC) VISIBLE,
  CONSTRAINT `fk_answers_questions1`
    FOREIGN KEY (`questions_question_id`)
    REFERENCES `gamedb`.`questions` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_answers_images1`
    FOREIGN KEY (`images_images_id`)
    REFERENCES `gamedb`.`images` (`images_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- begin adding data!


INSERT INTO common_lookup (common_lookup_question_categories)
VALUES ('MATH');

INSERT INTO common_lookup (common_lookup_question_categories)
VALUES ('HISTORY');

INSERT INTO common_lookup (common_lookup_question_categories)
VALUES ('CHEMISTRY');

INSERT INTO common_lookup (common_lookup_question_categories)
VALUES ('COMPSCI');

-- insert questions and answers



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is 2 x 2?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'MATH')
  );
SET @question_insert_id = last_insert_id(); -- we will use this in a second

INSERT INTO answers
(
  questions_question_id,
  answers_text,
  answers_true
)
VALUES
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '4',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '3',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '1',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '6',
  FALSE
);



-- verify it worked
SELECT * FROM questions;
SELECT * FROM answers;