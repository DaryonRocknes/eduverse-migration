-- ====================================================================
-- SCHEMA EDUVERSE POUR MYSQL / MARIADB - CORRIGE LE 13/10/2026
-- Base : dump phpMyAdmin du 02/06/2026 (MariaDB 10.4), complete par :
--   1. AUTO_INCREMENT sur 57 cles primaires supplementaires (toutes les
--      cles mono-colonne entieres qui etaient des SERIAL / sequences dans
--      PostgreSQL). Exclues car non-compteurs dans RosarioSIS :
--      food_service_accounts, food_service_staff_accounts,
--      food_service_student_accounts, history_marking_periods.
--      Meme regle que school/migration_auto_increment_mysql.sql.
--   2. updated_at ... ON UPDATE current_timestamp() sur 98 colonnes
--      (remplace le declencheur PostgreSQL set_updated_at).
--   3. 14 colonnes de moyennes / credits en decimal(22,16) comme dans
--      RosarioSIS amont (elles etaient en decimal(10,0) : arrondi a l'entier).
--   4. Partie 2 (apres "@@EDUVERSE-APRES-IMPORT@@") : vues, fonctions,
--      procedures et declencheurs.
--   5. Partie 3 (apres "@@EDUVERSE-CLES-ETRANGERES@@") : cles etrangeres.
-- SET SQL_MODE = NO_AUTO_VALUE_ON_ZERO est indispensable : user_profiles
-- et address contiennent un id 0 qui ne doit pas etre renumerote.
-- ====================================================================

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : mar. 02 juin 2026 à 16:47
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `eduverse`
--

-- --------------------------------------------------------

--
-- Structure de la table `access_log`
--

CREATE TABLE `access_log` (
  `syear` decimal(4,0) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `profile` varchar(30) DEFAULT NULL,
  `login_time` datetime DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `user_agent` longtext DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `accounting_categories`
--

CREATE TABLE `accounting_categories` (
  `id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `accounting_incomes`
--

CREATE TABLE `accounting_incomes` (
  `assigned_date` date DEFAULT NULL,
  `comments` longtext DEFAULT NULL,
  `id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `amount` decimal(14,2) NOT NULL,
  `file_attached` longtext DEFAULT NULL,
  `school_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `accounting_payments`
--

CREATE TABLE `accounting_payments` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `title` longtext DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `amount` decimal(14,2) NOT NULL,
  `payment_date` date DEFAULT NULL,
  `comments` longtext DEFAULT NULL,
  `file_attached` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `accounting_salaries`
--

CREATE TABLE `accounting_salaries` (
  `staff_id` int(11) NOT NULL,
  `assigned_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `comments` longtext DEFAULT NULL,
  `id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `amount` decimal(14,2) NOT NULL,
  `file_attached` longtext DEFAULT NULL,
  `school_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `address`
--

CREATE TABLE `address` (
  `address_id` int(11) NOT NULL,
  `house_no` decimal(5,0) DEFAULT NULL,
  `direction` varchar(2) DEFAULT NULL,
  `street` varchar(30) DEFAULT NULL,
  `apt` varchar(5) DEFAULT NULL,
  `zipcode` varchar(10) DEFAULT NULL,
  `city` longtext DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `mail_street` varchar(30) DEFAULT NULL,
  `mail_city` longtext DEFAULT NULL,
  `mail_state` varchar(50) DEFAULT NULL,
  `mail_zipcode` varchar(10) DEFAULT NULL,
  `address` longtext DEFAULT NULL,
  `mail_address` longtext DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `address_fields`
--

CREATE TABLE `address_fields` (
  `id` int(11) NOT NULL,
  `type` varchar(10) NOT NULL,
  `title` longtext NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `select_options` longtext DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `required` varchar(1) DEFAULT NULL,
  `default_selection` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `address_field_categories`
--

CREATE TABLE `address_field_categories` (
  `id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `residence` char(1) DEFAULT NULL,
  `mailing` char(1) DEFAULT NULL,
  `bus` char(1) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `attendance_calendar`
--

CREATE TABLE `attendance_calendar` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `school_date` date NOT NULL,
  `minutes` int(11) DEFAULT NULL,
  `block` varchar(10) DEFAULT NULL,
  `calendar_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `attendance_calendars`
--

CREATE TABLE `attendance_calendars` (
  `school_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `calendar_id` int(11) NOT NULL,
  `default_calendar` varchar(1) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `attendance_codes`
--

CREATE TABLE `attendance_codes` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `state_code` varchar(1) DEFAULT NULL,
  `default_code` varchar(1) DEFAULT NULL,
  `table_name` int(11) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `attendance_code_categories`
--

CREATE TABLE `attendance_code_categories` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `attendance_completed`
--

CREATE TABLE `attendance_completed` (
  `staff_id` int(11) NOT NULL,
  `school_date` date NOT NULL,
  `period_id` int(11) NOT NULL,
  `table_name` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `attendance_day`
--

CREATE TABLE `attendance_day` (
  `student_id` int(11) NOT NULL,
  `school_date` date NOT NULL,
  `minutes_present` int(11) DEFAULT NULL,
  `state_value` decimal(2,1) DEFAULT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `comment` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `attendance_period`
--

CREATE TABLE `attendance_period` (
  `student_id` int(11) NOT NULL,
  `school_date` date NOT NULL,
  `period_id` int(11) DEFAULT NULL,
  `attendance_code` int(11) DEFAULT NULL,
  `attendance_teacher_code` int(11) DEFAULT NULL,
  `attendance_reason` varchar(100) DEFAULT NULL,
  `admin` varchar(1) DEFAULT NULL,
  `course_period_id` int(11) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `comment` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `my_period_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `billing_fees`
--

CREATE TABLE `billing_fees` (
  `student_id` int(11) NOT NULL,
  `assigned_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `comments` longtext DEFAULT NULL,
  `id` int(11) NOT NULL,
  `title` longtext DEFAULT NULL,
  `amount` decimal(14,2) NOT NULL,
  `file_attached` longtext DEFAULT NULL,
  `school_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `waived_fee_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `month` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `billing_payments`
--

CREATE TABLE `billing_payments` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `amount` decimal(14,2) NOT NULL,
  `payment_date` date DEFAULT NULL,
  `comments` longtext DEFAULT NULL,
  `refunded_payment_id` int(11) DEFAULT NULL,
  `lunch_payment` varchar(1) DEFAULT NULL,
  `file_attached` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `month` varchar(5) DEFAULT NULL,
  `intitule_caissier` varchar(255) DEFAULT NULL,
  `imprimer` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `bordereaux_details`
--

CREATE TABLE `bordereaux_details` (
  `id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `autres_cycles` decimal(10,2) DEFAULT 0.00,
  `indemnites_responsabilite` decimal(10,2) DEFAULT 0.00,
  `prime_transport` decimal(10,2) DEFAULT 0.00,
  `prime_salissure` decimal(10,2) DEFAULT 0.00,
  `prime_encouragement` decimal(10,2) DEFAULT 0.00,
  `prime_anciennete` decimal(10,2) DEFAULT 0.00,
  `enfant_charge` decimal(10,2) DEFAULT 0.00,
  `assurances` decimal(10,2) DEFAULT 0.00,
  `autres` decimal(10,2) DEFAULT 0.00,
  `acomptes` decimal(10,2) DEFAULT 0.00,
  `cnss_employeur` decimal(10,2) DEFAULT 0.00,
  `cnss_employe` decimal(10,2) DEFAULT 0.00,
  `irpp_employe` decimal(10,2) DEFAULT 0.00,
  `net_payer` decimal(10,2) DEFAULT 0.00,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `calendar_events`
--

CREATE TABLE `calendar_events` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `school_date` date DEFAULT NULL,
  `title` varchar(50) NOT NULL,
  `description` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `config`
--

CREATE TABLE `config` (
  `school_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `config_value` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `courses`
--

CREATE TABLE `courses` (
  `syear` decimal(4,0) NOT NULL,
  `course_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `grade_level` int(11) DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `short_name` varchar(25) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `credit_hours` decimal(6,2) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `course_periods`
--

CREATE TABLE `course_periods` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `course_period_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `title` longtext DEFAULT NULL,
  `short_name` varchar(25) NOT NULL,
  `mp` varchar(3) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  `secondary_teacher_id` int(11) DEFAULT NULL,
  `room` varchar(10) DEFAULT NULL,
  `total_seats` decimal(10,0) DEFAULT NULL,
  `filled_seats` decimal(10,0) DEFAULT NULL,
  `does_attendance` longtext DEFAULT NULL,
  `does_honor_roll` varchar(1) DEFAULT NULL,
  `does_class_rank` varchar(1) DEFAULT NULL,
  `gender_restriction` varchar(1) DEFAULT NULL,
  `house_restriction` varchar(1) DEFAULT NULL,
  `availability` decimal(10,0) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `calendar_id` int(11) DEFAULT NULL,
  `half_day` varchar(1) DEFAULT NULL,
  `does_breakoff` varchar(1) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `grade_scale_id` int(11) DEFAULT NULL,
  `credits` decimal(6,2) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `echelle_notation` int(11) DEFAULT NULL,
  `semester_type` varchar(20) DEFAULT 'pair',
  `frais_classe` decimal(10,2) DEFAULT NULL,
  `total_mentant` int(11) DEFAULT NULL,
  `frais_classe_plein_temps` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `course_period_school_periods`
--

CREATE TABLE `course_period_school_periods` (
  `course_period_school_periods_id` int(11) NOT NULL,
  `course_period_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `days` varchar(7) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `course_subjects`
--

CREATE TABLE `course_subjects` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `short_name` varchar(25) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `custom_fields`
--

CREATE TABLE `custom_fields` (
  `id` int(11) NOT NULL,
  `type` varchar(10) NOT NULL,
  `title` longtext NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `select_options` longtext DEFAULT NULL,
  `CATEGORY_ID` varchar(255) DEFAULT NULL,
  `required` varchar(1) DEFAULT NULL,
  `default_selection` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Structure de la table `discipline_fields`
--

CREATE TABLE `discipline_fields` (
  `id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `short_name` varchar(20) DEFAULT NULL,
  `data_type` varchar(30) NOT NULL,
  `column_name` longtext NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `discipline_field_usage`
--

CREATE TABLE `discipline_field_usage` (
  `id` int(11) NOT NULL,
  `discipline_field_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `select_options` longtext DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `discipline_referrals`
--

CREATE TABLE `discipline_referrals` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `student_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `entry_date` date DEFAULT NULL,
  `referral_date` date DEFAULT NULL,
  `category_1` longtext DEFAULT NULL,
  `category_2` longtext DEFAULT NULL,
  `category_3` varchar(1) DEFAULT NULL,
  `category_4` longtext DEFAULT NULL,
  `category_5` longtext DEFAULT NULL,
  `category_6` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `category_7` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `eligibility`
--

CREATE TABLE `eligibility` (
  `student_id` int(11) NOT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_date` date DEFAULT NULL,
  `period_id` int(11) DEFAULT NULL,
  `eligibility_code` varchar(20) DEFAULT NULL,
  `course_period_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `eligibility_activities`
--

CREATE TABLE `eligibility_activities` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `comment` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `eligibility_completed`
--

CREATE TABLE `eligibility_completed` (
  `staff_id` int(11) NOT NULL,
  `school_date` date NOT NULL,
  `period_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_accounts`
--

CREATE TABLE `food_service_accounts` (
  `account_id` int(11) NOT NULL,
  `balance` decimal(9,2) NOT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_categories`
--

CREATE TABLE `food_service_categories` (
  `category_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `title` varchar(25) NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_items`
--

CREATE TABLE `food_service_items` (
  `item_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `short_name` varchar(25) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `description` varchar(25) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `price` decimal(9,2) NOT NULL,
  `price_reduced` decimal(9,2) DEFAULT NULL,
  `price_free` decimal(9,2) DEFAULT NULL,
  `price_staff` decimal(9,2) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_menus`
--

CREATE TABLE `food_service_menus` (
  `menu_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` varchar(25) NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_menu_items`
--

CREATE TABLE `food_service_menu_items` (
  `menu_item_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `does_count` varchar(1) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_staff_accounts`
--

CREATE TABLE `food_service_staff_accounts` (
  `staff_id` int(11) NOT NULL,
  `status` varchar(25) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `balance` decimal(9,2) NOT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_staff_transactions`
--

CREATE TABLE `food_service_staff_transactions` (
  `transaction_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `balance` decimal(9,2) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `short_name` varchar(25) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `seller_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_staff_transaction_items`
--

CREATE TABLE `food_service_staff_transaction_items` (
  `item_id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `amount` decimal(9,2) DEFAULT NULL,
  `short_name` varchar(25) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_student_accounts`
--

CREATE TABLE `food_service_student_accounts` (
  `student_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `discount` varchar(25) DEFAULT NULL,
  `status` varchar(25) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_transactions`
--

CREATE TABLE `food_service_transactions` (
  `transaction_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  `school_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `discount` varchar(25) DEFAULT NULL,
  `balance` decimal(9,2) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `short_name` varchar(25) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `seller_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `food_service_transaction_items`
--

CREATE TABLE `food_service_transaction_items` (
  `item_id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `amount` decimal(9,2) DEFAULT NULL,
  `discount` varchar(25) DEFAULT NULL,
  `short_name` varchar(25) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gradebook_assignments`
--

CREATE TABLE `gradebook_assignments` (
  `assignment_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `marking_period_id` int(11) NOT NULL,
  `course_period_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `assignment_type_id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `assigned_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `points` int(11) NOT NULL,
  `description` longtext DEFAULT NULL,
  `file` longtext DEFAULT NULL,
  `default_points` int(11) DEFAULT NULL,
  `submission` varchar(1) DEFAULT NULL,
  `weight` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gradebook_assignment_types`
--

CREATE TABLE `gradebook_assignment_types` (
  `assignment_type_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `final_grade_percent` decimal(6,5) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `created_mp` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gradebook_grades`
--

CREATE TABLE `gradebook_grades` (
  `student_id` int(11) NOT NULL,
  `period_id` int(11) DEFAULT NULL,
  `course_period_id` int(11) NOT NULL,
  `assignment_id` int(11) NOT NULL,
  `points` decimal(6,2) DEFAULT NULL,
  `comment` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `grades_completed`
--

CREATE TABLE `grades_completed` (
  `staff_id` int(11) NOT NULL,
  `marking_period_id` int(11) NOT NULL,
  `course_period_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `grade_levels`
--

CREATE TABLE `grade_levels` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `sort_order` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `history_marking_periods`
--

CREATE TABLE `history_marking_periods` (
  `parent_id` int(11) DEFAULT NULL,
  `mp_type` varchar(20) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `post_end_date` date DEFAULT NULL,
  `school_id` int(11) NOT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `marking_period_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `lunch_period`
--

CREATE TABLE `lunch_period` (
  `student_id` int(11) NOT NULL,
  `school_date` date NOT NULL,
  `period_id` int(11) NOT NULL,
  `attendance_code` int(11) DEFAULT NULL,
  `attendance_teacher_code` int(11) DEFAULT NULL,
  `attendance_reason` varchar(100) DEFAULT NULL,
  `admin` varchar(1) DEFAULT NULL,
  `course_period_id` int(11) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `comment` varchar(100) DEFAULT NULL,
  `table_name` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `from` varchar(255) DEFAULT NULL,
  `recipients` longtext DEFAULT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `messagexuser`
--

CREATE TABLE `messagexuser` (
  `user_id` int(11) NOT NULL,
  `key` varchar(10) DEFAULT NULL,
  `message_id` int(11) NOT NULL,
  `status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `moodlexrosario`
--

CREATE TABLE `moodlexrosario` (
  `column` varchar(100) NOT NULL,
  `rosario_id` int(11) NOT NULL,
  `moodle_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `people`
--

CREATE TABLE `people` (
  `person_id` int(11) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `people_fields`
--

CREATE TABLE `people_fields` (
  `id` int(11) NOT NULL,
  `type` varchar(10) DEFAULT NULL,
  `title` longtext NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `select_options` longtext DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `required` varchar(1) DEFAULT NULL,
  `default_selection` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `people_field_categories`
--

CREATE TABLE `people_field_categories` (
  `id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `custody` char(1) DEFAULT NULL,
  `emergency` char(1) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `people_join_contacts`
--

CREATE TABLE `people_join_contacts` (
  `id` int(11) NOT NULL,
  `person_id` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `value` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `portal_notes`
--

CREATE TABLE `portal_notes` (
  `id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `title` longtext NOT NULL,
  `content` longtext DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `published_user` int(11) DEFAULT NULL,
  `published_date` datetime DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `published_profiles` longtext DEFAULT NULL,
  `file_attached` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `portal_polls`
--

CREATE TABLE `portal_polls` (
  `id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `title` longtext NOT NULL,
  `votes_number` int(11) DEFAULT NULL,
  `display_votes` varchar(1) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `published_user` int(11) DEFAULT NULL,
  `published_date` datetime DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `published_profiles` longtext DEFAULT NULL,
  `students_teacher_id` int(11) DEFAULT NULL,
  `excluded_users` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `portal_poll_questions`
--

CREATE TABLE `portal_poll_questions` (
  `id` int(11) NOT NULL,
  `portal_poll_id` int(11) NOT NULL,
  `question` longtext NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `options` longtext DEFAULT NULL,
  `votes` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `profile_exceptions`
--

CREATE TABLE `profile_exceptions` (
  `profile_id` int(11) NOT NULL,
  `MODNAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `can_use` varchar(1) DEFAULT NULL,
  `can_edit` varchar(1) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `program_config`
--

CREATE TABLE `program_config` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `program` varchar(100) NOT NULL,
  `title` varchar(100) NOT NULL,
  `value` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `program_user_config`
--

CREATE TABLE `program_user_config` (
  `user_id` int(11) NOT NULL,
  `program` varchar(100) NOT NULL,
  `TITLE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `value` longtext DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `report_card_comments`
--

CREATE TABLE `report_card_comments` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `scale_id` int(11) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `title` longtext NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `report_card_comment_categories`
--

CREATE TABLE `report_card_comment_categories` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `title` longtext NOT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `report_card_comment_codes`
--

CREATE TABLE `report_card_comment_codes` (
  `id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `scale_id` int(11) NOT NULL,
  `title` varchar(5) NOT NULL,
  `short_name` varchar(100) DEFAULT NULL,
  `comment` varchar(100) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `report_card_comment_code_scales`
--

CREATE TABLE `report_card_comment_code_scales` (
  `id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` varchar(25) NOT NULL,
  `comment` varchar(100) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `report_card_grades`
--

CREATE TABLE `report_card_grades` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` varchar(5) NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `gpa_value` decimal(7,2) DEFAULT NULL,
  `break_off` decimal(7,2) DEFAULT NULL,
  `comment` longtext DEFAULT NULL,
  `grade_scale_id` int(11) DEFAULT NULL,
  `unweighted_gp` decimal(7,2) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `report_card_grade_scales`
--

CREATE TABLE `report_card_grade_scales` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `comment` longtext DEFAULT NULL,
  `hhr_gpa_value` decimal(7,2) DEFAULT NULL,
  `hr_gpa_value` decimal(7,2) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `gp_scale` decimal(7,2) NOT NULL,
  `gp_passing_value` decimal(7,2) DEFAULT NULL,
  `hrs_gpa_value` decimal(7,2) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `resources`
--

CREATE TABLE `resources` (
  `id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `link` longtext DEFAULT NULL,
  `published_profiles` longtext DEFAULT NULL,
  `published_grade_levels` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `schedule`
--

CREATE TABLE `schedule` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `modified_date` date DEFAULT NULL,
  `modified_by` varchar(255) DEFAULT NULL,
  `course_id` int(11) NOT NULL,
  `course_period_id` int(11) NOT NULL,
  `mp` varchar(3) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `scheduler_lock` varchar(1) DEFAULT NULL,
  `id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `schedule_requests`
--

CREATE TABLE `schedule_requests` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `with_teacher_id` int(11) DEFAULT NULL,
  `not_teacher_id` int(11) DEFAULT NULL,
  `with_period_id` int(11) DEFAULT NULL,
  `not_period_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `schools`
--

CREATE TABLE `schools` (
  `syear` decimal(4,0) NOT NULL,
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `zipcode` varchar(10) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `principal` varchar(100) DEFAULT NULL,
  `www_address` longtext DEFAULT NULL,
  `school_number` varchar(50) DEFAULT NULL,
  `short_name` varchar(25) DEFAULT NULL,
  `reporting_gp_scale` decimal(10,3) DEFAULT NULL,
  `number_days_rotation` decimal(1,0) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `custom_1` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `school_fields`
--

CREATE TABLE `school_fields` (
  `id` int(11) NOT NULL,
  `type` varchar(10) NOT NULL,
  `title` longtext NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `select_options` longtext DEFAULT NULL,
  `required` varchar(1) DEFAULT NULL,
  `default_selection` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `school_gradelevels`
--

CREATE TABLE `school_gradelevels` (
  `id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `short_name` varchar(3) DEFAULT NULL,
  `title` varchar(50) NOT NULL,
  `next_grade_id` int(11) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `marking_period_type` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `school_marking_periods`
--

CREATE TABLE `school_marking_periods` (
  `marking_period_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `mp` varchar(3) NOT NULL,
  `school_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `title` varchar(50) NOT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `post_start_date` date DEFAULT NULL,
  `post_end_date` date DEFAULT NULL,
  `does_grades` varchar(1) DEFAULT NULL,
  `does_comments` varchar(1) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `school_periods`
--

CREATE TABLE `school_periods` (
  `period_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `length` int(11) DEFAULT NULL,
  `start_time` varchar(10) DEFAULT NULL,
  `end_time` varchar(10) DEFAULT NULL,
  `block` varchar(10) DEFAULT NULL,
  `attendance` varchar(1) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `staff`
--

CREATE TABLE `staff` (
  `syear` decimal(4,0) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `current_school_id` int(11) DEFAULT NULL,
  `title` varchar(5) DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `name_suffix` varchar(3) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(106) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `custom_200000001` longtext DEFAULT NULL,
  `profile` varchar(30) DEFAULT NULL,
  `homeroom` varchar(5) DEFAULT NULL,
  `schools` varchar(150) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `failed_login` int(11) DEFAULT NULL,
  `profile_id` int(11) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `custom_200000002` varchar(1) DEFAULT NULL,
  `custom_200000003` longtext DEFAULT NULL,
  `custom_200000004` longtext DEFAULT NULL,
  `custom_200000005` date DEFAULT NULL,
  `a_salaire_fixe` char(1) DEFAULT NULL,
  `salaire_fixe` decimal(12,2) DEFAULT NULL,
  `date_debut_contrat` date DEFAULT NULL,
  `date_fin_contrat` date DEFAULT NULL,
  `parent_type` varchar(100) DEFAULT NULL,
  `ADDRESS` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `staff_exceptions`
--

CREATE TABLE `staff_exceptions` (
  `user_id` int(11) NOT NULL,
  `modname` varchar(150) NOT NULL,
  `can_use` varchar(1) DEFAULT NULL,
  `can_edit` varchar(1) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `staff_fields`
--

CREATE TABLE `staff_fields` (
  `id` int(11) NOT NULL,
  `type` varchar(10) NOT NULL,
  `title` longtext NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `select_options` longtext DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `required` varchar(1) DEFAULT NULL,
  `default_selection` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `staff_field_categories`
--

CREATE TABLE `staff_field_categories` (
  `id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `columns` decimal(4,0) DEFAULT NULL,
  `include` varchar(100) DEFAULT NULL,
  `admin` char(1) DEFAULT NULL,
  `teacher` char(1) DEFAULT NULL,
  `parent` char(1) DEFAULT NULL,
  `none` char(1) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `name_suffix` varchar(3) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(106) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `failed_login` int(11) DEFAULT NULL,
  `custom_200000000` longtext DEFAULT NULL,
  `custom_200000001` longtext DEFAULT NULL,
  `custom_200000002` longtext DEFAULT NULL,
  `custom_200000003` longtext DEFAULT NULL,
  `custom_200000004` date DEFAULT NULL,
  `custom_200000005` longtext DEFAULT NULL,
  `custom_200000006` longtext DEFAULT NULL,
  `custom_200000007` longtext DEFAULT NULL,
  `custom_200000008` longtext DEFAULT NULL,
  `custom_200000009` longtext DEFAULT NULL,
  `custom_200000010` char(1) DEFAULT NULL,
  `custom_200000011` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `frais_inscriptions` decimal(10,2) DEFAULT NULL,
  `reinscription` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `students_join_address`
--

CREATE TABLE `students_join_address` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `address_id` int(11) NOT NULL,
  `contact_seq` decimal(10,0) DEFAULT NULL,
  `gets_mail` varchar(1) DEFAULT NULL,
  `primary_residence` varchar(1) DEFAULT NULL,
  `legal_residence` varchar(1) DEFAULT NULL,
  `am_bus` varchar(1) DEFAULT NULL,
  `pm_bus` varchar(1) DEFAULT NULL,
  `mailing` varchar(1) DEFAULT NULL,
  `residence` varchar(1) DEFAULT NULL,
  `bus` varchar(1) DEFAULT NULL,
  `bus_pickup` varchar(1) DEFAULT NULL,
  `bus_dropoff` varchar(1) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `students_join_people`
--

CREATE TABLE `students_join_people` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `address_id` int(11) DEFAULT NULL,
  `custody` varchar(1) DEFAULT NULL,
  `emergency` varchar(1) DEFAULT NULL,
  `student_relation` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `students_join_users`
--

CREATE TABLE `students_join_users` (
  `student_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_assignments`
--

CREATE TABLE `student_assignments` (
  `assignment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `data` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_eligibility_activities`
--

CREATE TABLE `student_eligibility_activities` (
  `syear` decimal(4,0) DEFAULT NULL,
  `student_id` int(11) NOT NULL,
  `activity_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_enrollment`
--

CREATE TABLE `student_enrollment` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `grade_id` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `enrollment_code` int(11) DEFAULT NULL,
  `drop_code` int(11) DEFAULT NULL,
  `next_school` int(11) DEFAULT NULL,
  `calendar_id` int(11) DEFAULT NULL,
  `last_school` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `second_course_period_id` int(11) DEFAULT NULL,
  `semester` varchar(10) DEFAULT NULL,
  `second_semester` varchar(10) DEFAULT NULL,
  `course_period_id` int(11) DEFAULT NULL,
  `second_grade_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_enrollment_codes`
--

CREATE TABLE `student_enrollment_codes` (
  `id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `title` varchar(100) NOT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `type` varchar(4) DEFAULT NULL,
  `default_code` varchar(1) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_enrollment_course_periods`
--

CREATE TABLE `student_enrollment_course_periods` (
  `id` int(11) NOT NULL,
  `student_enrollment_id` int(11) NOT NULL,
  `course_period_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_field_categories`
--

CREATE TABLE `student_field_categories` (
  `id` int(11) NOT NULL,
  `title` longtext NOT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `columns` decimal(4,0) DEFAULT NULL,
  `include` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_medical`
--

CREATE TABLE `student_medical` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `type` varchar(25) DEFAULT NULL,
  `medical_date` date DEFAULT NULL,
  `comments` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_medical_alerts`
--

CREATE TABLE `student_medical_alerts` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_medical_visits`
--

CREATE TABLE `student_medical_visits` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `school_date` date DEFAULT NULL,
  `time_in` varchar(20) DEFAULT NULL,
  `time_out` varchar(20) DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  `result` varchar(100) DEFAULT NULL,
  `comments` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_mp_comments`
--

CREATE TABLE `student_mp_comments` (
  `student_id` int(11) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `marking_period_id` int(11) NOT NULL,
  `comment` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_mp_stats`
--

CREATE TABLE `student_mp_stats` (
  `student_id` int(11) NOT NULL,
  `marking_period_id` int(11) NOT NULL,
  `cum_weighted_factor` decimal(22,16) DEFAULT NULL,
  `cum_unweighted_factor` decimal(22,16) DEFAULT NULL,
  `cum_rank` int(11) DEFAULT NULL,
  `mp_rank` int(11) DEFAULT NULL,
  `class_size` int(11) DEFAULT NULL,
  `sum_weighted_factors` decimal(22,16) DEFAULT NULL,
  `sum_unweighted_factors` decimal(22,16) DEFAULT NULL,
  `count_weighted_factors` int(11) DEFAULT NULL,
  `count_unweighted_factors` int(11) DEFAULT NULL,
  `grade_level_short` varchar(3) DEFAULT NULL,
  `cr_weighted_factors` decimal(22,16) DEFAULT NULL,
  `cr_unweighted_factors` decimal(22,16) DEFAULT NULL,
  `count_cr_factors` int(11) DEFAULT NULL,
  `cum_cr_weighted_factor` decimal(22,16) DEFAULT NULL,
  `cum_cr_unweighted_factor` decimal(22,16) DEFAULT NULL,
  `credit_attempted` decimal(22,16) DEFAULT NULL,
  `credit_earned` decimal(22,16) DEFAULT NULL,
  `gp_credits` decimal(22,16) DEFAULT NULL,
  `cr_credits` decimal(22,16) DEFAULT NULL,
  `comments` varchar(75) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_parent_profiles`
--

CREATE TABLE `student_parent_profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `profil` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_report_card_comments`
--

CREATE TABLE `student_report_card_comments` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `course_period_id` int(11) NOT NULL,
  `report_card_comment_id` int(11) NOT NULL,
  `comment` varchar(5) DEFAULT NULL,
  `marking_period_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_report_card_grades`
--

CREATE TABLE `student_report_card_grades` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `course_period_id` int(11) DEFAULT NULL,
  `report_card_grade_id` int(11) DEFAULT NULL,
  `report_card_comment_id` int(11) DEFAULT NULL,
  `comment` longtext DEFAULT NULL,
  `grade_percent` decimal(4,1) DEFAULT NULL,
  `marking_period_id` int(11) NOT NULL,
  `grade_letter` varchar(5) DEFAULT NULL,
  `weighted_gp` decimal(7,2) DEFAULT NULL,
  `unweighted_gp` decimal(7,2) DEFAULT NULL,
  `gp_scale` decimal(7,2) DEFAULT NULL,
  `credit_attempted` decimal(22,16) DEFAULT NULL,
  `credit_earned` decimal(22,16) DEFAULT NULL,
  `credit_category` varchar(10) DEFAULT NULL,
  `course_title` longtext NOT NULL,
  `id` int(11) NOT NULL,
  `school` longtext DEFAULT NULL,
  `class_rank` varchar(1) DEFAULT NULL,
  `credit_hours` decimal(6,2) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `templates`
--

CREATE TABLE `templates` (
  `modname` varchar(150) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `template` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `id` int(11) NOT NULL,
  `profile` varchar(30) DEFAULT NULL,
  `title` longtext NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_appreciations`
--

CREATE TABLE `wx_appreciations` (
  `id` int(11) NOT NULL,
  `grade_id` int(11) NOT NULL,
  `appreciation` varchar(255) NOT NULL,
  `note_1` varchar(255) DEFAULT NULL,
  `note_2` varchar(255) DEFAULT NULL,
  `echelle_notation` varchar(10) DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `short_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_calcul_moyenne_config`
--

CREATE TABLE `wx_calcul_moyenne_config` (
  `ID` int(11) NOT NULL,
  `SCHOOL_ID` int(11) DEFAULT NULL,
  `Annee_Scolaire` varchar(10) DEFAULT NULL,
  `METHODE` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_config_publication_resultats`
--

CREATE TABLE `wx_config_publication_resultats` (
  `id` int(11) NOT NULL,
  `school_gradelevels_id` int(11) NOT NULL,
  `period` varchar(50) DEFAULT NULL,
  `valeur` int(11) DEFAULT NULL,
  `syear` decimal(4,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_course_periods_gradelevels`
--

CREATE TABLE `wx_course_periods_gradelevels` (
  `wx_course_periods_gradelevels_id` int(11) NOT NULL,
  `course_periods_id` int(11) NOT NULL,
  `school_gradelevels_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_course_periods_subjects`
--

CREATE TABLE `wx_course_periods_subjects` (
  `wx_course_periods_subjects_id` int(11) NOT NULL,
  `course_periods_id` int(11) NOT NULL,
  `course_subjects_id` int(11) NOT NULL,
  `coefficient` varchar(10) NOT NULL DEFAULT '1',
  `teacher_id` int(11) NOT NULL,
  `secondary_teacher_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `ue_id` int(11) DEFAULT NULL,
  `period_position` varchar(255) DEFAULT NULL,
  `taux_horaires` decimal(10,2) DEFAULT NULL,
  `ue_compensation` varchar(10) DEFAULT '0',
  `NOTE_MAX` int(11) DEFAULT 20
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_course_periods_subjects_periods`
--

CREATE TABLE `wx_course_periods_subjects_periods` (
  `wx_course_periods_subjects_periods_id` int(11) NOT NULL,
  `wx_course_periods_subjects_id` int(11) NOT NULL,
  `day` char(1) NOT NULL,
  `start_time` varchar(10) NOT NULL,
  `end_time` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_course_subjects_gradelevels`
--

CREATE TABLE `wx_course_subjects_gradelevels` (
  `wx_course_subjects_gradelevels_id` int(11) NOT NULL,
  `course_subjects_id` int(11) NOT NULL,
  `school_gradelevels_id` int(11) NOT NULL,
  `coefficient` decimal(5,2) DEFAULT 1.00,
  `semester_type` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_custom_configuration_school`
--

CREATE TABLE `wx_custom_configuration_school` (
  `id_custom_configuration_school` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `type_school` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_echelle_notation_appreciation`
--

CREATE TABLE `wx_echelle_notation_appreciation` (
  `id` int(11) NOT NULL,
  `note_debut` double NOT NULL,
  `note_fin` double NOT NULL,
  `echelle_notation` int(11) NOT NULL,
  `appreciation` varchar(5) DEFAULT NULL,
  `year` decimal(4,0) DEFAULT NULL,
  `school_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_families`
--

CREATE TABLE `wx_families` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `school_id` int(11) NOT NULL,
  `syear` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_family_members`
--

CREATE TABLE `wx_family_members` (
  `id` int(11) NOT NULL,
  `family_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `is_representative` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_gradel_period_evaluation`
--

CREATE TABLE `wx_gradel_period_evaluation` (
  `id_gradel_period_evaluation` int(11) NOT NULL,
  `school_gradelevels_id` int(11) NOT NULL,
  `type_period_evaluation` varchar(20) DEFAULT NULL,
  `year` decimal(4,0) NOT NULL,
  `allow_debt_passage` tinyint(1) DEFAULT 0,
  `debt_passage_percentage` decimal(5,2) DEFAULT 0.00,
  `eliminatory_note` decimal(5,2) DEFAULT 0.00,
  `debt_passage_percentage_devoir` decimal(5,2) DEFAULT 0.00,
  `debt_passage_percentage_session` decimal(5,2) DEFAULT 0.00,
  `eliminatory_mark` decimal(5,2) DEFAULT 0.00,
  `is_passage_with_debt` varchar(1) DEFAULT '0',
  `percentage_of_credit_for_passage` decimal(5,2) DEFAULT 0.00,
  `is_compensable` varchar(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_moyennes_finales_students`
--

CREATE TABLE `wx_moyennes_finales_students` (
  `id` int(11) NOT NULL,
  `student_enrollment_id` int(11) NOT NULL,
  `moyenne` double NOT NULL,
  `exam_type` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_moyennes_validation_gradelevel`
--

CREATE TABLE `wx_moyennes_validation_gradelevel` (
  `id` int(11) NOT NULL,
  `school_gradelevels_id` int(11) NOT NULL,
  `moyenne` double NOT NULL,
  `syear` decimal(4,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_notes_details`
--

CREATE TABLE `wx_notes_details` (
  `id_notes_details` int(11) NOT NULL,
  `type_dev` varchar(255) NOT NULL,
  `numero_dev` int(11) NOT NULL,
  `course_period_id` int(11) NOT NULL,
  `mounth` varchar(3) NOT NULL,
  `discipline` int(11) NOT NULL,
  `date_dev` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_notes_student_details`
--

CREATE TABLE `wx_notes_student_details` (
  `id_notes_student_details` int(11) NOT NULL,
  `wx_course_periods_subjects_id` int(11) NOT NULL,
  `type_dev` varchar(255) NOT NULL,
  `numero_dev` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `course_period_id` int(11) NOT NULL,
  `mounth` varchar(3) NOT NULL,
  `discipline` int(11) NOT NULL,
  `note` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_reduction_eleve`
--

CREATE TABLE `wx_reduction_eleve` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `school_id` int(11) NOT NULL,
  `syear` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_reduction_members`
--

CREATE TABLE `wx_reduction_members` (
  `id` int(11) NOT NULL,
  `reduction_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_rules_school`
--

CREATE TABLE `wx_rules_school` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `config_value` longtext DEFAULT NULL,
  `year` decimal(4,0) DEFAULT NULL,
  `school_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_teacher_attendance`
--

CREATE TABLE `wx_teacher_attendance` (
  `id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `done` tinyint(1) NOT NULL DEFAULT 1,
  `comments` longtext DEFAULT NULL,
  `hour_type` longtext DEFAULT 'non_programmed',
  `wx_course_periods_subjects_id` int(11) DEFAULT NULL,
  `total_hours` decimal(6,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_ues`
--

CREATE TABLE `wx_ues` (
  `id` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `gradelevel_id` int(11) DEFAULT NULL,
  `is_required` char(1) DEFAULT 'N',
  `credit` double DEFAULT NULL,
  `syear` int(11) DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `course_period_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wx_ues_subjects`
--

CREATE TABLE `wx_ues_subjects` (
  `id` int(11) NOT NULL,
  `ue_id` int(11) DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `accounting_categories`
--
ALTER TABLE `accounting_categories`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `accounting_incomes`
--
ALTER TABLE `accounting_incomes`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `accounting_payments`
--
ALTER TABLE `accounting_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accounting_payments_ind1` (`staff_id`),
  ADD KEY `accounting_payments_ind2` (`amount`);

--
-- Index pour la table `accounting_salaries`
--
ALTER TABLE `accounting_salaries`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`address_id`),
  ADD KEY `address_3` (`zipcode`),
  ADD KEY `address_4` (`street`);

--
-- Index pour la table `address_fields`
--
ALTER TABLE `address_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `address_desc_ind2` (`type`),
  ADD KEY `address_fields_ind3` (`category_id`);

--
-- Index pour la table `address_field_categories`
--
ALTER TABLE `address_field_categories`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `attendance_calendar`
--
ALTER TABLE `attendance_calendar`
  ADD PRIMARY KEY (`syear`,`school_id`,`school_date`,`calendar_id`);

--
-- Index pour la table `attendance_calendars`
--
ALTER TABLE `attendance_calendars`
  ADD PRIMARY KEY (`calendar_id`);

--
-- Index pour la table `attendance_codes`
--
ALTER TABLE `attendance_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attendance_codes_ind2` (`syear`,`school_id`),
  ADD KEY `attendance_codes_ind3` (`short_name`);

--
-- Index pour la table `attendance_code_categories`
--
ALTER TABLE `attendance_code_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attendance_code_categories_ind2` (`syear`,`school_id`);

--
-- Index pour la table `attendance_completed`
--
ALTER TABLE `attendance_completed`
  ADD PRIMARY KEY (`staff_id`,`school_date`,`period_id`,`table_name`);

--
-- Index pour la table `attendance_day`
--
ALTER TABLE `attendance_day`
  ADD PRIMARY KEY (`student_id`,`school_date`);

--
-- Index pour la table `attendance_period`
--
ALTER TABLE `attendance_period`
  ADD KEY `attendance_period_ind1` (`student_id`),
  ADD KEY `attendance_period_ind2` (`period_id`),
  ADD KEY `attendance_period_ind4` (`school_date`),
  ADD KEY `attendance_period_ind5` (`attendance_code`);

--
-- Index pour la table `billing_fees`
--
ALTER TABLE `billing_fees`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `billing_payments`
--
ALTER TABLE `billing_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `billing_payments_ind1` (`student_id`),
  ADD KEY `billing_payments_ind2` (`amount`),
  ADD KEY `billing_payments_ind3` (`refunded_payment_id`);

--
-- Index pour la table `bordereaux_details`
--
ALTER TABLE `bordereaux_details`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `bordereaux_details_staff_id_month_year_key` (`staff_id`,`month`,`year`);

--
-- Index pour la table `calendar_events`
--
ALTER TABLE `calendar_events`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD KEY `courses_ind1` (`syear`,`school_id`),
  ADD KEY `courses_ind2` (`subject_id`);

--
-- Index pour la table `course_periods`
--
ALTER TABLE `course_periods`
  ADD PRIMARY KEY (`course_period_id`),
  ADD KEY `course_periods_ind2` (`syear`,`school_id`);

--
-- Index pour la table `course_period_school_periods`
--
ALTER TABLE `course_period_school_periods`
  ADD PRIMARY KEY (`course_period_school_periods_id`),
  ADD UNIQUE KEY `course_period_school_periods_course_period_id_period_id_key` (`course_period_id`,`period_id`);

--
-- Index pour la table `course_subjects`
--
ALTER TABLE `course_subjects`
  ADD PRIMARY KEY (`subject_id`),
  ADD KEY `course_subjects_ind1` (`syear`,`school_id`);

--
-- Index pour la table `custom_fields`
--
ALTER TABLE `custom_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `custom_desc_ind2` (`type`),
  ADD KEY `custom_fields_ind3` (`CATEGORY_ID`);

--
-- Index pour la table `discipline_fields`
--
ALTER TABLE `discipline_fields`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `discipline_field_usage`
--
ALTER TABLE `discipline_field_usage`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `discipline_referrals`
--
ALTER TABLE `discipline_referrals`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `eligibility`
--
ALTER TABLE `eligibility`
  ADD KEY `eligibility_ind1` (`student_id`,`course_period_id`,`school_date`);

--
-- Index pour la table `eligibility_activities`
--
ALTER TABLE `eligibility_activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `eligibility_activities_ind1` (`school_id`,`syear`);

--
-- Index pour la table `eligibility_completed`
--
ALTER TABLE `eligibility_completed`
  ADD PRIMARY KEY (`staff_id`,`school_date`,`period_id`);

--
-- Index pour la table `food_service_accounts`
--
ALTER TABLE `food_service_accounts`
  ADD PRIMARY KEY (`account_id`);

--
-- Index pour la table `food_service_categories`
--
ALTER TABLE `food_service_categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Index pour la table `food_service_items`
--
ALTER TABLE `food_service_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Index pour la table `food_service_menus`
--
ALTER TABLE `food_service_menus`
  ADD PRIMARY KEY (`menu_id`);

--
-- Index pour la table `food_service_menu_items`
--
ALTER TABLE `food_service_menu_items`
  ADD PRIMARY KEY (`menu_item_id`);

--
-- Index pour la table `food_service_staff_accounts`
--
ALTER TABLE `food_service_staff_accounts`
  ADD PRIMARY KEY (`staff_id`),
  ADD UNIQUE KEY `food_service_staff_accounts_barcode_key` (`barcode`);

--
-- Index pour la table `food_service_staff_transactions`
--
ALTER TABLE `food_service_staff_transactions`
  ADD PRIMARY KEY (`transaction_id`);

--
-- Index pour la table `food_service_staff_transaction_items`
--
ALTER TABLE `food_service_staff_transaction_items`
  ADD PRIMARY KEY (`item_id`,`transaction_id`),
  ADD KEY `food_service_staff_transaction_items_ind1` (`transaction_id`);

--
-- Index pour la table `food_service_student_accounts`
--
ALTER TABLE `food_service_student_accounts`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `food_service_student_accounts_barcode_key` (`barcode`);

--
-- Index pour la table `food_service_transactions`
--
ALTER TABLE `food_service_transactions`
  ADD PRIMARY KEY (`transaction_id`);

--
-- Index pour la table `food_service_transaction_items`
--
ALTER TABLE `food_service_transaction_items`
  ADD PRIMARY KEY (`item_id`,`transaction_id`),
  ADD KEY `food_service_transaction_items_ind1` (`transaction_id`);

--
-- Index pour la table `gradebook_assignments`
--
ALTER TABLE `gradebook_assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `gradebook_assignment_types_ind1` (`staff_id`,`course_id`),
  ADD KEY `gradebook_assignments_ind1` (`staff_id`,`marking_period_id`),
  ADD KEY `gradebook_assignments_ind3` (`assignment_type_id`);

--
-- Index pour la table `gradebook_assignment_types`
--
ALTER TABLE `gradebook_assignment_types`
  ADD PRIMARY KEY (`assignment_type_id`);

--
-- Index pour la table `gradebook_grades`
--
ALTER TABLE `gradebook_grades`
  ADD PRIMARY KEY (`student_id`,`assignment_id`,`course_period_id`),
  ADD KEY `gradebook_grades_ind1` (`assignment_id`);

--
-- Index pour la table `grades_completed`
--
ALTER TABLE `grades_completed`
  ADD PRIMARY KEY (`staff_id`,`marking_period_id`,`course_period_id`);

--
-- Index pour la table `grade_levels`
--
ALTER TABLE `grade_levels`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `history_marking_periods`
--
ALTER TABLE `history_marking_periods`
  ADD PRIMARY KEY (`marking_period_id`),
  ADD KEY `history_marking_period_ind1` (`school_id`),
  ADD KEY `history_marking_period_ind2` (`syear`);

--
-- Index pour la table `lunch_period`
--
ALTER TABLE `lunch_period`
  ADD PRIMARY KEY (`student_id`,`school_date`,`period_id`),
  ADD KEY `lunch_period_ind1` (`student_id`),
  ADD KEY `lunch_period_ind2` (`period_id`),
  ADD KEY `lunch_period_ind3` (`attendance_code`),
  ADD KEY `lunch_period_ind4` (`school_date`);

--
-- Index pour la table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `messages_ind` (`syear`,`school_id`);

--
-- Index pour la table `messagexuser`
--
ALTER TABLE `messagexuser`
  ADD KEY `messagexuser_ind` (`user_id`,`key`,`status`);

--
-- Index pour la table `moodlexrosario`
--
ALTER TABLE `moodlexrosario`
  ADD PRIMARY KEY (`column`,`rosario_id`);

--
-- Index pour la table `people`
--
ALTER TABLE `people`
  ADD PRIMARY KEY (`person_id`),
  ADD KEY `people_1` (`last_name`,`first_name`);

--
-- Index pour la table `people_fields`
--
ALTER TABLE `people_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `people_desc_ind2` (`type`),
  ADD KEY `people_fields_ind3` (`category_id`);

--
-- Index pour la table `people_field_categories`
--
ALTER TABLE `people_field_categories`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `people_join_contacts`
--
ALTER TABLE `people_join_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `people_join_contacts_ind1` (`person_id`);

--
-- Index pour la table `portal_notes`
--
ALTER TABLE `portal_notes`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `portal_polls`
--
ALTER TABLE `portal_polls`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `portal_poll_questions`
--
ALTER TABLE `portal_poll_questions`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `profile_exceptions`
--
ALTER TABLE `profile_exceptions`
  ADD PRIMARY KEY (`profile_id`,`MODNAME`);

--
-- Index pour la table `program_config`
--
ALTER TABLE `program_config`
  ADD KEY `program_config_ind1` (`school_id`,`syear`);

--
-- Index pour la table `program_user_config`
--
ALTER TABLE `program_user_config`
  ADD KEY `program_user_config_ind1` (`user_id`,`program`);

--
-- Index pour la table `report_card_comments`
--
ALTER TABLE `report_card_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `report_card_comments_ind1` (`syear`,`school_id`);

--
-- Index pour la table `report_card_comment_categories`
--
ALTER TABLE `report_card_comment_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `report_card_comment_categories_ind1` (`syear`,`school_id`);

--
-- Index pour la table `report_card_comment_codes`
--
ALTER TABLE `report_card_comment_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `report_card_comment_codes_ind1` (`school_id`);

--
-- Index pour la table `report_card_comment_code_scales`
--
ALTER TABLE `report_card_comment_code_scales`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `report_card_grades`
--
ALTER TABLE `report_card_grades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `report_card_grades_ind1` (`syear`,`school_id`);

--
-- Index pour la table `report_card_grade_scales`
--
ALTER TABLE `report_card_grade_scales`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `schedule`
--
ALTER TABLE `schedule`
  ADD KEY `schedule_ind1` (`course_id`),
  ADD KEY `schedule_ind2` (`course_period_id`),
  ADD KEY `schedule_ind3` (`student_id`,`marking_period_id`,`start_date`,`end_date`),
  ADD KEY `schedule_ind4` (`syear`,`school_id`);

--
-- Index pour la table `schedule_requests`
--
ALTER TABLE `schedule_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `schedule_requests_ind1` (`student_id`,`course_id`,`syear`),
  ADD KEY `schedule_requests_ind2` (`syear`,`school_id`);

--
-- Index pour la table `schools`
--
ALTER TABLE `schools`
  ADD PRIMARY KEY (`id`,`syear`),
  ADD KEY `schools_ind1` (`syear`),
  ADD KEY `schools_idx1` (`custom_1`(255));

--
-- Index pour la table `school_fields`
--
ALTER TABLE `school_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `school_desc_ind2` (`type`);

--
-- Index pour la table `school_gradelevels`
--
ALTER TABLE `school_gradelevels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `school_gradelevels_ind1` (`school_id`);

--
-- Index pour la table `school_marking_periods`
--
ALTER TABLE `school_marking_periods`
  ADD PRIMARY KEY (`marking_period_id`),
  ADD KEY `school_marking_periods_ind1` (`parent_id`),
  ADD KEY `school_marking_periods_ind2` (`syear`,`school_id`,`start_date`,`end_date`);

--
-- Index pour la table `school_periods`
--
ALTER TABLE `school_periods`
  ADD PRIMARY KEY (`period_id`),
  ADD KEY `school_periods_ind1` (`syear`,`school_id`);

--
-- Index pour la table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staff_id`),
  ADD KEY `staff_idx200000002` (`custom_200000002`),
  ADD KEY `staff_idx200000003` (`custom_200000003`(768)),
  ADD KEY `staff_ind1` (`staff_id`,`syear`),
  ADD KEY `staff_ind2` (`last_name`,`first_name`),
  ADD KEY `staff_ind3` (`schools`);

--
-- Index pour la table `staff_exceptions`
--
ALTER TABLE `staff_exceptions`
  ADD PRIMARY KEY (`user_id`,`modname`);

--
-- Index pour la table `staff_fields`
--
ALTER TABLE `staff_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `staff_desc_ind2` (`type`),
  ADD KEY `staff_fields_ind3` (`category_id`);

--
-- Index pour la table `staff_field_categories`
--
ALTER TABLE `staff_field_categories`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `students_username_key` (`username`),
  ADD KEY `name` (`last_name`,`first_name`,`middle_name`);

--
-- Index pour la table `students_join_address`
--
ALTER TABLE `students_join_address`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stu_addr_meets_2` (`address_id`),
  ADD KEY `students_join_address_ind1` (`student_id`);

--
-- Index pour la table `students_join_people`
--
ALTER TABLE `students_join_people`
  ADD PRIMARY KEY (`id`),
  ADD KEY `relations_meets_2` (`address_id`),
  ADD KEY `students_join_people_ind1` (`student_id`);

--
-- Index pour la table `students_join_users`
--
ALTER TABLE `students_join_users`
  ADD PRIMARY KEY (`student_id`,`staff_id`);

--
-- Index pour la table `student_assignments`
--
ALTER TABLE `student_assignments`
  ADD PRIMARY KEY (`assignment_id`,`student_id`);

--
-- Index pour la table `student_eligibility_activities`
--
ALTER TABLE `student_eligibility_activities`
  ADD KEY `student_eligibility_activities_ind1` (`student_id`);

--
-- Index pour la table `student_enrollment`
--
ALTER TABLE `student_enrollment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_enrollment_2` (`grade_id`),
  ADD KEY `student_enrollment_3` (`syear`,`student_id`,`school_id`),
  ADD KEY `student_enrollment_4` (`start_date`,`end_date`);

--
-- Index pour la table `student_enrollment_codes`
--
ALTER TABLE `student_enrollment_codes`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `student_enrollment_course_periods`
--
ALTER TABLE `student_enrollment_course_periods`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `student_field_categories`
--
ALTER TABLE `student_field_categories`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `student_medical`
--
ALTER TABLE `student_medical`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_medical_ind1` (`student_id`);

--
-- Index pour la table `student_medical_alerts`
--
ALTER TABLE `student_medical_alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_medical_alerts_ind1` (`student_id`);

--
-- Index pour la table `student_medical_visits`
--
ALTER TABLE `student_medical_visits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_medical_visits_ind1` (`student_id`);

--
-- Index pour la table `student_mp_comments`
--
ALTER TABLE `student_mp_comments`
  ADD PRIMARY KEY (`student_id`,`syear`,`marking_period_id`);

--
-- Index pour la table `student_mp_stats`
--
ALTER TABLE `student_mp_stats`
  ADD PRIMARY KEY (`student_id`,`marking_period_id`);

--
-- Index pour la table `student_parent_profiles`
--
ALTER TABLE `student_parent_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`,`staff_id`);

--
-- Index pour la table `student_report_card_comments`
--
ALTER TABLE `student_report_card_comments`
  ADD PRIMARY KEY (`syear`,`student_id`,`course_period_id`,`marking_period_id`,`report_card_comment_id`),
  ADD KEY `student_report_card_comments_ind1` (`syear`,`school_id`);

--
-- Index pour la table `student_report_card_grades`
--
ALTER TABLE `student_report_card_grades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_report_card_grades_ind2` (`student_id`),
  ADD KEY `student_report_card_grades_ind3` (`course_period_id`),
  ADD KEY `student_report_card_grades_ind4` (`marking_period_id`);

--
-- Index pour la table `templates`
--
ALTER TABLE `templates`
  ADD PRIMARY KEY (`modname`,`staff_id`);

--
-- Index pour la table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `wx_appreciations`
--
ALTER TABLE `wx_appreciations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `wx_calcul_moyenne_config`
--
ALTER TABLE `wx_calcul_moyenne_config`
  ADD PRIMARY KEY (`ID`);

--
-- Index pour la table `wx_config_publication_resultats`
--
ALTER TABLE `wx_config_publication_resultats`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `wx_course_periods_gradelevels`
--
ALTER TABLE `wx_course_periods_gradelevels`
  ADD PRIMARY KEY (`wx_course_periods_gradelevels_id`);

--
-- Index pour la table `wx_course_periods_subjects`
--
ALTER TABLE `wx_course_periods_subjects`
  ADD PRIMARY KEY (`wx_course_periods_subjects_id`);

--
-- Index pour la table `wx_course_periods_subjects_periods`
--
ALTER TABLE `wx_course_periods_subjects_periods`
  ADD PRIMARY KEY (`wx_course_periods_subjects_periods_id`);

--
-- Index pour la table `wx_course_subjects_gradelevels`
--
ALTER TABLE `wx_course_subjects_gradelevels`
  ADD PRIMARY KEY (`wx_course_subjects_gradelevels_id`);

--
-- Index pour la table `wx_custom_configuration_school`
--
ALTER TABLE `wx_custom_configuration_school`
  ADD PRIMARY KEY (`id_custom_configuration_school`);

--
-- Index pour la table `wx_echelle_notation_appreciation`
--
ALTER TABLE `wx_echelle_notation_appreciation`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `wx_families`
--
ALTER TABLE `wx_families`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `wx_family_members`
--
ALTER TABLE `wx_family_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `wx_family_members_student_id_key` (`student_id`);

--
-- Index pour la table `wx_gradel_period_evaluation`
--
ALTER TABLE `wx_gradel_period_evaluation`
  ADD PRIMARY KEY (`id_gradel_period_evaluation`);

--
-- Index pour la table `wx_moyennes_finales_students`
--
ALTER TABLE `wx_moyennes_finales_students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_student_exam` (`student_enrollment_id`,`exam_type`);

--
-- Index pour la table `wx_moyennes_validation_gradelevel`
--
ALTER TABLE `wx_moyennes_validation_gradelevel`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `wx_notes_details`
--
ALTER TABLE `wx_notes_details`
  ADD PRIMARY KEY (`id_notes_details`);

--
-- Index pour la table `wx_notes_student_details`
--
ALTER TABLE `wx_notes_student_details`
  ADD PRIMARY KEY (`id_notes_student_details`);

--
-- Index pour la table `wx_reduction_eleve`
--
ALTER TABLE `wx_reduction_eleve`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `wx_reduction_members`
--
ALTER TABLE `wx_reduction_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `wx_reduction_members_student_id_key` (`student_id`);

--
-- Index pour la table `wx_rules_school`
--
ALTER TABLE `wx_rules_school`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `wx_teacher_attendance`
--
ALTER TABLE `wx_teacher_attendance`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `wx_ues`
--
ALTER TABLE `wx_ues`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `wx_ues_subjects`
--
ALTER TABLE `wx_ues_subjects`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `accounting_categories`
--
ALTER TABLE `accounting_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `accounting_incomes`
--
ALTER TABLE `accounting_incomes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `accounting_payments`
--
ALTER TABLE `accounting_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `accounting_salaries`
--
ALTER TABLE `accounting_salaries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `attendance_calendars`
--
ALTER TABLE `attendance_calendars`
  MODIFY `calendar_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `attendance_codes`
--
ALTER TABLE `attendance_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `attendance_code_categories`
--
ALTER TABLE `attendance_code_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `billing_fees`
--
ALTER TABLE `billing_fees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `billing_payments`
--
ALTER TABLE `billing_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `bordereaux_details`
--
ALTER TABLE `bordereaux_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `eligibility_activities`
--
ALTER TABLE `eligibility_activities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `report_card_comments`
--
ALTER TABLE `report_card_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `report_card_grades`
--
ALTER TABLE `report_card_grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `report_card_grade_scales`
--
ALTER TABLE `report_card_grade_scales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `schools`
--
ALTER TABLE `schools`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `school_fields`
--
ALTER TABLE `school_fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `school_gradelevels`
--
ALTER TABLE `school_gradelevels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `school_marking_periods`
--
ALTER TABLE `school_marking_periods`
  MODIFY `marking_period_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `school_periods`
--
ALTER TABLE `school_periods`
  MODIFY `period_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `staff`
--
ALTER TABLE `staff`
  MODIFY `staff_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `student_enrollment`
--
ALTER TABLE `student_enrollment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `student_enrollment_codes`
--
ALTER TABLE `student_enrollment_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `student_enrollment_course_periods`
--
ALTER TABLE `student_enrollment_course_periods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `student_parent_profiles`
--
ALTER TABLE `student_parent_profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_appreciations`
--
ALTER TABLE `wx_appreciations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_calcul_moyenne_config`
--
ALTER TABLE `wx_calcul_moyenne_config`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_config_publication_resultats`
--
ALTER TABLE `wx_config_publication_resultats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_custom_configuration_school`
--
ALTER TABLE `wx_custom_configuration_school`
  MODIFY `id_custom_configuration_school` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_families`
--
ALTER TABLE `wx_families`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_family_members`
--
ALTER TABLE `wx_family_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_notes_student_details`
--
ALTER TABLE `wx_notes_student_details`
  MODIFY `id_notes_student_details` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_reduction_eleve`
--
ALTER TABLE `wx_reduction_eleve`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_reduction_members`
--
ALTER TABLE `wx_reduction_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_teacher_attendance`
--
ALTER TABLE `wx_teacher_attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `address` (ajoute le 13/10/2026)
--
ALTER TABLE `address`
  MODIFY `address_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `address_field_categories` (ajoute le 13/10/2026)
--
ALTER TABLE `address_field_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `address_fields` (ajoute le 13/10/2026)
--
ALTER TABLE `address_fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `calendar_events` (ajoute le 13/10/2026)
--
ALTER TABLE `calendar_events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `course_period_school_periods` (ajoute le 13/10/2026)
--
ALTER TABLE `course_period_school_periods`
  MODIFY `course_period_school_periods_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `course_periods` (ajoute le 13/10/2026)
--
ALTER TABLE `course_periods`
  MODIFY `course_period_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `course_subjects` (ajoute le 13/10/2026)
--
ALTER TABLE `course_subjects`
  MODIFY `subject_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `courses` (ajoute le 13/10/2026)
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `custom_fields` (ajoute le 13/10/2026)
--
ALTER TABLE `custom_fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `discipline_field_usage` (ajoute le 13/10/2026)
--
ALTER TABLE `discipline_field_usage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `discipline_fields` (ajoute le 13/10/2026)
--
ALTER TABLE `discipline_fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `discipline_referrals` (ajoute le 13/10/2026)
--
ALTER TABLE `discipline_referrals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `food_service_categories` (ajoute le 13/10/2026)
--
ALTER TABLE `food_service_categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `food_service_items` (ajoute le 13/10/2026)
--
ALTER TABLE `food_service_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `food_service_menu_items` (ajoute le 13/10/2026)
--
ALTER TABLE `food_service_menu_items`
  MODIFY `menu_item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `food_service_menus` (ajoute le 13/10/2026)
--
ALTER TABLE `food_service_menus`
  MODIFY `menu_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `food_service_staff_transactions` (ajoute le 13/10/2026)
--
ALTER TABLE `food_service_staff_transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `food_service_transactions` (ajoute le 13/10/2026)
--
ALTER TABLE `food_service_transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `grade_levels` (ajoute le 13/10/2026)
--
ALTER TABLE `grade_levels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gradebook_assignment_types` (ajoute le 13/10/2026)
--
ALTER TABLE `gradebook_assignment_types`
  MODIFY `assignment_type_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gradebook_assignments` (ajoute le 13/10/2026)
--
ALTER TABLE `gradebook_assignments`
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `messages` (ajoute le 13/10/2026)
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `people` (ajoute le 13/10/2026)
--
ALTER TABLE `people`
  MODIFY `person_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `people_field_categories` (ajoute le 13/10/2026)
--
ALTER TABLE `people_field_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `people_fields` (ajoute le 13/10/2026)
--
ALTER TABLE `people_fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `people_join_contacts` (ajoute le 13/10/2026)
--
ALTER TABLE `people_join_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `portal_notes` (ajoute le 13/10/2026)
--
ALTER TABLE `portal_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `portal_poll_questions` (ajoute le 13/10/2026)
--
ALTER TABLE `portal_poll_questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `portal_polls` (ajoute le 13/10/2026)
--
ALTER TABLE `portal_polls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `report_card_comment_categories` (ajoute le 13/10/2026)
--
ALTER TABLE `report_card_comment_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `report_card_comment_code_scales` (ajoute le 13/10/2026)
--
ALTER TABLE `report_card_comment_code_scales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `report_card_comment_codes` (ajoute le 13/10/2026)
--
ALTER TABLE `report_card_comment_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `resources` (ajoute le 13/10/2026)
--
ALTER TABLE `resources`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `schedule_requests` (ajoute le 13/10/2026)
--
ALTER TABLE `schedule_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `staff_field_categories` (ajoute le 13/10/2026)
--
ALTER TABLE `staff_field_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `staff_fields` (ajoute le 13/10/2026)
--
ALTER TABLE `staff_fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `student_field_categories` (ajoute le 13/10/2026)
--
ALTER TABLE `student_field_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `student_medical` (ajoute le 13/10/2026)
--
ALTER TABLE `student_medical`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `student_medical_alerts` (ajoute le 13/10/2026)
--
ALTER TABLE `student_medical_alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `student_medical_visits` (ajoute le 13/10/2026)
--
ALTER TABLE `student_medical_visits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `student_report_card_grades` (ajoute le 13/10/2026)
--
ALTER TABLE `student_report_card_grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `students` (ajoute le 13/10/2026)
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `students_join_address` (ajoute le 13/10/2026)
--
ALTER TABLE `students_join_address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `students_join_people` (ajoute le 13/10/2026)
--
ALTER TABLE `students_join_people`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `user_profiles` (ajoute le 13/10/2026)
--
ALTER TABLE `user_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_course_periods_gradelevels` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_course_periods_gradelevels`
  MODIFY `wx_course_periods_gradelevels_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_course_periods_subjects` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_course_periods_subjects`
  MODIFY `wx_course_periods_subjects_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_course_periods_subjects_periods` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_course_periods_subjects_periods`
  MODIFY `wx_course_periods_subjects_periods_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_course_subjects_gradelevels` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_course_subjects_gradelevels`
  MODIFY `wx_course_subjects_gradelevels_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_echelle_notation_appreciation` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_echelle_notation_appreciation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_gradel_period_evaluation` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_gradel_period_evaluation`
  MODIFY `id_gradel_period_evaluation` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_moyennes_finales_students` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_moyennes_finales_students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_moyennes_validation_gradelevel` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_moyennes_validation_gradelevel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_notes_details` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_notes_details`
  MODIFY `id_notes_details` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_rules_school` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_rules_school`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_ues` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_ues`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `wx_ues_subjects` (ajoute le 13/10/2026)
--
ALTER TABLE `wx_ues_subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- ####################################################################
-- @@EDUVERSE-APRES-IMPORT@@
-- ####################################################################
--
-- PARTIE 2 : VUES, FONCTIONS / PROCEDURES, DECLENCHEURS
-- (ajoutee le 13/10/2026 ; equivalents MySQL de RosarioSIS 11.0,
--  fichier amont rosariosis_mysql.sql, verifies contre le dump
--  PostgreSQL EDUVERSE).
--
-- L'outil de migration execute cette partie APRES l'import des
-- donnees, bloc par bloc (un bloc = une ligne "-- @@OBJET ..."),
-- et signale chaque echec. Les declencheurs doivent imperativement
-- etre crees apres l'import : sinon, chaque ligne importee dans
-- student_report_card_grades recalculerait student_mp_stats.
--
-- Collation des vues : l'application se connecte en utf8mb4_unicode_520_ci
-- (Warehouse.php : SET NAMES utf8mb4 COLLATE utf8mb4_unicode_520_ci), les
-- tables sont en utf8mb4_general_ci, phpMyAdmin et le client mysql en
-- general_ci. Les colonnes calculees des vues ('Y', 'History', mp_type...)
-- portent donc un COLLATE utf8mb4_general_ci explicite : sans lui, l'une ou
-- l'autre connexion obtient l'erreur 1267 "Illegal mix of collations"
-- (constate en test sur WHERE DOES_GRADES='Y').
--
-- Chargement manuel avec le client mysql : le fichier entier passe
-- tel quel (les DELIMITER sont geres par le client mysql et par
-- phpMyAdmin).
--
-- Non repris volontairement :
--   - la vue "dual" : DUAL existe nativement dans MySQL / MariaDB ;
--   - immutable_unaccent() : n'est appelee par aucun code de
--     l'application (la recherche accent-insensible est assuree par
--     la collation utf8mb4_general_ci) ;
--   - set_updated_at() et ses 94 declencheurs : remplaces par
--     "ON UPDATE current_timestamp()" sur les colonnes updated_at.
-- ####################################################################

-- @@OBJET VUE course_details
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW `course_details` AS
    SELECT cp.school_id, cp.syear, cp.marking_period_id, c.subject_id, cp.course_id, cp.course_period_id, cp.teacher_id, c.title AS course_title, cp.title AS cp_title, cp.grade_scale_id, cp.mp, cp.credits
    FROM course_periods cp, courses c
    WHERE (cp.course_id = c.course_id);

-- @@OBJET VUE enroll_grade
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW `enroll_grade` AS
    SELECT e.id, e.syear, e.school_id, e.student_id, e.start_date, e.end_date, sg.short_name, sg.title
    FROM student_enrollment e, school_gradelevels sg
    WHERE (e.grade_id = sg.id);

-- @@OBJET VUE marking_periods
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW `marking_periods` AS
    SELECT school_marking_periods.marking_period_id, 'Rosario' COLLATE utf8mb4_general_ci AS mp_source, school_marking_periods.syear, school_marking_periods.school_id,
        (CASE WHEN school_marking_periods.mp = 'FY' THEN 'year' WHEN school_marking_periods.mp = 'SEM' THEN 'semester' WHEN school_marking_periods.mp = 'QTR' THEN 'quarter' ELSE NULL END) COLLATE utf8mb4_general_ci AS mp_type,
        school_marking_periods.title, school_marking_periods.short_name, school_marking_periods.sort_order,
        CASE WHEN school_marking_periods.parent_id > 0 THEN school_marking_periods.parent_id ELSE -1 END AS parent_id,
        CASE WHEN ((SELECT smp.parent_id FROM school_marking_periods smp WHERE (smp.marking_period_id = school_marking_periods.parent_id)) > 0)
            THEN (SELECT smp.parent_id FROM school_marking_periods smp WHERE (smp.marking_period_id = school_marking_periods.parent_id))
            ELSE -1 END AS grandparent_id,
        school_marking_periods.start_date, school_marking_periods.end_date, school_marking_periods.post_start_date, school_marking_periods.post_end_date,
        school_marking_periods.does_grades, school_marking_periods.does_comments
    FROM school_marking_periods
    UNION
    SELECT history_marking_periods.marking_period_id, 'History' COLLATE utf8mb4_general_ci AS mp_source, history_marking_periods.syear, history_marking_periods.school_id,
        history_marking_periods.mp_type COLLATE utf8mb4_general_ci AS mp_type, history_marking_periods.name AS title, history_marking_periods.short_name, NULL AS sort_order,
        history_marking_periods.parent_id, (-1) AS grandparent_id, NULL AS start_date, history_marking_periods.post_end_date AS end_date,
        NULL AS post_start_date, history_marking_periods.post_end_date, 'Y' COLLATE utf8mb4_general_ci AS does_grades, NULL AS does_comments
    FROM history_marking_periods;

-- @@OBJET VUE transcript_grades
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW `transcript_grades` AS
    SELECT mp.syear, mp.school_id, mp.marking_period_id, mp.mp_type,
    mp.short_name, mp.parent_id, mp.grandparent_id,
    (SELECT mp2.end_date
        FROM student_report_card_grades
            JOIN marking_periods mp2
            ON mp2.marking_period_id = student_report_card_grades.marking_period_id
        WHERE student_report_card_grades.student_id = sms.student_id
        AND (student_report_card_grades.marking_period_id = mp.parent_id
            OR student_report_card_grades.marking_period_id = mp.grandparent_id)
        AND student_report_card_grades.course_title = srcg.course_title
        ORDER BY mp2.end_date LIMIT 1) AS parent_end_date,
    mp.end_date, sms.student_id,
    (sms.cum_weighted_factor * COALESCE(schools.reporting_gp_scale, (SELECT reporting_gp_scale FROM schools WHERE mp.school_id = id ORDER BY syear LIMIT 1))) AS cum_weighted_gpa,
    (sms.cum_unweighted_factor * schools.reporting_gp_scale) AS cum_unweighted_gpa,
    sms.cum_rank, sms.mp_rank, sms.class_size,
    ((sms.sum_weighted_factors / sms.count_weighted_factors) * schools.reporting_gp_scale) AS weighted_gpa,
    ((sms.sum_unweighted_factors / sms.count_unweighted_factors) * schools.reporting_gp_scale) AS unweighted_gpa,
    sms.grade_level_short, srcg.comment, srcg.grade_percent, srcg.grade_letter,
    srcg.weighted_gp, srcg.unweighted_gp, srcg.gp_scale, srcg.credit_attempted,
    srcg.credit_earned, srcg.course_title, srcg.school AS school_name,
    schools.reporting_gp_scale AS school_scale,
    ((sms.cr_weighted_factors / sms.count_cr_factors) * schools.reporting_gp_scale) AS cr_weighted_gpa,
    ((sms.cr_unweighted_factors / sms.count_cr_factors) * schools.reporting_gp_scale) AS cr_unweighted_gpa,
    (sms.cum_cr_weighted_factor * schools.reporting_gp_scale) AS cum_cr_weighted_gpa,
    (sms.cum_cr_unweighted_factor * schools.reporting_gp_scale) AS cum_cr_unweighted_gpa,
    srcg.class_rank, sms.comments,
    srcg.credit_hours
    FROM marking_periods mp
        JOIN student_report_card_grades srcg
        ON mp.marking_period_id = srcg.marking_period_id
        JOIN student_mp_stats sms
        ON sms.marking_period_id = mp.marking_period_id
            AND sms.student_id = srcg.student_id
        LEFT OUTER JOIN schools
        ON mp.school_id = schools.id
            AND (mp.mp_source<>'History' AND mp.syear = schools.syear)
                OR (mp.mp_source='History' AND mp.syear=(SELECT syear FROM schools WHERE mp.school_id = id ORDER BY syear LIMIT 1))
    ORDER BY srcg.course_period_id;

-- @@OBJET PROCEDURE calc_cum_cr_gpa
DROP PROCEDURE IF EXISTS `calc_cum_cr_gpa`;
DELIMITER $$
CREATE PROCEDURE `calc_cum_cr_gpa`(mp_id integer, s_id integer)
    SQL SECURITY INVOKER
BEGIN
    UPDATE student_mp_stats
    SET cum_cr_weighted_factor = cr_weighted_factors/cr_credits,
        cum_cr_unweighted_factor = cr_unweighted_factors/cr_credits
    WHERE student_mp_stats.student_id = s_id and student_mp_stats.marking_period_id = mp_id;
END$$
DELIMITER ;

-- @@OBJET PROCEDURE calc_cum_gpa
DROP PROCEDURE IF EXISTS `calc_cum_gpa`;
DELIMITER $$
CREATE PROCEDURE `calc_cum_gpa`(mp_id integer, s_id integer)
    SQL SECURITY INVOKER
BEGIN
    UPDATE student_mp_stats
    SET cum_weighted_factor = sum_weighted_factors/gp_credits,
        cum_unweighted_factor = sum_unweighted_factors/gp_credits
    WHERE student_mp_stats.student_id = s_id and student_mp_stats.marking_period_id = mp_id;
END$$
DELIMITER ;

-- @@OBJET PROCEDURE calc_gpa_mp
DROP PROCEDURE IF EXISTS `calc_gpa_mp`;
DELIMITER $$
CREATE PROCEDURE `calc_gpa_mp`(s_id integer, mp_id integer)
    SQL SECURITY INVOKER
BEGIN
    DECLARE oldrec integer;

    SELECT count(*) INTO oldrec FROM student_mp_stats WHERE student_id = s_id and marking_period_id = mp_id;

    IF oldrec > 0 THEN
    UPDATE student_mp_stats sms
    JOIN (
        select
        student_id,
        marking_period_id,
        sum(weighted_gp*credit_attempted/gp_scale) as sum_weighted_factors,
        sum(unweighted_gp*credit_attempted/gp_scale) as sum_unweighted_factors,
        sum(credit_attempted) as gp_credits,
        sum( case when class_rank = 'Y' THEN weighted_gp*credit_attempted/gp_scale END ) as cr_weighted,
        sum( case when class_rank = 'Y' THEN unweighted_gp*credit_attempted/gp_scale END ) as cr_unweighted,
        sum( case when class_rank = 'Y' THEN credit_attempted END) as cr_credits

        from student_report_card_grades
        where student_id = s_id
        and marking_period_id = mp_id
        and not gp_scale = 0
        group by student_id, marking_period_id
    ) as rcg
    ON rcg.student_id = sms.student_id and rcg.marking_period_id = sms.marking_period_id
    SET
        sms.sum_weighted_factors = rcg.sum_weighted_factors,
        sms.sum_unweighted_factors = rcg.sum_unweighted_factors,
        sms.cr_weighted_factors = rcg.cr_weighted,
        sms.cr_unweighted_factors = rcg.cr_unweighted,
        sms.gp_credits = rcg.gp_credits,
        sms.cr_credits = rcg.cr_credits;

    ELSE
    INSERT INTO student_mp_stats (student_id, marking_period_id, sum_weighted_factors, sum_unweighted_factors, grade_level_short, cr_weighted_factors, cr_unweighted_factors, gp_credits, cr_credits)

        select
            srcg.student_id,
            srcg.marking_period_id,
            sum(weighted_gp*credit_attempted/gp_scale) as sum_weighted_factors,
            sum(unweighted_gp*credit_attempted/gp_scale) as sum_unweighted_factors,
            (select eg.short_name
                from enroll_grade eg, marking_periods mp
                where eg.student_id = s_id
                and eg.syear = mp.syear
                and eg.school_id = mp.school_id
                and eg.start_date <= mp.end_date
                and mp.marking_period_id = mp_id
                order by eg.start_date desc
                limit 1) as short_name,
            sum( case when class_rank = 'Y' THEN weighted_gp*credit_attempted/gp_scale END ) as cr_weighted,
            sum( case when class_rank = 'Y' THEN unweighted_gp*credit_attempted/gp_scale END ) as cr_unweighted,
            sum(credit_attempted) as gp_credits,
            sum(case when class_rank = 'Y' THEN credit_attempted END) as cr_credits
        from student_report_card_grades srcg
        where srcg.student_id = s_id and srcg.marking_period_id = mp_id and not srcg.gp_scale = 0
        group by srcg.student_id, srcg.marking_period_id, short_name;
    END IF;
END$$
DELIMITER ;

-- @@OBJET FONCTION credit
DROP FUNCTION IF EXISTS `credit`;
DELIMITER $$
CREATE FUNCTION `credit`(cp_id integer, mp_id integer) RETURNS numeric(6,2)
    READS SQL DATA
    SQL SECURITY INVOKER
BEGIN
    DECLARE course_detail_mp_id integer;
    DECLARE course_detail_mp varchar(3);
    DECLARE course_detail_credits numeric(6,2);
    DECLARE mp_detail_mp_id integer;
    DECLARE mp_detail_mp_type varchar(20);
    DECLARE val_mp_count integer;

    select marking_period_id,mp,credits into course_detail_mp_id,course_detail_mp,course_detail_credits from course_periods where course_period_id = cp_id;
    select marking_period_id,mp_type into mp_detail_mp_id,mp_detail_mp_type from marking_periods where marking_period_id = mp_id;

    IF course_detail_mp_id = mp_detail_mp_id THEN
        RETURN course_detail_credits;
    ELSEIF course_detail_mp = 'FY' AND mp_detail_mp_type = 'semester' THEN
        select count(*) into val_mp_count from marking_periods where parent_id = course_detail_mp_id group by parent_id;
    ELSEIF course_detail_mp = 'FY' and mp_detail_mp_type = 'quarter' THEN
        select count(*) into val_mp_count from marking_periods where grandparent_id = course_detail_mp_id group by grandparent_id;
    ELSEIF course_detail_mp = 'SEM' and mp_detail_mp_type = 'quarter' THEN
        select count(*) into val_mp_count from marking_periods where parent_id = course_detail_mp_id group by parent_id;
    ELSE
        RETURN course_detail_credits;
    END IF;

    IF val_mp_count > 0 THEN
        RETURN course_detail_credits/val_mp_count;
    ELSE
        RETURN course_detail_credits;
    END IF;
END$$
DELIMITER ;

-- @@OBJET FONCTION set_class_rank_mp
DROP FUNCTION IF EXISTS `set_class_rank_mp`;
DELIMITER $$
CREATE FUNCTION `set_class_rank_mp`(mp_id integer) RETURNS integer
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
BEGIN
    update student_mp_stats sms
    JOIN (
        select mp.marking_period_id, sgm.student_id,
        (select count(*)+1
            from student_mp_stats sgm3
            where sgm3.cum_cr_weighted_factor > sgm.cum_cr_weighted_factor
            and sgm3.marking_period_id = mp.marking_period_id
            and sgm3.student_id in (select distinct sgm2.student_id
                from student_mp_stats sgm2, student_enrollment se2
                where sgm2.student_id = se2.student_id
                and sgm2.marking_period_id = mp.marking_period_id
                and se2.grade_id = se.grade_id)) as class_rank,
        (select count(*)
            from student_mp_stats sgm4
            where sgm4.marking_period_id = mp.marking_period_id
            and sgm4.student_id in (select distinct sgm5.student_id
                from student_mp_stats sgm5, student_enrollment se3
                where sgm5.student_id = se3.student_id
                and sgm5.marking_period_id = mp.marking_period_id
                and se3.grade_id = se.grade_id)) as class_size
        from student_enrollment se, student_mp_stats sgm, marking_periods mp
        where se.student_id = sgm.student_id
        and sgm.marking_period_id = mp.marking_period_id
        and mp.marking_period_id = mp_id
        and se.syear = mp.syear
        and not sgm.cum_cr_weighted_factor is null
    ) as class_rank
    ON sms.marking_period_id = class_rank.marking_period_id and sms.student_id = class_rank.student_id
    set sms.cum_rank = class_rank.class_rank, sms.class_size = class_rank.class_size;
    RETURN 1;
END$$
DELIMITER ;

-- @@OBJET PROCEDURE t_update_mp_stats
DROP PROCEDURE IF EXISTS `t_update_mp_stats`;
DELIMITER $$
CREATE PROCEDURE `t_update_mp_stats`(s_id integer, mp_id integer)
    SQL SECURITY INVOKER
BEGIN
    CALL calc_gpa_mp(s_id, mp_id);
    CALL calc_cum_gpa(mp_id, s_id);
    CALL calc_cum_cr_gpa(mp_id, s_id);
END$$
DELIMITER ;

-- @@OBJET DECLENCHEUR srcg_mp_stats_insert
DROP TRIGGER IF EXISTS `srcg_mp_stats_insert`;
CREATE TRIGGER `srcg_mp_stats_insert` AFTER INSERT ON `student_report_card_grades` FOR EACH ROW CALL t_update_mp_stats(NEW.student_id, NEW.marking_period_id);

-- @@OBJET DECLENCHEUR srcg_mp_stats_update
DROP TRIGGER IF EXISTS `srcg_mp_stats_update`;
CREATE TRIGGER `srcg_mp_stats_update` AFTER UPDATE ON `student_report_card_grades` FOR EACH ROW CALL t_update_mp_stats(NEW.student_id, NEW.marking_period_id);

-- @@OBJET DECLENCHEUR srcg_mp_stats_delete
DROP TRIGGER IF EXISTS `srcg_mp_stats_delete`;
CREATE TRIGGER `srcg_mp_stats_delete` AFTER DELETE ON `student_report_card_grades` FOR EACH ROW CALL t_update_mp_stats(OLD.student_id, OLD.marking_period_id);


-- ####################################################################
-- @@EDUVERSE-CLES-ETRANGERES@@
-- ####################################################################
--
-- PARTIE 3 : CLES ETRANGERES (118, reprises du dump PostgreSQL EDUVERSE ;
-- RosarioSIS amont declare lui aussi ses cles etrangeres dans
-- rosariosis_mysql.sql).
-- L'outil de migration les pose APRES l'import, une par une : il compte
-- d'abord les lignes orphelines ; s'il y en a, la cle n'est pas posee et
-- l'ecart est signale (table, contrainte, nombre de lignes).
-- Noms rendus uniques (MySQL exige un nom unique par base, PostgreSQL
-- seulement par table) : wx_course_periods_subjects.fk_course_periods, wx_course_periods_gradelevels.fk_course_periods, student_enrollment_course_periods.fk_course_periods, wx_course_periods_subjects.fk_course_subjects, wx_course_subjects_gradelevels.fk_course_subjects, wx_course_periods_gradelevels.fk_school_gradelevels, wx_course_subjects_gradelevels.fk_school_gradelevels, wx_moyennes_finales_students.fk_student_enrollment_id, student_enrollment_course_periods.fk_student_enrollment_id
-- Une instruction par ligne : ne pas couper les lignes.
-- ####################################################################

SET FOREIGN_KEY_CHECKS = 1;
ALTER TABLE `accounting_incomes` ADD CONSTRAINT `accounting_incomes_category_id_fkey` FOREIGN KEY (`category_id`) REFERENCES `accounting_categories` (`id`);
ALTER TABLE `accounting_incomes` ADD CONSTRAINT `accounting_incomes_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `accounting_payments` ADD CONSTRAINT `accounting_payments_category_id_fkey` FOREIGN KEY (`category_id`) REFERENCES `accounting_categories` (`id`);
ALTER TABLE `accounting_payments` ADD CONSTRAINT `accounting_payments_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `accounting_payments` ADD CONSTRAINT `accounting_payments_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `accounting_salaries` ADD CONSTRAINT `accounting_salaries_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `accounting_salaries` ADD CONSTRAINT `accounting_salaries_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `attendance_calendar` ADD CONSTRAINT `attendance_calendar_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `attendance_calendars` ADD CONSTRAINT `attendance_calendars_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `attendance_code_categories` ADD CONSTRAINT `attendance_code_categories_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `attendance_codes` ADD CONSTRAINT `attendance_codes_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `attendance_completed` ADD CONSTRAINT `attendance_completed_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `attendance_day` ADD CONSTRAINT `attendance_day_marking_period_id_fkey` FOREIGN KEY (`marking_period_id`) REFERENCES `school_marking_periods` (`marking_period_id`);
ALTER TABLE `attendance_day` ADD CONSTRAINT `attendance_day_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `attendance_period` ADD CONSTRAINT `attendance_period_course_period_id_fkey` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`);
ALTER TABLE `attendance_period` ADD CONSTRAINT `attendance_period_marking_period_id_fkey` FOREIGN KEY (`marking_period_id`) REFERENCES `school_marking_periods` (`marking_period_id`);
ALTER TABLE `attendance_period` ADD CONSTRAINT `attendance_period_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `billing_fees` ADD CONSTRAINT `billing_fees_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `billing_fees` ADD CONSTRAINT `billing_fees_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `billing_payments` ADD CONSTRAINT `billing_payments_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `billing_payments` ADD CONSTRAINT `billing_payments_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `calendar_events` ADD CONSTRAINT `calendar_events_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `course_period_school_periods` ADD CONSTRAINT `course_period_school_periods_course_period_id_fkey` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`);
ALTER TABLE `course_periods` ADD CONSTRAINT `course_periods_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);
ALTER TABLE `course_periods` ADD CONSTRAINT `course_periods_marking_period_id_fkey` FOREIGN KEY (`marking_period_id`) REFERENCES `school_marking_periods` (`marking_period_id`);
ALTER TABLE `course_periods` ADD CONSTRAINT `course_periods_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `course_periods` ADD CONSTRAINT `course_periods_secondary_teacher_id_fkey` FOREIGN KEY (`secondary_teacher_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `course_periods` ADD CONSTRAINT `course_periods_teacher_id_fkey` FOREIGN KEY (`teacher_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE;
ALTER TABLE `course_subjects` ADD CONSTRAINT `course_subjects_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `courses` ADD CONSTRAINT `courses_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `discipline_field_usage` ADD CONSTRAINT `discipline_field_usage_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `discipline_referrals` ADD CONSTRAINT `discipline_referrals_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `discipline_referrals` ADD CONSTRAINT `discipline_referrals_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `discipline_referrals` ADD CONSTRAINT `discipline_referrals_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `eligibility_activities` ADD CONSTRAINT `eligibility_activities_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `eligibility_completed` ADD CONSTRAINT `eligibility_completed_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `eligibility` ADD CONSTRAINT `eligibility_course_period_id_fkey` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`);
ALTER TABLE `eligibility` ADD CONSTRAINT `eligibility_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `attendance_period` ADD CONSTRAINT `fk_attendance_period_my_period` FOREIGN KEY (`my_period_id`) REFERENCES `wx_course_periods_subjects_periods` (`wx_course_periods_subjects_periods_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE `wx_course_periods_subjects` ADD CONSTRAINT `wx_course_periods_subjects_fk_course_periods` FOREIGN KEY (`course_periods_id`) REFERENCES `course_periods` (`course_period_id`) ON DELETE CASCADE;
ALTER TABLE `wx_course_periods_gradelevels` ADD CONSTRAINT `wx_course_periods_gradelevels_fk_course_periods` FOREIGN KEY (`course_periods_id`) REFERENCES `course_periods` (`course_period_id`) ON DELETE CASCADE;
ALTER TABLE `student_enrollment_course_periods` ADD CONSTRAINT `student_enrollment_course_periods_fk_course_periods` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`) ON DELETE CASCADE;
ALTER TABLE `wx_course_periods_subjects` ADD CONSTRAINT `wx_course_periods_subjects_fk_course_subjects` FOREIGN KEY (`course_subjects_id`) REFERENCES `course_subjects` (`subject_id`) ON DELETE CASCADE;
ALTER TABLE `wx_course_subjects_gradelevels` ADD CONSTRAINT `wx_course_subjects_gradelevels_fk_course_subjects` FOREIGN KEY (`course_subjects_id`) REFERENCES `course_subjects` (`subject_id`) ON DELETE CASCADE;
ALTER TABLE `wx_course_periods_gradelevels` ADD CONSTRAINT `wx_course_periods_gradelevels_fk_school_gradelevels` FOREIGN KEY (`school_gradelevels_id`) REFERENCES `school_gradelevels` (`id`) ON DELETE CASCADE;
ALTER TABLE `wx_course_subjects_gradelevels` ADD CONSTRAINT `wx_course_subjects_gradelevels_fk_school_gradelevels` FOREIGN KEY (`school_gradelevels_id`) REFERENCES `school_gradelevels` (`id`) ON DELETE CASCADE;
ALTER TABLE `wx_moyennes_validation_gradelevel` ADD CONSTRAINT `fk_school_gradelevels_id` FOREIGN KEY (`school_gradelevels_id`) REFERENCES `school_gradelevels` (`id`) ON DELETE CASCADE;
ALTER TABLE `wx_teacher_attendance` ADD CONSTRAINT `fk_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE;
ALTER TABLE `wx_moyennes_finales_students` ADD CONSTRAINT `wx_moyennes_finales_students_fk_student_enrollment_id` FOREIGN KEY (`student_enrollment_id`) REFERENCES `student_enrollment` (`id`) ON DELETE CASCADE;
ALTER TABLE `student_enrollment_course_periods` ADD CONSTRAINT `student_enrollment_course_periods_fk_student_enrollment_id` FOREIGN KEY (`student_enrollment_id`) REFERENCES `student_enrollment` (`id`) ON DELETE CASCADE;
ALTER TABLE `wx_course_periods_subjects_periods` ADD CONSTRAINT `fk_wx_course_periods_subjects` FOREIGN KEY (`wx_course_periods_subjects_id`) REFERENCES `wx_course_periods_subjects` (`wx_course_periods_subjects_id`) ON DELETE CASCADE;
ALTER TABLE `food_service_staff_accounts` ADD CONSTRAINT `food_service_staff_accounts_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `food_service_staff_transactions` ADD CONSTRAINT `food_service_staff_transactions_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `food_service_staff_transactions` ADD CONSTRAINT `food_service_staff_transactions_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `food_service_student_accounts` ADD CONSTRAINT `food_service_student_accounts_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `food_service_transactions` ADD CONSTRAINT `food_service_transactions_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `food_service_transactions` ADD CONSTRAINT `food_service_transactions_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `gradebook_assignment_types` ADD CONSTRAINT `gradebook_assignment_types_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);
ALTER TABLE `gradebook_assignment_types` ADD CONSTRAINT `gradebook_assignment_types_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `gradebook_assignments` ADD CONSTRAINT `gradebook_assignments_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);
ALTER TABLE `gradebook_assignments` ADD CONSTRAINT `gradebook_assignments_course_period_id_fkey` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`);
ALTER TABLE `gradebook_assignments` ADD CONSTRAINT `gradebook_assignments_marking_period_id_fkey` FOREIGN KEY (`marking_period_id`) REFERENCES `school_marking_periods` (`marking_period_id`);
ALTER TABLE `gradebook_assignments` ADD CONSTRAINT `gradebook_assignments_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `gradebook_grades` ADD CONSTRAINT `gradebook_grades_course_period_id_fkey` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`);
ALTER TABLE `gradebook_grades` ADD CONSTRAINT `gradebook_grades_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `grades_completed` ADD CONSTRAINT `grades_completed_course_period_id_fkey` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`);
ALTER TABLE `grades_completed` ADD CONSTRAINT `grades_completed_marking_period_id_fkey` FOREIGN KEY (`marking_period_id`) REFERENCES `school_marking_periods` (`marking_period_id`);
ALTER TABLE `grades_completed` ADD CONSTRAINT `grades_completed_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `lunch_period` ADD CONSTRAINT `lunch_period_course_period_id_fkey` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`);
ALTER TABLE `lunch_period` ADD CONSTRAINT `lunch_period_marking_period_id_fkey` FOREIGN KEY (`marking_period_id`) REFERENCES `school_marking_periods` (`marking_period_id`);
ALTER TABLE `lunch_period` ADD CONSTRAINT `lunch_period_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `messages` ADD CONSTRAINT `messages_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `portal_notes` ADD CONSTRAINT `portal_notes_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `portal_polls` ADD CONSTRAINT `portal_polls_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `program_config` ADD CONSTRAINT `program_config_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `report_card_comment_categories` ADD CONSTRAINT `report_card_comment_categories_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);
ALTER TABLE `report_card_comment_categories` ADD CONSTRAINT `report_card_comment_categories_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `report_card_comments` ADD CONSTRAINT `report_card_comments_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `report_card_grade_scales` ADD CONSTRAINT `report_card_grade_scales_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `report_card_grades` ADD CONSTRAINT `report_card_grades_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `schedule` ADD CONSTRAINT `schedule_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);
ALTER TABLE `schedule` ADD CONSTRAINT `schedule_course_period_id_fkey` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`);
ALTER TABLE `schedule` ADD CONSTRAINT `schedule_marking_period_id_fkey` FOREIGN KEY (`marking_period_id`) REFERENCES `school_marking_periods` (`marking_period_id`);
ALTER TABLE `schedule_requests` ADD CONSTRAINT `schedule_requests_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);
ALTER TABLE `schedule_requests` ADD CONSTRAINT `schedule_requests_marking_period_id_fkey` FOREIGN KEY (`marking_period_id`) REFERENCES `school_marking_periods` (`marking_period_id`);
ALTER TABLE `schedule_requests` ADD CONSTRAINT `schedule_requests_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `schedule_requests` ADD CONSTRAINT `schedule_requests_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `schedule` ADD CONSTRAINT `schedule_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `schedule` ADD CONSTRAINT `schedule_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `school_marking_periods` ADD CONSTRAINT `school_marking_periods_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `school_periods` ADD CONSTRAINT `school_periods_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `staff_exceptions` ADD CONSTRAINT `staff_exceptions_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `student_assignments` ADD CONSTRAINT `student_assignments_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `student_eligibility_activities` ADD CONSTRAINT `student_eligibility_activities_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `student_enrollment` ADD CONSTRAINT `student_enrollment_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `student_enrollment` ADD CONSTRAINT `student_enrollment_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `student_medical_alerts` ADD CONSTRAINT `student_medical_alerts_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `student_medical` ADD CONSTRAINT `student_medical_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `student_medical_visits` ADD CONSTRAINT `student_medical_visits_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `student_mp_comments` ADD CONSTRAINT `student_mp_comments_marking_period_id_fkey` FOREIGN KEY (`marking_period_id`) REFERENCES `school_marking_periods` (`marking_period_id`);
ALTER TABLE `student_mp_comments` ADD CONSTRAINT `student_mp_comments_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `student_mp_stats` ADD CONSTRAINT `student_mp_stats_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `student_report_card_comments` ADD CONSTRAINT `student_report_card_comments_course_period_id_fkey` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`);
ALTER TABLE `student_report_card_comments` ADD CONSTRAINT `student_report_card_comments_marking_period_id_fkey` FOREIGN KEY (`marking_period_id`) REFERENCES `school_marking_periods` (`marking_period_id`);
ALTER TABLE `student_report_card_comments` ADD CONSTRAINT `student_report_card_comments_school_id_syear_fkey` FOREIGN KEY (`school_id`, `syear`) REFERENCES `schools` (`id`, `syear`);
ALTER TABLE `student_report_card_comments` ADD CONSTRAINT `student_report_card_comments_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `student_report_card_grades` ADD CONSTRAINT `student_report_card_grades_course_period_id_fkey` FOREIGN KEY (`course_period_id`) REFERENCES `course_periods` (`course_period_id`);
ALTER TABLE `student_report_card_grades` ADD CONSTRAINT `student_report_card_grades_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `students_join_address` ADD CONSTRAINT `students_join_address_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `students_join_people` ADD CONSTRAINT `students_join_people_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `students_join_users` ADD CONSTRAINT `students_join_users_staff_id_fkey` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`);
ALTER TABLE `students_join_users` ADD CONSTRAINT `students_join_users_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `wx_family_members` ADD CONSTRAINT `wx_family_members_family_id_fkey` FOREIGN KEY (`family_id`) REFERENCES `wx_families` (`id`) ON DELETE CASCADE;
ALTER TABLE `wx_family_members` ADD CONSTRAINT `wx_family_members_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE;
ALTER TABLE `wx_notes_student_details` ADD CONSTRAINT `wx_notes_student_details_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);
ALTER TABLE `wx_notes_student_details` ADD CONSTRAINT `wx_notes_student_details_wx_course_periods_subjects_id_fkey` FOREIGN KEY (`wx_course_periods_subjects_id`) REFERENCES `wx_course_periods_subjects` (`wx_course_periods_subjects_id`) ON DELETE CASCADE;
ALTER TABLE `wx_ues_subjects` ADD CONSTRAINT `wx_ues_subjects_subject_id_fkey` FOREIGN KEY (`subject_id`) REFERENCES `course_subjects` (`subject_id`);
ALTER TABLE `wx_ues_subjects` ADD CONSTRAINT `wx_ues_subjects_ue_id_fkey` FOREIGN KEY (`ue_id`) REFERENCES `wx_ues` (`id`) ON DELETE CASCADE;
