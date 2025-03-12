-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema memories
-- -----------------------------------------------------
-- 코리아아이티아카데미 부산 Memories 프로젝트 데이터베이스

-- -----------------------------------------------------
-- Schema memories
--
-- 코리아아이티아카데미 부산 Memories 프로젝트 데이터베이스
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `memories` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `memories` ;

-- -----------------------------------------------------
-- Table `memories`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `memories`.`user` (
  `user_id` VARCHAR(20) NOT NULL COMMENT '사용자 아이디',
  `user_password` VARCHAR(255) NOT NULL COMMENT '사용자 비밀번호',
  `join_type` VARCHAR(6) NOT NULL COMMENT '회원 가입 경로 (NORMAL, KAKAO, NAVER)',
  `sns_id` VARCHAR(100) NULL COMMENT 'OAuth 인증 후 인증 서버로부터 발급 받은 사용자의 아이디',
  `name` VARCHAR(15) NOT NULL COMMENT '사용자 이름',
  `address` TEXT NOT NULL COMMENT '사용자 주소',
  `detail_address` TEXT NULL COMMENT '사용자 상세 주소',
  `profile_image` TEXT NULL COMMENT '사용자 프로필 이미지',
  `gender` VARCHAR(5) NULL COMMENT '사용자 성별',
  `age` INT NULL COMMENT '사용자 나이',
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  UNIQUE INDEX `sns_id_UNIQUE` (`sns_id` ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = 'Memories 서비스 사용자 테이블';


-- -----------------------------------------------------
-- Table `memories`.`memory_test`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `memories`.`memory_test` (
  `user_id` VARCHAR(20) NOT NULL COMMENT '검사를 수행한 사용자의 아이디',
  `sequence` INT NOT NULL COMMENT '사용자별 검사 순번',
  `measurement_time` INT NOT NULL COMMENT '측정된 시간 (검사 결과)',
  `test_date` VARCHAR(16) NOT NULL COMMENT '검사한 날짜',
  `gap` INT NULL COMMENT '직전 순번의 측정된 시간 - 현재 순번의 측정된 시간',
  PRIMARY KEY (`user_id`, `sequence`),
  CONSTRAINT `memory_test_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `memories`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '기억력 검사 기록 테이블';


-- -----------------------------------------------------
-- Table `memories`.`concentration_test`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `memories`.`concentration_test` (
  `user_id` VARCHAR(20) NOT NULL COMMENT '검사를 수행한 사용자 아이디',
  `sequence` INT NOT NULL COMMENT '사용자별 검사 순번',
  `measurement_score` INT NOT NULL COMMENT '측정 성공 점수',
  `error_count` INT NOT NULL COMMENT '측정 오류 횟수',
  `test_date` VARCHAR(16) NOT NULL COMMENT '검사 날짜',
  `score_gap` INT NULL COMMENT '직전 순번의 측정된 점수 - 현재 순번의 측정된 점수',
  `error_gap` INT NULL COMMENT '직전 순번의 측정된 오류 횟수 - 현재 순번의 측정된 오류 횟수',
  PRIMARY KEY (`user_id`, `sequence`),
  CONSTRAINT `concentration_test_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `memories`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '집중력 검사 기록 테이블';


-- -----------------------------------------------------
-- Table `memories`.`diary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `memories`.`diary` (
  `diary_number` INT NOT NULL AUTO_INCREMENT COMMENT '일기 관리 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '일기 작성자 아이디',
  `write_date` VARCHAR(10) NOT NULL COMMENT '일기 작성 날짜 (YYYY-MM-DD)',
  `weather` VARCHAR(10) NOT NULL COMMENT '당일 날씨 (맑음, 흐림, 비, 눈, 안개)',
  `feeling` VARCHAR(10) NOT NULL COMMENT '당일 기분 (행복, 즐거움, 보통, 슬픔, 분노)',
  `title` TEXT NOT NULL COMMENT '일기 제목',
  `content` TEXT NOT NULL COMMENT '일기 내용 (HTML 형식)',
  PRIMARY KEY (`diary_number`),
  UNIQUE INDEX `diary_number_UNIQUE` (`diary_number` ASC) VISIBLE,
  INDEX `diary_write_user_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `diary_write_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `memories`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '일기 테이블';

CREATE USER 'memories' IDENTIFIED BY 'qwer1234';

GRANT ALL ON `memories`.* TO 'memories';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
