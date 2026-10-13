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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL,
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
  `updated_at` datetime DEFAULT NULL,
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
  `updated_at` datetime DEFAULT NULL,
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
  `updated_at` datetime DEFAULT current_timestamp()
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL,
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL,
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL,
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL,
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL,
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL,
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `students_join_users`
--

CREATE TABLE `students_join_users` (
  `student_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL,
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `student_mp_stats`
--

CREATE TABLE `student_mp_stats` (
  `student_id` int(11) NOT NULL,
  `marking_period_id` int(11) NOT NULL,
  `cum_weighted_factor` decimal(10,0) DEFAULT NULL,
  `cum_unweighted_factor` decimal(10,0) DEFAULT NULL,
  `cum_rank` int(11) DEFAULT NULL,
  `mp_rank` int(11) DEFAULT NULL,
  `class_size` int(11) DEFAULT NULL,
  `sum_weighted_factors` decimal(10,0) DEFAULT NULL,
  `sum_unweighted_factors` decimal(10,0) DEFAULT NULL,
  `count_weighted_factors` int(11) DEFAULT NULL,
  `count_unweighted_factors` int(11) DEFAULT NULL,
  `grade_level_short` varchar(3) DEFAULT NULL,
  `cr_weighted_factors` decimal(10,0) DEFAULT NULL,
  `cr_unweighted_factors` decimal(10,0) DEFAULT NULL,
  `count_cr_factors` int(11) DEFAULT NULL,
  `cum_cr_weighted_factor` decimal(10,0) DEFAULT NULL,
  `cum_cr_unweighted_factor` decimal(10,0) DEFAULT NULL,
  `credit_attempted` decimal(10,0) DEFAULT NULL,
  `credit_earned` decimal(10,0) DEFAULT NULL,
  `gp_credits` decimal(10,0) DEFAULT NULL,
  `cr_credits` decimal(10,0) DEFAULT NULL,
  `comments` varchar(75) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
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
  `updated_at` datetime DEFAULT NULL
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
  `credit_attempted` decimal(10,0) DEFAULT NULL,
  `credit_earned` decimal(10,0) DEFAULT NULL,
  `credit_category` varchar(10) DEFAULT NULL,
  `course_title` longtext NOT NULL,
  `id` int(11) NOT NULL,
  `school` longtext DEFAULT NULL,
  `class_rank` varchar(1) DEFAULT NULL,
  `credit_hours` decimal(6,2) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime DEFAULT NULL
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
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
