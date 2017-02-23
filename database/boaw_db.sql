-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Erstellungszeit: 26. Jan 2017 um 09:00
-- Server-Version: 10.1.19-MariaDB
-- PHP-Version: 7.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `boaw_db`
--

DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AlleKurseVonLehrer` (`lehrermail` VARCHAR(50))  BEGIN
Select * from kurse where kID = (Select kID from lehrer_macht_kurse where lID =(Select lID from lehrer where lEmail = lehrermail));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AlleKurseVonSchueler` (`schuelermail` VARCHAR(50))  BEGIN
Select * from kurse where kID = (Select kID from schueler_hat_kurse where sEmail = schuelermail);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `erstelleKurs` (`Emailvonlehrer` VARCHAR(100), `kBez` VARCHAR(100), `kBeschr` VARCHAR(500), `minL` TINYINT(4), `maxL` TINYINT(4), `minS` TINYINT(4), `maxS` TINYINT(4), `Tag` DATE, `ZAnf` TIME, `ZEnd` TIME)  BEGIN

Declare zwischenspeicher smallint(5) DEFAULT 0;


Insert into kurse (kBezeichnung,kBeschreibung,minLehrer,maxLehrer,minSchueler,maxSchueler,deleted) Values(Kbez,KBeschr,minL,maxL,minS,maxS,0);

Select kID into zwischenspeicher from kurse where kBezeichnung = kBez and kBeschreibung = kBeschr LIMIT 1;

Insert into kurse_wann (kID,Tag,ZeitAnfang,ZeitEnde) Values(zwischenspeicher, (Select tid from tage where tdatum = Tag LIMIT 1),ZAnf,ZEnd);

Insert into lehrer_macht_kurse (lEmail,kID,kBesitzer,deleted) Values(Emailvonlehrer,zwischenspeicher,1,0);



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `löscheKurs` (`kursid` SMALLINT(5))  BEGIN
Update kurse set deleted = 0 where kID = kursid;
Update lehrer_macht_kurse set deleted = 0 where kID = kursid;
Update schueler_hat_kurse set deleted = 0 where kID = kursid;
Update kurse_wann set deleted = 0 where kID = kursid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `löscheKursRueckgaenging` (`kursid` SMALLINT(5))  BEGIN
Update kurse set deleted = 1 where kID = kursid;
Update lehrer_macht_kurse set deleted = 1 where kID = kursid;
Update schueler_hat_kurse set deleted = 1 where kID = kursid;
Update kurse_wann set deleted = 1 where kID = kursid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProjektWochenInsert` (`startdate` DATE, `enddate` DATE)  BEGIN
DECLARE dateNow date DEFAULT startdate;
DECLARE counter smallint(6) DEFAULT 0;

date_loop: LOOP
    if dateNow = enddate then
   	 leave date_loop;
    end if;

    if dayofweek(dateNow) != 1 && dayofweek(dateNow) != 7 then
   	 set counter = counter + 1;
   	 INSERT INTO tage (tid, twochentag, tdatum) values(counter,dayofweek(dateNow),dateNow);
    end if;
	set dateNow = date_add(dateNow, interval 1 day);
    
end loop date_loop;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TageLöschen` ()  BEGIN
Delete from Tage;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `whipe_everything` ()  BEGIN
Delete from lehrer;
Delete from lehrer_macht_kurse;
Delete from kurse;
Delete from kurse_wann;
Delete from tage;
Delete from schueler_hat_kurse;
Delete from schueler;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `kurse`
--

CREATE TABLE `kurse` (
  `kID` smallint(5) UNSIGNED NOT NULL,
  `kBezeichnung` varchar(100) NOT NULL,
  `kBeschreibung` varchar(500) NOT NULL,
  `minLehrer` tinyint(4) NOT NULL,
  `maxLehrer` tinyint(4) NOT NULL,
  `minSchueler` tinyint(4) NOT NULL,
  `maxSchueler` tinyint(4) NOT NULL,
  `deleted` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `kurse`
--

INSERT INTO `kurse` (`kID`, `kBezeichnung`, `kBeschreibung`, `minLehrer`, `maxLehrer`, `minSchueler`, `maxSchueler`, `deleted`) VALUES
(1, 'Erfrischung im Ottakringer Bad', 'Eine kurze Erfrischung im Ottakringer Bad. Bitte Badesachen mitnehmen!', 1, 3, 8, 20, 0),
(2, 'Wanderausflug im Neuwaldegg', 'Eine angenehme Wandertour im Neuwaldegg. Bitte angemessen bekleiden!', 2, 3, 8, 30, 0),
(3, 'Mechatronik-Austellung beim Museumsquartier', 'Die lang ersehnte Mechatronik- und Roboterausstellung ist jetzt endlich gekommen! Wer auch nur ein bisschen daran interessiert ist, soll diese einmalige Gelegenheit ausnutzen und mitkommen!', 2, 2, 10, 25, 0),
(4, 'testbezeichnung', 'Beschreibung', 1, 3, 10, 35, 0),
(5, 'Testkurs', 'Dies ist ein Testkurs', 1, 2, 5, 10, 0),
(6, 'Testkurs', 'Dies ist ein Testkurs', 1, 2, 5, 10, 0),
(7, 'Testkurs', 'Dies ist ein Testkurs', 1, 2, 5, 10, 0),
(8, 'AyyPARTY', 'WHADDUP', 1, 2, 3, 4, 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `kurse_wann`
--

CREATE TABLE `kurse_wann` (
  `kID` smallint(5) UNSIGNED NOT NULL,
  `Tag` smallint(5) UNSIGNED NOT NULL,
  `ZeitAnfang` time NOT NULL,
  `ZeitEnde` time NOT NULL,
  `deleted` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `kurse_wann`
--

INSERT INTO `kurse_wann` (`kID`, `Tag`, `ZeitAnfang`, `ZeitEnde`, `deleted`) VALUES
(1, 2, '09:00:00', '13:00:00', NULL),
(2, 1, '08:00:00', '12:00:00', NULL),
(3, 3, '08:00:00', '12:00:00', NULL),
(4, 4, '08:00:00', '12:00:00', NULL),
(8, 3, '08:00:00', '14:00:00', NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `lehrer`
--

CREATE TABLE `lehrer` (
  `lID` smallint(5) UNSIGNED NOT NULL,
  `lEmail` varchar(50) NOT NULL,
  `lVorname` varchar(30) NOT NULL,
  `lNachname` varchar(30) NOT NULL,
  `admin` tinyint(1) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `lehrer`
--

INSERT INTO `lehrer` (`lID`, `lEmail`, `lVorname`, `lNachname`, `admin`, `deleted`) VALUES
(1, 'lzehm@htl-ottakring.at', 'Miki', 'Zehetner', 1, 0),
(2, 'b.rahman98@htl-ottakring.ac.at', 'benedikt', 'rahman', NULL, 0),
(3, 'x.eleazar@htl-ottakring.ac.at', 'xyruz kyle', 'eleazar', NULL, 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `lehrer_macht_kurse`
--

CREATE TABLE `lehrer_macht_kurse` (
  `lEmail` varchar(50) NOT NULL,
  `kID` smallint(5) NOT NULL,
  `kBesitzer` tinyint(1) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `lehrer_macht_kurse`
--

INSERT INTO `lehrer_macht_kurse` (`lEmail`, `kID`, `kBesitzer`, `deleted`) VALUES
('1', 1, 1, 0),
('1', 2, 1, 0),
('1', 3, 1, 0),
('1', 5, 1, 0),
('1', 8, 1, 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `schueler`
--

CREATE TABLE `schueler` (
  `sEmail` varchar(50) NOT NULL,
  `sVorname` varchar(30) NOT NULL,
  `sNachname` varchar(30) NOT NULL,
  `sKlasse` varchar(6) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `schueler`
--

INSERT INTO `schueler` (`sEmail`, `sVorname`, `sNachname`, `sKlasse`, `deleted`) VALUES
('b.rahman98@htl-ottakring.ac.at', 'Benedikt Shakil', 'Rahman', '5BHITM', 0),
('r.langschwert98@htl-ottakring.ac.at', 'Rene', 'Langschwert', '5BHITM', 0),
('x.eleazar98@htl-ottakring.ac.at', 'Xyruz Kyle', 'Eleazar', '5BHITM', 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `schueler_hat_kurse`
--

CREATE TABLE `schueler_hat_kurse` (
  `sEmail` varchar(50) NOT NULL,
  `kID` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `schueler_hat_kurse`
--

INSERT INTO `schueler_hat_kurse` (`sEmail`, `kID`) VALUES
('b.rahman98@htl-ottakring.ac.at', 1),
('b.rahman98@htl-ottakring.ac.at', 2),
('r.langschwert98@htl-ottakring.ac.at', 2),
('x.eleazar98@htl-ottakring.ac.at', 1),
('x.eleazar98@htl-ottakring.ac.at', 2);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tage`
--

CREATE TABLE `tage` (
  `tid` smallint(5) UNSIGNED NOT NULL,
  `twochentag` varchar(20) NOT NULL,
  `tdatum` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `tage`
--

INSERT INTO `tage` (`tid`, `twochentag`, `tdatum`) VALUES
(0, 'Sonntag', '2017-06-04'),
(1, 'Montag', '2017-06-05'),
(2, 'Dienstag', '2017-06-06'),
(3, 'Mittwoch', '2017-06-07'),
(4, 'Donnerstag', '2017-06-08'),
(5, 'Freitag', '2017-06-09'),
(6, 'Samstag', '2017-06-10');

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `kurse`
--
ALTER TABLE `kurse`
  ADD PRIMARY KEY (`kID`);

--
-- Indizes für die Tabelle `lehrer`
--
ALTER TABLE `lehrer`
  ADD PRIMARY KEY (`lID`);

--
-- Indizes für die Tabelle `schueler`
--
ALTER TABLE `schueler`
  ADD PRIMARY KEY (`sEmail`);

--
-- Indizes für die Tabelle `tage`
--
ALTER TABLE `tage`
  ADD PRIMARY KEY (`tid`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `kurse`
--
ALTER TABLE `kurse`
  MODIFY `kID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT für Tabelle `lehrer`
--
ALTER TABLE `lehrer`
  MODIFY `lID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
