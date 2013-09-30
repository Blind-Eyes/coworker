/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50528
 Source Host           : localhost
 Source Database       : coworker

 Target Server Type    : MySQL
 Target Server Version : 50528
 File Encoding         : utf-8

 Date: 05/26/2013 22:08:33 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `administrador`
-- ----------------------------
DROP TABLE IF EXISTS `administrador`;
CREATE TABLE `administrador` (
  `usuario_cedula` varchar(20) NOT NULL,
  PRIMARY KEY (`usuario_cedula`),
  KEY `usuario_cedula_idx` (`usuario_cedula`),
  CONSTRAINT `administrador_usuario_cedula` FOREIGN KEY (`usuario_cedula`) REFERENCES `usuario` (`cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `administrador`
-- ----------------------------
BEGIN;
INSERT INTO `administrador` VALUES ('20174430');
COMMIT;

-- ----------------------------
--  Table structure for `auxiliar`
-- ----------------------------
DROP TABLE IF EXISTS `auxiliar`;
CREATE TABLE `auxiliar` (
  `usuario_cedula` varchar(20) NOT NULL,
  PRIMARY KEY (`usuario_cedula`),
  KEY `usuario_cedula_idx` (`usuario_cedula`),
  CONSTRAINT `auxiliar_usuario_cedula` FOREIGN KEY (`usuario_cedula`) REFERENCES `usuario` (`cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `auxiliar`
-- ----------------------------
BEGIN;
INSERT INTO `auxiliar` VALUES ('20174430');
COMMIT;

-- ----------------------------
--  Table structure for `bitacora`
-- ----------------------------
DROP TABLE IF EXISTS `bitacora`;
CREATE TABLE `bitacora` (
  `id` int(11) NOT NULL,
  `usuario_cedula` varchar(20) NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `descripcion` text NOT NULL,
  `ip` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `carpeta_iva`
-- ----------------------------
DROP TABLE IF EXISTS `carpeta_iva`;
CREATE TABLE `carpeta_iva` (
  `iva_mensual_id` int(11) NOT NULL,
  `auxiliar_cedula` varchar(20) NOT NULL,
  `fecha_creada` datetime NOT NULL,
  `fecha_elaborada` datetime NOT NULL,
  `fecha_contabilizacion_comprobantes` datetime NOT NULL,
  PRIMARY KEY (`iva_mensual_id`,`auxiliar_cedula`),
  KEY `iva_mensual_id_idx` (`iva_mensual_id`),
  KEY `auxiliar_cedula_idx` (`auxiliar_cedula`),
  CONSTRAINT `carpeta_auxiliar_cedula` FOREIGN KEY (`auxiliar_cedula`) REFERENCES `auxiliar` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `carpeta_iva_mensual_id` FOREIGN KEY (`iva_mensual_id`) REFERENCES `iva_mensual` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `cobranza`
-- ----------------------------
DROP TABLE IF EXISTS `cobranza`;
CREATE TABLE `cobranza` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supervisor_cedula` varchar(20) NOT NULL,
  `facturacion_id` int(11) NOT NULL,
  `forma_pago` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`supervisor_cedula`,`facturacion_id`),
  KEY `supervisor_cedula_idx` (`supervisor_cedula`),
  KEY `facturacion_id_idx` (`id`),
  CONSTRAINT `cobranza_facturacion_id` FOREIGN KEY (`id`) REFERENCES `facturacion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `cobranza_supervisor_cedula` FOREIGN KEY (`supervisor_cedula`) REFERENCES `supervisor` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `cobranza_cheque`
-- ----------------------------
DROP TABLE IF EXISTS `cobranza_cheque`;
CREATE TABLE `cobranza_cheque` (
  `cobranza_id` int(11) NOT NULL,
  `usuario_cedula` varchar(20) NOT NULL,
  `numero_cheque` varchar(255) NOT NULL,
  `beneficiario` varchar(255) NOT NULL,
  `banco_destino` varchar(255) NOT NULL,
  `banco_origen` varchar(255) NOT NULL,
  `monto` float NOT NULL,
  `fecha` datetime NOT NULL,
  PRIMARY KEY (`cobranza_id`,`usuario_cedula`),
  KEY `facturacion_id_idx` (`cobranza_id`),
  KEY `usuario_cedula_idx` (`usuario_cedula`),
  CONSTRAINT `cheque_cobranza_id` FOREIGN KEY (`cobranza_id`) REFERENCES `cobranza` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `cheque_usuario_cedula` FOREIGN KEY (`usuario_cedula`) REFERENCES `usuario` (`cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `cobranza_deposito`
-- ----------------------------
DROP TABLE IF EXISTS `cobranza_deposito`;
CREATE TABLE `cobranza_deposito` (
  `cobranza_id` int(11) NOT NULL,
  `numero_deposito` varchar(255) NOT NULL,
  `beneficiario` varchar(255) NOT NULL,
  `banco_destino` varchar(255) NOT NULL,
  `monto` float NOT NULL,
  `fecha` datetime NOT NULL,
  `usuario_cedula` varchar(20) NOT NULL,
  PRIMARY KEY (`cobranza_id`,`usuario_cedula`),
  KEY `facturacion_id_idx` (`cobranza_id`),
  KEY `usuario_cedula_idx` (`usuario_cedula`),
  CONSTRAINT `deposito_cobranza_id` FOREIGN KEY (`cobranza_id`) REFERENCES `cobranza` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `deposito_usuario_cedula` FOREIGN KEY (`usuario_cedula`) REFERENCES `usuario` (`cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `cobranza_efectivo`
-- ----------------------------
DROP TABLE IF EXISTS `cobranza_efectivo`;
CREATE TABLE `cobranza_efectivo` (
  `cobranza_id` int(11) NOT NULL,
  `usuario_cedula` varchar(20) NOT NULL,
  `monto` float NOT NULL,
  `fecha` datetime NOT NULL,
  PRIMARY KEY (`cobranza_id`,`usuario_cedula`),
  KEY `cobranza_id_idx` (`cobranza_id`),
  KEY `usuario_cedula_idx` (`usuario_cedula`),
  CONSTRAINT `efectivo_cobranza_id` FOREIGN KEY (`cobranza_id`) REFERENCES `cobranza` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `efectivo_usuario_cedula` FOREIGN KEY (`usuario_cedula`) REFERENCES `usuario` (`cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `contribuyente`
-- ----------------------------
DROP TABLE IF EXISTS `contribuyente`;
CREATE TABLE `contribuyente` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `rif` varchar(255) NOT NULL,
  `direccion` varchar(255) DEFAULT 'NO',
  `telefono` varchar(255) DEFAULT 'NO',
  `contacto` varchar(255) DEFAULT 'NO',
  `correo` varchar(255) DEFAULT 'NO',
  `municipio` varchar(255) DEFAULT 'NO',
  `fecha_cierre` varchar(255) DEFAULT 'NO',
  `tipo` varchar(255) NOT NULL,
  `activo` tinyint(4) NOT NULL DEFAULT '1',
  `usuario` varchar(255) NOT NULL,
  `clave` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `rif_UNIQUE` (`rif`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `contribuyente`
-- ----------------------------
BEGIN;
INSERT INTO `contribuyente` VALUES ('1', '1', 'Prueba', 'J-123456-7', 'NO', 'NO', 'NO', 'NO', 'NO', 'NO', 'Ordinaria', '1', 'hahahaha', 'jajajaja'), ('9', '7', 'Corporación Fujiyama West, C.A.', 'J400169836', 'Calle 2 de Vista Alegre, Edif. Mago, PB, Local 4', '0212-4711759', 'Eduardo Rodriguez', 'fujiyamasushibar@gmail.com', 'Libertador', '31-12-2012', 'Ordinaria', '1', 'fujiwest', 'J400169836');
COMMIT;

-- ----------------------------
--  Table structure for `contribuyente_auxiliar`
-- ----------------------------
DROP TABLE IF EXISTS `contribuyente_auxiliar`;
CREATE TABLE `contribuyente_auxiliar` (
  `auxiliar_cedula` varchar(20) NOT NULL,
  `contribuyente_id` int(11) NOT NULL,
  PRIMARY KEY (`auxiliar_cedula`,`contribuyente_id`),
  KEY `auxiliar_cedula_idx` (`auxiliar_cedula`),
  KEY `contribuyente_auxiliar_id` (`contribuyente_id`),
  CONSTRAINT `contribuyente_auxiliar_cedula` FOREIGN KEY (`auxiliar_cedula`) REFERENCES `auxiliar` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `contribuyente_auxiliar_id` FOREIGN KEY (`contribuyente_id`) REFERENCES `contribuyente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `contribuyente_auxiliar`
-- ----------------------------
BEGIN;
INSERT INTO `contribuyente_auxiliar` VALUES ('20174430', '1');
COMMIT;

-- ----------------------------
--  Table structure for `declarada_islr`
-- ----------------------------
DROP TABLE IF EXISTS `declarada_islr`;
CREATE TABLE `declarada_islr` (
  `islr_id` int(11) NOT NULL,
  `auxiliar_cedula` varchar(20) NOT NULL,
  `fecha_declarada` datetime NOT NULL,
  `numero_declaracion` varchar(255) NOT NULL,
  `monto_a_pagar` float NOT NULL,
  `tipo` varchar(255) NOT NULL,
  PRIMARY KEY (`islr_id`,`auxiliar_cedula`),
  KEY `auxiliar_cedula_idx` (`auxiliar_cedula`),
  KEY `islr_id_idx` (`islr_id`),
  CONSTRAINT `declarada_islr_auxiliar_cedula` FOREIGN KEY (`auxiliar_cedula`) REFERENCES `auxiliar` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `declarada_islr_id` FOREIGN KEY (`islr_id`) REFERENCES `islr` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `declarada_iva`
-- ----------------------------
DROP TABLE IF EXISTS `declarada_iva`;
CREATE TABLE `declarada_iva` (
  `iva_mensual_id` int(11) NOT NULL,
  `auxiliar_cedula` varchar(20) NOT NULL,
  `fecha_declarada` datetime NOT NULL,
  `numero_declaracion` varchar(255) NOT NULL,
  `monto_a_pagar` float NOT NULL,
  PRIMARY KEY (`iva_mensual_id`,`auxiliar_cedula`),
  KEY `iva_mensual_id_idx` (`iva_mensual_id`),
  KEY `auxiliar_cedula_idx` (`auxiliar_cedula`),
  CONSTRAINT `declarada_iva_auxiliar_cedula` FOREIGN KEY (`auxiliar_cedula`) REFERENCES `auxiliar` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `declarada_iva_mensual_id` FOREIGN KEY (`iva_mensual_id`) REFERENCES `iva_mensual` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `desarrollo_islr`
-- ----------------------------
DROP TABLE IF EXISTS `desarrollo_islr`;
CREATE TABLE `desarrollo_islr` (
  `islr_id` int(11) NOT NULL,
  `auxiliar_cedula` varchar(20) NOT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_culminacion` datetime DEFAULT NULL,
  `fecha_revision` datetime DEFAULT NULL,
  `observaciones` text,
  PRIMARY KEY (`islr_id`,`auxiliar_cedula`),
  KEY `auxiliar_cedula_idx` (`auxiliar_cedula`),
  KEY `islr_id_idx` (`islr_id`),
  CONSTRAINT `desarrollo_islr_auxiliar_cedula` FOREIGN KEY (`auxiliar_cedula`) REFERENCES `auxiliar` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `desarrollo_islr_id` FOREIGN KEY (`islr_id`) REFERENCES `islr` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `director`
-- ----------------------------
DROP TABLE IF EXISTS `director`;
CREATE TABLE `director` (
  `usuario_cedula` varchar(20) NOT NULL,
  PRIMARY KEY (`usuario_cedula`),
  KEY `usuario_cedula_idx` (`usuario_cedula`),
  CONSTRAINT `director_usuario_cedula` FOREIGN KEY (`usuario_cedula`) REFERENCES `usuario` (`cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `director`
-- ----------------------------
BEGIN;
INSERT INTO `director` VALUES ('20174430');
COMMIT;

-- ----------------------------
--  Table structure for `factura_islr`
-- ----------------------------
DROP TABLE IF EXISTS `factura_islr`;
CREATE TABLE `factura_islr` (
  `facturacion_id` int(11) NOT NULL,
  `islr_id` int(11) NOT NULL,
  `contribuyente_id` int(11) NOT NULL,
  PRIMARY KEY (`facturacion_id`),
  KEY `facturacion_id_idx` (`facturacion_id`),
  KEY `islr_id_idx` (`islr_id`),
  KEY `contribuyente_id_idx` (`contribuyente_id`),
  CONSTRAINT `factura_islr_contribuyente_id` FOREIGN KEY (`contribuyente_id`) REFERENCES `contribuyente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `factura_islr_facturacion_id` FOREIGN KEY (`facturacion_id`) REFERENCES `facturacion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `factura_islr_islr_id` FOREIGN KEY (`islr_id`) REFERENCES `islr` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `factura_iva`
-- ----------------------------
DROP TABLE IF EXISTS `factura_iva`;
CREATE TABLE `factura_iva` (
  `facturacion_id` int(11) NOT NULL,
  `iva_mensual_id` int(11) NOT NULL,
  `contribuyente_id` int(11) NOT NULL,
  PRIMARY KEY (`facturacion_id`,`iva_mensual_id`,`contribuyente_id`),
  KEY `iva_mensual_id_idx` (`iva_mensual_id`),
  KEY `contribuyente_id_idx` (`contribuyente_id`),
  KEY `facturacion_id_idx` (`facturacion_id`),
  CONSTRAINT `factura_iva_contribuyente_id` FOREIGN KEY (`contribuyente_id`) REFERENCES `contribuyente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `factura_iva_facturacion_id` FOREIGN KEY (`facturacion_id`) REFERENCES `facturacion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `factura_iva_mensual_id` FOREIGN KEY (`iva_mensual_id`) REFERENCES `iva_mensual` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `facturacion`
-- ----------------------------
DROP TABLE IF EXISTS `facturacion`;
CREATE TABLE `facturacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supervisor_cedula` varchar(20) NOT NULL,
  `contribuyente_id` int(11) NOT NULL,
  `fecha_factura` datetime NOT NULL,
  `numero_factura` varchar(255) NOT NULL,
  `concepto_factura` text NOT NULL,
  `monto_factura` float NOT NULL,
  PRIMARY KEY (`id`,`supervisor_cedula`,`contribuyente_id`),
  KEY `supervisor_cedula_idx` (`supervisor_cedula`),
  KEY `contribuyente_id_idx` (`contribuyente_id`),
  CONSTRAINT `facturacion_contribuyente_id` FOREIGN KEY (`contribuyente_id`) REFERENCES `contribuyente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `facturacion_supervisor_cedula` FOREIGN KEY (`supervisor_cedula`) REFERENCES `supervisor` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `fechas`
-- ----------------------------
DROP TABLE IF EXISTS `fechas`;
CREATE TABLE `fechas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` datetime NOT NULL,
  `tipo` varchar(255) NOT NULL,
  `ano` int(11) NOT NULL,
  `monto` float DEFAULT NULL,
  `observaciones` text,
  `mes` int(11) NOT NULL,
  `dia` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `islr`
-- ----------------------------
DROP TABLE IF EXISTS `islr`;
CREATE TABLE `islr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contribuyente_id` int(11) NOT NULL,
  `ano` int(11) NOT NULL,
  `estado` varchar(255) NOT NULL DEFAULT 'NO',
  `observaciones` text,
  PRIMARY KEY (`id`,`contribuyente_id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `contribuyente_id_idx` (`contribuyente_id`),
  CONSTRAINT `islr_contribuyente_id` FOREIGN KEY (`contribuyente_id`) REFERENCES `contribuyente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `iva_mensual`
-- ----------------------------
DROP TABLE IF EXISTS `iva_mensual`;
CREATE TABLE `iva_mensual` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contribuyente_id` int(11) NOT NULL,
  `mes` int(11) NOT NULL,
  `ano` int(11) NOT NULL,
  `fecha_llegada` datetime NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'Inicio',
  `observaciones` text,
  PRIMARY KEY (`id`,`contribuyente_id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `contribuyente_id_idx` (`contribuyente_id`),
  CONSTRAINT `iva_mensual_contribuyente_id` FOREIGN KEY (`contribuyente_id`) REFERENCES `contribuyente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `patente`
-- ----------------------------
DROP TABLE IF EXISTS `patente`;
CREATE TABLE `patente` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contribuyente_id` int(11) NOT NULL,
  `status` varchar(20) NOT NULL,
  `patentecol` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`,`contribuyente_id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `contribuyente_id_idx` (`contribuyente_id`),
  CONSTRAINT `patente_contribuyente_id` FOREIGN KEY (`contribuyente_id`) REFERENCES `contribuyente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `patente_ano`
-- ----------------------------
DROP TABLE IF EXISTS `patente_ano`;
CREATE TABLE `patente_ano` (
  `patente_id` int(11) NOT NULL,
  `auxiliar_cedula` varchar(20) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `fecha` datetime NOT NULL,
  `monto` float NOT NULL,
  `numero_declaracion` varchar(255) NOT NULL,
  PRIMARY KEY (`patente_id`,`auxiliar_cedula`),
  KEY `patente_id_idx` (`patente_id`),
  KEY `auxiliar_cedula_idx` (`auxiliar_cedula`),
  CONSTRAINT `patente_ano_auxiliar_cedula` FOREIGN KEY (`auxiliar_cedula`) REFERENCES `auxiliar` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `patente_ano_patente_id` FOREIGN KEY (`patente_id`) REFERENCES `patente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `patente_mes`
-- ----------------------------
DROP TABLE IF EXISTS `patente_mes`;
CREATE TABLE `patente_mes` (
  `patente_id` int(11) NOT NULL,
  `auxiliar_cedula` varchar(20) NOT NULL,
  `mes` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `monto` float NOT NULL,
  `numero_declaracion` datetime NOT NULL,
  `patente_mescol` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`patente_id`,`auxiliar_cedula`),
  KEY `auxiliar_cedula_idx` (`auxiliar_cedula`),
  KEY `patente_id_idx` (`patente_id`),
  CONSTRAINT `factura_iva_patente_id` FOREIGN KEY (`patente_id`) REFERENCES `patente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `patente_mes_auxiliar_cedula` FOREIGN KEY (`auxiliar_cedula`) REFERENCES `auxiliar` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `procesada_iva`
-- ----------------------------
DROP TABLE IF EXISTS `procesada_iva`;
CREATE TABLE `procesada_iva` (
  `iva_mensual_id` int(11) NOT NULL,
  `auxiliar_cedula` varchar(20) NOT NULL,
  `fecha_procesada` datetime NOT NULL,
  PRIMARY KEY (`iva_mensual_id`,`auxiliar_cedula`),
  KEY `iva_mensual_id_idx` (`iva_mensual_id`),
  KEY `auxiliar_cedula_idx` (`auxiliar_cedula`),
  CONSTRAINT `procesada_iva_auxiliar_cedula` FOREIGN KEY (`auxiliar_cedula`) REFERENCES `auxiliar` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `procesada_iva_mensual_id` FOREIGN KEY (`iva_mensual_id`) REFERENCES `iva_mensual` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `retenciones_islr`
-- ----------------------------
DROP TABLE IF EXISTS `retenciones_islr`;
CREATE TABLE `retenciones_islr` (
  `iva_mensual_id` int(11) NOT NULL,
  `auxiliar_cedula` varchar(20) NOT NULL,
  `fecha_declaracion` datetime NOT NULL,
  `numero_declaracion` varchar(255) NOT NULL,
  `monto_a_pagar` float NOT NULL,
  PRIMARY KEY (`iva_mensual_id`,`auxiliar_cedula`),
  KEY `iva_mensual_id_idx` (`iva_mensual_id`),
  KEY `auxiliar_cedula_idx` (`auxiliar_cedula`),
  CONSTRAINT `retenciones_islr_auxiliar_cedula` FOREIGN KEY (`auxiliar_cedula`) REFERENCES `auxiliar` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `retenciones_islr_iva_mensual_id` FOREIGN KEY (`iva_mensual_id`) REFERENCES `iva_mensual` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `retenciones_iva`
-- ----------------------------
DROP TABLE IF EXISTS `retenciones_iva`;
CREATE TABLE `retenciones_iva` (
  `iva_mensual_id` int(11) NOT NULL,
  `auxiliar_cedula` varchar(20) NOT NULL,
  `quincena` int(11) NOT NULL,
  `fecha_declaracion` datetime NOT NULL,
  `numero_declaracion` varchar(255) NOT NULL,
  `monto_a_pagar` float NOT NULL,
  PRIMARY KEY (`iva_mensual_id`,`auxiliar_cedula`),
  KEY `iva_mensual_id_idx` (`iva_mensual_id`),
  KEY `auxiliar_cedula_idx` (`auxiliar_cedula`),
  CONSTRAINT `retenciones_iva_auxiliar_cedula` FOREIGN KEY (`auxiliar_cedula`) REFERENCES `auxiliar` (`usuario_cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `retenciones_iva_mensual_id` FOREIGN KEY (`iva_mensual_id`) REFERENCES `iva_mensual` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `supervisor`
-- ----------------------------
DROP TABLE IF EXISTS `supervisor`;
CREATE TABLE `supervisor` (
  `usuario_cedula` varchar(20) NOT NULL,
  PRIMARY KEY (`usuario_cedula`),
  KEY `usuario_cedula_idx` (`usuario_cedula`),
  CONSTRAINT `supervisor_usuario_cedula` FOREIGN KEY (`usuario_cedula`) REFERENCES `usuario` (`cedula`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `supervisor`
-- ----------------------------
BEGIN;
INSERT INTO `supervisor` VALUES ('20174430');
COMMIT;

-- ----------------------------
--  Table structure for `usuario`
-- ----------------------------
DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `cedula` varchar(20) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `correo` varchar(255) NOT NULL,
  `telefono` varchar(255) NOT NULL,
  `cargo` varchar(255) NOT NULL,
  `fecha_ingreso` datetime NOT NULL,
  `username` varchar(255) NOT NULL,
  `salario` float NOT NULL,
  `activo` tinyint(4) NOT NULL,
  PRIMARY KEY (`cedula`),
  UNIQUE KEY `cedula_UNIQUE` (`cedula`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `usuario`
-- ----------------------------
BEGIN;
INSERT INTO `usuario` VALUES ('20174430', 'Alejandro', 'Pardo Rodriguez', 'e10adc3949ba59abbe56e057f20f883e', 'alejandro.pardo.r@gmail.com', '0416-4151084', 'Administrador', '2011-08-15 00:00:00', 'apardo', '1700', '1');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
