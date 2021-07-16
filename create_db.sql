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
  `answers_text` VARCHAR(90) NOT NULL,
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
SET @question_insert_id = last_insert_id();

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



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is the subtraction symbol?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'MATH')
  );
SET @question_insert_id = last_insert_id();

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
  '-',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '*',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '+',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '%',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is the division symbol?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'MATH')
  );
SET @question_insert_id = last_insert_id();

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
  '/',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '*',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '+',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '%',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is 10 x 5?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'MATH')
  );
SET @question_insert_id = last_insert_id();

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
  '50',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '55',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '45',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '15',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is 2 divided by 8?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'MATH')
  );
SET @question_insert_id = last_insert_id();

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
  '0.25',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '16',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '28',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '4',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is 10 divided by 4?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'MATH')
  );
SET @question_insert_id = last_insert_id();

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
  '2.5',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '40',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '0.4',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '14',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is 2/5 + 3/8?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'MATH')
  );
SET @question_insert_id = last_insert_id();

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
  '31/40',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '34/40',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '6/13',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '5/13',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'One and a third minus five-sixths is equal to what?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'MATH')
  );
SET @question_insert_id = last_insert_id();

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
  '1/2',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '3/9',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '1/3',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '-1/3',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is 0.032/100?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'MATH')
  );
SET @question_insert_id = last_insert_id();

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
  '0.00032',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '3.2',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '32',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '0.0032',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'When was the Declaration of Independence signed?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'July 4, 1776',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'February 20, 1778',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'June 21, 1788',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'December 19, 1777',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What were Lewis and Clark sent out to explore?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'The Louisiana Purchase',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'The State of Louisiana',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Hudson Bay',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Alaska',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'When did Lewis and Clark leave on their expidition?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'May 14, 1804',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'August 31, 1803',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'March 4, 1801',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'May 3, 1802',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'Who was the first President of the United States?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'George Washington',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'John Adams',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Thomas Jefferson',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'James Madison',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'Who was the 16th President of the United States?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'Abraham Lincoln',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'John Tyler',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Rutherford B. Hayes',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Chester A. Arthur',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is the Capital of the United States?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'Washington, D.C.',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Philadelphia',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'New York City',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Baltimore',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is the bloodiest conflict in American History?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'American Civil War',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Iraq War',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'World War II',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Demonic Invasion of 2166',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'When did the moon landing occur?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'July 20, 1969',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'September 12, 1962',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'November 22, 1963',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'January 28, 1986',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'When was slavery abolished in the United States?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'December 6, 1865',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'September 22, 1862',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'November 22, 1963',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'April 9, 1865',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'When did the United States join World War I?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'April 6, 1917',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'November 11, 1918',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'July 28, 1914',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'July 1, 1916',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'Who was President during most of the Great Depression?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'Franklin D. Roosevelt',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Theodore Roosevelt',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Harry S. Truman',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Herbert Hoover',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'Which Constitutional amendment prohibited the manufacture, sale, and transportation of alcohol?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  '18',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '21',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '17',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '20',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What did Constitutional amendment 26 do?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'Age to vote dropped to 18 years',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Presidents limited to two terms',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Congressional pay cannot be altered by a law until the start of term of office',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Right to vote cannot be withheld due to poll taxation',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'Which Native American tribe was not relocated from their ancestral lands during “The Trail of Tears”?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'HISTORY')
  );
SET @question_insert_id = last_insert_id();

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
  'Sioux',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Cherokee',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Choctaw',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Seminole',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is the first element in the periodic table?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'CHEMISTRY')
  );
SET @question_insert_id = last_insert_id();

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
  'Hydrogen',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Air',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Helium',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Gold',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'What is the atomic number of oxygen?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'CHEMISTRY')
  );
SET @question_insert_id = last_insert_id();

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
  '8',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '188',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '15.99',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  '16',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'Helium, neon, and argon belong to which group?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'CHEMISTRY')
  );
SET @question_insert_id = last_insert_id();

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
  'Noble gases',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Alkali metals',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Non-metals',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Metalloids',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'Who created the periodic table?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'CHEMISTRY')
  );
SET @question_insert_id = last_insert_id();

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
  'Dmitri Medeleev',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Samuel Hayden',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Thomas Jefferson',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Cher',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'Which of the following is not a halogen?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'CHEMISTRY')
  );
SET @question_insert_id = last_insert_id();

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
  'Polonium',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Fluorine',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Iodine',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Astatine',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'The order of elements in the periodic table is based on...',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'CHEMISTRY')
  );
SET @question_insert_id = last_insert_id();

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
  'The number of protons in the nucleus',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'The electric charge of the nucleus',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'The boiling point of the element',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'The atomic mass of the element',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'Which of the following elements is a metalloid?',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'CHEMISTRY')
  );
SET @question_insert_id = last_insert_id();

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
  'Silicon',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Silver',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Sulfur',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Selenium',
  FALSE
);



INSERT INTO questions (question_text, common_lookup_id)
VALUES
(
  'Atoms of elements in the same group have the same number of...',
  (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_question_categories = 'CHEMISTRY')
  );
SET @question_insert_id = last_insert_id();

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
  'Valence electrons',
  TRUE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Protons',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Neutrons',
  FALSE
),
(
  (SELECT question_id
    FROM questions
    WHERE question_id = @question_insert_id),
  'Grammy awards',
  FALSE
);



-- verify it worked
SELECT * FROM questions;
SELECT * FROM answers;