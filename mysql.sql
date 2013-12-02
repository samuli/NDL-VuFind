--
-- Table structure for table `change_tracker`
--

CREATE TABLE `change_tracker` (
  `core` varchar(30) COLLATE utf8_swedish_ci NOT NULL,
  `id` varchar(64) COLLATE utf8_swedish_ci NOT NULL,
  `first_indexed` datetime DEFAULT NULL,
  `last_indexed` datetime DEFAULT NULL,
  `last_record_change` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`core`,`id`),
  KEY `deleted_index` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8_swedish_ci NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `visible` tinyint(1) DEFAULT '1',
  `rating` float DEFAULT NULL,
  `type` tinyint(1) NOT NULL,
  `updated` datetime DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `rating` (`rating`),
  KEY `visible` (`visible`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `comments_inappropriate`
--

CREATE TABLE `comments_inappropriate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `comment_id` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reason` varchar(1000) COLLATE utf8_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `comment_id` (`comment_id`),
  CONSTRAINT `comments_inappropriate_ibfk_2` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `comments_record`
--

CREATE TABLE `comments_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_id` varchar(255) NOT NULL,
  `comment_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `comment_id` (`comment_id`),
  KEY `key_record_id` (`record_id`(30)),
  CONSTRAINT `comments_record_ibfk_1` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

--
-- Table structure for table `due_date_reminder`
--

CREATE TABLE `due_date_reminder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `loan_id` varchar(255) COLLATE utf8_swedish_ci NOT NULL,
  `due_date` datetime NOT NULL,
  `notification_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `due_date_reminder_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `oai_resumption`
--

CREATE TABLE `oai_resumption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `params` text COLLATE utf8_swedish_ci,
  `expires` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `resource_id` int(11) NOT NULL DEFAULT '0',
  `rating` float DEFAULT NULL,
  `comment` text COLLATE utf8_swedish_ci,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `resource_id` (`resource_id`),
  CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `resource`
--

CREATE TABLE `resource` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_id` varchar(60) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `title` varchar(200) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `source` varchar(50) COLLATE utf8_swedish_ci NOT NULL DEFAULT 'VuFind',
  `data` blob,
  `title_sort` varchar(60) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `author_sort` varchar(60) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `date_sort` varchar(60) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `format_sort` varchar(60) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `record_id` (`record_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `resource_tags`
--

CREATE TABLE `resource_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL DEFAULT '0',
  `tag_id` int(11) NOT NULL DEFAULT '0',
  `list_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `posted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `resource_id` (`resource_id`),
  KEY `tag_id` (`tag_id`),
  KEY `list_id` (`list_id`),
  CONSTRAINT `resource_tags_ibfk_14` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resource_tags_ibfk_15` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE,
  CONSTRAINT `resource_tags_ibfk_16` FOREIGN KEY (`list_id`) REFERENCES `user_list` (`id`) ON DELETE SET NULL,
  CONSTRAINT `resource_tags_ibfk_17` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `search`
--

CREATE TABLE `search` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `session_id` varchar(128) COLLATE utf8_swedish_ci DEFAULT NULL,
  `folder_id` int(11) DEFAULT NULL,
  `created` date NOT NULL DEFAULT '0000-00-00',
  `title` varchar(20) COLLATE utf8_swedish_ci DEFAULT NULL,
  `saved` int(1) NOT NULL DEFAULT '0',
  `search_object` blob,
  `schedule` int(1) NOT NULL DEFAULT '0',
  `last_executed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `schedule_base_url` varchar(255) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `folder_id` (`folder_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `session`
--
CREATE TABLE `session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(128) COLLATE utf8_swedish_ci DEFAULT NULL,
  `data` text COLLATE utf8_swedish_ci,
  `last_used` int(12) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_id` (`session_id`),
  KEY `last_used` (`last_used`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `tags`
--

CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(25) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `password` varchar(32) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `firstname` varchar(50) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `lastname` varchar(50) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `email` varchar(250) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `cat_username` varchar(50) COLLATE utf8_swedish_ci DEFAULT NULL,
  `cat_password` varchar(50) COLLATE utf8_swedish_ci DEFAULT NULL,
  `college` varchar(100) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `major` varchar(100) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `home_library` varchar(100) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `language` varchar(30) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `due_date_notification` int(11) NOT NULL DEFAULT '0',
  `due_date_reminder` int(11) NOT NULL DEFAULT '0',
  `last_login` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `user_due_date_reminder_key` (`due_date_reminder`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `user_account`
--

CREATE TABLE `user_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `account_name` varchar(255) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `description` varchar(255) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `cat_username` varchar(50) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `cat_password` varchar(50) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `home_library` varchar(100) COLLATE utf8_swedish_ci NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `saved` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_account_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `user_list`
--

CREATE TABLE `user_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(200) COLLATE utf8_swedish_ci NOT NULL,
  `description` text COLLATE utf8_swedish_ci,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `public` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_list_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Table structure for table `user_resource`
--

CREATE TABLE `user_resource` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `list_id` int(11) DEFAULT NULL,
  `notes` text COLLATE utf8_swedish_ci,
  `saved` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `resource_id` (`resource_id`),
  KEY `user_id` (`user_id`),
  KEY `list_id` (`list_id`),
  CONSTRAINT `user_resource_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_resource_ibfk_2` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_resource_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_resource_ibfk_4` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_resource_ibfk_5` FOREIGN KEY (`list_id`) REFERENCES `user_list` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;