/*
SQLyog Community Edition- MySQL GUI v8.05 
MySQL - 5.5.37 : Database - wizzov14_wizzo_tax
*********************************************************************
*/
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;



/*Table structure for table `add_appointment` */

DROP TABLE IF EXISTS `add_appointment`;

CREATE TABLE `add_appointment` (
  `sino` int(11) NOT NULL,
  `token` int(11) DEFAULT NULL,
  `date1` datetime DEFAULT NULL,
  `d_name` varchar(100) DEFAULT NULL,
  `p_name` varchar(100) DEFAULT NULL,
  `p_id` int(11) DEFAULT NULL,
  `add1` varchar(100) DEFAULT NULL,
  `add2` varchar(100) DEFAULT NULL,
  `hep` int(11) DEFAULT NULL,
  `allergy` int(11) DEFAULT NULL,
  `hyper` int(11) DEFAULT NULL,
  `diabetics` int(11) DEFAULT NULL,
  `cardiac` int(11) DEFAULT NULL,
  `infection` int(11) DEFAULT NULL,
  `medication` int(11) DEFAULT NULL,
  `other` int(11) DEFAULT NULL,
  PRIMARY KEY (`sino`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `add_appointment` */

insert  into `add_appointment`(`sino`,`token`,`date1`,`d_name`,`p_name`,`p_id`,`add1`,`add2`,`hep`,`allergy`,`hyper`,`diabetics`,`cardiac`,`infection`,`medication`,`other`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `attendance_data` */

DROP TABLE IF EXISTS `attendance_data`;

CREATE TABLE `attendance_data` (
  `att_no` int(11) NOT NULL DEFAULT '0',
  `att_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `att_desc` varchar(150) NOT NULL DEFAULT 'NIL',
  `att_sino` int(11) NOT NULL DEFAULT '0',
  `emp_code` varchar(50) DEFAULT NULL,
  `emp_name` varchar(200) NOT NULL DEFAULT 'NIL',
  `hrs_work` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '0',
  `total` double NOT NULL DEFAULT '0',
  `net_total` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `attendance_data` */

insert  into `attendance_data`(`att_no`,`att_date`,`att_desc`,`att_sino`,`emp_code`,`emp_name`,`hrs_work`,`rate`,`total`,`net_total`) values (0,'2020-01-17 12:15:05','NIL',0,NULL,'NIL',0,0,0,0);

/*Table structure for table `audit_log` */

DROP TABLE IF EXISTS `audit_log`;

CREATE TABLE `audit_log` (
  `unique_id` int(30) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `partyname` varchar(255) CHARACTER SET utf8 NOT NULL,
  `data` text,
  PRIMARY KEY (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `audit_log` */

insert  into `audit_log`(`unique_id`,`date`,`partyname`,`data`) values (1,'2025-09-20 15:57:37','ABC CUSTOMER','{\"Bill No\":2 ,\"Si No\":0 ,\"amount\":0 ,\"NetTotal\":100 ,\"Employee\":\"NIL\",\"BillForm\":\"8\",\"Typ\":\"CUSTOMER\",\"godown\":\"MAIN\",\"bill_time\":\"03:56 pm\",\"status\":\"DELETE\"}'),(2,'2025-09-20 15:58:02','ABC CUSTOMER','{\"Bill No\":2 ,\"Si No\":0 ,\"amount\":0 ,\"NetTotal\":100 ,\"Employee\":\"NIL\",\"BillForm\":\"8\",\"Typ\":\"CUSTOMER\",\"godown\":\"MAIN\",\"bill_time\":\"03:56 pm\",\"status\":\"DELETE\"}'),(3,'2025-09-20 16:07:36','ABC CUSTOMER','{\"Bill No\":1 ,\"Si No\":0 ,\"amount\":0 ,\"NetTotal\":100 ,\"Employee\":\"NIL\",\"BillForm\":\"8\",\"Typ\":\"CUSTOMER\",\"godown\":\"MAIN\",\"bill_time\":\"03:31 pm\",\"status\":\"DELETE\"}'),(4,'2025-09-20 16:07:54','ABC PURCHASE PARTY','{\"Bill No\":1 ,\"Si No\":0 ,\"amount\":118 ,\"NetTotal\":0 ,\"Employee\":\"\",\"BillForm\":\"PURCHASE BILL\",\"Typ\":\"PURCHASE PARTY\",\"godown\":\"MAIN\",\"bill_time\":\"\",\"status\":\"DELETE\"}');

/*Table structure for table `barcode` */

DROP TABLE IF EXISTS `barcode`;

CREATE TABLE `barcode` (
  `ItemName` varchar(255) DEFAULT NULL,
  `NewBarNo` int(255) DEFAULT NULL,
  `NewBarText` varchar(255) DEFAULT NULL,
  `Typ` varchar(255) DEFAULT NULL,
  `BillNo` int(11) DEFAULT NULL,
  `Stat` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `barcode` */

insert  into `barcode`(`ItemName`,`NewBarNo`,`NewBarText`,`Typ`,`BillNo`,`Stat`) values (NULL,1019,NULL,NULL,6,NULL);

/*Table structure for table `batchwisereport` */

DROP TABLE IF EXISTS `batchwisereport`;

CREATE TABLE `batchwisereport` (
  `LoginId` varchar(100) NOT NULL,
  `LoginDate` datetime NOT NULL,
  `LoginTime` varchar(30) DEFAULT NULL,
  `OpCash` double DEFAULT NULL,
  `Sales` double DEFAULT NULL,
  `SReturn` double DEFAULT NULL,
  `NetSales` double DEFAULT NULL,
  `Actual` varchar(10) DEFAULT NULL,
  `BatchNo` varchar(30) NOT NULL DEFAULT '',
  `DiscAmt` double DEFAULT NULL,
  `CashAmtAct` double DEFAULT '0',
  `BankAmtAct` double DEFAULT '0',
  `SystemId` varchar(25) DEFAULT 'SYS1',
  `LogoutDate` datetime DEFAULT NULL,
  `LogoutTime` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`LoginId`,`LoginDate`,`BatchNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `batchwisereport` */

insert  into `batchwisereport`(`LoginId`,`LoginDate`,`LoginTime`,`OpCash`,`Sales`,`SReturn`,`NetSales`,`Actual`,`BatchNo`,`DiscAmt`,`CashAmtAct`,`BankAmtAct`,`SystemId`,`LogoutDate`,`LogoutTime`) values ('Admin','2025-09-20 00:00:00','11:11:33',0,NULL,NULL,NULL,NULL,'1.0',NULL,0,0,'SYS1',NULL,NULL);

/*Table structure for table `batchwisestock` */

DROP TABLE IF EXISTS `batchwisestock`;

CREATE TABLE `batchwisestock` (
  `item` varchar(255) NOT NULL DEFAULT 'NIL',
  `exp_date` date DEFAULT NULL,
  `batch_no` varchar(100) NOT NULL DEFAULT 'NIL',
  `curr_stk` double DEFAULT '0',
  `cost` double DEFAULT '0',
  `price` double DEFAULT '0',
  `godown` varchar(100) NOT NULL DEFAULT 'MAIN',
  PRIMARY KEY (`item`,`batch_no`,`godown`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `batchwisestock` */

/*Table structure for table `booking` */

DROP TABLE IF EXISTS `booking`;

CREATE TABLE `booking` (
  `auto_num` int(11) NOT NULL AUTO_INCREMENT,
  `inv_code` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `num` int(11) DEFAULT NULL,
  `shop_code` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `curr_date` datetime DEFAULT NULL,
  `del_date` datetime DEFAULT NULL,
  `del_time` time DEFAULT NULL,
  `trial_date` datetime DEFAULT NULL,
  `dead_date` datetime DEFAULT NULL,
  `fin_date` datetime DEFAULT NULL,
  `cust_name` varchar(70) CHARACTER SET utf8 DEFAULT NULL,
  `place` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `cust_id` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `phone_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `other` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `emp` varchar(70) CHARACTER SET utf8 DEFAULT NULL,
  `cut_master` varchar(70) CHARACTER SET utf8 DEFAULT NULL,
  `photo` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `total` double DEFAULT NULL,
  `add_amt` double DEFAULT NULL,
  `net_total` double DEFAULT NULL,
  `amt_rec` double DEFAULT NULL,
  `bal` double DEFAULT NULL,
  `media` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `tab1_data` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `tab2_data` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `tab3_data` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `tab4_data` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `rework` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `t1_cut_notes` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `t1_qty` double DEFAULT NULL,
  `t1_logo` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `t1_notes` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `t1_img1` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `t1_img2` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `t2_cut_notes` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `t2_qty` double DEFAULT NULL,
  `t2_logo` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `t2_notes` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `t2_img1` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `t2_img2` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `t3_cut_notes` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `t3_qty` double DEFAULT NULL,
  `t3_logo` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `t3_notes` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `t3_img1` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `t3_img2` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `t4_cut_notes` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `t4_qty` double DEFAULT NULL,
  `t4_logo` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `t4_notes` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `t4_img1` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `t4_img2` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `cut_date` datetime DEFAULT NULL,
  `stat` int(11) DEFAULT '0',
  PRIMARY KEY (`auto_num`),
  UNIQUE KEY `num` (`auto_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC;

/*Data for the table `booking` */

/*Table structure for table `booking_jtable` */

DROP TABLE IF EXISTS `booking_jtable`;

CREATE TABLE `booking_jtable` (
  `num` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(50) DEFAULT NULL,
  `si` int(5) DEFAULT NULL,
  `products` varchar(70) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `total` double DEFAULT NULL,
  `date1` datetime DEFAULT NULL,
  `order_type` varchar(200) DEFAULT NULL,
  `stat` double DEFAULT '0',
  PRIMARY KEY (`num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `booking_jtable` */

/*Table structure for table `bulkinvoice_table` */

DROP TABLE IF EXISTS `bulkinvoice_table`;

CREATE TABLE `bulkinvoice_table` (
  `entry_no` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `net_qty` double DEFAULT NULL,
  `net_total` double DEFAULT NULL,
  `sino` int(11) DEFAULT NULL,
  `party_name` varchar(255) DEFAULT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `total` double DEFAULT NULL,
  `typ` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `bulkinvoice_table` */

insert  into `bulkinvoice_table`(`entry_no`,`date`,`net_qty`,`net_total`,`sino`,`party_name`,`item_name`,`qty`,`rate`,`total`,`typ`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `buyerspending_table` */

DROP TABLE IF EXISTS `buyerspending_table`;

CREATE TABLE `buyerspending_table` (
  `sino` int(11) DEFAULT NULL,
  `billno` int(11) DEFAULT '0',
  `bill_date` datetime DEFAULT NULL,
  `party_name` varchar(255) DEFAULT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `actual_qty` double DEFAULT NULL,
  `pur_qty` double DEFAULT NULL,
  `pur_price` double DEFAULT NULL,
  `total` double DEFAULT NULL,
  `cash_paid` double DEFAULT NULL,
  `curr_price` double DEFAULT NULL,
  `balance_stock` double DEFAULT NULL,
  `balance_amt` double DEFAULT NULL,
  `rec_no` int(11) DEFAULT '0',
  `unq_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`unq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `buyerspending_table` */

/*Table structure for table `checkatt` */

DROP TABLE IF EXISTS `checkatt`;

CREATE TABLE `checkatt` (
  `Date1` datetime NOT NULL,
  PRIMARY KEY (`Date1`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `checkatt` */

/*Table structure for table `checkpcswage` */

DROP TABLE IF EXISTS `checkpcswage`;

CREATE TABLE `checkpcswage` (
  `PcsWagesDate` datetime NOT NULL,
  PRIMARY KEY (`PcsWagesDate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `checkpcswage` */

/*Table structure for table `clearance_entry_table` */

DROP TABLE IF EXISTS `clearance_entry_table`;

CREATE TABLE `clearance_entry_table` (
  `sino` int(22) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `party` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `order_paid` double DEFAULT NULL,
  `amt_clr_1` double DEFAULT NULL,
  `amt_clr_2` double DEFAULT NULL,
  `balance` double DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `amt_sr` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `clearance_entry_table` */

insert  into `clearance_entry_table`(`sino`,`date`,`party`,`notes`,`order_paid`,`amt_clr_1`,`amt_clr_2`,`balance`,`rate`,`amt_sr`) values (1,NULL,'','',0,0,0,0,0,0);

/*Table structure for table `collection` */

DROP TABLE IF EXISTS `collection`;

CREATE TABLE `collection` (
  `BillNo` int(11) DEFAULT NULL,
  `TransactionType` varchar(50) DEFAULT NULL,
  `SiNo` int(11) DEFAULT NULL,
  `Date1` datetime DEFAULT NULL,
  `PartyName` varchar(255) DEFAULT NULL,
  `Amount` double DEFAULT NULL,
  `NetTotal` double DEFAULT NULL,
  `ChequeNo` varchar(50) DEFAULT NULL,
  `Narration` varchar(255) DEFAULT NULL,
  `Employee` varchar(150) DEFAULT NULL,
  `Typ` varchar(255) DEFAULT NULL,
  `BillForm` varchar(255) DEFAULT NULL,
  `Stat` int(11) DEFAULT NULL,
  `CashFlow` varchar(255) DEFAULT NULL,
  `godown` varchar(255) DEFAULT NULL,
  `local_app_user_entry_id` varchar(100) DEFAULT NULL,
  `image_data` text,
  `bill_time` varchar(10) DEFAULT NULL,
  `Reminder` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `RetNo` varchar(100) DEFAULT '0',
  `uniqueId` int(11) NOT NULL AUTO_INCREMENT,
  `TaxP` double NOT NULL DEFAULT '0',
  `TaxAmt` double NOT NULL DEFAULT '0',
  `Code1` int(11) DEFAULT NULL,
  `TaxBillNo` int(11) DEFAULT '0',
  `fin_year` varchar(25) DEFAULT '0',
  `prefix` varchar(50) DEFAULT '',
  PRIMARY KEY (`uniqueId`)
) ENGINE=MyISAM AUTO_INCREMENT=11881 DEFAULT CHARSET=utf8;

/*Data for the table `collection` */

insert  into `collection`(`BillNo`,`TransactionType`,`SiNo`,`Date1`,`PartyName`,`Amount`,`NetTotal`,`ChequeNo`,`Narration`,`Employee`,`Typ`,`BillForm`,`Stat`,`CashFlow`,`godown`,`local_app_user_entry_id`,`image_data`,`bill_time`,`Reminder`,`RetNo`,`uniqueId`,`TaxP`,`TaxAmt`,`Code1`,`TaxBillNo`,`fin_year`,`prefix`) values (0,'Cash',0,NULL,'NIL',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2021-05-17 17:55:22','0',11661,0,0,NULL,0,'0',''),(NULL,'Opening',NULL,'2025-09-20 00:00:00','ABC PURCHASE PARTY',0,0,NULL,NULL,'NIL','PURCHASE PARTY',NULL,1,NULL,NULL,NULL,NULL,NULL,'2025-09-20 12:23:44','0',11876,0,0,NULL,0,'0','');

/*Table structure for table `collsino` */

DROP TABLE IF EXISTS `collsino`;

CREATE TABLE `collsino` (
  `sino` varchar(255) NOT NULL,
  PRIMARY KEY (`sino`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `collsino` */

/*Table structure for table `company` */

DROP TABLE IF EXISTS `company`;

CREATE TABLE `company` (
  `Name` varchar(50) DEFAULT NULL,
  `Place` varchar(50) DEFAULT NULL,
  `Add1` varchar(200) DEFAULT NULL,
  `Add2` varchar(200) DEFAULT NULL,
  `Ph` varchar(50) DEFAULT NULL,
  `Postal` varchar(50) DEFAULT NULL,
  `Country` varchar(50) DEFAULT NULL,
  `Web` varchar(50) DEFAULT NULL,
  `EMail` varchar(50) DEFAULT NULL,
  `Rs` varchar(100) DEFAULT NULL,
  `Sr` varchar(100) DEFAULT NULL,
  `company_details` text,
  `identific_no` varchar(100) DEFAULT '0',
  `city_name` varchar(200) DEFAULT 'city',
  `post_code` varchar(100) DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `company` */

insert  into `company`(`Name`,`Place`,`Add1`,`Add2`,`Ph`,`Postal`,`Country`,`Web`,`EMail`,`Rs`,`Sr`,`company_details`,`identific_no`,`city_name`,`post_code`) values ('COM NAME','ADD 1','ADD2','GST','','','CRN','','','18.5','0.069','','43','','');

/*Table structure for table `cus_sticker_master` */

DROP TABLE IF EXISTS `cus_sticker_master`;

CREATE TABLE `cus_sticker_master` (
  `sino` int(22) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `weight` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `mrp` double DEFAULT NULL,
  `pack_date` datetime DEFAULT NULL,
  `barcode` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `branch` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `des` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `incredients` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `cus_sticker_master` */

insert  into `cus_sticker_master`(`sino`,`date`,`weight`,`mrp`,`pack_date`,`barcode`,`branch`,`des`,`incredients`,`name`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `cus_sticker_table` */

DROP TABLE IF EXISTS `cus_sticker_table`;

CREATE TABLE `cus_sticker_table` (
  `id` int(22) DEFAULT NULL,
  `sino` int(22) DEFAULT NULL,
  `nutritions` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `val` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `cus_sticker_table` */

/*Table structure for table `dailysalatt` */

DROP TABLE IF EXISTS `dailysalatt`;

CREATE TABLE `dailysalatt` (
  `SiNo` int(11) DEFAULT '0',
  `Staff` varchar(50) DEFAULT NULL,
  `Wages` double DEFAULT '0',
  `Worked` varchar(50) DEFAULT NULL,
  `Detail` varchar(50) DEFAULT NULL,
  `Date1` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `dailysalatt` */

/*Table structure for table `damagemaster` */

DROP TABLE IF EXISTS `damagemaster`;

CREATE TABLE `damagemaster` (
  `Stock_No` int(11) NOT NULL DEFAULT '0',
  `Date1` datetime DEFAULT NULL,
  `Descri` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `TotalQty` double NOT NULL DEFAULT '0',
  `NetTotal` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`Stock_No`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `damagemaster` */

insert  into `damagemaster`(`Stock_No`,`Date1`,`Descri`,`TotalQty`,`NetTotal`) values (0,NULL,NULL,0,0);

/*Table structure for table `damagetable` */

DROP TABLE IF EXISTS `damagetable`;

CREATE TABLE `damagetable` (
  `SiNo` int(11) NOT NULL DEFAULT '0',
  `Barcode` varchar(255) NOT NULL DEFAULT '0',
  `ItemName` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `Qty` double NOT NULL DEFAULT '0',
  `Rate` double NOT NULL DEFAULT '0',
  `Total` double NOT NULL DEFAULT '0',
  `ExpiryDate` date DEFAULT NULL,
  `Warhouse` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `Inv_no` int(11) DEFAULT NULL,
  `Date1` datetime DEFAULT NULL,
  `Pack` int(11) DEFAULT '1',
  `Unit` varchar(30) DEFAULT 'Pcs',
  `batch_no` varchar(100) DEFAULT 'NIL'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `damagetable` */

/*Table structure for table `dbinfo` */

DROP TABLE IF EXISTS `dbinfo`;

CREATE TABLE `dbinfo` (
  `DatabaseName` varchar(100) DEFAULT NULL,
  `FinancialYear` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `dbinfo` */

/*Table structure for table `dblogger` */

DROP TABLE IF EXISTS `dblogger`;

CREATE TABLE `dblogger` (
  `id` varchar(100) DEFAULT NULL,
  `localtablename` varchar(100) DEFAULT NULL,
  `onlinetablename` varchar(100) DEFAULT NULL,
  `columnkey` varchar(100) DEFAULT NULL,
  `columnvalue` varchar(100) DEFAULT NULL,
  `rowstatus` varchar(60) DEFAULT NULL,
  `logger_id` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `dblogger` */

/*Table structure for table `dc_master` */

DROP TABLE IF EXISTS `dc_master`;

CREATE TABLE `dc_master` (
  `billNo` int(11) NOT NULL,
  `billDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `billRefNo` varchar(20) DEFAULT '0',
  `party` varchar(250) DEFAULT NULL,
  `partyTyp` varchar(20) DEFAULT NULL,
  `descr` varchar(250) DEFAULT NULL,
  `netQty` double DEFAULT '0',
  `netAmount` double DEFAULT '0',
  `otherCharge` double DEFAULT '0',
  `reccharge` double DEFAULT '0',
  `balance` double DEFAULT '0',
  `discount` double DEFAULT '0',
  `delivery_date` timestamp NULL DEFAULT NULL,
  `batch_no` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`billNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `dc_master` */

insert  into `dc_master`(`billNo`,`billDate`,`billRefNo`,`party`,`partyTyp`,`descr`,`netQty`,`netAmount`,`otherCharge`,`reccharge`,`balance`,`discount`,`delivery_date`,`batch_no`) values (0,'2019-08-06 14:43:42','0',NULL,NULL,NULL,0,0,0,0,0,0,NULL,NULL);

/*Table structure for table `dc_table` */

DROP TABLE IF EXISTS `dc_table`;

CREATE TABLE `dc_table` (
  `billNo` int(11) DEFAULT NULL,
  `siNo` int(11) DEFAULT NULL,
  `itemC` varchar(150) DEFAULT NULL,
  `itemName` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `qty` double DEFAULT '0',
  `rate` double DEFAULT '0',
  `amount` double DEFAULT '0',
  `pack` int(11) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `billTyp` varchar(50) DEFAULT NULL,
  `dc_date` datetime DEFAULT NULL,
  `dc_key` varchar(250) DEFAULT NULL,
  `warehouse` varchar(250) DEFAULT NULL,
  `tot_days` double DEFAULT '0',
  `batch_no` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `dc_table` */

/*Table structure for table `dcmasterdetails` */

DROP TABLE IF EXISTS `dcmasterdetails`;

CREATE TABLE `dcmasterdetails` (
  `BillNo` int(11) NOT NULL DEFAULT '0',
  `BillDate` datetime DEFAULT NULL,
  `BillPartyName` varchar(50) DEFAULT NULL,
  `BillTotalField` double DEFAULT '0',
  `BillDiscAmtField` double DEFAULT '0',
  `BillDiscPercField` double DEFAULT '0',
  `BillTaxField` double DEFAULT '0',
  `BillPackageField` double DEFAULT '0',
  `BillNetTotalField` double DEFAULT '0',
  `BillTyp` varchar(50) DEFAULT NULL,
  `BillTime` datetime DEFAULT NULL,
  `OrderNo` double DEFAULT '0',
  `TDiscAmt` double DEFAULT '0',
  `TaxAmt` double DEFAULT '0',
  `Status1` int(11) DEFAULT '0',
  `TotItWiseDisc` double DEFAULT '0',
  `TotItWiseTot` double DEFAULT '0',
  `Lorry` varchar(50) DEFAULT NULL,
  `DCNoTax` double DEFAULT '0',
  `TotDiscPercAmt` double DEFAULT '0',
  `CessP` double DEFAULT '0',
  `CessA` double DEFAULT '0',
  `TotItWiseQty` double DEFAULT '0',
  PRIMARY KEY (`BillNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `dcmasterdetails` */

insert  into `dcmasterdetails`(`BillNo`,`BillDate`,`BillPartyName`,`BillTotalField`,`BillDiscAmtField`,`BillDiscPercField`,`BillTaxField`,`BillPackageField`,`BillNetTotalField`,`BillTyp`,`BillTime`,`OrderNo`,`TDiscAmt`,`TaxAmt`,`Status1`,`TotItWiseDisc`,`TotItWiseTot`,`Lorry`,`DCNoTax`,`TotDiscPercAmt`,`CessP`,`CessA`,`TotItWiseQty`) values (0,NULL,NULL,0,0,0,0,0,0,NULL,NULL,0,0,0,0,0,0,NULL,0,0,0,0,0);

/*Table structure for table `dcsalesbill` */

DROP TABLE IF EXISTS `dcsalesbill`;

CREATE TABLE `dcsalesbill` (
  `BillNo` int(11) DEFAULT '0',
  `SiNo` int(11) DEFAULT '0',
  `ItemC` varchar(50) DEFAULT NULL,
  `Item` varchar(50) DEFAULT NULL,
  `Qty` double DEFAULT '0',
  `Rate` double DEFAULT '0',
  `Dis` double DEFAULT '0',
  `Tot` int(11) DEFAULT '0',
  `TaxP` int(11) DEFAULT '0',
  `TaxA` int(11) DEFAULT '0',
  `Total` double DEFAULT '0',
  `GoodsOn` varchar(50) DEFAULT NULL,
  `SBDate` datetime DEFAULT NULL,
  `Cst` double DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `dcsalesbill` */

/*Table structure for table `deleted_bill` */

DROP TABLE IF EXISTS `deleted_bill`;

CREATE TABLE `deleted_bill` (
  `inv` int(11) NOT NULL,
  `date1` datetime DEFAULT NULL,
  `party_name` varchar(100) DEFAULT NULL,
  `item` varchar(100) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `total` double DEFAULT NULL,
  `status1` varchar(30) DEFAULT NULL,
  `si_no` int(11) DEFAULT NULL,
  `update_delete` varchar(30) DEFAULT NULL,
  `old_new` varchar(10) DEFAULT NULL,
  `bill_time` varchar(10) DEFAULT NULL,
  `emp_name` varchar(25) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `deleted_bill` */

insert  into `deleted_bill`(`inv`,`date1`,`party_name`,`item`,`qty`,`rate`,`total`,`status1`,`si_no`,`update_delete`,`old_new`,`bill_time`,`emp_name`) values (0,'2025-09-20 00:00:00',NULL,NULL,0,NULL,0,'master',NULL,'UPDATE','OLD',NULL,NULL),(0,'2025-09-20 00:00:00',NULL,NULL,0,NULL,0,'master',NULL,'UPDATE','NEW',NULL,NULL),(0,'2025-09-20 00:00:00',NULL,NULL,0,NULL,0,'master',NULL,'UPDATE','OLD',NULL,NULL),(0,'2025-09-20 00:00:00',NULL,NULL,0,NULL,0,'master',NULL,'UPDATE','NEW',NULL,NULL),(2,'2025-09-20 00:00:00','ABC CUSTOMER',NULL,5,NULL,100,'master',NULL,'DELETE','OLD',NULL,NULL),(2,NULL,NULL,'TEST',5,20,100,'8',NULL,'DELETE','OLD',NULL,NULL),(2,'2025-09-20 00:00:00','ABC CUSTOMER',NULL,5,NULL,100,'master',NULL,'DELETE','OLD',NULL,NULL),(2,NULL,NULL,'TEST',5,20,100,'8',NULL,'DELETE','OLD',NULL,NULL),(1,'2025-09-20 00:00:00','ABC CUSTOMER',NULL,5,NULL,100,'master',NULL,'DELETE','OLD',NULL,NULL),(1,NULL,NULL,'TEST',5,20,100,'8',NULL,'DELETE','OLD',NULL,NULL);

/*Table structure for table `delivery_master` */

DROP TABLE IF EXISTS `delivery_master`;

CREATE TABLE `delivery_master` (
  `BillNo` int(11) NOT NULL DEFAULT '0',
  `BillDate` datetime DEFAULT NULL,
  `BillPartyName` varchar(50) DEFAULT NULL,
  `BillTotalField` double DEFAULT '0',
  `BillDiscAmtField` double DEFAULT '0',
  `BillDiscPercField` double DEFAULT '0',
  `BillTaxField` double DEFAULT '0',
  `BillPackageField` double DEFAULT '0',
  `BillNetTotalField` double DEFAULT '0',
  `BillTyp` varchar(50) DEFAULT NULL,
  `BillTime` varchar(30) DEFAULT NULL,
  `OrderNo` double DEFAULT '0',
  `TDiscAmt` double DEFAULT '0',
  `TaxAmt` double DEFAULT '0',
  `DCBillNo` varchar(255) DEFAULT NULL,
  `TItTaxAmt` double DEFAULT '0',
  `TAmt` double DEFAULT '0',
  `Cess` double DEFAULT '0',
  `Lorry` varchar(50) DEFAULT NULL,
  `DCNoTax` double DEFAULT '0',
  `TotDiscPercAmt` double DEFAULT '0',
  `CessP` double DEFAULT '0',
  `TotItWiseQty1` double DEFAULT '0',
  `CashP` varchar(100) DEFAULT NULL,
  `CashCard` varchar(255) DEFAULT NULL,
  `CashCardAmt` varchar(255) DEFAULT NULL,
  `godown` varchar(255) DEFAULT NULL,
  `warranty` varchar(255) DEFAULT NULL,
  `del_date` datetime DEFAULT NULL,
  `advance` double DEFAULT '0',
  `sino` int(11) DEFAULT '0',
  `local_app_user_entry_id` varchar(100) DEFAULT 'NIL',
  `EmpCode` varchar(30) DEFAULT '0',
  `SystemId` varchar(30) DEFAULT NULL,
  `HldingStatus` int(11) DEFAULT NULL,
  `BatchNo` double DEFAULT '0',
  `cst_id` varchar(255) DEFAULT 'NIL',
  `ReceiptType` varchar(50) DEFAULT 'Cash',
  PRIMARY KEY (`BillNo`),
  UNIQUE KEY `BillNo` (`BillNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `delivery_master` */

insert  into `delivery_master`(`BillNo`,`BillDate`,`BillPartyName`,`BillTotalField`,`BillDiscAmtField`,`BillDiscPercField`,`BillTaxField`,`BillPackageField`,`BillNetTotalField`,`BillTyp`,`BillTime`,`OrderNo`,`TDiscAmt`,`TaxAmt`,`DCBillNo`,`TItTaxAmt`,`TAmt`,`Cess`,`Lorry`,`DCNoTax`,`TotDiscPercAmt`,`CessP`,`TotItWiseQty1`,`CashP`,`CashCard`,`CashCardAmt`,`godown`,`warranty`,`del_date`,`advance`,`sino`,`local_app_user_entry_id`,`EmpCode`,`SystemId`,`HldingStatus`,`BatchNo`,`cst_id`,`ReceiptType`) values (0,NULL,NULL,0,0,0,0,0,0,NULL,NULL,0,0,0,NULL,0,0,0,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'NIL','0',NULL,NULL,0,'NIL','Cash');

/*Table structure for table `doctor_master` */

DROP TABLE IF EXISTS `doctor_master`;

CREATE TABLE `doctor_master` (
  `d_name` varchar(150) NOT NULL,
  `h_name` varchar(100) DEFAULT NULL,
  `address1` varchar(100) DEFAULT NULL,
  `gender` varchar(30) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `email` varchar(20) DEFAULT NULL,
  `qualification` varchar(50) DEFAULT NULL,
  `spl` varchar(100) DEFAULT NULL,
  `fees` double DEFAULT '0',
  PRIMARY KEY (`d_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `doctor_master` */

/*Table structure for table `employee_master` */

DROP TABLE IF EXISTS `employee_master`;

CREATE TABLE `employee_master` (
  `emp_id` int(11) NOT NULL AUTO_INCREMENT,
  `file_no` int(11) DEFAULT NULL,
  `emp_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `nationality` varchar(255) DEFAULT NULL,
  `job_title` varchar(255) DEFAULT NULL,
  `join_date` datetime DEFAULT NULL,
  `proj_name` varchar(255) DEFAULT NULL,
  `proj_code` varchar(255) DEFAULT NULL,
  `supplier_name` varchar(255) DEFAULT NULL,
  `worker_status` varchar(255) DEFAULT NULL,
  `iqama` varchar(255) DEFAULT NULL,
  `iqama_expires` datetime DEFAULT NULL,
  `iqama_profession` varchar(255) DEFAULT NULL,
  `passport` varchar(255) DEFAULT NULL,
  `pass_expires` datetime DEFAULT NULL,
  `basic_salary` double DEFAULT NULL,
  `housing` double DEFAULT NULL,
  `transportation` double DEFAULT NULL,
  `food` double DEFAULT NULL,
  `other` double DEFAULT NULL,
  `total` double DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `personal_email` varchar(200) DEFAULT NULL,
  `emergency_contact` varchar(255) DEFAULT NULL,
  `education` varchar(255) DEFAULT NULL,
  `dob` datetime DEFAULT NULL,
  `bank` varchar(200) DEFAULT NULL,
  `iban` varchar(200) DEFAULT NULL,
  `contract_duration` varchar(200) DEFAULT NULL,
  `vacation` varchar(200) DEFAULT NULL,
  `service_amt` double DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `supplier_code` varchar(150) DEFAULT NULL,
  `mobile` varchar(200) DEFAULT NULL,
  `gender` varchar(250) DEFAULT NULL,
  `mob_alow` double DEFAULT NULL,
  `fix_alow` double DEFAULT NULL,
  `remote_alow` double DEFAULT NULL,
  `shift_alow` double DEFAULT NULL,
  `ticket_alow` double DEFAULT NULL,
  `border_no` int(11) DEFAULT NULL,
  `sector` varchar(255) DEFAULT NULL,
  `insurance` varchar(255) DEFAULT NULL,
  `residency` varchar(255) DEFAULT NULL,
  `loan` double DEFAULT NULL,
  PRIMARY KEY (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `employee_master` */

/*Table structure for table `enquiry` */

DROP TABLE IF EXISTS `enquiry`;

CREATE TABLE `enquiry` (
  `enq_no` int(11) NOT NULL AUTO_INCREMENT,
  `product` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `enq_date` datetime DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `image` text,
  `diamondwt` double DEFAULT '0',
  `grosswt` double DEFAULT '0',
  PRIMARY KEY (`enq_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `enquiry` */

/*Table structure for table `expiry_table` */

DROP TABLE IF EXISTS `expiry_table`;

CREATE TABLE `expiry_table` (
  `descrip` varchar(255) DEFAULT NULL,
  `typ` varchar(255) DEFAULT NULL,
  `exp_date` datetime DEFAULT NULL,
  `LedgerName` varchar(255) DEFAULT NULL,
  `CareOf` varchar(255) DEFAULT NULL,
  `Amount` double DEFAULT NULL,
  `Stat` int(11) DEFAULT NULL,
  `Uniq_Id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_typ` varchar(10) DEFAULT 'Others',
  UNIQUE KEY `Uniq_Id` (`Uniq_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `expiry_table` */

/*Table structure for table `finsavdmatcnsmtion` */

DROP TABLE IF EXISTS `finsavdmatcnsmtion`;

CREATE TABLE `finsavdmatcnsmtion` (
  `QNo` int(11) DEFAULT '0',
  `Prod_Nam` varchar(50) DEFAULT NULL,
  `SiNo` int(11) DEFAULT '0',
  `MatNam` varchar(50) DEFAULT NULL,
  `Typ` varchar(50) DEFAULT NULL,
  `OneMtArea` varchar(50) DEFAULT NULL,
  `TotArea` varchar(50) DEFAULT NULL,
  `Qty` double DEFAULT '0',
  `Unit1` varchar(50) DEFAULT NULL,
  `Date1` datetime DEFAULT NULL,
  `Cst` double DEFAULT '0',
  `BigUnit` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `finsavdmatcnsmtion` */

/*Table structure for table `finshedsavedgoods` */

DROP TABLE IF EXISTS `finshedsavedgoods`;

CREATE TABLE `finshedsavedgoods` (
  `PNo` int(11) NOT NULL DEFAULT '0',
  `NoOfProd` int(11) DEFAULT '0',
  `PName` varchar(50) DEFAULT NULL,
  `Date1` datetime DEFAULT NULL,
  PRIMARY KEY (`PNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `finshedsavedgoods` */

/*Table structure for table `formula_jtable` */

DROP TABLE IF EXISTS `formula_jtable`;

CREATE TABLE `formula_jtable` (
  `fBillNo` int(11) DEFAULT '0',
  `si_no` int(11) DEFAULT '0',
  `rowMaterials` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `qty` double DEFAULT '0',
  `cost` double DEFAULT '0',
  `total` double DEFAULT '0',
  `wastage` double DEFAULT '0',
  `perValue` double DEFAULT '0',
  `date1` datetime DEFAULT NULL,
  `finishedGoods` varchar(100) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `formula_jtable` */

/*Table structure for table `formula_master` */

DROP TABLE IF EXISTS `formula_master`;

CREATE TABLE `formula_master` (
  `fBillNo` int(11) NOT NULL DEFAULT '0',
  `finishedGoods` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `qty` double DEFAULT '0',
  `date1` datetime DEFAULT NULL,
  `description` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `net_qty` double DEFAULT '0',
  `net_total` double DEFAULT '0',
  `piece_rate` double DEFAULT '0',
  PRIMARY KEY (`fBillNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `formula_master` */

insert  into `formula_master`(`fBillNo`,`finishedGoods`,`qty`,`date1`,`description`,`net_qty`,`net_total`,`piece_rate`) values (0,NULL,0,NULL,NULL,0,0,0);

/*Table structure for table `formula_tbl` */

DROP TABLE IF EXISTS `formula_tbl`;

CREATE TABLE `formula_tbl` (
  `test_name` varchar(255) DEFAULT NULL,
  `sub_name` varchar(255) DEFAULT NULL,
  `formula` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `formula_tbl` */

/*Table structure for table `godown_trans` */

DROP TABLE IF EXISTS `godown_trans`;

CREATE TABLE `godown_trans` (
  `vcr_no` int(11) DEFAULT '0',
  `sino` int(11) DEFAULT '0',
  `date1` datetime DEFAULT NULL,
  `itemc` varchar(50) DEFAULT NULL,
  `item` varchar(255) DEFAULT NULL,
  `qty` double DEFAULT '0',
  `rate` double DEFAULT '0',
  `total` double DEFAULT '0',
  `src` varchar(255) DEFAULT '0',
  `dest` varchar(255) DEFAULT '0',
  `tax_percent` double DEFAULT '0',
  `pack` double DEFAULT NULL,
  `unit` varchar(10) DEFAULT NULL,
  `net_total` double NOT NULL DEFAULT '0',
  `batch_no` varchar(100) DEFAULT 'NIL',
  `expiry` date NOT NULL DEFAULT '2020-01-01'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `godown_trans` */

insert  into `godown_trans`(`vcr_no`,`sino`,`date1`,`itemc`,`item`,`qty`,`rate`,`total`,`src`,`dest`,`tax_percent`,`pack`,`unit`,`net_total`,`batch_no`,`expiry`) values (0,0,NULL,NULL,NULL,0,0,0,'0','0',0,NULL,NULL,0,'NIL','2020-01-01');

/*Table structure for table `godown_wise_stock` */

DROP TABLE IF EXISTS `godown_wise_stock`;

CREATE TABLE `godown_wise_stock` (
  `Item` varchar(100) CHARACTER SET utf8 NOT NULL,
  `godown` varchar(100) CHARACTER SET utf8 NOT NULL,
  `qty` double DEFAULT NULL,
  `cst` double DEFAULT '0',
  `it_unit` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT 'NIL',
  `it_pack` double DEFAULT '0',
  PRIMARY KEY (`Item`,`godown`,`it_unit`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Data for the table `godown_wise_stock` */

/*Table structure for table `godownsalesitem` */

DROP TABLE IF EXISTS `godownsalesitem`;

CREATE TABLE `godownsalesitem` (
  `invoice` int(11) NOT NULL,
  `sino` int(11) NOT NULL,
  `sino2` int(11) NOT NULL,
  `item` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `warehouse` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `unit` varchar(30) DEFAULT NULL,
  `pack` int(11) DEFAULT NULL,
  `BillForm` varchar(30) NOT NULL,
  PRIMARY KEY (`invoice`,`sino`,`sino2`,`BillForm`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `godownsalesitem` */

/*Table structure for table `hold_master_tbl` */

DROP TABLE IF EXISTS `hold_master_tbl`;

CREATE TABLE `hold_master_tbl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `party` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `item` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `unit` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `slno` int(11) DEFAULT NULL,
  `emp` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `date1` datetime DEFAULT NULL,
  `bill_tot` double DEFAULT NULL,
  `items_tot` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_party_item` (`party`,`item`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `hold_master_tbl` */

/*Table structure for table `hospital_master` */

DROP TABLE IF EXISTS `hospital_master`;

CREATE TABLE `hospital_master` (
  `name1` varchar(150) DEFAULT NULL,
  `add1` varchar(500) DEFAULT NULL,
  `add2` varchar(500) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `hospital_master` */

/*Table structure for table `hr_jtable` */

DROP TABLE IF EXISTS `hr_jtable`;

CREATE TABLE `hr_jtable` (
  `bill_no` int(11) DEFAULT NULL,
  `si_no` int(11) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `emp_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `date_frm` datetime DEFAULT NULL,
  `date_to` datetime DEFAULT NULL,
  `tot_datys` int(11) DEFAULT NULL,
  `loan` double DEFAULT NULL,
  `tot_salary` double DEFAULT NULL,
  `gosi` double DEFAULT NULL,
  `vacation_accural` double DEFAULT NULL,
  `esb` double DEFAULT NULL,
  `service_fee_due` double DEFAULT NULL,
  `net_salary_paid` double DEFAULT NULL,
  `charges_no_vat` double DEFAULT NULL,
  `vat_applicable_fee` double DEFAULT NULL,
  `vat_amt` double DEFAULT NULL,
  `vat_tot` double DEFAULT NULL,
  `bonus` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `hr_jtable` */

/*Table structure for table `hr_master` */

DROP TABLE IF EXISTS `hr_master`;

CREATE TABLE `hr_master` (
  `bill_no` int(11) DEFAULT NULL,
  `party_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `vat_no` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `due_date` datetime DEFAULT NULL,
  `bill_loan_tot` double DEFAULT NULL,
  `bill_salary_tot` double DEFAULT NULL,
  `bill_gosi_tot` double DEFAULT NULL,
  `bill_vac_acu_tot` double DEFAULT NULL,
  `bill_esb_tot` double DEFAULT NULL,
  `bill_servicefee_due_tot` double DEFAULT NULL,
  `bill_net_sal_paid_tot` double DEFAULT NULL,
  `bill_chargeno_vat_tot` double DEFAULT NULL,
  `bill_vat_app_fee_tot` double DEFAULT NULL,
  `bill_vat_amt_tot` double DEFAULT NULL,
  `bill_vat_tot` double DEFAULT NULL,
  `net_tax_amt` double DEFAULT NULL,
  `net_tax_exepmt_amt` double DEFAULT NULL,
  `net_dis_amt` double DEFAULT NULL,
  `net_after_dis` double DEFAULT NULL,
  `net_vat` double DEFAULT NULL,
  `net_customer_amt_due` double DEFAULT NULL,
  `net_loan_amt` double DEFAULT NULL,
  `net_inv_after_loan` double DEFAULT NULL,
  `godown` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `proj_code` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `inv_type` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `sup_date` datetime DEFAULT NULL,
  `staff` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `bill_net_bonus` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `hr_master` */

insert  into `hr_master`(`bill_no`,`party_name`,`vat_no`,`date`,`due_date`,`bill_loan_tot`,`bill_salary_tot`,`bill_gosi_tot`,`bill_vac_acu_tot`,`bill_esb_tot`,`bill_servicefee_due_tot`,`bill_net_sal_paid_tot`,`bill_chargeno_vat_tot`,`bill_vat_app_fee_tot`,`bill_vat_amt_tot`,`bill_vat_tot`,`net_tax_amt`,`net_tax_exepmt_amt`,`net_dis_amt`,`net_after_dis`,`net_vat`,`net_customer_amt_due`,`net_loan_amt`,`net_inv_after_loan`,`godown`,`proj_code`,`inv_type`,`sup_date`,`staff`,`bill_net_bonus`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `in_trans` */

DROP TABLE IF EXISTS `in_trans`;

CREATE TABLE `in_trans` (
  `id` int(11) NOT NULL,
  `itemname` varchar(50) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `total` double DEFAULT NULL,
  `party` varchar(50) DEFAULT NULL,
  `net_qty` double DEFAULT NULL,
  `net_amnt` double DEFAULT NULL,
  `godown` varchar(50) DEFAULT NULL,
  `employee` varchar(50) DEFAULT NULL,
  `date1` datetime DEFAULT NULL,
  `inv_no` int(11) DEFAULT NULL,
  `upload_status` varchar(50) DEFAULT 'pending',
  `local_app_user_entry_id` varchar(50) DEFAULT NULL,
  `credit` varchar(50) DEFAULT NULL,
  `inv_no_str` double DEFAULT NULL,
  `typ` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `in_trans` */

/*Table structure for table `incentive_master` */

DROP TABLE IF EXISTS `incentive_master`;

CREATE TABLE `incentive_master` (
  `name1` varchar(100) NOT NULL DEFAULT '',
  `perc` int(11) DEFAULT NULL,
  `typ` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name1`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `incentive_master` */

insert  into `incentive_master`(`name1`,`perc`,`typ`) values ('NIL',2,'EMPLOYEES');

/*Table structure for table `laboratory` */

DROP TABLE IF EXISTS `laboratory`;

CREATE TABLE `laboratory` (
  `sino` int(11) NOT NULL DEFAULT '0',
  `date1` datetime DEFAULT NULL,
  `id` varchar(150) DEFAULT NULL,
  `name1` varchar(150) DEFAULT NULL,
  `gender` varchar(150) DEFAULT NULL,
  `blood` varchar(10) DEFAULT NULL,
  `add1` varchar(150) DEFAULT NULL,
  `dob` datetime DEFAULT NULL,
  `mar_status` varchar(30) DEFAULT NULL,
  `contact` varchar(100) DEFAULT '0',
  `age` int(11) DEFAULT '0',
  `nation` varchar(30) DEFAULT '0',
  `days` int(11) DEFAULT '0',
  `next_date` datetime DEFAULT NULL,
  `attach_report` varchar(100) DEFAULT '0',
  `gross_tot` double DEFAULT '0',
  `con_fee` double DEFAULT NULL,
  `disc` double DEFAULT NULL,
  `other` double DEFAULT NULL,
  `grand_tot` double DEFAULT '0',
  `payment_mode` varchar(30) DEFAULT '0',
  `paid` double DEFAULT '0',
  `balance` double DEFAULT '0',
  `symptoms` varchar(200) DEFAULT NULL,
  `disease` varchar(200) DEFAULT NULL,
  `history` varchar(500) DEFAULT NULL,
  `taxp` double DEFAULT NULL,
  `taxa` double DEFAULT NULL,
  `case_no` varchar(50) DEFAULT NULL,
  `del_date` datetime DEFAULT NULL,
  `doctors` varchar(150) DEFAULT NULL,
  `hospital` varchar(150) DEFAULT NULL,
  `file_no` varchar(150) DEFAULT NULL,
  `status1` varchar(150) DEFAULT NULL,
  `date_bill` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`sino`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `laboratory` */

insert  into `laboratory`(`sino`,`date1`,`id`,`name1`,`gender`,`blood`,`add1`,`dob`,`mar_status`,`contact`,`age`,`nation`,`days`,`next_date`,`attach_report`,`gross_tot`,`con_fee`,`disc`,`other`,`grand_tot`,`payment_mode`,`paid`,`balance`,`symptoms`,`disease`,`history`,`taxp`,`taxa`,`case_no`,`del_date`,`doctors`,`hospital`,`file_no`,`status1`,`date_bill`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',0,'0',0,NULL,'0',0,NULL,NULL,NULL,0,'0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `laboratory_jtabla` */

DROP TABLE IF EXISTS `laboratory_jtabla`;

CREATE TABLE `laboratory_jtabla` (
  `billno` int(11) DEFAULT '0',
  `sino` int(11) DEFAULT '0',
  `description` varchar(150) DEFAULT NULL,
  `unit1` varchar(300) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `price` double DEFAULT '0',
  `total1` double DEFAULT NULL,
  `dose` varchar(30) DEFAULT NULL,
  `tax_per` double DEFAULT '0',
  `tax_amt` double DEFAULT '0',
  `net_value` double DEFAULT NULL,
  `pack` double DEFAULT NULL,
  `unit` varchar(100) DEFAULT NULL,
  `godown` varchar(100) DEFAULT NULL,
  `date1` datetime DEFAULT NULL,
  `form` varchar(10) DEFAULT NULL,
  `cost` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `laboratory_jtabla` */

insert  into `laboratory_jtabla`(`billno`,`sino`,`description`,`unit1`,`qty`,`price`,`total1`,`dose`,`tax_per`,`tax_amt`,`net_value`,`pack`,`unit`,`godown`,`date1`,`form`,`cost`) values (0,0,NULL,NULL,NULL,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0);

/*Table structure for table `labreport` */

DROP TABLE IF EXISTS `labreport`;

CREATE TABLE `labreport` (
  `SiNo` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT NULL,
  `Date1` datetime DEFAULT NULL,
  `Particulars` varchar(50) DEFAULT NULL,
  `Pcs` double DEFAULT NULL,
  `Credit` double DEFAULT '0',
  `Debit` double DEFAULT '0',
  `ToDelAtt` int(11) DEFAULT '0',
  `VCNo` int(11) DEFAULT NULL,
  `color` varchar(100) DEFAULT NULL,
  `size` varchar(100) DEFAULT NULL,
  KEY `SiNo` (`SiNo`)
) ENGINE=MyISAM AUTO_INCREMENT=575 DEFAULT CHARSET=utf8;

/*Data for the table `labreport` */

/*Table structure for table `ledger_docs` */

DROP TABLE IF EXISTS `ledger_docs`;

CREATE TABLE `ledger_docs` (
  `id_no` int(20) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `ledger` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `si_no` int(20) DEFAULT NULL,
  `des` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `path` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `ledger_docs` */

/*Table structure for table `ledgertypes` */

DROP TABLE IF EXISTS `ledgertypes`;

CREATE TABLE `ledgertypes` (
  `Code1` varchar(255) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Class` varchar(255) DEFAULT NULL,
  `Subclass` varchar(255) DEFAULT NULL,
  `typ` varchar(255) DEFAULT NULL,
  `level1` double DEFAULT NULL,
  `lengths` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ledgertypes` */

insert  into `ledgertypes`(`Code1`,`Description`,`Class`,`Subclass`,`typ`,`level1`,`lengths`) values ('0','CUSTOMER/ SUNDRY DEBTORS','NIL','NIL','NIL',0,0),('0','PURCHASE PARTY/ SUNDRY CREDITORS','NIL','NIL','NIL',0,0),('0','EMPLOYEES','NIL','NIL','NIL',0,0),('0','EXPENSE','NIL','NIL','NIL',0,0),('0','LOAN LIABILITY','NIL','NIL','NIL',0,0),('0','OTHER','NIL','NIL','NIL',0,0),('1','ASSET','ASSET','Assets','B/S',1,1),('2','LIABILITY','LIABILITY','Liability','B/S',1,1),('3','INCOME','INCOME','Revenues','P/L',1,1),('4','GENERAL & OPRATING EXPENSES','EXPENSE','General & administrative Expenses','P/L',1,1),('11','FIXED ASSET','ASSET','Fixed Assets','B/S',2,2),('12','CURRENT ASSET','ASSET','Current Assets','B/S',2,2),('21','CAPITAL','LIABILITY','Partner s Equity','B/S',2,2),('22','TEMPORARY ADVANCE','LIABILITY','Current Liablities ','B/S',2,2),('23','LONG TERM LOAN & ADVANCES','LIABILITY','Non Current Liabilities','B/S',2,2),('24','CURRENT LIABILITY  PAYABLE','LIABILITY','Current Liablities ','B/S',2,2),('25','PROFIT & LOSS A/C','LIABILITY','Partner s Equity','B/S',2,2),('26','ACCRUED EXPENSES','LIABILITY','Current Liablities ','B/S',2,2),('27','PROVISION & OUTSTANDING','LIABILITY','Current Liablities ','B/S',2,2),('28','REMUNERATION PROVISION','LIABILITY','Current Liablities ','B/S',2,2),('31','TRADE RECEIVABLE','INCOME','Accounts Receivable','P/L',2,2),('41','ADMINISTRATIVE EXPENSES','EXPENSE','Adm & Office exp','P/L',2,2),('42','OFFICE & EMPLOYEE OPRATING EXPENSES','EXPENSE','Emp Related Expenes','P/L',2,2),('43','SALES EXPENES','EXPENSE','Cost of Goods Sold','P/L',2,2),('44','FINANCIAL RELATED EXPENDITURE','EXPENSE','Fin Income / Cost','P/L',2,2),('45','DEPRECIATION','EXPENSE','Depreciation Expense','P/L',2,2),('46','GOVERNMENT PAYMENTS','EXPENSE','Adm & Office exp','P/L',2,2),('1101','LAND','ASSET','Property and EQP','B/S',3,4),('1102','BUILDING','ASSET','Property and EQP','B/S',3,4),('1103','EQUIPMENT','ASSET','Property and EQP','B/S',3,4),('1104','BUILDING IMPROVEMENT','ASSET','Property and EQP','B/S',3,4),('1105','VEHICLE','ASSET','Property and EQP','B/S',3,4),('1106','FURNITURE','ASSET','Property and EQP','B/S',3,4),('1107','COMPUTER & RELATED','ASSET','Property and EQP','B/S',3,4),('1108','SOFT WARE','ASSET','Property and EQP','B/S',3,4),('1201','CASH ACCOUNT','ASSET','Cash & Bank','B/S',3,4),('1202','BANK ACCOUNT','ASSET','Cash & Bank','B/S',3,4),('1203','DIRECT PURCHASE ADVANCE','ASSET','Prepayments & Others','B/S',3,4),('1204','EMPLOYEE LOAN - LONG TERM','ASSET','Other Receivables','B/S',3,4),('1205','EMPLOYEE LOAN AND ADVANCE SALARY','ASSET','Other Receivables','B/S',3,4),('1206','OTHER RECEIVABLES','ASSET','Other Receivables','B/S',3,4),('1207','INVENTORY','ASSET','Inventories - net','B/S',3,4),('1208','GOOD WILL','ASSET','Good Will','B/S',3,4),('1209','CUSTOMER ACCOUNTS RECEIVABLES','ASSET','Trade Receivables','B/S',3,4),('1210','INPUT VAT RECEIVABLES','ASSET','Other Receivables','B/S',3,4),('1211','PREPAID & OTHER ADV. RECEIVABLES','ASSET','Prepayments & Others','B/S',3,4),('2101','CAPITAL FROM SHARE HOLDERS','LIABILITY','Share Capital','B/S',3,4),('2201','TEMPORARY ADV FROM SHARE HOLDERS','LIABILITY','Short Term Debt','B/S',3,4),('2202','TEMPORARY ADV FROM CUSTOMERS','LIABILITY','Trade Receivables','B/S',3,4),('2203','TEMPORARY ADV FROM OTHER PARTIES','LIABILITY','Short Term Debt','B/S',3,4),('2301','LONG TERM LOAN FROM BANK','LIABILITY','Long Term Debt','B/S',3,4),('2302','LONG TERM LOAN FROM SHARE HOLDERS','LIABILITY','Long Term Debt','B/S',3,4),('2401','SUPPLIER PAYABLE FOR SALE','LIABILITY','Accounts Payable','B/S',3,4),('2402','LOCAL SUPPLIER PAYABLE  FOR SALE','LIABILITY','Accounts Payable','B/S',3,4),('2403','GOVT.VAT PAYABLES','LIABILITY','Other Payable','B/S',3,4),('2404','OWNERS RENT PAYABLE','LIABILITY','Other Payable','B/S',3,4),('2405','TASKFORCE SOFTWARE PAYABLE','LIABILITY','Accounts Payable','B/S',3,4),('2501','PROFIT & LOSS','LIABILITY','Retained Earnings','B/S',3,4),('2601','OFFICE EMPLOYEE ACCRUED SALARY','LIABILITY','Accrued Exp & Other','B/S',3,4),('2602','OFFICE SAUDI ACCRUED SALARY','LIABILITY','Accrued Exp & Other','B/S',3,4),('2603','SALES TEAM ACCRUED SALARY','LIABILITY','Accrued Exp & Other','B/S',3,4),('2604','OFFICE LABOUR ACCRUED SALARY','LIABILITY','Accrued Exp & Other','B/S',3,4),('2605','WAREHOSE EMPLOYEE ACCRUED SALARY','LIABILITY','Accrued Exp & Other','B/S',3,4),('2701','Provision & O/S For Zakat','LIABILITY','Provision for Zakat','B/S',3,4),('2702','Prov & O/S For GOSI','LIABILITY','Provision for Gosi','B/S',3,4),('2703','Prov & O/S For  GOSI (Saudi)','LIABILITY','Provision for Gosi','B/S',3,4),('2704','Prov & O/S For Employee Iqama','LIABILITY','Provision for Iqama','B/S',3,4),('2705','Provision For Dependant Fee (Family)','LIABILITY','Provision for Family Iqama','B/S',3,4),('2801','OWNER S REMUNERATION PROVISION PAYABLE','LIABILITY','Provision for Others','B/S',3,4),('3101','INCOME FROM SALES','INCOME','Sales','P/L',3,4),('3201','NON TRADE RECEIVABLE','INCOME','Other Income','P/L',3,4),('3202','INCOME FROM OTHERS','INCOME','Other Income','P/L',3,4),('4101','ADMINISTRATIVE EXPENSE GENERAL','EXPENSE','Adm & Office exp','P/L',3,4),('4201','EMPLOYEE RELATED EXPENES','EXPENSE','Salaries & Wages','P/L',3,4),('4202','OFFICE OPRATING EXPENSES','EXPENSE','Adm & Office exp','P/L',3,4),('4301','DIRECT SALES EXPENSE','EXPENSE','Cost of Goods Sold','P/L',3,4),('4401','BANK RELATED EXPENSE','EXPENSE','Fin Income / Cost','P/L',3,4),('4402','OTHER FINANCIAL RELATED EXP','EXPENSE','Fin Income / Cost','P/L',3,4),('4501','DEPRECIATION FOR FIXED ASSESTS','EXPENSE','Depreciation Expense','P/L',3,4),('4601','ZAKATH & TAXES','EXPENSE','Provision for Zakat','P/L',3,4);

/*Table structure for table `lens_details` */

DROP TABLE IF EXISTS `lens_details`;

CREATE TABLE `lens_details` (
  `party_name` varchar(255) DEFAULT NULL,
  `Typ` varchar(255) DEFAULT NULL,
  `rd_sph` varchar(255) DEFAULT '0',
  `rd_cyl` varchar(255) DEFAULT '0',
  `rd_axis` varchar(255) DEFAULT '0',
  `rd_add` varchar(255) DEFAULT '0',
  `rn_sph` varchar(255) DEFAULT '0',
  `rn_cyl` varchar(255) DEFAULT '0',
  `rn_axis` varchar(255) DEFAULT '0',
  `rn_add` varchar(255) DEFAULT '0',
  `ld_sph` varchar(255) DEFAULT '0',
  `ld_cyl` varchar(255) DEFAULT '0',
  `ld_axis` varchar(255) DEFAULT '0',
  `ld_add` varchar(255) DEFAULT '0',
  `ln_sph` varchar(255) DEFAULT '0',
  `ln_cyl` varchar(255) DEFAULT '0',
  `ln_axis` varchar(255) DEFAULT '0',
  `ln_add` varchar(255) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `lens_details` */

/*Table structure for table `master` */

DROP TABLE IF EXISTS `master`;

CREATE TABLE `master` (
  `Name` varchar(200) NOT NULL,
  `Typ` varchar(255) DEFAULT NULL,
  `Code` varchar(255) DEFAULT NULL,
  `Address1` varchar(255) DEFAULT NULL,
  `Address2` varchar(255) DEFAULT NULL,
  `Ph` varchar(50) DEFAULT NULL,
  `TinNo` varchar(50) DEFAULT NULL,
  `CstNo` varchar(50) DEFAULT NULL,
  `Desig` varchar(255) DEFAULT NULL,
  `Salary` varchar(255) DEFAULT NULL,
  `Bank` varchar(255) DEFAULT NULL,
  `Opening` varchar(255) DEFAULT NULL,
  `Stat` int(11) DEFAULT NULL,
  `emp` varchar(255) DEFAULT NULL,
  `credit_limit` double DEFAULT '0',
  `local_app_user_entry_id` varchar(100) DEFAULT NULL,
  `route` varchar(200) DEFAULT 'NIL',
  `acc_code` double NOT NULL DEFAULT '0',
  `class` varchar(50) DEFAULT NULL,
  `sub_class` varchar(50) DEFAULT NULL,
  `type_` varchar(50) DEFAULT NULL,
  `level_` varchar(30) DEFAULT NULL,
  `length_` varchar(30) DEFAULT NULL,
  `address` text,
  `outlet` varchar(255) DEFAULT '0',
  `emp_userID` int(11) DEFAULT '0',
  `emp_userTyp` varchar(20) DEFAULT 'NIL',
  `emp_salaryAmount` double DEFAULT '0',
  `emp_password` varchar(20) DEFAULT NULL,
  `zk_stat` tinyint(11) DEFAULT '0',
  `second_name` varchar(255) DEFAULT NULL,
  `city_name` varchar(30) DEFAULT '0',
  `mid` int(11) NOT NULL,
  PRIMARY KEY (`Name`),
  KEY `Code` (`Code`),
  KEY `Address1` (`Address1`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `master` */

insert  into `master`(`Name`,`Typ`,`Code`,`Address1`,`Address2`,`Ph`,`TinNo`,`CstNo`,`Desig`,`Salary`,`Bank`,`Opening`,`Stat`,`emp`,`credit_limit`,`local_app_user_entry_id`,`route`,`acc_code`,`class`,`sub_class`,`type_`,`level_`,`length_`,`address`,`outlet`,`emp_userID`,`emp_userTyp`,`emp_salaryAmount`,`emp_password`,`zk_stat`,`second_name`,`city_name`,`mid`) values ('NIL','EMPLOYEES','0',NULL,NULL,NULL,NULL,'',NULL,'DAILY','CURRENT','0',0,'0',0,NULL,'NIL',0,NULL,NULL,NULL,NULL,NULL,'Nil','0',0,'NIL',0,NULL,0,NULL,'0',0),('4','PURCHASE PARTY','0',NULL,NULL,NULL,NULL,'',NULL,'DAILY','CURRENT','0',0,'0',0,NULL,'NIL',0,NULL,NULL,NULL,NULL,NULL,'Nil','0',0,'NIL',0,NULL,0,NULL,'0',0),('3','CUSTOMER','0',NULL,NULL,NULL,NULL,'',NULL,'DAILY','CURRENT','0',0,'0',0,NULL,'NIL',0,NULL,NULL,NULL,NULL,NULL,'Nil','0',0,'NIL',0,NULL,0,NULL,'0',0),('ABC CUSTOMER','CUSTOMER','','','','','','','','HOURLY','MONDAY','0.0',0,'NIL',0,NULL,'NIL',0,NULL,NULL,NULL,NULL,NULL,'','0',0,'NIL',0,NULL,0,'','0',1),('ABC PURCHASE PARTY','PURCHASE PARTY','','','','','','','','HOURLY','MONDAY','0.0',0,'NIL',0,NULL,'NIL',0,NULL,NULL,NULL,NULL,NULL,'','0',0,'NIL',0,NULL,0,'','0',1);

/*Table structure for table `master1` */

DROP TABLE IF EXISTS `master1`;

CREATE TABLE `master1` (
  `typ` varchar(20) NOT NULL,
  `name1` varchar(100) NOT NULL,
  `price` double DEFAULT NULL,
  `unit` double DEFAULT '0',
  `dose` varchar(10) DEFAULT NULL,
  `descr` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`typ`,`name1`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `master1` */

/*Table structure for table `masterdetails` */

DROP TABLE IF EXISTS `masterdetails`;

CREATE TABLE `masterdetails` (
  `BillNo` int(11) NOT NULL DEFAULT '0',
  `BillDate` datetime DEFAULT NULL,
  `BillPartyName` varchar(255) DEFAULT NULL,
  `BillTotalField` double DEFAULT '0',
  `BillDiscAmtField` double DEFAULT '0',
  `BillDiscPercField` double DEFAULT '0',
  `BillTaxField` double DEFAULT '0',
  `BillPackageField` double DEFAULT '0',
  `BillNetTotalField` double DEFAULT '0',
  `BillTyp` varchar(50) DEFAULT NULL,
  `BillTime` varchar(30) DEFAULT NULL,
  `OrderNo` double DEFAULT '0',
  `TDiscAmt` double DEFAULT '0',
  `TaxAmt` double DEFAULT '0',
  `DCBillNo` varchar(255) DEFAULT '0*0',
  `TItTaxAmt` double DEFAULT '0',
  `TAmt` double DEFAULT '0',
  `Cess` double DEFAULT '0',
  `Lorry` varchar(50) DEFAULT NULL,
  `DCNoTax` double DEFAULT '0',
  `TotDiscPercAmt` double DEFAULT '0',
  `CessP` double DEFAULT '0',
  `TotItWiseQty1` double DEFAULT '0',
  `CashP` varchar(100) DEFAULT NULL,
  `CashCard` varchar(255) DEFAULT NULL,
  `CashCardAmt` varchar(255) DEFAULT NULL,
  `godown` varchar(255) DEFAULT NULL,
  `warranty` varchar(255) DEFAULT NULL,
  `del_date` datetime DEFAULT NULL,
  `advance` double DEFAULT '0',
  `sino` int(11) DEFAULT '0',
  `local_app_user_entry_id` varchar(100) DEFAULT 'NIL',
  `EmpCode` varchar(200) DEFAULT '0',
  `SystemId` varchar(30) DEFAULT NULL,
  `HldingStatus` int(11) DEFAULT NULL,
  `BatchNo` double DEFAULT '0',
  `cst_id` int(11) DEFAULT '0',
  `ReceiptType` varchar(50) DEFAULT 'Cash',
  `redeemPoint` double DEFAULT NULL,
  `NewBillNo` varchar(100) DEFAULT NULL,
  `Profit` double DEFAULT '0',
  `TaxBillNo` int(11) DEFAULT '0',
  `fin_year` varchar(25) DEFAULT '0',
  `cr_dr` varchar(10) DEFAULT 'Dr',
  `qr_encode` text,
  `vat_no` varchar(24) DEFAULT '',
  PRIMARY KEY (`BillNo`),
  UNIQUE KEY `BillNo` (`BillNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `masterdetails` */

insert  into `masterdetails`(`BillNo`,`BillDate`,`BillPartyName`,`BillTotalField`,`BillDiscAmtField`,`BillDiscPercField`,`BillTaxField`,`BillPackageField`,`BillNetTotalField`,`BillTyp`,`BillTime`,`OrderNo`,`TDiscAmt`,`TaxAmt`,`DCBillNo`,`TItTaxAmt`,`TAmt`,`Cess`,`Lorry`,`DCNoTax`,`TotDiscPercAmt`,`CessP`,`TotItWiseQty1`,`CashP`,`CashCard`,`CashCardAmt`,`godown`,`warranty`,`del_date`,`advance`,`sino`,`local_app_user_entry_id`,`EmpCode`,`SystemId`,`HldingStatus`,`BatchNo`,`cst_id`,`ReceiptType`,`redeemPoint`,`NewBillNo`,`Profit`,`TaxBillNo`,`fin_year`,`cr_dr`,`qr_encode`,`vat_no`) values (0,NULL,NULL,0,0,0,0,0,0,NULL,NULL,0,0,0,'0*0',0,0,0,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'NIL','0',NULL,NULL,0,0,'Cash',NULL,NULL,0,0,'2025','Dr',NULL,'');

/*Table structure for table `masterdetails8b` */

DROP TABLE IF EXISTS `masterdetails8b`;

CREATE TABLE `masterdetails8b` (
  `BillNo` int(11) NOT NULL DEFAULT '0',
  `BillDate` datetime DEFAULT NULL,
  `BillPartyName` varchar(50) DEFAULT NULL,
  `BillTotalField` double DEFAULT '0',
  `BillDiscAmtField` double DEFAULT '0',
  `BillDiscPercField` double DEFAULT '0',
  `BillTaxField` double DEFAULT '0',
  `BillPackageField` double DEFAULT '0',
  `BillNetTotalField` double DEFAULT '0',
  `BillTyp` varchar(50) DEFAULT NULL,
  `BillTime` varchar(30) DEFAULT NULL,
  `OrderNo` double DEFAULT '0',
  `TDiscAmt` double DEFAULT '0',
  `TaxAmt` double DEFAULT '0',
  `DCBillNo` varchar(255) DEFAULT NULL,
  `TItTaxAmt` double DEFAULT '0',
  `TAmt` double DEFAULT '0',
  `Cess` double DEFAULT '0',
  `Lorry` varchar(50) DEFAULT NULL,
  `DCNoTax` double DEFAULT '0',
  `TotDiscPercAmt` double DEFAULT '0',
  `CessP` double DEFAULT '0',
  `TotItWiseQty1` double DEFAULT '0',
  `CashP` varchar(100) DEFAULT NULL,
  `CashCard` varchar(255) DEFAULT NULL,
  `CashCardAmt` varchar(255) DEFAULT NULL,
  `godown` varchar(255) DEFAULT NULL,
  `warranty` varchar(255) DEFAULT NULL,
  `del_date` datetime DEFAULT NULL,
  `advance` double DEFAULT '0',
  `sino` int(11) DEFAULT '0',
  `EmpCode` varchar(255) DEFAULT '0',
  `SystemId` varchar(30) DEFAULT NULL,
  `HldingStatus` int(11) DEFAULT NULL,
  `BatchNo` double DEFAULT '0',
  `ReceiptType` varchar(50) DEFAULT 'Cash',
  `cst_id` varchar(255) DEFAULT 'NIL',
  `NewBillNo` varchar(100) DEFAULT NULL,
  `local_app_user_entry_id` varchar(100) DEFAULT NULL,
  `Profit` double DEFAULT '0',
  `cr_dr` varchar(10) DEFAULT 'Dr',
  `vat_no` varchar(24) DEFAULT '',
  `prefix` varchar(50) DEFAULT '',
  PRIMARY KEY (`BillNo`),
  UNIQUE KEY `BillNo` (`BillNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `masterdetails8b` */

insert  into `masterdetails8b`(`BillNo`,`BillDate`,`BillPartyName`,`BillTotalField`,`BillDiscAmtField`,`BillDiscPercField`,`BillTaxField`,`BillPackageField`,`BillNetTotalField`,`BillTyp`,`BillTime`,`OrderNo`,`TDiscAmt`,`TaxAmt`,`DCBillNo`,`TItTaxAmt`,`TAmt`,`Cess`,`Lorry`,`DCNoTax`,`TotDiscPercAmt`,`CessP`,`TotItWiseQty1`,`CashP`,`CashCard`,`CashCardAmt`,`godown`,`warranty`,`del_date`,`advance`,`sino`,`EmpCode`,`SystemId`,`HldingStatus`,`BatchNo`,`ReceiptType`,`cst_id`,`NewBillNo`,`local_app_user_entry_id`,`Profit`,`cr_dr`,`vat_no`,`prefix`) values (0,NULL,NULL,0,0,0,0,0,0,NULL,NULL,0,0,0,NULL,0,0,0,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'0',NULL,NULL,0,'Cash','NIL',NULL,NULL,0,'Dr','','');

/*Table structure for table `masterdetails8bnew` */

DROP TABLE IF EXISTS `masterdetails8bnew`;

CREATE TABLE `masterdetails8bnew` (
  `BillNo` int(11) NOT NULL DEFAULT '0',
  `BillDate` datetime DEFAULT NULL,
  `BillPartyName` varchar(50) DEFAULT NULL,
  `BillTotalField` double DEFAULT '0',
  `BillDiscAmtField` double DEFAULT '0',
  `BillDiscPercField` double DEFAULT '0',
  `BillTaxField` double DEFAULT '0',
  `BillPackageField` double DEFAULT '0',
  `BillNetTotalField` double DEFAULT '0',
  `BillTyp` varchar(50) DEFAULT NULL,
  `BillTime` varchar(30) DEFAULT NULL,
  `OrderNo` double DEFAULT '0',
  `TDiscAmt` double DEFAULT '0',
  `TaxAmt` double DEFAULT '0',
  `DCBillNo` varchar(255) DEFAULT NULL,
  `TItTaxAmt` double DEFAULT '0',
  `TAmt` double DEFAULT '0',
  `Cess` double DEFAULT '0',
  `Lorry` varchar(50) DEFAULT NULL,
  `DCNoTax` double DEFAULT '0',
  `TotDiscPercAmt` double DEFAULT '0',
  `CessP` double DEFAULT '0',
  `TotItWiseQty1` double DEFAULT '0',
  `CashP` varchar(100) DEFAULT NULL,
  `CashCard` varchar(255) DEFAULT NULL,
  `CashCardAmt` varchar(255) DEFAULT NULL,
  `godown` varchar(255) DEFAULT NULL,
  `warranty` varchar(255) DEFAULT NULL,
  `del_date` datetime DEFAULT NULL,
  `advance` double DEFAULT '0',
  `sino` int(11) DEFAULT '0',
  `EmpCode` varchar(255) DEFAULT '0',
  `SystemId` varchar(30) DEFAULT NULL,
  `HldingStatus` int(11) DEFAULT NULL,
  `BatchNo` double DEFAULT '0',
  `ReceiptType` varchar(50) DEFAULT 'Cash',
  `cst_id` varchar(255) DEFAULT 'NIL',
  `Profit` double DEFAULT '0',
  `redeemPoint` double DEFAULT NULL,
  `TaxBillNo` int(11) DEFAULT '0',
  `fin_year` varchar(25) DEFAULT '0',
  `cr_dr` varchar(10) DEFAULT 'Dr',
  `vat_no` varchar(24) DEFAULT '',
  `local_app_user_entry_id` varchar(255) DEFAULT 'NIL',
  `prefix` varchar(50) DEFAULT '',
  `NewBillNo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`BillNo`),
  UNIQUE KEY `BillNo` (`BillNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `masterdetails8bnew` */

insert  into `masterdetails8bnew`(`BillNo`,`BillDate`,`BillPartyName`,`BillTotalField`,`BillDiscAmtField`,`BillDiscPercField`,`BillTaxField`,`BillPackageField`,`BillNetTotalField`,`BillTyp`,`BillTime`,`OrderNo`,`TDiscAmt`,`TaxAmt`,`DCBillNo`,`TItTaxAmt`,`TAmt`,`Cess`,`Lorry`,`DCNoTax`,`TotDiscPercAmt`,`CessP`,`TotItWiseQty1`,`CashP`,`CashCard`,`CashCardAmt`,`godown`,`warranty`,`del_date`,`advance`,`sino`,`EmpCode`,`SystemId`,`HldingStatus`,`BatchNo`,`ReceiptType`,`cst_id`,`Profit`,`redeemPoint`,`TaxBillNo`,`fin_year`,`cr_dr`,`vat_no`,`local_app_user_entry_id`,`prefix`,`NewBillNo`) values (0,NULL,NULL,0,0,0,0,0,0,NULL,NULL,0,0,0,NULL,0,0,0,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'0',NULL,NULL,0,'Cash','NIL',0,NULL,0,'2023','Dr','','NIL','',NULL);

/*Table structure for table `matusage` */

DROP TABLE IF EXISTS `matusage`;

CREATE TABLE `matusage` (
  `qno` int(11) DEFAULT '0',
  `date1` datetime DEFAULT NULL,
  `sino` int(11) DEFAULT '0',
  `acc` varchar(50) DEFAULT NULL,
  `nam` varchar(100) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `total` double DEFAULT NULL,
  `trn_no` int(11) DEFAULT NULL,
  `unt` varchar(50) DEFAULT NULL,
  `parts` varchar(255) DEFAULT NULL,
  `per_prod` double DEFAULT '0',
  `finishedGoods` varchar(100) DEFAULT NULL,
  `Barcode` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `matusage` */
/*Table structure for table `mis_bod_master` */

DROP TABLE IF EXISTS `mis_bod_master`;

CREATE TABLE `mis_bod_master` (
  `bm_idno` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `add_1` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `add_2` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `mob_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `designation` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `photo` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `expiry_date` varchar(255) DEFAULT NULL,
  `member_typ` varchar(25) DEFAULT 'MEMBER',
  `bod_name` varchar(255) NOT NULL,
  `adhar_no` varchar(25) DEFAULT 'email',
  `email_id` varchar(55) DEFAULT '123456789012',
  `pan_no` varchar(15) DEFAULT 'PAN',
  PRIMARY KEY (`bm_idno`,`bod_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `mis_bod_master` */

/*Table structure for table `mis_division_master` */

DROP TABLE IF EXISTS `mis_division_master`;

CREATE TABLE `mis_division_master` (
  `dv_idno` int(11) NOT NULL AUTO_INCREMENT,
  `division` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `dv_typ` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `incentive` double DEFAULT NULL,
  `recv_name` varchar(255) CHARACTER SET utf8 DEFAULT 'RECIEVER NAME',
  PRIMARY KEY (`dv_idno`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `mis_division_master` */

/*Table structure for table `mis_donator_master` */

DROP TABLE IF EXISTS `mis_donator_master`;

CREATE TABLE `mis_donator_master` (
  `dm_idno` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `add_1` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `add_2` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `mob_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `division` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `donation_typ` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `box_no` double DEFAULT NULL,
  `amount` double DEFAULT NULL,
  PRIMARY KEY (`dm_idno`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `mis_donator_master` */

/*Table structure for table `mis_property_master` */

DROP TABLE IF EXISTS `mis_property_master`;

CREATE TABLE `mis_property_master` (
  `sino` int(11) NOT NULL AUTO_INCREMENT,
  `property_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `survey_no` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `property_dtl` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `area` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `village` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `place` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `landmark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `waqf_person_name` varchar(200) DEFAULT NULL,
  `waqf_dtl` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `building_tax` varchar(255) DEFAULT NULL,
  `land_tax` varchar(255) DEFAULT NULL,
  `division` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `prp_typ` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `image_1` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `image_2` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `image_3` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `image_4` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `re_survey_no` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `category` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `category_typ` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `doc` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`sino`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `mis_property_master` */

/*Table structure for table `mis_property_tbl` */

DROP TABLE IF EXISTS `mis_property_tbl`;

CREATE TABLE `mis_property_tbl` (
  `p_idno` int(11) DEFAULT NULL,
  `sino` int(11) DEFAULT NULL,
  `div_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `name_occupant` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `adv_amt` double DEFAULT NULL,
  `rent_amt` double DEFAULT NULL,
  `remarks` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `mis_property_tbl` */

/*Table structure for table `mis_receiver_master` */

DROP TABLE IF EXISTS `mis_receiver_master`;

CREATE TABLE `mis_receiver_master` (
  `rm_idno` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `add_1` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `add_2` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `mob_no` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`rm_idno`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `mis_receiver_master` */

/*Table structure for table `mis_receiver_tbl` */

DROP TABLE IF EXISTS `mis_receiver_tbl`;

CREATE TABLE `mis_receiver_tbl` (
  `rt_idno` int(11) DEFAULT NULL,
  `sino` int(11) DEFAULT NULL,
  `div_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `mis_receiver_tbl` */

/*Table structure for table `mis_tapal` */

DROP TABLE IF EXISTS `mis_tapal`;

CREATE TABLE `mis_tapal` (
  `tapal_no` int(11) NOT NULL AUTO_INCREMENT,
  `tapal_date` datetime DEFAULT NULL,
  `to_name` varchar(250) DEFAULT NULL,
  `typ` varchar(50) DEFAULT NULL,
  `img_loc` varchar(255) DEFAULT NULL,
  `stmp_det` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`tapal_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `mis_tapal` */

/*Table structure for table `mobile_app_gps` */

DROP TABLE IF EXISTS `mobile_app_gps`;

CREATE TABLE `mobile_app_gps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `latitude` varchar(100) DEFAULT NULL,
  `longitude` varchar(100) DEFAULT NULL,
  `party_name` varchar(100) DEFAULT NULL,
  `action` text,
  `date1` datetime DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `user` varchar(100) DEFAULT NULL,
  `godown` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

/*Data for the table `mobile_app_gps` */

/*Table structure for table `offerdiscount` */

DROP TABLE IF EXISTS `offerdiscount`;

CREATE TABLE `offerdiscount` (
  `offer_no` int(11) NOT NULL DEFAULT '0',
  `offer_date` datetime DEFAULT NULL,
  `type` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `sino` int(11) DEFAULT '0',
  `ItemC` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `ItemName` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `cost` double DEFAULT '0',
  `rate` double DEFAULT '0',
  `mrp` double DEFAULT '0',
  `qty` double DEFAULT '0',
  `unit` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `pack` double DEFAULT NULL,
  `Exp_date` datetime DEFAULT NULL,
  `desc` varchar(300) CHARACTER SET utf8 DEFAULT NULL,
  `TaxP` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `offerdiscount` */

insert  into `offerdiscount`(`offer_no`,`offer_date`,`type`,`sino`,`ItemC`,`ItemName`,`cost`,`rate`,`mrp`,`qty`,`unit`,`pack`,`Exp_date`,`desc`,`TaxP`) values (0,NULL,NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,0);

/*Table structure for table `other` */

DROP TABLE IF EXISTS `other`;

CREATE TABLE `other` (
  `Typ` varchar(255) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Nam` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Typ`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `other` */

insert  into `other`(`Typ`,`Description`,`Nam`) values ('CHOOSE CODE','Barcode',NULL),('Sales Bill 8','Estimate',NULL),('Sales Bill 8B','Estimate',NULL),('SERACH','Item',NULL),('DATABASE PATH','D:MYSQL',NULL),('TAX_COLOUM','0',NULL),('0','ISCHECKED',NULL),('LANGUAGE','ENGLISH',NULL),('Item Name','TABLEFOCUS',NULL),('2.0','BATCH NO',NULL),('YES','TAX TYPE',NULL),('NIL','PRODUCT GROUP',NULL),('GST_VAT','GST',NULL),('B2BPrint','LazerA4PrintB2b_TAXGST',NULL),('B2CPrint','LazerA4PrintB2c_TAXGST',NULL),('NIL ROUTE','ROUTE',NULL),('NIL-','SUB CATEGORY',NULL),('K_STAT','S.N.A.T',NULL),('LOGO_LOCATION','D:\\WIZZO SOFTWARES\\VERSION 14 ON 07-05-2025\\EasyEnterprise\\dist\\Image\\logo.png',NULL),('1-49','0',NULL),('50-74','0',NULL),('75-above','0',NULL),('MAIN','STOCK UNDER','0');

/*Table structure for table `outlet_group` */

DROP TABLE IF EXISTS `outlet_group`;

CREATE TABLE `outlet_group` (
  `sino` int(11) DEFAULT NULL,
  `outlet` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `group_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `outlet_group` */

insert  into `outlet_group`(`sino`,`outlet`,`group_name`) values (0,NULL,NULL);

/*Table structure for table `pass` */

DROP TABLE IF EXISTS `pass`;

CREATE TABLE `pass` (
  `UName` varchar(50) DEFAULT NULL,
  `PassWord` varchar(50) DEFAULT NULL,
  `Typ` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `pass` */

insert  into `pass`(`UName`,`PassWord`,`Typ`) values ('0','123','Admin'),('0','123','admin@gmail.com');

/*Table structure for table `patient_registration` */

DROP TABLE IF EXISTS `patient_registration`;

CREATE TABLE `patient_registration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_id` varchar(30) DEFAULT NULL,
  `p_name` varchar(100) DEFAULT NULL,
  `address1` varchar(100) DEFAULT NULL,
  `address2` varchar(100) DEFAULT NULL,
  `gender` varchar(30) DEFAULT NULL,
  `contact1` varchar(30) DEFAULT NULL,
  `contact2` varchar(30) DEFAULT NULL,
  `mail1` varchar(30) DEFAULT NULL,
  `dob` datetime DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `nationality` varchar(30) DEFAULT NULL,
  `marital_status` varchar(30) DEFAULT NULL,
  `religion` varchar(30) DEFAULT NULL,
  `photo` varchar(100) DEFAULT NULL,
  `dr_name` varchar(150) DEFAULT NULL,
  `consult_fee` double DEFAULT NULL,
  `con_taxP` double DEFAULT NULL,
  `con_taxA` double DEFAULT NULL,
  `con_gtot` double DEFAULT NULL,
  `p_type` varchar(50) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `disease_details` varchar(220) DEFAULT NULL,
  `p_status` varchar(50) DEFAULT NULL,
  `p_catagory` varchar(50) DEFAULT NULL,
  `amb_service` varchar(50) DEFAULT NULL,
  `salary_expenses` varchar(50) DEFAULT NULL,
  `entry_purchase` varchar(50) DEFAULT NULL,
  `age_month` double DEFAULT '0',
  `age_days` double DEFAULT '0',
  `validity` varchar(100) DEFAULT NULL,
  `token_no` int(11) DEFAULT '0',
  `visit_time` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `patient_registration` */

/*Table structure for table `pbill` */

DROP TABLE IF EXISTS `pbill`;

CREATE TABLE `pbill` (
  `InvoiceNo` int(11) NOT NULL DEFAULT '0',
  `InvoiceDat` datetime DEFAULT NULL,
  `PartyName` varchar(50) DEFAULT NULL,
  `Total` double DEFAULT '0',
  `Tax` double DEFAULT '0',
  `Package` double DEFAULT '0',
  `DiscAmt` double DEFAULT '0',
  `NTot` double DEFAULT '0',
  `BillTime` varchar(30) DEFAULT NULL,
  `OrderNo` varchar(255) DEFAULT NULL,
  `TDiscAmt` double DEFAULT '0',
  `TaxAmt` double DEFAULT '0',
  `DCBillNo` int(11) DEFAULT '0',
  `TItTaxAmt` double DEFAULT '0',
  `TAmt` double DEFAULT '0',
  `Cess` double DEFAULT '0',
  `Lorry` varchar(50) DEFAULT NULL,
  `DCNoTax` double DEFAULT '0',
  `CessP` double DEFAULT '0',
  `TotItWiseQty` double DEFAULT '0',
  `VatP` int(11) DEFAULT '0',
  `VatA` int(11) DEFAULT '0',
  `godown` varchar(255) DEFAULT NULL,
  `careof` varchar(255) DEFAULT NULL,
  `SystemId` varchar(30) DEFAULT NULL,
  `local_app_user_entry_id` varchar(100) DEFAULT NULL,
  `tax_mode` varchar(50) NOT NULL DEFAULT 'NIL',
  `net_trans_cost` double NOT NULL DEFAULT '0',
  `DiscPTyp` varchar(25) DEFAULT 'Discount % After Tax',
  `TaxBillNo` int(11) DEFAULT '0',
  `fin_year` varchar(25) DEFAULT '0',
  `sack_wt` double DEFAULT NULL,
  `dust_wt` double DEFAULT NULL,
  `prefix` varchar(50) DEFAULT '',
  PRIMARY KEY (`InvoiceNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `pbill` */

insert  into `pbill`(`InvoiceNo`,`InvoiceDat`,`PartyName`,`Total`,`Tax`,`Package`,`DiscAmt`,`NTot`,`BillTime`,`OrderNo`,`TDiscAmt`,`TaxAmt`,`DCBillNo`,`TItTaxAmt`,`TAmt`,`Cess`,`Lorry`,`DCNoTax`,`CessP`,`TotItWiseQty`,`VatP`,`VatA`,`godown`,`careof`,`SystemId`,`local_app_user_entry_id`,`tax_mode`,`net_trans_cost`,`DiscPTyp`,`TaxBillNo`,`fin_year`,`sack_wt`,`dust_wt`,`prefix`) values (0,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,0,0,0,0,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,'NIL',0,'Discount % After Tax',0,'2025',NULL,NULL,'');

/*Table structure for table `pbill_order` */

DROP TABLE IF EXISTS `pbill_order`;

CREATE TABLE `pbill_order` (
  `InvoiceNo` int(11) NOT NULL DEFAULT '0',
  `InvoiceDat` datetime DEFAULT NULL,
  `PartyName` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `Total` double DEFAULT '0',
  `Tax` double DEFAULT '0',
  `Package` double DEFAULT '0',
  `DiscAmt` double DEFAULT '0',
  `NTot` double DEFAULT '0',
  `BillTime` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `OrderNo` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `TDiscAmt` double DEFAULT '0',
  `TaxAmt` double DEFAULT '0',
  `DCBillNo` int(11) DEFAULT '0',
  `TItTaxAmt` double DEFAULT '0',
  `TAmt` double DEFAULT '0',
  `Cess` double DEFAULT '0',
  `Lorry` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `DCNoTax` double DEFAULT '0',
  `CessP` double DEFAULT '0',
  `TotItWiseQty` double DEFAULT '0',
  `VatP` int(11) DEFAULT '0',
  `VatA` int(11) DEFAULT '0',
  `godown` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `careof` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `SystemId` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `tax_mode` varchar(50) NOT NULL DEFAULT 'NIL',
  `net_trans_cost` double NOT NULL DEFAULT '0',
  `DiscPTyp` varchar(25) DEFAULT 'Discount % After Tax',
  `prefix` varchar(50) CHARACTER SET utf8 DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pbill_order` */

insert  into `pbill_order`(`InvoiceNo`,`InvoiceDat`,`PartyName`,`Total`,`Tax`,`Package`,`DiscAmt`,`NTot`,`BillTime`,`OrderNo`,`TDiscAmt`,`TaxAmt`,`DCBillNo`,`TItTaxAmt`,`TAmt`,`Cess`,`Lorry`,`DCNoTax`,`CessP`,`TotItWiseQty`,`VatP`,`VatA`,`godown`,`careof`,`SystemId`,`tax_mode`,`net_trans_cost`,`DiscPTyp`,`prefix`) values (0,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,0,0,0,0,NULL,0,0,0,0,0,NULL,NULL,NULL,'NIL',0,'Discount % After Tax','');

/*Table structure for table `pcode` */

DROP TABLE IF EXISTS `pcode`;

CREATE TABLE `pcode` (
  `Pos` varchar(50) DEFAULT NULL,
  `Code` varchar(50) DEFAULT NULL,
  KEY `Code` (`Code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `pcode` */

insert  into `pcode`(`Pos`,`Code`) values ('5','D'),('7','C'),('8','T'),('4','K'),('6','O'),('1','B'),('9','E'),('0','R'),('3','N'),('2','A');

/*Table structure for table `pricenet` */

DROP TABLE IF EXISTS `pricenet`;

CREATE TABLE `pricenet` (
  `QNo` int(11) NOT NULL DEFAULT '0',
  `Prod_Name` varchar(50) DEFAULT NULL,
  `NetTot` double DEFAULT '0',
  `Date1` datetime DEFAULT NULL,
  PRIMARY KEY (`QNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `pricenet` */

insert  into `pricenet`(`QNo`,`Prod_Name`,`NetTot`,`Date1`) values (0,NULL,0,NULL);

/*Table structure for table `pricequot` */

DROP TABLE IF EXISTS `pricequot`;

CREATE TABLE `pricequot` (
  `QNo` int(11) DEFAULT '0',
  `Prod_Nam` varchar(50) DEFAULT NULL,
  `SiNo` int(11) DEFAULT '0',
  `MatNam` varchar(50) DEFAULT NULL,
  `Typ` varchar(50) DEFAULT NULL,
  `Rate` double DEFAULT '0',
  `Area` double DEFAULT '0',
  `Cost` double DEFAULT '0',
  `Date1` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `pricequot` */

insert  into `pricequot`(`QNo`,`Prod_Nam`,`SiNo`,`MatNam`,`Typ`,`Rate`,`Area`,`Cost`,`Date1`) values (0,NULL,0,NULL,NULL,0,0,0,NULL);

/*Table structure for table `prmasterdetails` */

DROP TABLE IF EXISTS `prmasterdetails`;

CREATE TABLE `prmasterdetails` (
  `RetNo` int(11) NOT NULL DEFAULT '0',
  `BillDate` datetime DEFAULT NULL,
  `BillPartyName` varchar(50) DEFAULT NULL,
  `BillTotalField` double DEFAULT '0',
  `BillDiscAmtField` double DEFAULT '0',
  `BillDiscPercField` double DEFAULT '0',
  `BillTaxField` double DEFAULT '0',
  `BillPackageField` double DEFAULT '0',
  `BillNetTotalField` double DEFAULT '0',
  `BillTyp` varchar(50) DEFAULT NULL,
  `TDiscAmt` double DEFAULT '0',
  `TaxAmt` double DEFAULT '0',
  `godown` varchar(255) DEFAULT NULL,
  `PinvNo` varchar(255) DEFAULT NULL,
  `TaxBillNo` int(11) DEFAULT '0',
  `fin_year` varchar(25) DEFAULT '0',
  `sys_id` varchar(25) DEFAULT 'SYS1',
  `prefix` varchar(50) DEFAULT '',
  `TItTaxAmt` double DEFAULT NULL,
  `local_app_user_entry_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`RetNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `prmasterdetails` */

insert  into `prmasterdetails`(`RetNo`,`BillDate`,`BillPartyName`,`BillTotalField`,`BillDiscAmtField`,`BillDiscPercField`,`BillTaxField`,`BillPackageField`,`BillNetTotalField`,`BillTyp`,`TDiscAmt`,`TaxAmt`,`godown`,`PinvNo`,`TaxBillNo`,`fin_year`,`sys_id`,`prefix`,`TItTaxAmt`,`local_app_user_entry_id`) values (0,NULL,NULL,0,0,0,0,0,0,NULL,0,0,NULL,NULL,0,'2023','SYS1','',NULL,NULL);

/*Table structure for table `pscwages` */

DROP TABLE IF EXISTS `pscwages`;

CREATE TABLE `pscwages` (
  `SiNo` int(11) DEFAULT '0',
  `Labour` varchar(50) DEFAULT NULL,
  `Qty` int(11) DEFAULT '0',
  `Rate` double DEFAULT '0',
  `Wages` double DEFAULT '0',
  `Detail` varchar(50) DEFAULT NULL,
  `Date1` datetime DEFAULT NULL,
  `colour` varchar(50) DEFAULT NULL,
  `size1` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `pscwages` */

/*Table structure for table `purchasebill` */

DROP TABLE IF EXISTS `purchasebill`;

CREATE TABLE `purchasebill` (
  `PBillNo` int(11) DEFAULT '0',
  `PSiNo` int(11) DEFAULT '0',
  `ItemC` varchar(50) DEFAULT NULL,
  `PItem` varchar(255) DEFAULT NULL,
  `PQty` double DEFAULT '0',
  `sqft` double DEFAULT NULL,
  `PRate` double DEFAULT '0',
  `PDis` double DEFAULT '0',
  `PTotal` double DEFAULT '0',
  `PTaxP` double DEFAULT '0',
  `PTaxA` double DEFAULT '0',
  `PNetV` double DEFAULT '0',
  `Perc` double DEFAULT NULL,
  `MRP` double DEFAULT NULL,
  `SRP` double DEFAULT NULL,
  `PGoodsOn` varchar(50) DEFAULT NULL,
  `PBDate` datetime DEFAULT NULL,
  `Stat` int(11) DEFAULT NULL,
  `Pack` double DEFAULT NULL,
  `Unit` varchar(10) DEFAULT NULL,
  `Ex_date` datetime NOT NULL DEFAULT '2017-07-01 00:00:00',
  `local_app_user_entry_id` varchar(100) DEFAULT NULL,
  `batch_no` varchar(100) NOT NULL DEFAULT 'NIL',
  `trans_cost` double NOT NULL DEFAULT '0',
  `sold_qty` double DEFAULT '0',
  `BillTyp` varchar(10) DEFAULT 'PB',
  `UnitRateFC` double DEFAULT '0',
  `TotalFc` double DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `purchasebill` */

/*Table structure for table `purchasebill_order` */

DROP TABLE IF EXISTS `purchasebill_order`;

CREATE TABLE `purchasebill_order` (
  `PBillNo` int(11) DEFAULT '0',
  `PSiNo` int(11) DEFAULT '0',
  `ItemC` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `PItem` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `PQty` double DEFAULT '0',
  `sqft` double DEFAULT NULL,
  `PRate` double DEFAULT '0',
  `PDis` double DEFAULT '0',
  `PTotal` double DEFAULT '0',
  `PTaxP` double DEFAULT '0',
  `PTaxA` double DEFAULT '0',
  `PNetV` double DEFAULT '0',
  `Perc` double DEFAULT NULL,
  `MRP` double DEFAULT NULL,
  `SRP` double DEFAULT NULL,
  `PGoodsOn` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `PBDate` datetime DEFAULT NULL,
  `Stat` int(11) DEFAULT NULL,
  `Pack` double DEFAULT NULL,
  `Unit` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `Ex_date` datetime NOT NULL DEFAULT '2017-07-01 00:00:00',
  `batch_no` varchar(100) DEFAULT 'NIL',
  `trans_cost` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `purchasebill_order` */

insert  into `purchasebill_order`(`PBillNo`,`PSiNo`,`ItemC`,`PItem`,`PQty`,`sqft`,`PRate`,`PDis`,`PTotal`,`PTaxP`,`PTaxA`,`PNetV`,`Perc`,`MRP`,`SRP`,`PGoodsOn`,`PBDate`,`Stat`,`Pack`,`Unit`,`Ex_date`,`batch_no`,`trans_cost`) values (0,0,NULL,NULL,0,NULL,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2017-07-01 00:00:00','NIL',0);

/*Table structure for table `purchasereturn` */

DROP TABLE IF EXISTS `purchasereturn`;

CREATE TABLE `purchasereturn` (
  `SiNo` int(11) DEFAULT '0',
  `ItemC` varchar(50) DEFAULT NULL,
  `Item` varchar(50) DEFAULT NULL,
  `Qty` double DEFAULT '0',
  `sqft` double DEFAULT NULL,
  `Rate` double DEFAULT '0',
  `Dis` double DEFAULT '0',
  `Tot` double DEFAULT NULL,
  `TaxP` double DEFAULT NULL,
  `TaxA` double DEFAULT NULL,
  `Total` double DEFAULT '0',
  `RetNo` int(11) DEFAULT '0',
  `SBDate` datetime DEFAULT NULL,
  `Stat` int(11) DEFAULT NULL,
  `godown` varchar(255) DEFAULT NULL,
  `Pack` double DEFAULT NULL,
  `Unit` varchar(10) DEFAULT NULL,
  `batch_no` varchar(100) DEFAULT 'NIL',
  `local_app_user_entry_id` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `purchasereturn` */

/*Table structure for table `qutnet` */

DROP TABLE IF EXISTS `qutnet`;

CREATE TABLE `qutnet` (
  `QNo` int(11) NOT NULL DEFAULT '0',
  `Date1` datetime DEFAULT NULL,
  `Prod_Name` varchar(100) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `descr` varchar(255) DEFAULT NULL,
  `each_cost` double DEFAULT NULL,
  `nqty` double DEFAULT NULL,
  `total` double DEFAULT NULL,
  PRIMARY KEY (`QNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `qutnet` */

insert  into `qutnet`(`QNo`,`Date1`,`Prod_Name`,`qty`,`descr`,`each_cost`,`nqty`,`total`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Data for the table `sales` */

insert  into `sales`(`sino`,`date1`,`id`,`name1`,`gender`,`blood`,`add1`,`dob`,`mar_status`,`contact`,`age`,`nation`,`days`,`next_date`,`attach_report`,`gross_tot`,`con_fee`,`disc`,`other`,`grand_tot`,`payment_mode`,`paid`,`balance`,`symptoms`,`disease`,`history`,`taxp`,`taxa`,`case_no`,`del_date`,`doctors`,`complaint`,`daignosis`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',0,'0',0,NULL,'0',0,NULL,NULL,NULL,0,'0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `sales_jtable` */

DROP TABLE IF EXISTS `sales_jtable`;

CREATE TABLE `sales_jtable` (
  `billno` int(11) DEFAULT '0',
  `sino` int(11) DEFAULT '0',
  `description` varchar(150) DEFAULT NULL,
  `unit1` varchar(300) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `price` double DEFAULT '0',
  `total1` double DEFAULT NULL,
  `dose` varchar(30) DEFAULT NULL,
  `tax_per` double DEFAULT '0',
  `tax_amt` double DEFAULT '0',
  `net_value` double DEFAULT NULL,
  `pack` double DEFAULT NULL,
  `unit` varchar(100) DEFAULT NULL,
  `godown` varchar(100) DEFAULT NULL,
  `date1` datetime DEFAULT NULL,
  `form` varchar(10) DEFAULT NULL,
  `cost` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `sales_jtable` */

insert  into `sales_jtable`(`billno`,`sino`,`description`,`unit1`,`qty`,`price`,`total1`,`dose`,`tax_per`,`tax_amt`,`net_value`,`pack`,`unit`,`godown`,`date1`,`form`,`cost`) values (0,0,NULL,NULL,NULL,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0);

/*Table structure for table `salesbill` */

DROP TABLE IF EXISTS `salesbill`;

CREATE TABLE `salesbill` (
  `BillNo` int(11) DEFAULT '0',
  `SiNo` int(11) DEFAULT '0',
  `ItemC` varchar(50) DEFAULT NULL,
  `Item` varchar(255) DEFAULT NULL,
  `Qty` double DEFAULT '0',
  `sqft` double DEFAULT NULL,
  `Dis` double DEFAULT '0',
  `Rate` double DEFAULT '0',
  `Total` double DEFAULT '0',
  `TaxP` double DEFAULT '0',
  `TaxA` double DEFAULT '0',
  `NetV` double DEFAULT '0',
  `GoodsOn` varchar(50) DEFAULT NULL,
  `SBDate` datetime DEFAULT NULL,
  `Cst` double DEFAULT '0',
  `ItWiseDisAmt` double DEFAULT '0',
  `Stat` int(11) DEFAULT NULL,
  `BillTyp` varchar(255) DEFAULT NULL,
  `local_app_user_entry_id` varchar(50) DEFAULT NULL,
  `local_app_invoice_id` int(11) DEFAULT NULL,
  `Pack` double DEFAULT NULL,
  `Unit` varchar(10) DEFAULT NULL,
  `cst_id` varchar(30) DEFAULT NULL,
  `Fils` varchar(55) NOT NULL DEFAULT '000',
  `batch_no` varchar(100) DEFAULT 'NIL',
  `mrp` double DEFAULT '0',
  `exp_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `salesbill` */

/*Table structure for table `salesbill8b` */

DROP TABLE IF EXISTS `salesbill8b`;

CREATE TABLE `salesbill8b` (
  `BillNo` int(11) DEFAULT '0',
  `SiNo` int(11) DEFAULT '0',
  `ItemC` varchar(50) DEFAULT NULL,
  `Item` varchar(255) DEFAULT NULL,
  `Qty` double DEFAULT '0',
  `sqft` double DEFAULT '0',
  `Dis` double DEFAULT '0',
  `Rate` double DEFAULT '0',
  `Total` double DEFAULT '0',
  `TaxP` double DEFAULT '0',
  `TaxA` double DEFAULT '0',
  `NetV` double DEFAULT '0',
  `GoodsOn` varchar(50) DEFAULT NULL,
  `SBDate` datetime DEFAULT NULL,
  `Cst` double DEFAULT '0',
  `ItWiseDisAmt` double DEFAULT '0',
  `Stat` int(11) DEFAULT '0',
  `BillTyp` varchar(255) DEFAULT NULL,
  `Pack` double DEFAULT NULL,
  `Unit` varchar(10) DEFAULT NULL,
  `local_app_user_entry_id` varchar(100) DEFAULT NULL,
  `local_app_invoice_id` varchar(100) DEFAULT NULL,
  `batch_no` varchar(100) DEFAULT 'NIL',
  `mrp` double DEFAULT '0',
  `exp_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `salesbill8b` */

/*Table structure for table `salesitem` */

DROP TABLE IF EXISTS `salesitem`;

CREATE TABLE `salesitem` (
  `ItemNo` int(11) NOT NULL AUTO_INCREMENT,
  `ItemNameTextField` varchar(255) NOT NULL,
  `ItemC` varchar(255) NOT NULL,
  `StockInMain` double DEFAULT '0',
  `StockInGoDown` double DEFAULT '0',
  `Cost` double DEFAULT '0',
  `Rate1` double DEFAULT '0',
  `Rate2` double DEFAULT '0',
  `Rate3` double DEFAULT '0',
  `Disc` double DEFAULT '0',
  `Tax1` double DEFAULT '0',
  `DiscP` varchar(50) DEFAULT NULL,
  `Color` varchar(50) DEFAULT NULL,
  `Size` varchar(50) DEFAULT NULL,
  `MfgDate` datetime DEFAULT NULL,
  `CostRs` double DEFAULT NULL,
  `Typ` varchar(255) DEFAULT NULL,
  `Stat` double DEFAULT NULL,
  `Pack` double DEFAULT NULL,
  `prod_typ` varchar(255) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `RatePerInch` double DEFAULT NULL,
  `photo1` varchar(255) DEFAULT NULL,
  `curr_stock` double DEFAULT NULL,
  `SecUnit` varchar(50) DEFAULT NULL,
  `SecCostRate` double DEFAULT '0',
  `SecRetailRate` double DEFAULT '0',
  `SecWholesaleRate` double DEFAULT '0',
  `ThirdUnit` varchar(50) DEFAULT NULL,
  `ThirdCost` double DEFAULT NULL,
  `ThirdRate1` double DEFAULT NULL,
  `ThirdRate2` double DEFAULT NULL,
  `ThirdPack` double DEFAULT NULL,
  `SecBarcode` varchar(50) DEFAULT NULL,
  `ThirdBarcode` varchar(50) DEFAULT NULL,
  `SecRate2` double DEFAULT NULL,
  `NewItemCode` varchar(30) DEFAULT NULL,
  `Company` varchar(30) DEFAULT NULL,
  `ArabicName` varchar(255) DEFAULT NULL,
  `local_app_user_entry_id` varchar(100) DEFAULT NULL,
  `EmpCode` varchar(30) DEFAULT NULL,
  `subCategory` varchar(100) DEFAULT 'NIL',
  `carmaker` varchar(150) DEFAULT NULL,
  `model` varchar(150) DEFAULT NULL,
  `year1` varchar(150) DEFAULT NULL,
  `varient` varchar(150) DEFAULT NULL,
  `varient_compactible` text,
  `printer` varchar(250) DEFAULT NULL,
  `lockItem` varchar(150) DEFAULT '0',
  PRIMARY KEY (`ItemNameTextField`,`ItemC`),
  KEY `ItemNo` (`ItemNo`)
) ENGINE=InnoDB AUTO_INCREMENT=3704 DEFAULT CHARSET=utf8;

/*Data for the table `salesitem` */

/*Table structure for table `salesreturn` */

DROP TABLE IF EXISTS `salesreturn`;

CREATE TABLE `salesreturn` (
  `SiNo` int(11) DEFAULT '0',
  `ItemC` varchar(50) DEFAULT NULL,
  `Item` varchar(255) DEFAULT NULL,
  `Qty` double DEFAULT '0',
  `sqft` double DEFAULT NULL,
  `Rate` double DEFAULT '0',
  `Dis` double DEFAULT '0',
  `Tot` double DEFAULT NULL,
  `TaxP` double DEFAULT NULL,
  `TaxA` double DEFAULT NULL,
  `Total` double DEFAULT '0',
  `RetNo` int(11) DEFAULT '0',
  `SBDate` datetime DEFAULT NULL,
  `Stat` int(11) DEFAULT NULL,
  `godown` varchar(255) DEFAULT NULL,
  `Pack` double DEFAULT NULL,
  `Unit` varchar(10) DEFAULT NULL,
  `local_app_user_entry_id` varchar(100) DEFAULT NULL,
  `batch_no` varchar(100) DEFAULT 'NIL'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `salesreturn` */

/*Table structure for table `saverec` */

DROP TABLE IF EXISTS `saverec`;

CREATE TABLE `saverec` (
  `SiNo` int(11) DEFAULT NULL,
  `InvoiceNo` int(11) DEFAULT NULL,
  `BillNo` int(11) DEFAULT NULL,
  `LedgerType` varchar(50) DEFAULT NULL,
  `LedgerName` varchar(250) DEFAULT NULL,
  `TransactionType` varchar(50) DEFAULT NULL,
  `Debit` double DEFAULT '0',
  `Credit` double DEFAULT '0',
  `Narration` varchar(250) DEFAULT NULL,
  `Description` varchar(250) DEFAULT NULL,
  `Date1` datetime DEFAULT NULL,
  `Balance` varchar(250) DEFAULT NULL,
  `Employee` varchar(100) DEFAULT NULL,
  `godown` varchar(100) DEFAULT NULL,
  `TaxP` double DEFAULT '0',
  `TaxAmt` double DEFAULT '0',
  `TotalAmt` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `saverec` */

/*Table structure for table `service_bill` */

DROP TABLE IF EXISTS `service_bill`;

CREATE TABLE `service_bill` (
  `BillNo` int(11) NOT NULL,
  `SiNo` int(11) NOT NULL,
  `ServiceName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `Qty` double NOT NULL DEFAULT '0',
  `RATE` double NOT NULL DEFAULT '0',
  `Total` double NOT NULL DEFAULT '0',
  `Unit` varchar(25) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`BillNo`,`SiNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `service_bill` */

/*Table structure for table `service_master` */

DROP TABLE IF EXISTS `service_master`;

CREATE TABLE `service_master` (
  `ServiceNo` int(11) NOT NULL,
  `Date1` datetime DEFAULT NULL,
  `DueDate` datetime DEFAULT NULL,
  `PartyName` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `CashParty` varchar(255) DEFAULT NULL,
  `PhoneNo` varchar(55) CHARACTER SET utf8 DEFAULT NULL,
  `Add1` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `Add2` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `IMEI_NO` varchar(55) CHARACTER SET utf8 DEFAULT NULL,
  `SecurityCode` varchar(55) CHARACTER SET utf8 DEFAULT NULL,
  `JobAssign` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `SubTotal` double DEFAULT '0',
  `Disc` double DEFAULT '0',
  `VatPerc` double DEFAULT '0',
  `VatAmt` double DEFAULT '0',
  `GrandTotal` double DEFAULT '0',
  `CustomerComment` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `StaffComment` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `Supplier` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `PhoneImg` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `CashReceived` double DEFAULT '0',
  `CollectionSino` int(11) DEFAULT NULL,
  `Status` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `modelNo` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `RegNo` varchar(255) DEFAULT NULL,
  `Make` varchar(100) DEFAULT NULL,
  `ModelYear` varchar(55) DEFAULT NULL,
  `Odometer` varchar(100) DEFAULT NULL,
  `NoCylinder` int(10) DEFAULT NULL,
  `ChasisNo` varchar(100) DEFAULT NULL,
  `ServiceTyp` varchar(100) DEFAULT NULL,
  `RecTime` time DEFAULT NULL,
  `ReceiptType` varchar(50) CHARACTER SET utf8 DEFAULT 'Cash',
  `SrvImg1` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `SrvImg2` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `SrvImg3` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `Sales_no` int(11) DEFAULT NULL,
  `DelTime` time DEFAULT NULL,
  PRIMARY KEY (`ServiceNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `service_master` */

insert  into `service_master`(`ServiceNo`,`Date1`,`DueDate`,`PartyName`,`CashParty`,`PhoneNo`,`Add1`,`Add2`,`IMEI_NO`,`SecurityCode`,`JobAssign`,`SubTotal`,`Disc`,`VatPerc`,`VatAmt`,`GrandTotal`,`CustomerComment`,`StaffComment`,`Supplier`,`PhoneImg`,`CashReceived`,`CollectionSino`,`Status`,`modelNo`,`RegNo`,`Make`,`ModelYear`,`Odometer`,`NoCylinder`,`ChasisNo`,`ServiceTyp`,`RecTime`,`ReceiptType`,`SrvImg1`,`SrvImg2`,`SrvImg3`,`Sales_no`,`DelTime`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Cash',NULL,NULL,NULL,0,NULL);

/*Table structure for table `service_provided` */

DROP TABLE IF EXISTS `service_provided`;

CREATE TABLE `service_provided` (
  `id` int(11) DEFAULT NULL,
  `SiNo` int(11) DEFAULT NULL,
  `ServiceProvided` varchar(50) DEFAULT NULL,
  `qty` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `service_provided` */

/*Table structure for table `setdynamic` */

DROP TABLE IF EXISTS `setdynamic`;

CREATE TABLE `setdynamic` (
  `position` varchar(100) DEFAULT NULL,
  `iconName` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `image` varchar(250) DEFAULT NULL,
  `fun_name` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `setdynamic` */

insert  into `setdynamic`(`position`,`iconName`,`image`,`fun_name`) values ('1','SALES REPORT#تقرير المبيعات','sales report.png','Sales Report'),('2','RECEIPT NEW','receiptnew.png','Receipt New'),('3','PAYMENT NEW','PaymentNew.png','Payment New'),('4','SALES RETURN','salesreturn80x80.png','Sales Return'),('5','ORDER FORM','Order Form.png','Order Form'),('6','PURCHASE RETURN','Purchase return.png','Purchase Return'),('7','PURCHASE ORDER','Purchase order80x80.png','Purchase Order'),('8','SALES OUTSTANDING','salesoutstanding.png','Sundry Debtors Outstanding'),('9','PURCHASE OUTSTANDING','purchaseoutstanding.png','Sundry Creditors Outstanding'),('10','STOCK REPORT','stockreport80x80.png','Stock Report'),('11','PURCHASE LEDGER','purchaseledger.png','Purchase Ledger'),('12','SALES LEDGER','salesledger.png','Sales Ledger'),('13','CASH BOOK','cashbook.png','Cash Book'),('14','SALES DETAILS','salesdetails.png','Sales Detail'),('15','PURCHASE DETAILS','purchasedetails.png','New Purchase List'),('16','EXPENSE REPORT','Journal80x80.png','Expense Summary'),('17','<html><center>Ledger<br>','Ledger.png','Ledger'),('18','<html><center>Add Product<br>','Add product.png','Sales Item'),('19','<html><center>Sales Invoice<br>B2B#فاتورة مبيعات B2B','B2B.png','Sales Invoice B2B'),('20','<html><center>Sales Invoice<br>B2C','B2C.png','Sales Invoice B2C'),('21','Sales Return','pos.png','Sales Return'),('22','<html><center>Payment<br>','Payment.png','Payment'),('23','<html><center>Receipt<br>','Receipt.png','Receipt'),('24','<html><center>Purchase<br>','Purchase.png','PurchaseBill');

/*Table structure for table `settings` */

DROP TABLE IF EXISTS `settings`;

CREATE TABLE `settings` (
  `initialrun` int(11) DEFAULT NULL,
  `organ_name` varchar(180) NOT NULL,
  `sticker_name` varchar(180) DEFAULT NULL,
  `add1` varchar(180) DEFAULT NULL,
  `add2` varchar(180) DEFAULT NULL,
  `ph` varchar(180) DEFAULT NULL,
  `contact` varchar(180) DEFAULT NULL,
  `sms` varchar(180) DEFAULT NULL,
  `scale` varchar(180) DEFAULT NULL,
  `account_name` varchar(180) DEFAULT NULL,
  `website` varchar(180) DEFAULT NULL,
  `email` varchar(180) DEFAULT NULL,
  `tin_no` varchar(100) DEFAULT NULL,
  `cst` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`organ_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `settings` */

insert  into `settings`(`initialrun`,`organ_name`,`sticker_name`,`add1`,`add2`,`ph`,`contact`,`sms`,`scale`,`account_name`,`website`,`email`,`tin_no`,`cst`) values (0,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `settings2` */

DROP TABLE IF EXISTS `settings2`;

CREATE TABLE `settings2` (
  `names` varchar(150) NOT NULL,
  `type` varchar(150) DEFAULT NULL,
  `num` int(11) DEFAULT '0',
  PRIMARY KEY (`names`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `settings2` */

/*Table structure for table `share_holder` */

DROP TABLE IF EXISTS `share_holder`;

CREATE TABLE `share_holder` (
  `holder_name` varchar(255) NOT NULL,
  `amount_invstd` double DEFAULT '0',
  `percent_invstd` double DEFAULT '0',
  `godown` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `share_holder` */

/*Table structure for table `sms_control` */

DROP TABLE IF EXISTS `sms_control`;

CREATE TABLE `sms_control` (
  `msg_url` varchar(2063) NOT NULL DEFAULT 'NIL',
  `num` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `sms_control` */

/*Table structure for table `srmasterdetails` */

DROP TABLE IF EXISTS `srmasterdetails`;

CREATE TABLE `srmasterdetails` (
  `RetNo` int(11) NOT NULL DEFAULT '0',
  `BillDate` datetime DEFAULT NULL,
  `BillPartyName` varchar(50) DEFAULT NULL,
  `BillTotalField` double DEFAULT '0',
  `BillDiscAmtField` double DEFAULT '0',
  `BillDiscPercField` double DEFAULT '0',
  `BillTaxField` double DEFAULT '0',
  `BillPackageField` double DEFAULT '0',
  `BillNetTotalField` double DEFAULT '0',
  `BillTyp` varchar(50) DEFAULT NULL,
  `TDiscAmt` double DEFAULT '0',
  `TaxAmt` double DEFAULT '0',
  `Employee` varchar(50) DEFAULT NULL,
  `billno` int(11) DEFAULT NULL,
  `godown` varchar(255) DEFAULT NULL,
  `local_app_user_entry_id` varchar(100) DEFAULT NULL,
  `BatchNo` double DEFAULT '0',
  `netQty` double DEFAULT '0',
  `sys_id` varchar(100) DEFAULT 'SYS1',
  `place` varchar(100) DEFAULT NULL,
  `cst_id` int(11) DEFAULT '0',
  `Profit` double DEFAULT '0',
  `TaxBillNo` int(11) DEFAULT '0',
  `fin_year` varchar(25) DEFAULT '0',
  `BillTime` varchar(30) DEFAULT NULL,
  `prefix` varchar(50) DEFAULT '',
  `TItTaxAmt` double DEFAULT NULL,
  `narration` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RetNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `srmasterdetails` */

insert  into `srmasterdetails`(`RetNo`,`BillDate`,`BillPartyName`,`BillTotalField`,`BillDiscAmtField`,`BillDiscPercField`,`BillTaxField`,`BillPackageField`,`BillNetTotalField`,`BillTyp`,`TDiscAmt`,`TaxAmt`,`Employee`,`billno`,`godown`,`local_app_user_entry_id`,`BatchNo`,`netQty`,`sys_id`,`place`,`cst_id`,`Profit`,`TaxBillNo`,`fin_year`,`BillTime`,`prefix`,`TItTaxAmt`,`narration`) values (0,NULL,NULL,0,0,0,0,0,0,NULL,0,0,NULL,NULL,NULL,NULL,0,0,'SYS1',NULL,0,0,0,'2023',NULL,'',NULL,NULL);

/*Table structure for table `status_table` */

DROP TABLE IF EXISTS `status_table`;

CREATE TABLE `status_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `params` varchar(100) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `typ` varchar(100) DEFAULT NULL,
  `value` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=latin1;

/*Data for the table `status_table` */

insert  into `status_table`(`id`,`params`,`description`,`typ`,`value`) values (13,'DBLOGGER NO','NIL','CONFIG',NULL),(14,'ItemCode123','NIL','CONFIG',NULL),(15,'MAIN','NIL','CONFIG',''),(16,'SYS1','NIL','CONFIG',NULL),(17,'www.google.in','NIL','CONFIG',NULL),(18,'MRP','NIL','CONFIG','CURRENCY SHORTNAME1'),(19,'YRP','NIL','CONFIG',NULL),(20,'YES COST','NIL','CONFIG',NULL),(21,'OFFLINE','NIL','CONFIG',NULL),(22,'DECIMAL_VALUE','NIL','CONFIG','3'),(23,'PRIMARY_CURRENCY','NIL','CONFIG','Rupees'),(24,'SUB_CURRENCY','NIL','CONFIG','Paisa'),(25,'CHANGE','NIL','CONFIG',NULL),(26,'NO ROUND','NIL','CONFIG',NULL),(27,'NO SMS','NIL','CONFIG',NULL),(28,'NO B2B CESS','NIL','CONFIG',NULL),(29,'NO B2C CESS','NIL','CONFIG',NULL),(30,'CONTACT WISE','NIL','CONFIG',NULL),(31,'NO PRINT DNOTE','NIL','CONFIG',NULL),(32,'1010','NIL','CONFIG',NULL),(33,'NO FREE','NIL','CONFIG',NULL),(34,'NO DISCPERQTY','NIL','CONFIG',NULL),(35,'NO_SR_DISC_PERCENTAGE','NIL','CONFIG',NULL),(36,'W.H PURCHASE COST','NIL','CONFIG',NULL),(37,'ITEMCODE INCREMENT NO','NIL','CONFIG',NULL),(38,'20','NIL','CONFIG',NULL),(39,'5','NIL','CONFIG',NULL),(40,'STOCK CHECK NO','NIL','CONFIG',NULL),(41,'0','NIL','CONFIG',NULL),(42,'ITEM CODE','NIL','CONFIG',NULL),(43,'P-RATE','NIL','CONFIG',NULL),(44,'12','NIL','CONFIG',NULL),(45,'NO-SB RATE UPDATE','NIL','CONFIG',NULL),(46,'BATCH_EXPIRY','NIL','CONFIG','YES BATCH-YES EXPIRY'),(47,'NO GODOWNWISE PROUCT','NIL','CONFIG',NULL),(48,'NO TRANS COST','NIL','CONFIG',NULL),(49,'NO NON STOCK ITEMS','NIL','CONFIG',NULL),(50,'NO LAST SELLING PRICE UPDATE FROM ADD PRODUCT','NIL','CONFIG',NULL),(51,'NO CHECK COST IN SALES INV','NIL','CONFIG',NULL),(52,'NO SALSE_INVOICE_VALIDATION','NIL','CONFIG',NULL),(53,'NO AUTO_MOBILE_IN_ADDPRODUCT','NIL','CONFIG',NULL),(54,'NO_COST&CODE_FROM_SALESITEM','NIL','CONFIG',NULL),(55,'NO_AUTO_COMPATIVITY_IN_SALESITEM','NIL','CONFIG',NULL),(56,'NO_PURCHASE_DUPICATE_ENTRY','NIL','CONFIG',NULL),(57,'2','NIL','CONFIG',NULL),(58,'NO_REDEEMPOINT','NIL','CONFIG',NULL),(59,'YES_BARCODE_WISE_PRODUCTION','NIL','CONFIG','YES'),(60,'NO_EDIT_BATCH_SALES','NIL','CONFIG',NULL),(61,'ON_RESTORE','NIL','CONFIG',NULL),(62,'NO_RENT_MANAGEMENT','NIL','CONFIG',NULL),(63,'NO_PHARMACY','NIL','CONFIG',NULL),(64,'AMT_WORDS_OTHER','NIL','CONFIG',NULL),(65,'24','NIL','CONFIG',NULL),(66,'NO PURCHASE INVOICE VALIDATION','NIL','CONFIG',NULL),(67,'7','NIL','CONFIG',NULL),(68,'YES_MALAYALAM_TRANS','NIL','CONFIG',NULL),(69,'INCENTIVE_NETTOTAL_WISE','NIL','CONFIG',NULL),(70,'YES_LAST_PURCHASE_BARCODE','NIL','CONFIG',NULL),(71,'YES_PRIVILAGES_USER&WH','NIL','CONFIG',NULL),(72,'YES_SET_OFFER','NIL','CONFIG',NULL),(73,'YES_ZERO_COST','NIL','CONFIG',NULL),(74,'YES_EMP_LIAB_PNL1','NIL','CONFIG',NULL),(75,'YES_TAX_INVOICE_NUMBER','NIL','CONFIG',NULL),(76,'YES_TODAY_SALES','NIL','CONFIG',NULL),(77,'NO_STK_PBILL_BAR_WISE','NIL','CONFIG',NULL),(78,'NO_PUR_DISC_AMT_PNL1','NIL','CONFIG',NULL),(79,'NO_INVENTORY','NIL','CONFIG',NULL),(82,'USERWISE_PARTY',NULL,'CONFIG','YES'),(86,'1027',NULL,'CONFIG','CLOSE BATCH'),(87,'THERMAL_IP1',NULL,'CONFIG','192.168.1.111'),(88,'PRINT_ADDRESS',NULL,'CONFIG','YES'),(89,'DRAWER',NULL,'CONFIG','YES'),(90,'MATCH_JOURNAL',NULL,'CONFIG','YES'),(91,'KOT_ENABLED',NULL,'CONFIG','YES'),(92,'ALL_KOT',NULL,'CONFIG','YES'),(93,'SECOND_INVOICE',NULL,'CONFIG','YES'),(94,'ADD_ON',NULL,'CONFIG','YES'),(95,'ORDER_NO_INCREMENT',NULL,'CONFIG','NO'),(98,'PRODUCT_TYP','','CONFIG','SERVICE,FINISHED GOODS,RAW MATERIAL');

/*Table structure for table `sub_material` */

DROP TABLE IF EXISTS `sub_material`;

CREATE TABLE `sub_material` (
  `qno` int(11) DEFAULT NULL,
  `sino` int(11) DEFAULT NULL,
  `material` varchar(250) DEFAULT NULL,
  `qty` double DEFAULT '0',
  `rate` double DEFAULT '0',
  `total` double DEFAULT '0',
  `netTotal` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `sub_material` */

/*Table structure for table `subledger` */

DROP TABLE IF EXISTS `subledger`;

CREATE TABLE `subledger` (
  `Code1` varchar(100) DEFAULT NULL,
  `name1` varchar(255) NOT NULL,
  `Typ` varchar(100) DEFAULT NULL,
  `status_` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `subledger` */

insert  into `subledger`(`Code1`,`name1`,`Typ`,`status_`) values ('1000','NIL',NULL,NULL);

/*Table structure for table `temp` */

DROP TABLE IF EXISTS `temp`;

CREATE TABLE `temp` (
  `sino` varchar(100) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `old_amt` varchar(100) DEFAULT NULL,
  `curr_bal` varchar(100) DEFAULT NULL,
  `total` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `date` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `debit` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `credit` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `balance1` varchar(100) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `temp` */

/*Table structure for table `temp2` */

DROP TABLE IF EXISTS `temp2`;

CREATE TABLE `temp2` (
  `sino` varchar(100) DEFAULT '0',
  `customer` varchar(100) DEFAULT NULL,
  `item` varchar(100) DEFAULT NULL,
  `qty` varchar(100) DEFAULT NULL,
  `rate` varchar(100) DEFAULT NULL,
  `amount` varchar(100) DEFAULT NULL,
  `box_name` varchar(100) DEFAULT NULL,
  `sales_man` varchar(100) DEFAULT NULL,
  `date` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `temp2` */

/*Table structure for table `temp_print` */

DROP TABLE IF EXISTS `temp_print`;

CREATE TABLE `temp_print` (
  `si_no` varchar(50) DEFAULT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `item_name` varchar(120) DEFAULT NULL,
  `qty` varchar(50) DEFAULT NULL,
  `rate` varchar(50) DEFAULT NULL,
  `price1` varchar(50) DEFAULT NULL,
  `price2` varchar(50) DEFAULT NULL,
  `rate_code` varchar(100) DEFAULT NULL,
  `party_code` varchar(100) DEFAULT NULL,
  `size` varchar(100) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `shop_name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `temp_print` */

/*Table structure for table `tempbarc` */

DROP TABLE IF EXISTS `tempbarc`;

CREATE TABLE `tempbarc` (
  `Sino` varchar(255) DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `BarNum` varchar(50) DEFAULT NULL,
  `BarStar` varchar(50) DEFAULT NULL,
  `Mrp` varchar(50) DEFAULT NULL,
  `Rrp` varchar(50) DEFAULT NULL,
  `CostCode` varchar(50) DEFAULT NULL,
  `PartyCode` varchar(50) DEFAULT NULL,
  `ShopName` varchar(255) DEFAULT NULL,
  `Code2` varchar(255) DEFAULT NULL,
  `art_no` varchar(100) DEFAULT NULL,
  `color` varchar(100) DEFAULT NULL,
  `materials` varchar(255) DEFAULT NULL,
  `size` varchar(100) DEFAULT NULL,
  `qty` varchar(100) DEFAULT NULL,
  `arb_num` varchar(255) DEFAULT NULL,
  KEY `PartyCode` (`PartyCode`),
  KEY `Code2` (`Code2`),
  KEY `BarStar` (`BarStar`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `tempbarc` */

/*Table structure for table `templabrpt` */

DROP TABLE IF EXISTS `templabrpt`;

CREATE TABLE `templabrpt` (
  `Date1` datetime DEFAULT NULL,
  `Particulars` varchar(50) DEFAULT NULL,
  `Pcs` int(11) DEFAULT NULL,
  `Credit` double DEFAULT '0',
  `Debit` double DEFAULT '0',
  `color` varchar(100) DEFAULT NULL,
  `size1` varchar(100) DEFAULT NULL,
  `collection_no` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `templabrpt` */

insert  into `templabrpt`(`Date1`,`Particulars`,`Pcs`,`Credit`,`Debit`,`color`,`size1`,`collection_no`) values (NULL,'Opening',NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `tempnewsaledetails` */

DROP TABLE IF EXISTS `tempnewsaledetails`;

CREATE TABLE `tempnewsaledetails` (
  `SiNo` int(11) DEFAULT '0',
  `BillNo` int(11) DEFAULT '0',
  `Date1` datetime DEFAULT NULL,
  `Party` varchar(50) DEFAULT NULL,
  `Add1` varchar(50) DEFAULT NULL,
  `Tin` varchar(50) DEFAULT NULL,
  `Tot` double DEFAULT '0',
  `Dis` double DEFAULT '0',
  `Tax` double DEFAULT '0',
  `Cess` double DEFAULT '0',
  `NTot` double DEFAULT '0',
  `Form` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `tempnewsaledetails` */

/*Table structure for table `tempqut` */

DROP TABLE IF EXISTS `tempqut`;

CREATE TABLE `tempqut` (
  `SiNo` int(11) DEFAULT '0',
  `MatName` varchar(50) DEFAULT NULL,
  `Typ` varchar(50) DEFAULT NULL,
  `Part` varchar(50) DEFAULT NULL,
  `Breadth` varchar(50) DEFAULT NULL,
  `Length` varchar(50) DEFAULT NULL,
  `Qty` varchar(50) DEFAULT NULL,
  `Tot` double DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `tempqut` */

/*Table structure for table `temptable` */

DROP TABLE IF EXISTS `temptable`;

CREATE TABLE `temptable` (
  `PartyNo` int(11) DEFAULT '0',
  `Name` varchar(255) DEFAULT NULL,
  `Bal` double DEFAULT '0',
  `emp` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `temptable` */

insert  into `temptable`(`PartyNo`,`Name`,`Bal`,`emp`) values (0,'NIL',0,NULL);

/*Table structure for table `temptaxsales` */

DROP TABLE IF EXISTS `temptaxsales`;

CREATE TABLE `temptaxsales` (
  `Date1` varchar(255) DEFAULT NULL,
  `Lorry` varchar(255) DEFAULT NULL,
  `BillNo` varchar(50) DEFAULT NULL,
  `Wt` varchar(50) DEFAULT NULL,
  `Decr` varchar(50) DEFAULT NULL,
  `Qty` varchar(50) DEFAULT NULL,
  `Rate` varchar(50) DEFAULT NULL,
  `Tot` varchar(50) DEFAULT NULL,
  `Tax` varchar(50) DEFAULT NULL,
  `NTot` varchar(50) DEFAULT NULL,
  `Debit` varchar(255) DEFAULT NULL,
  `eleven` varchar(50) DEFAULT NULL,
  `twelve` varchar(50) DEFAULT NULL,
  `add1` varchar(100) DEFAULT NULL,
  `tin` varchar(100) DEFAULT NULL,
  `form` varchar(100) DEFAULT NULL,
  `dis` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `temptaxsales` */

/*Table structure for table `test_details` */

DROP TABLE IF EXISTS `test_details`;

CREATE TABLE `test_details` (
  `test_no` int(11) DEFAULT NULL,
  `billdate` date DEFAULT NULL,
  `test_name` varchar(150) DEFAULT NULL,
  `sl_no` int(11) DEFAULT NULL,
  `sub_name` varchar(150) DEFAULT NULL,
  `min_val` double DEFAULT NULL,
  `max_val` double DEFAULT NULL,
  `ref_range` varchar(150) DEFAULT NULL,
  `formula` varchar(255) DEFAULT NULL,
  `price_test` double DEFAULT '0',
  `price_subt` double DEFAULT '0',
  `unit_test` varchar(150) DEFAULT NULL,
  `normalF` varchar(255) DEFAULT NULL,
  `normalC` varchar(255) DEFAULT NULL,
  `varient_typ` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `test_details` */

insert  into `test_details`(`test_no`,`billdate`,`test_name`,`sl_no`,`sub_name`,`min_val`,`max_val`,`ref_range`,`formula`,`price_test`,`price_subt`,`unit_test`,`normalF`,`normalC`,`varient_typ`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,NULL,NULL);

/*Table structure for table `test_result` */

DROP TABLE IF EXISTS `test_result`;

CREATE TABLE `test_result` (
  `billno` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `slno` int(11) DEFAULT NULL,
  `test_parameter` varchar(150) DEFAULT NULL,
  `result` double DEFAULT NULL,
  `refernce_range` varchar(150) DEFAULT NULL,
  `num` int(11) NOT NULL AUTO_INCREMENT,
  `normal_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`num`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `test_result` */

insert  into `test_result`(`billno`,`date`,`slno`,`test_parameter`,`result`,`refernce_range`,`num`,`normal_value`) values (0,NULL,NULL,NULL,NULL,NULL,1,NULL);

/*Table structure for table `testtable` */

DROP TABLE IF EXISTS `testtable`;

CREATE TABLE `testtable` (
  `text1` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Data for the table `testtable` */

/*Table structure for table `to_print_tbl` */

DROP TABLE IF EXISTS `to_print_tbl`;

CREATE TABLE `to_print_tbl` (
  `item_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `order_no` varchar(100) CHARACTER SET utf8 NOT NULL,
  `time1` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `table_no` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `qty` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `waiter_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `print_status` int(11) DEFAULT '0',
  `kit` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `notes` varchar(200) CHARACTER SET utf8 DEFAULT 'NIL',
  PRIMARY KEY (`item_name`,`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `to_print_tbl` */

/*Table structure for table `trip_master` */

DROP TABLE IF EXISTS `trip_master`;

CREATE TABLE `trip_master` (
  `sino` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `driver` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `vehicle_typ` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `mobile` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `des` varchar(400) CHARACTER SET utf8 DEFAULT NULL,
  `vehicle_no` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `trip_fr` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `total` double DEFAULT NULL,
  `advance` double DEFAULT NULL,
  `net_total` double DEFAULT NULL,
  `km_from` double DEFAULT NULL,
  `km_to` double DEFAULT NULL,
  `km_total` double DEFAULT NULL,
  `total_expense` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `trip_master` */

insert  into `trip_master`(`sino`,`date`,`driver`,`vehicle_typ`,`mobile`,`des`,`vehicle_no`,`trip_fr`,`discount`,`total`,`advance`,`net_total`,`km_from`,`km_to`,`km_total`,`total_expense`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `trip_table` */

DROP TABLE IF EXISTS `trip_table`;

CREATE TABLE `trip_table` (
  `billno` bigint(20) DEFAULT NULL,
  `sino` int(11) DEFAULT NULL,
  `typ` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `income` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `unit` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `total` double DEFAULT NULL,
  `sino_exp` int(11) DEFAULT NULL,
  `expense` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `exp_amt` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `trip_table` */

/*Table structure for table `unused_barcode` */

DROP TABLE IF EXISTS `unused_barcode`;

CREATE TABLE `unused_barcode` (
  `sino` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `barcode` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `unused_barcode` */

/*Table structure for table `user_privilage` */

DROP TABLE IF EXISTS `user_privilage`;

CREATE TABLE `user_privilage` (
  `usr_name` varchar(20) NOT NULL,
  `sales` varchar(20) NOT NULL DEFAULT '1-1-1',
  `purchase` varchar(20) NOT NULL DEFAULT '1-1-1-1',
  `sales_ret` varchar(20) NOT NULL DEFAULT '1-1-1',
  `purch_ret` varchar(20) NOT NULL DEFAULT '1-1-1-1',
  `salesitem` varchar(20) NOT NULL DEFAULT '1-1-1',
  `ledger` varchar(20) NOT NULL DEFAULT '1-1-1-1',
  `warehouse` varchar(20) NOT NULL DEFAULT '1-1-1',
  `waretrans` varchar(20) NOT NULL DEFAULT '1-1-1',
  `reports` varchar(500) NOT NULL DEFAULT '1-1-1-1-1-1-1-1',
  `receipt` varchar(20) NOT NULL DEFAULT '1-1-1-1',
  `apk_sync` varchar(5) NOT NULL DEFAULT '0',
  `reports_sec` varchar(200) NOT NULL DEFAULT '1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1',
  PRIMARY KEY (`usr_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `user_privilage` */

insert  into `user_privilage`(`usr_name`,`sales`,`purchase`,`sales_ret`,`purch_ret`,`salesitem`,`ledger`,`warehouse`,`waretrans`,`reports`,`receipt`,`apk_sync`,`reports_sec`) values ('ABDURAHMAN','1-0-1','1-1-1-1','1-1-1','1-1-1-1','0-0-0','0-0-0-0','0-0-0','0-0-0','0-0-0-0-0-0-0-0-0','1-1-1-1','0','0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-1-0-1-0-0'),('Admin','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('AFSAL','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('AJMAL','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('DDEE','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('FARIS','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','0-0-0','0-0-0-0-0-0-0-0-0','1-1-1-1','0','0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0'),('FASAL','1-1-1','1-1-1-1','0-0-0','1-1-1-1','0-0-0','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-0-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('FAZIL','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('GARJ','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('HUSSAIN','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('JACK','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('NABEEL','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('RAHIL','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('RAHOOF','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('RAOOF','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('RASHID','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('SABEEH','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('SAKEER','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1'),('USER1','1-0-1','1-1-1-1','1-1-1','1-1-1-1','0-0-0','0-0-0-0','0-0-0','0-0-0','0-0-0-0-0-0-0-0-0','1-1-1-1','0','0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0'),('VIBIN','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1-1','1-1-1','1-1-1','1-1-1-1-1-1-1-1','1-1-1-1','0','1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1');

/*Table structure for table `userprevillage_apk` */

DROP TABLE IF EXISTS `userprevillage_apk`;

CREATE TABLE `userprevillage_apk` (
  `apk_user` varchar(250) CHARACTER SET utf8 NOT NULL,
  `trade_transactions` varchar(250) CHARACTER SET utf8 DEFAULT '0-0-0-0-0',
  `account_entries` varchar(250) CHARACTER SET utf8 DEFAULT '0-0-0',
  `business_identifiers` varchar(250) CHARACTER SET utf8 DEFAULT '0-0-0-0-0',
  `printer_status` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `apk_sync_stat` varchar(250) CHARACTER SET utf8 DEFAULT '0',
  `menu_management` varchar(250) CHARACTER SET utf8 DEFAULT '0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0',
  `sync_pervillage` varchar(250) CHARACTER SET utf8 DEFAULT '0-0-0-0-0-0-0-0-0',
  `zatca_access` varchar(250) CHARACTER SET utf8 DEFAULT NULL,
  `other_identifiers` varchar(1000) DEFAULT '{"transaction":"0","take_stock":"0","casbook":"0","catogory":"0","visited_shop":"0","nw_salesbill":"0","retail_whole":"0","enqiry":"0","en_order":"0","pay_method":"0","en_dust":"0","stk_qty_change":"0","party_enquiry":"0","gst_vat":"GST"}',
  PRIMARY KEY (`apk_user`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `userprevillage_apk` */

/*Table structure for table `varients` */

DROP TABLE IF EXISTS `varients`;

CREATE TABLE `varients` (
  `varient_types` varchar(150) DEFAULT NULL,
  `description` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `varients` */

insert  into `varients`(`varient_types`,`description`) values ('YEAR','2021'),('VARIENT','BLACK'),('CARMAKER','BLUE'),('CARMAKER','RED'),('MODEL','MODEL-1'),('VARIENT','LOW'),('VARIENT','RED'),('MODEL','MOD2'),('YEAR','2020');

/*Table structure for table `vehicle_wt_mngt` */

DROP TABLE IF EXISTS `vehicle_wt_mngt`;

CREATE TABLE `vehicle_wt_mngt` (
  `sino` int(11) NOT NULL,
  `billno` int(11) DEFAULT NULL,
  `billdate` datetime DEFAULT NULL,
  `vehic_no` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `cmp_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `sup_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `driver_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `driver_mob_no` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `vehic_typ` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `material` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `bill_weight` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `gross_weight` double DEFAULT NULL,
  `tire_weight` double DEFAULT NULL,
  `net_weight` double DEFAULT NULL,
  `date_in` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `date_out` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`sino`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `vehicle_wt_mngt` */

insert  into `vehicle_wt_mngt`(`sino`,`billno`,`billdate`,`vehic_no`,`cmp_name`,`sup_name`,`driver_name`,`driver_mob_no`,`vehic_typ`,`material`,`bill_weight`,`notes`,`gross_weight`,`tire_weight`,`net_weight`,`date_in`,`date_out`) values (0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL);

/*Table structure for table `zatca_config` */

DROP TABLE IF EXISTS `zatca_config`;

CREATE TABLE `zatca_config` (
  `common_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `si_no` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `org_identifier` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `org_unit_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `country` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `inv_typ` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `bussiness_category` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `org_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `otp` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `zatca_config` */

insert  into `zatca_config`(`common_name`,`si_no`,`org_identifier`,`org_unit_name`,`country`,`inv_typ`,`address`,`bussiness_category`,`org_name`,`otp`) values ('FAHAD TESTING','1-TST|2-TST|3-174a701e-96b5-45d4-9857-3574202df381','399999999900003','HEADOFFICE','SA','1100','JEDDAH','SUPERMARKET','HEADOFFICE','556467');

/*Table structure for table `zatca_einv_stat` */

DROP TABLE IF EXISTS `zatca_einv_stat`;

CREATE TABLE `zatca_einv_stat` (
  `sino` int(11) NOT NULL AUTO_INCREMENT,
  `bill_no` varchar(15) CHARACTER SET utf8 DEFAULT NULL,
  `bill_form` varchar(25) CHARACTER SET utf8 DEFAULT NULL,
  `inv_type` varchar(25) CHARACTER SET utf8 DEFAULT NULL,
  `bill_party` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `bill_wotax_amt` double DEFAULT '0',
  `bill_tax_amt` double DEFAULT '0',
  `bill_net_amt` double DEFAULT '0',
  `resp_code` int(11) DEFAULT '0',
  `resp_status` varchar(15) CHARACTER SET utf8 DEFAULT NULL,
  `resp_message` text CHARACTER SET utf8,
  `inv_id` varchar(15) CHARACTER SET utf8 DEFAULT NULL,
  `inv_uuid` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `qr_code` text CHARACTER SET utf8,
  `resp_warning` text CHARACTER SET utf8,
  `resp_kind` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `resp_time` datetime DEFAULT NULL,
  `curr_usr` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`sino`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `zatca_einv_stat` */

/*Table structure for table `zk_attendence_data` */

DROP TABLE IF EXISTS `zk_attendence_data`;

CREATE TABLE `zk_attendence_data` (
  `uid` int(11) NOT NULL DEFAULT '0',
  `p_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `p_typ` int(11) NOT NULL DEFAULT '0',
  `p_stat` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `zk_attendence_data` */

/*Table structure for table `zk_user_data` */

DROP TABLE IF EXISTS `zk_user_data`;

CREATE TABLE `zk_user_data` (
  `uid` int(11) NOT NULL DEFAULT '0',
  `u_name` varchar(200) NOT NULL DEFAULT 'NIL',
  `u_privilege` varchar(50) NOT NULL DEFAULT 'NIL',
  `u_pass` varchar(20) NOT NULL DEFAULT '0',
  `u_card` varchar(50) DEFAULT NULL,
  `u_gid` varchar(20) DEFAULT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `data_stat` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `zk_user_data` */

/* Trigger structure for table `collection` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_update_collection_log` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_update_collection_log` BEFORE UPDATE ON `collection` FOR EACH ROW BEGIN INSERT INTO audit_log (`DATE`, partyname, `DATA`) VALUES (NOW(), IFNULL(NEW.PartyName, ''), CONCAT('{"Bill No":', IFNULL(NEW.BillNo, 0), ' ,"Si No":', IFNULL(NEW.SiNo, 0), ' ,"amount":', IFNULL(NEW.Amount, 0), ' ,"NetTotal":', IFNULL(NEW.NetTotal, 0), ' ,"Employee":"', IFNULL(NEW.Employee, ''), '","BillForm":"', IFNULL(NEW.BillForm, ''), '","Typ":"', IFNULL(NEW.Typ, ''), '","godown":"', IFNULL(NEW.godown, ''), '","bill_time":"', IFNULL(NEW.bill_time, ''), '","status":"UPDATE"}')); END */$$


DELIMITER ;

/* Trigger structure for table `collection` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_delete_collection_log` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_delete_collection_log` BEFORE DELETE ON `collection` FOR EACH ROW BEGIN INSERT INTO audit_log (`DATE`, partyname, `DATA`) VALUES (NOW(), IFNULL(OLD.PartyName, ''), CONCAT('{"Bill No":', IFNULL(OLD.BillNo, 0), ' ,"Si No":', IFNULL(OLD.SiNo, 0), ' ,"amount":', IFNULL(OLD.Amount, 0), ' ,"NetTotal":', IFNULL(OLD.NetTotal, 0), ' ,"Employee":"', IFNULL(OLD.Employee, ''), '","BillForm":"', IFNULL(OLD.BillForm, ''), '","Typ":"', IFNULL(OLD.Typ, ''), '","godown":"', IFNULL(OLD.godown, ''), '","bill_time":"', IFNULL(OLD.bill_time, ''), '","status":"DELETE"}')); END */$$


DELIMITER ;

/* Trigger structure for table `damagetable` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_damage_Insert` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_damage_Insert` AFTER INSERT ON `damagetable` FOR EACH ROW BEGIN IF new.Warhouse = 'MAIN' THEN UPDATE SalesItem SET curr_stock = curr_stock - new.Qty, Stat = 1 WHERE ItemNameTextField = new.ItemName; ELSE IF (SELECT COUNT(*) FROM godown_wise_stock WHERE item = new.ItemName AND godown = new.Warhouse) > 0 THEN UPDATE godown_wise_stock SET qty = qty - (new.Qty * new.Pack) WHERE item = new.ItemName AND godown = new.Warhouse; ELSE INSERT INTO godown_wise_stock (item, qty, cst, it_unit, it_pack, godown) VALUES (new.ItemName, -(new.Qty * new.Pack), new.rate, new.unit, new.Pack, new.Warhouse); END IF; END IF; IF new.batch_no != 'NIL' THEN UPDATE batchwisestock SET curr_stk = curr_stk - (new.Qty * new.Pack) WHERE item = new.ItemName AND batch_no = new.batch_no AND godown = new.Warhouse; END IF; END */$$


DELIMITER ;

/* Trigger structure for table `damagetable` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_damage_Delete` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_damage_Delete` AFTER DELETE ON `damagetable` FOR EACH ROW BEGIN IF old.Warhouse = 'MAIN' THEN UPDATE SalesItem SET curr_stock = curr_stock + old.Qty, Stat = 1 WHERE ItemNameTextField = old.ItemName; ELSE IF (SELECT COUNT(*) FROM godown_wise_stock WHERE item = old.ItemName AND godown = old.Warhouse) > 0 THEN UPDATE godown_wise_stock SET qty = qty + (old.Qty * old.Pack) WHERE item = old.ItemName AND godown = old.Warhouse; ELSE INSERT INTO godown_wise_stock (item, qty, cst, it_unit, it_pack, godown) VALUES (old.ItemName, old.Qty * old.Pack, old.rate, old.unit, old.Pack, old.Warhouse); END IF; END IF; IF old.batch_no != 'NIL' THEN UPDATE batchwisestock SET curr_stk = curr_stk + (old.Qty * old.Pack) WHERE item = old.ItemName AND batch_no = old.batch_no AND godown = old.Warhouse; END IF; END */$$


DELIMITER ;

/* Trigger structure for table `dc_table` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_dc_insert` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_dc_insert` AFTER INSERT ON `dc_table` FOR EACH ROW BEGIN IF new.warehouse = 'MAIN' THEN IF new.billTyp = 'DC-INWARD' THEN UPDATE SalesItem SET SalesItem.curr_stock = (SalesItem.curr_stock + (new.qty * new.pack)), Stat = 1 WHERE SalesItem.ItemNameTextField = new.itemName; ELSE UPDATE SalesItem SET SalesItem.curr_stock = (SalesItem.curr_stock - (new.qty * new.pack)), Stat = 1 WHERE SalesItem.ItemNameTextField = new.itemName; END IF; ELSE IF new.billTyp = 'DC-INWARD' THEN IF (SELECT COUNT(*) FROM godown_wise_stock WHERE item = new.itemName AND godown = new.warehouse) > 0 THEN UPDATE godown_wise_stock SET qty = (qty + (new.qty * new.pack)) WHERE item = new.itemName AND godown = new.warehouse; ELSE INSERT INTO godown_wise_stock (item, qty, cst, it_unit, it_pack, godown) VALUES (new.itemName, new.qty * new.pack, new.rate, new.unit, new.pack, new.warehouse); END IF; ELSE IF (SELECT COUNT(*) FROM godown_wise_stock WHERE item = new.itemName AND godown = new.warehouse) > 0 THEN UPDATE godown_wise_stock SET qty = (qty - (new.qty * new.pack)) WHERE item = new.itemName AND godown = new.warehouse; ELSE INSERT INTO godown_wise_stock (item, qty, cst, it_unit, it_pack, godown) VALUES (new.itemName, -(new.qty * new.pack), new.rate, new.unit, new.pack, new.warehouse); END IF; END IF; END IF; END */$$


DELIMITER ;

/* Trigger structure for table `dc_table` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_dc_delete` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_dc_delete` AFTER DELETE ON `dc_table` FOR EACH ROW BEGIN IF old.warehouse = 'MAIN' THEN IF old.billTyp = 'DC-INWARD' THEN UPDATE SalesItem SET SalesItem.curr_stock = (SalesItem.curr_stock - (old.qty * old.pack)), Stat = 1 WHERE SalesItem.ItemNameTextField = old.itemName; ELSE UPDATE SalesItem SET SalesItem.curr_stock = (SalesItem.curr_stock + (old.qty * old.pack)), Stat = 1 WHERE SalesItem.ItemNameTextField = old.itemName; END IF; ELSE IF old.billTyp = 'DC-INWARD' THEN IF (SELECT COUNT(*) FROM godown_wise_stock WHERE item = old.itemName AND godown = old.warehouse) > 0 THEN UPDATE godown_wise_stock SET qty = (qty - (old.qty * old.pack)) WHERE item = old.itemName AND godown = old.warehouse; END IF; ELSE IF (SELECT COUNT(*) FROM godown_wise_stock WHERE item = old.itemName AND godown = old.warehouse) > 0 THEN UPDATE godown_wise_stock SET qty = (qty + (old.qty * old.pack)) WHERE item = old.itemName AND godown = old.warehouse; END IF; END IF; END IF; END */$$


DELIMITER ;

/* Trigger structure for table `godown_trans` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_insert_godown_trans` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_insert_godown_trans` AFTER INSERT ON `godown_trans` FOR EACH ROW BEGIN IF new.src ='MAIN' THEN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock-(new.qty*new.pack)),Stat=1 WHERE SalesItem.ItemNameTextField=new.Item;ELSEIF new.dest ='MAIN' THEN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock+(new.qty*new.pack)),Stat=1 WHERE SalesItem.ItemNameTextField=new.Item;END IF;IF new.src !='MAIN' THEN UPDATE godown_wise_stock SET qty=qty-(new.qty*new.pack) WHERE Item=new.item AND godown=new.src AND it_unit=new.unit;END IF;IF new.dest !='MAIN' THEN INSERT INTO godown_wise_stock(Item,godown,qty,cst,it_unit,it_pack)VALUES(new.item,new.dest,(new.qty*new.pack),new.rate,new.unit,new.pack) ON DUPLICATE KEY UPDATE qty=qty+(new.qty*new.pack),cst=new.rate,it_pack=new.pack;END IF;IF new.batch_no!='NIL' THEN INSERT INTO batchwisestock(item,exp_date,batch_no,curr_stk,cost,price,godown)VALUES(new.item,new.expiry,new.batch_no,(new.qty*new.pack),new.rate,new.rate,new.dest) ON DUPLICATE KEY UPDATE curr_stk=curr_stk+(new.Qty*new.Pack),exp_date=new.expiry,cost=new.rate,price=new.rate;INSERT INTO batchwisestock(item,exp_date,batch_no,curr_stk,cost,price,godown)VALUES(new.item,new.expiry,new.batch_no,(new.qty*new.pack),new.rate,new.rate,new.src) ON DUPLICATE KEY UPDATE curr_stk=curr_stk-(new.Qty*new.Pack),exp_date=new.expiry,cost=new.rate,price=new.rate;END IF;END */$$


DELIMITER ;

/* Trigger structure for table `godown_trans` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_delete_godown_trans` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_delete_godown_trans` AFTER DELETE ON `godown_trans` FOR EACH ROW BEGIN IF old.src ='MAIN' THEN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock+(old.qty*old.pack)),Stat=1 WHERE SalesItem.ItemNameTextField=old.Item;ELSEIF old.dest='MAIN' THEN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock-(old.qty*old.pack)),Stat=1 WHERE SalesItem.ItemNameTextField=old.Item;END IF;IF old.src!='MAIN' THEN UPDATE godown_wise_stock SET qty=qty+(old.qty*old.pack) WHERE Item=old.item AND godown=old.src AND it_unit=old.unit;END IF;IF old.dest!='MAIN' THEN UPDATE godown_wise_stock SET qty=qty-(old.qty*old.pack) WHERE Item=old.item AND godown=old.dest AND it_unit=old.unit;END IF;IF old.batch_no!='NIL' THEN UPDATE batchwisestock SET curr_stk=curr_stk-(old.Qty*old.Pack) WHERE batchwisestock.item=old.Item AND batchwisestock.batch_no=old.batch_no AND batchwisestock.godown=old.dest;UPDATE batchwisestock SET curr_stk=curr_stk+(old.Qty*old.Pack) WHERE batchwisestock.item=old.Item AND batchwisestock.batch_no=old.batch_no AND batchwisestock.godown=old.src;END IF;END */$$


DELIMITER ;

/* Trigger structure for table `godownsalesitem` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_insert_godownsalesitem` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_insert_godownsalesitem` AFTER INSERT ON `godownsalesitem` FOR EACH ROW BEGIN IF new.BillForm ='PURCHASE' THEN INSERT INTO godown_wise_stock(Item,godown,qty,it_unit,it_pack)VALUES(new.item,new.warehouse,(new.qty*new.pack),new.unit,new.pack) ON DUPLICATE KEY UPDATE qty=qty+(new.qty*new.pack),it_pack=new.pack;ELSEIF new.BillForm ='SALES' THEN INSERT INTO godown_wise_stock(Item,godown,qty,it_unit,it_pack)VALUES(new.item,new.warehouse,-(new.qty*new.pack),new.unit,new.pack) ON DUPLICATE KEY UPDATE qty=qty-(new.qty*new.pack),it_pack=new.pack;ELSEIF new.BillForm ='SalesReturn' THEN INSERT INTO godown_wise_stock(Item,godown,qty,it_unit,it_pack)VALUES(new.item,new.warehouse,(new.qty*new.pack),new.unit,new.pack) ON DUPLICATE KEY UPDATE qty=qty+(new.qty*new.pack),it_pack=new.pack;ELSEIF new.Billform ='PurchaseReturn' THEN INSERT INTO godown_wise_stock(Item,godown,qty,it_unit,it_pack)VALUES(new.item,new.warehouse,-(new.qty*new.pack),new.unit,new.pack) ON DUPLICATE KEY UPDATE qty=qty-(new.qty*new.pack),it_pack=new.pack;END IF;END */$$


DELIMITER ;

/* Trigger structure for table `godownsalesitem` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_delete_godownsalesitem` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_delete_godownsalesitem` AFTER DELETE ON `godownsalesitem` FOR EACH ROW BEGIN IF old.BillForm ='PURCHASE' THEN UPDATE godown_wise_stock SET qty=qty-(old.qty*old.pack) WHERE godown=old.warehouse AND Item=old.item AND it_unit=old.unit;ELSEIF old.BillForm ='SALES' THEN UPDATE godown_wise_stock SET qty=qty+(old.qty*old.pack) WHERE godown=old.warehouse AND Item=old.item AND it_unit=old.unit;ELSEIF old.BillForm ='SalesReturn' THEN UPDATE godown_wise_stock SET qty=qty-(old.qty*old.pack) WHERE godown=old.warehouse AND Item=old.item AND it_unit=old.unit;ELSEIF old.Billform ='PurchaseReturn' THEN UPDATE godown_wise_stock SET qty=qty+(old.qty*old.pack) WHERE godown=old.warehouse AND Item=old.item AND it_unit=old.unit;END IF;END */$$


DELIMITER ;

/* Trigger structure for table `masterdetails` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_insert_masterdetails` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_insert_masterdetails` AFTER INSERT ON `masterdetails` FOR EACH ROW BEGIN IF NEW.HldingStatus = 1 THEN INSERT INTO deleted_bill (si_no, inv, date1, party_name, status1, qty, total, update_delete, old_new, bill_time, emp_name) VALUES (@max1, NEW.BillNo, CURDATE(), NEW.BillPartyName, 'master', NEW.TotItWiseQty1, NEW.BillNetTotalField, 'HOLD', 'NEW', CURTIME(), NEW.Lorry); END IF; IF NEW.cr_dr = 'Dr' THEN INSERT INTO Collection (BillNo, Date1, PartyName, NetTotal, TransactionType, Typ, BillForm, godown, Employee, local_app_user_entry_id, bill_time, Reminder, Stat, TaxBillNo, fin_year) VALUES (NEW.BillNo, NEW.BillDate, NEW.BillPartyName, NEW.BillNetTotalField, 'ToSales', 'CUSTOMER', '8', NEW.godown, NEW.Lorry, NEW.local_app_user_entry_id, NEW.BillTime, NEW.BillDate, 1, NEW.TaxBillNo, NEW.fin_year); ELSEIF NEW.cr_dr = 'Cr' THEN INSERT INTO Collection (BillNo, Date1, PartyName, NetTotal, TransactionType, Typ, BillForm, godown, Employee, local_app_user_entry_id, bill_time, Reminder, Stat, TaxBillNo, fin_year) VALUES (NEW.BillNo, NEW.BillDate, NEW.BillPartyName, NEW.BillNetTotalField, 'ToSales', 'PURCHASE PARTY', '8', NEW.godown, NEW.Lorry, NEW.local_app_user_entry_id, NEW.BillTime, NEW.BillDate, 1, NEW.TaxBillNo, NEW.fin_year); END IF; IF NEW.BillPartyName = '3' THEN INSERT INTO Collection (BillNo, Date1, PartyName, Amount, TransactionType, Typ, BillForm, godown, Employee, local_app_user_entry_id, bill_time, Reminder, Stat) VALUES (NEW.BillNo, NEW.BillDate, NEW.BillPartyName, NEW.BillNetTotalField, 'Recieved ByCash', 'CUSTOMER', '8', NEW.godown, NEW.Lorry, NEW.local_app_user_entry_id, NEW.BillTime, NEW.BillDate, 1); ELSEIF (NEW.sino > 0 AND NEW.advance > 0 AND NEW.BillPartyName != '3') THEN INSERT INTO Collection (BillNo, TransactionType, SiNo, Date1, PartyName, Amount, Employee, Typ, CashFlow, godown, local_app_user_entry_id, bill_time, Reminder, Stat, Code1, BillForm) VALUES (NEW.BillNo, 'Cash', NEW.sino, NEW.BillDate, NEW.BillPartyName, NEW.advance, NEW.Lorry, 'CUSTOMER', 'DEBIT', NEW.godown, NEW.local_app_user_entry_id, NEW.BillTime, NEW.BillDate, 1, CAST(NEW.BatchNo AS DECIMAL(10,1)), 'BTB_REC'); END IF; END */$$


DELIMITER ;

/* Trigger structure for table `masterdetails` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_update_masterdetails` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_update_masterdetails` BEFORE UPDATE ON `masterdetails` FOR EACH ROW BEGIN SET @max1:=(SELECT MAX(si_no)+1 FROM deleted_bill);INSERT INTO deleted_bill(si_no,inv,date1,party_name,status1,qty,total,update_delete,old_new)VALUES (@max1,old.BillNo,CURDATE(),old.BillPartyName,'master',old.TotItWiseQty1,old.BillNetTotalField,'UPDATE','OLD');INSERT INTO deleted_bill(si_no,inv,date1,party_name,status1,qty,total,update_delete,old_new)VALUES (@max1,new.BillNo,CURDATE(),new.BillPartyName,'master',new.TotItWiseQty1,new.BillNetTotalField,'UPDATE','NEW');INSERT INTO deleted_bill(inv,item,qty,rate,total,status1,si_no,update_delete,old_new)(SELECT SalesBill.BillNo,SalesBill.Item,SalesBill.Qty,SalesBill.Rate,SalesBill.NetV,SalesBill.BillTyp,@max1,'UPDATE','OLD' FROM SalesBill WHERE SalesBill.BillTyp='8' AND SalesBill.BillNo=new.BillNo);END */$$


DELIMITER ;

/* Trigger structure for table `masterdetails` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_delete_masterdetails` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_delete_masterdetails` BEFORE DELETE ON `masterdetails` FOR EACH ROW BEGIN SET @max1:=(SELECT MAX(si_no)+1 FROM deleted_bill);INSERT INTO deleted_bill(si_no,inv,date1,party_name,status1,qty,total,update_delete,old_new)VALUES (@max1,old.BillNo,CURDATE(),old.BillPartyName,'master',old.TotItWiseQty1,old.BillNetTotalField,'DELETE','OLD');INSERT INTO deleted_bill(inv,item,qty,rate,total,status1,si_no,update_delete,old_new)(SELECT SalesBill.BillNo,SalesBill.Item,SalesBill.Qty,SalesBill.Rate,SalesBill.NetV,SalesBill.BillTyp,@max1,'DELETE','OLD' FROM SalesBill WHERE SalesBill.BillTyp='8' AND SalesBill.BillNo=old.BillNo);END */$$


DELIMITER ;

/* Trigger structure for table `masterdetails8b` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_update_masterdetails8b` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_update_masterdetails8b` BEFORE UPDATE ON `masterdetails8b` FOR EACH ROW BEGIN SET @max1:=(SELECT MAX(si_no)+1 FROM deleted_bill);INSERT INTO deleted_bill(si_no,inv,date1,party_name,status1,qty,total,update_delete,old_new)VALUES (@max1,old.BillNo,CURDATE(),old.BillPartyName,'master',old.TotItWiseQty1,old.BillNetTotalField,'UPDATE','OLD');INSERT INTO deleted_bill(si_no,inv,date1,party_name,status1,qty,total,update_delete,old_new)VALUES (@max1,new.BillNo,CURDATE(),new.BillPartyName,'master',new.TotItWiseQty1,new.BillNetTotalField,'UPDATE','NEW');INSERT INTO deleted_bill(inv,item,qty,rate,total,status1,si_no,update_delete,old_new)(SELECT SalesBill.BillNo,SalesBill.Item,SalesBill.Qty,SalesBill.Rate,SalesBill.NetV,SalesBill.BillTyp,@max1,'UPDATE','OLD' FROM SalesBill WHERE SalesBill.BillTyp='8BNEW' AND SalesBill.BillNo=new.BillNo);END */$$


DELIMITER ;

/* Trigger structure for table `masterdetails8b` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_delete_masterdetails8b` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_delete_masterdetails8b` BEFORE DELETE ON `masterdetails8b` FOR EACH ROW BEGIN SET @max1:=(SELECT MAX(si_no)+1 FROM deleted_bill);INSERT INTO deleted_bill(si_no,inv,date1,party_name,status1,qty,total,update_delete,old_new)VALUES (@max1,old.BillNo,CURDATE(),old.BillPartyName,'master',old.TotItWiseQty1,old.BillNetTotalField,'DELETE','OLD');INSERT INTO deleted_bill(inv,item,qty,rate,total,status1,si_no,update_delete,old_new)(SELECT SalesBill.BillNo,SalesBill.Item,SalesBill.Qty,SalesBill.Rate,SalesBill.NetV,SalesBill.BillTyp,@max1,'DELETE','OLD' FROM SalesBill WHERE SalesBill.BillTyp='8BNEW' AND SalesBill.BillNo=old.BillNo);END */$$


DELIMITER ;

/* Trigger structure for table `masterdetails8bnew` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_insert_masterdetails8bnew` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_insert_masterdetails8bnew` AFTER INSERT ON `masterdetails8bnew` FOR EACH ROW BEGIN IF NEW.cr_dr = 'Dr' THEN INSERT INTO Collection (BillNo, Date1, PartyName, NetTotal, TransactionType, Typ, BillForm, godown, Reminder, Stat, local_app_user_entry_id, bill_time, TaxBillNo, fin_year) VALUES (NEW.BillNo, NEW.BillDate, NEW.BillPartyName, NEW.BillNetTotalField, 'ToSales', 'CUSTOMER', '8BNEW', NEW.godown, NEW.BillDate, 1, NEW.local_app_user_entry_id, NEW.BillTime, NEW.TaxBillNo, NEW.fin_year); ELSEIF NEW.cr_dr = 'Cr' THEN INSERT INTO Collection (BillNo, Date1, PartyName, NetTotal, TransactionType, Typ, BillForm, godown, Reminder, Stat, local_app_user_entry_id, bill_time, TaxBillNo, fin_year) VALUES (NEW.BillNo, NEW.BillDate, NEW.BillPartyName, NEW.BillNetTotalField, 'ToSales', 'PURCHASE PARTY', '8BNEW', NEW.godown, NEW.BillDate, 1, NEW.local_app_user_entry_id, NEW.BillTime, NEW.TaxBillNo, NEW.fin_year); END IF; IF NEW.BillPartyName = '3' THEN INSERT INTO Collection (BillNo, Date1, PartyName, Amount, TransactionType, Typ, BillForm, godown, Reminder, Stat, local_app_user_entry_id, bill_time) VALUES (NEW.BillNo, NEW.BillDate, NEW.BillPartyName, NEW.BillNetTotalField, 'Recieved ByCash', 'CUSTOMER', '8BNEW', NEW.godown, NEW.BillDate, 1, NEW.local_app_user_entry_id, NEW.BillTime); ELSEIF (NEW.sino > 0 AND NEW.advance > 0 AND NEW.BillPartyName != '3') THEN INSERT INTO Collection (BillNo, TransactionType, SiNo, Date1, PartyName, Amount, Employee, Typ, CashFlow, godown, Reminder, Stat, Code1, BillForm, local_app_user_entry_id, bill_time) VALUES (NEW.BillNo, 'Cash', NEW.sino, NEW.BillDate, NEW.BillPartyName, NEW.advance, NEW.Lorry, 'CUSTOMER', 'DEBIT', NEW.godown, NEW.BillDate, 1, CAST(NEW.BatchNo AS DECIMAL(10,1)), 'BTC_REC', NEW.local_app_user_entry_id, NEW.BillTime); END IF; END */$$


DELIMITER ;

/* Trigger structure for table `matusage` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_mat_insert` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_mat_insert` AFTER INSERT ON `matusage` FOR EACH ROW BEGIN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock+new.qty),Stat=1 WHERE SalesItem.ItemNameTextField=new.nam AND new.acc='FINISHED GOODS';UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock-new.qty),Stat=1 WHERE SalesItem.ItemNameTextField=new.nam AND new.acc='MATERIAL';END */$$


DELIMITER ;

/* Trigger structure for table `matusage` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_mat_delete` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_mat_delete` AFTER DELETE ON `matusage` FOR EACH ROW BEGIN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock-old.qty),Stat=1 WHERE SalesItem.ItemNameTextField=old.nam AND old.acc='FINISHED GOODS';UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock+old.qty),Stat=1 WHERE SalesItem.ItemNameTextField=old.nam AND old.acc='MATERIAL';END */$$


DELIMITER ;

/* Trigger structure for table `purchasebill` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_p_delete` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_p_delete` AFTER DELETE ON `purchasebill` FOR EACH ROW BEGIN IF old.PGoodsOn = 'MAIN' THEN UPDATE SalesItem SET SalesItem.curr_stock = (SalesItem.curr_stock - ((old.PQty * old.Pack) + (old.sqft * old.Pack))), Stat = 1 WHERE SalesItem.ItemNameTextField = old.PItem; IF old.batch_no != 'NIL' THEN UPDATE batchwisestock SET curr_stk = curr_stk - ((old.PQty * old.Pack) + (old.sqft * old.Pack)) WHERE batchwisestock.item = old.PItem AND batchwisestock.batch_no = old.batch_no; END IF; ELSE IF (SELECT COUNT(*) FROM godown_wise_stock WHERE godown_wise_stock.item = old.PItem AND godown_wise_stock.godown = old.PGoodsOn) > 0 THEN UPDATE godown_wise_stock SET qty = (godown_wise_stock.qty - ((old.PQty * old.Pack) + (old.sqft * old.Pack))) WHERE godown_wise_stock.item = old.PItem AND godown_wise_stock.godown = old.PGoodsOn; END IF; END IF; END */$$


DELIMITER ;

/* Trigger structure for table `purchasereturn` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_pr_insert` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_pr_insert` AFTER INSERT ON `purchasereturn` FOR EACH ROW BEGIN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock-(new.Qty*new.Pack)),Stat=1 WHERE SalesItem.ItemNameTextField=new.Item;IF new.batch_no!='NIL' THEN UPDATE batchwisestock SET curr_stk=curr_stk-(new.Qty*new.Pack) WHERE batchwisestock.item=new.Item AND batchwisestock.batch_no=new.batch_no AND batchwisestock.godown=new.godown;END IF;END */$$


DELIMITER ;

/* Trigger structure for table `purchasereturn` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_pr_delete` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_pr_delete` AFTER DELETE ON `purchasereturn` FOR EACH ROW BEGIN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock+(old.Qty*old.Pack)),Stat=1 WHERE SalesItem.ItemNameTextField=old.Item;IF old.batch_no!='NIL' THEN UPDATE batchwisestock SET curr_stk=curr_stk+(old.Qty*old.Pack) WHERE batchwisestock.item=old.Item AND batchwisestock.batch_no=old.batch_no AND batchwisestock.godown=old.godown;END IF;END */$$


DELIMITER ;

/* Trigger structure for table `salesbill` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_sb_insert` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_sb_insert` AFTER INSERT ON `salesbill` FOR EACH ROW BEGIN IF new.GoodsOn='MAIN' THEN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock-((new.qty*new.Pack)+(new.sqft*new.Pack))),Stat=1 WHERE SalesItem.ItemNameTextField=new.Item;END IF;
    IF new.GoodsOn!='MAIN' THEN INSERT INTO godown_wise_stock(Item,godown,qty,it_unit,it_pack)VALUES(new.Item,new.GoodsOn,-(new.Qty*new.Pack),new.Unit,new.Pack) ON DUPLICATE KEY UPDATE qty=qty-(new.Qty*new.Pack);END IF;
    IF new.batch_no!='NIL' THEN UPDATE batchwisestock SET curr_stk=curr_stk-((new.Qty*new.Pack)+(new.sqft*new.Pack)) WHERE batchwisestock.item=new.Item AND batchwisestock.batch_no=new.batch_no AND batchwisestock.godown=new.GoodsOn;END IF;END */$$


DELIMITER ;

/* Trigger structure for table `salesbill` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_sb_delete` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_sb_delete` AFTER DELETE ON `salesbill` FOR EACH ROW BEGIN IF old.GoodsOn='MAIN' THEN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock+(old.qty*old.Pack)+(old.sqft*old.Pack)),Stat=1 WHERE SalesItem.ItemNameTextField=old.Item;END IF;
    IF old.GoodsOn!='MAIN' THEN UPDATE godown_wise_stock SET qty=qty+(old.Qty*old.Pack) WHERE godown=old.GoodsOn AND Item=old.Item AND it_unit=old.Unit;END IF;IF old.batch_no!='NIL'
     THEN UPDATE batchwisestock SET curr_stk=curr_stk+((old.Qty*old.Pack)+(old.sqft*old.Pack)) WHERE batchwisestock.item=old.Item  AND batchwisestock.batch_no=old.batch_no AND batchwisestock.godown=old.GoodsOn;END IF;END */$$


DELIMITER ;

/* Trigger structure for table `salesreturn` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_sr_insert` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_sr_insert` AFTER INSERT ON `salesreturn` FOR EACH ROW BEGIN IF new.local_app_user_entry_id IS NULL THEN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock+(new.Qty*new.Pack)),Stat=1 WHERE SalesItem.ItemNameTextField=new.Item;END IF;IF new.local_app_user_entry_id IS NOT NULL THEN INSERT INTO godown_wise_stock(Item,godown,qty,it_unit,it_pack)VALUES(new.Item,new.godown,(new.Qty*new.Pack),new.Unit,new.Pack) ON DUPLICATE KEY UPDATE qty=qty+(new.Qty*new.Pack);END IF;IF new.batch_no!='NIL' THEN UPDATE batchwisestock SET curr_stk=curr_stk+(new.Qty*new.Pack) WHERE batchwisestock.item=new.Item AND batchwisestock.batch_no=new.batch_no AND batchwisestock.godown=new.godown;END IF;END */$$


DELIMITER ;

/* Trigger structure for table `salesreturn` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_sr_delete` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_sr_delete` AFTER DELETE ON `salesreturn` FOR EACH ROW BEGIN IF old.local_app_user_entry_id IS NULL THEN UPDATE SalesItem SET SalesItem.curr_stock= (SalesItem.curr_stock-(old.Qty*old.Pack)),Stat=1 WHERE SalesItem.ItemNameTextField=old.Item;END IF;IF old.local_app_user_entry_id IS NOT NULL THEN UPDATE godown_wise_stock SET qty=qty-(old.Qty*old.Pack) WHERE godown=old.godown AND Item=old.Item AND it_unit=old.Unit;END IF;IF old.batch_no!='NIL' THEN UPDATE batchwisestock SET curr_stk=curr_stk-(old.Qty*old.Pack) WHERE batchwisestock.item=old.Item AND batchwisestock.batch_no=old.batch_no;END IF;END */$$


DELIMITER ;

/* Trigger structure for table `service_master` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_service_insert` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_service_insert` AFTER INSERT ON `service_master` FOR EACH ROW BEGIN DECLARE next_si INT; SELECT COALESCE(MAX(SiNo), 0) + 1 INTO next_si FROM Collection; INSERT INTO Collection (BillNo, Date1, PartyName, NetTotal, TransactionType, Typ, Employee) VALUES (NEW.ServiceNo, NEW.Date1, NEW.PartyName, NEW.GrandTotal, 'ToService', 'CUSTOMER', NEW.JobAssign); IF NEW.CashReceived != 0 THEN     INSERT INTO Collection (BillNo, TransactionType, SiNo, Date1, PartyName, Amount, Employee, Typ, CashFlow)     VALUES (NEW.ServiceNo, 'Cash', next_si, NEW.Date1, NEW.PartyName, NEW.CashReceived, NEW.JobAssign, 'CUSTOMER', 'DEBIT'); END IF; END */$$


DELIMITER ;

/* Trigger structure for table `service_master` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `t_service_delete` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `t_service_delete` AFTER DELETE ON `service_master` FOR EACH ROW BEGIN DELETE FROM Collection WHERE BillNo = OLD.ServiceNo; END */$$


DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
