CREATE DATABASE ONT;
CREATE TABLE `clients` ( `id` int(11) NOT NULL AUTO_INCREMENT, `name` text NOT NULL,  `phone` char(13) DEFAULT NULL,  `status` text NOT NULL,  `i_date` date NOT NULL,  PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=latin1
