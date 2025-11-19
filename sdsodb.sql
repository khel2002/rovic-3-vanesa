-- -------------------------------------------------------------
-- TablePlus 6.3.2(586)
--
-- https://tableplus.com/
--
-- Database: sdsodb
-- Generation Time: 2025-11-20 02:02:42.1720
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents` (
  `document_id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `document_type` enum('permit','report','proposal') NOT NULL,
  `document_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`document_id`),
  KEY `event_id` (`event_id`),
  CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `event_approval_flow`;
CREATE TABLE `event_approval_flow` (
  `approval_id` int NOT NULL AUTO_INCREMENT,
  `permit_id` int NOT NULL,
  `approver_role` enum('Faculty_Adviser','BARGO','SDSO_Head','SAS_Director','VP_SAS') COLLATE utf8mb4_unicode_ci NOT NULL,
  `approver_id` int DEFAULT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `comments` text COLLATE utf8mb4_unicode_ci,
  `signature_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`approval_id`),
  KEY `fk_event_approval_permit` (`permit_id`),
  KEY `fk_event_approval_user` (`approver_id`),
  CONSTRAINT `fk_event_approval_permit` FOREIGN KEY (`permit_id`) REFERENCES `permits` (`permit_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_event_approval_user` FOREIGN KEY (`approver_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `event_approvals`;
CREATE TABLE `event_approvals` (
  `approval_id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `approver_role` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `approver_id` int DEFAULT NULL,
  `role` enum('Student_Organization','Faculty_Adviser','BARGO','SDSO_Head','SAS_Director','VP_SAS') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `comments` text COLLATE utf8mb4_unicode_ci,
  `signature_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`approval_id`),
  KEY `event_id` (`event_id`),
  KEY `event_approvals_user_fk` (`approver_id`),
  CONSTRAINT `event_approvals_event_fk` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE,
  CONSTRAINT `event_approvals_user_fk` FOREIGN KEY (`approver_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `event_comments`;
CREATE TABLE `event_comments` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `user_id` int NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `event_id` (`event_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `event_comments_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE,
  CONSTRAINT `event_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `event_submission_logs`;
CREATE TABLE `event_submission_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `submission_type` enum('permit','proposal','report') NOT NULL,
  `submission_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('submitted','approved','rejected') DEFAULT 'submitted',
  `submitted_by` int NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `event_id` (`event_id`),
  KEY `submitted_by` (`submitted_by`),
  CONSTRAINT `event_submission_logs_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`),
  CONSTRAINT `event_submission_logs_ibfk_2` FOREIGN KEY (`submitted_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `event_title` varchar(255) NOT NULL,
  `event_date` date DEFAULT NULL,
  `proposal_status` enum('pending','approved','rejected') DEFAULT 'pending',
  `current_stage` enum('Student_Organization','Faculty_Adviser','BARGO','SDSO_Head','SAS_Director','VP_SAS','completed') DEFAULT 'Student_Organization',
  `event_report_submitted` tinyint(1) DEFAULT '0',
  `event_permit_submitted` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`event_id`),
  KEY `organization_id` (`organization_id`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `members`;
CREATE TABLE `members` (
  `member_id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `member_name` varchar(255) NOT NULL,
  `contact_email` varchar(255) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `membership_status` varchar(50) DEFAULT 'active',
  `joined_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`member_id`),
  KEY `idx_organization_id` (`organization_id`),
  CONSTRAINT `members_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`organization_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `message` text,
  `notification_type` enum('event_approval','proposal_review','event_report') NOT NULL,
  `status` enum('read','unread') DEFAULT 'unread',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `officers`;
CREATE TABLE `officers` (
  `officer_id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `role` varchar(100) NOT NULL,
  `officer_name` varchar(255) NOT NULL,
  `contact_email` varchar(255) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `member_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`officer_id`),
  UNIQUE KEY `unique_role_per_org` (`organization_id`,`role`),
  KEY `idx_organization_id` (`organization_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_member_id` (`member_id`),
  CONSTRAINT `officers_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`organization_id`) ON DELETE CASCADE,
  CONSTRAINT `officers_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `officers_ibfk_3` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `organizations`;
CREATE TABLE `organizations` (
  `organization_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `organization_name` varchar(255) NOT NULL,
  `organization_type` varchar(100) DEFAULT NULL,
  `adviser_id` int DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `description` int DEFAULT NULL,
  `adviser_name` varchar(255) DEFAULT NULL,
  `contact_email` varchar(255) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `profile_id` int NOT NULL,
  PRIMARY KEY (`organization_id`),
  KEY `user_id_idx` (`user_id`),
  KEY `fk_organizations_adviser` (`adviser_id`),
  KEY `fk_organizations_user_profiles1_idx` (`profile_id`),
  CONSTRAINT `fk_organizations_adviser` FOREIGN KEY (`adviser_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_organizations_user_profiles1` FOREIGN KEY (`profile_id`) REFERENCES `user_profiles` (`profile_id`),
  CONSTRAINT `organizations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `permits`;
CREATE TABLE `permits` (
  `permit_id` int NOT NULL AUTO_INCREMENT,
  `hashed_id` varchar(255) DEFAULT NULL,
  `organization_id` int NOT NULL,
  `title_activity` varchar(255) NOT NULL,
  `purpose` text,
  `type` enum('In-Campus','Off-Campus') DEFAULT NULL,
  `nature` varchar(255) DEFAULT NULL,
  `venue` varchar(255) DEFAULT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `time_start` time DEFAULT NULL,
  `time_end` time DEFAULT NULL,
  `participants` varchar(255) DEFAULT NULL,
  `number` int DEFAULT NULL,
  `signature_data` longtext,
  `pdf_data` longblob,
  `signature_upload` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`permit_id`),
  UNIQUE KEY `hashed_id` (`hashed_id`),
  KEY `organization_id_idx` (`organization_id`),
  CONSTRAINT `fk_permits_organization` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`organization_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `permits_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`organization_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `proposals`;
CREATE TABLE `proposals` (
  `proposal_id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `description` text,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `review_comments` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`proposal_id`),
  KEY `event_id` (`event_id`),
  CONSTRAINT `proposals_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `signatures`;
CREATE TABLE `signatures` (
  `signature_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `signature_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`signature_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `signatures_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `user_logs`;
CREATE TABLE `user_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `user_profiles`;
CREATE TABLE `user_profiles` (
  `profile_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `sex` enum('Male','Female') DEFAULT NULL,
  `type` enum('student','employee') DEFAULT NULL,
  `suffix` enum('JR','SR','I','II','III','IV','V','VI','VII','VIII','IX','X') DEFAULT NULL,
  PRIMARY KEY (`profile_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `account_role` enum('Student_Organization','SDSO_Head','Faculty_Adviser','VP_SAS','SAS_Director','BARGO','admin') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `profile_id` int NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_users_user_profiles1_idx` (`profile_id`),
  CONSTRAINT `fk_users_user_profiles1` FOREIGN KEY (`profile_id`) REFERENCES `user_profiles` (`profile_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `user_logs` (`id`, `user_id`, `action`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(213, 1, 'Logged in', '127.0.0.1', NULL, '2025-11-19 21:21:40', '2025-11-19 21:21:40');

INSERT INTO `user_profiles` (`profile_id`, `first_name`, `middle_name`, `last_name`, `email`, `contact_number`, `address`, `created_at`, `updated_at`, `sex`, `type`, `suffix`) VALUES
(1, 'Jun Michael', 'Melendres', 'Roa', 'michaelroa121@gmail.com', '098765432', 'Ichon Macrohon Southern Leyte', '2025-11-19 20:27:22', '2025-11-19 20:27:22', 'Male', 'employee', 'III'),
(2, 'Jun Michael', 'Melendres', 'Roa', 'michaelroa121@gmail.com', '098765432', 'ichon', '2025-11-19 21:15:12', '2025-11-19 21:15:12', 'Male', 'employee', 'SR');

INSERT INTO `users` (`user_id`, `username`, `password`, `account_role`, `created_at`, `updated_at`, `profile_id`) VALUES
(1, 'admin', '$2y$10$Tbdzm93Nr1VATMYp1HGDG.XiZJCiol/.tA4HFqEnft8j9wX1ch2Hy', 'admin', '2025-11-19 20:28:22', '2025-11-19 21:21:21', 1);



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;