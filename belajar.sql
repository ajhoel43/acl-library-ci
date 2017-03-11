-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Mar 11, 2017 at 11:36 AM
-- Server version: 5.6.33
-- PHP Version: 5.6.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `belajar`
--

-- --------------------------------------------------------

--
-- Table structure for table `group`
--

CREATE TABLE `group` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `keterangan` text,
  `grant_all_access` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `group`
--

INSERT INTO `group` (`id`, `nama`, `keterangan`, `grant_all_access`) VALUES
(1, 'Super User', 'Grup untuk Super User', 1),
(2, 'Officer', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `group_acl`
--

CREATE TABLE `group_acl` (
  `id` int(11) NOT NULL,
  `id_group` int(11) NOT NULL,
  `id_menu` int(11) NOT NULL,
  `create` tinyint(1) DEFAULT '0',
  `read` tinyint(1) DEFAULT '0',
  `update` tinyint(1) DEFAULT '0',
  `delete` tinyint(1) DEFAULT '0',
  `report` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `group_acl`
--

INSERT INTO `group_acl` (`id`, `id_group`, `id_menu`, `create`, `read`, `update`, `delete`, `report`) VALUES
(1, 2, 2, 0, 1, 0, 0, 0),
(2, 2, 1, 1, 1, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `class_name` varchar(100) NOT NULL,
  `func_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `name`, `class_name`, `func_name`) VALUES
(1, 'My Menu', 'myclass', NULL),
(2, 'My Menu with Specified Read', 'myclass', 'menu_specific_read');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `email`) VALUES
(1, 'user', 'user', 'user@mail.com'),
(2, 'superuser', 'superuser', 'super@mail.com');

-- --------------------------------------------------------

--
-- Table structure for table `user_acl`
--

CREATE TABLE `user_acl` (
  `id` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_menu` int(11) NOT NULL,
  `create` tinyint(1) DEFAULT '0',
  `read` tinyint(1) DEFAULT '0',
  `update` tinyint(1) DEFAULT '0',
  `delete` tinyint(1) DEFAULT '0',
  `report` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_acl`
--

INSERT INTO `user_acl` (`id`, `id_user`, `id_menu`, `create`, `read`, `update`, `delete`, `report`) VALUES
(1, 1, 1, 0, 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_group`
--

CREATE TABLE `user_group` (
  `id` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_group` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_group`
--

INSERT INTO `user_group` (`id`, `id_user`, `id_group`) VALUES
(1, 2, 1),
(2, 1, 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `group`
--
ALTER TABLE `group`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `group_acl`
--
ALTER TABLE `group_acl`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_group` (`id_group`),
  ADD KEY `id_menu` (`id_menu`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `user_acl`
--
ALTER TABLE `user_acl`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_menu` (`id_menu`);

--
-- Indexes for table `user_group`
--
ALTER TABLE `user_group`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_group` (`id_group`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `group`
--
ALTER TABLE `group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `group_acl`
--
ALTER TABLE `group_acl`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `user_acl`
--
ALTER TABLE `user_acl`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `user_group`
--
ALTER TABLE `user_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `group_acl`
--
ALTER TABLE `group_acl`
  ADD CONSTRAINT `group_acl_ibfk_1` FOREIGN KEY (`id_group`) REFERENCES `group` (`id`),
  ADD CONSTRAINT `group_acl_ibfk_2` FOREIGN KEY (`id_menu`) REFERENCES `menu` (`id`);

--
-- Constraints for table `user_acl`
--
ALTER TABLE `user_acl`
  ADD CONSTRAINT `user_acl_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `user_acl_ibfk_2` FOREIGN KEY (`id_menu`) REFERENCES `menu` (`id`);

--
-- Constraints for table `user_group`
--
ALTER TABLE `user_group`
  ADD CONSTRAINT `user_group_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `user_group_ibfk_2` FOREIGN KEY (`id_group`) REFERENCES `group` (`id`);
