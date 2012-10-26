SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `coworker`.`usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`usuario` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`usuario` (
  `cedula` VARCHAR(20) NOT NULL ,
  `nombre` VARCHAR(255) NOT NULL ,
  `apellido` VARCHAR(255) NOT NULL ,
  `password` VARCHAR(255) NOT NULL ,
  `correo` VARCHAR(255) NOT NULL ,
  `telefono` VARCHAR(255) NOT NULL ,
  `cargo` VARCHAR(255) NOT NULL ,
  `fecha_ingreso` DATETIME NOT NULL ,
  `username` VARCHAR(255) NOT NULL ,
  `salario` FLOAT NOT NULL ,
  `activo` TINYINT NOT NULL ,
  PRIMARY KEY (`cedula`) ,
  UNIQUE INDEX `cedula_UNIQUE` (`cedula` ASC) ,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`contribuyente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`contribuyente` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`contribuyente` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `codigo` INT NOT NULL ,
  `nombre` VARCHAR(255) NOT NULL ,
  `rif` VARCHAR(255) NOT NULL ,
  `direccion` VARCHAR(255) NULL DEFAULT 'NO' ,
  `telefono` VARCHAR(255) NULL DEFAULT 'NO' ,
  `contacto` VARCHAR(255) NULL DEFAULT 'NO' ,
  `correo` VARCHAR(255) NULL DEFAULT 'NO' ,
  `municipio` VARCHAR(255) NULL DEFAULT 'NO' ,
  `fecha_cierre` VARCHAR(255) NULL DEFAULT 'NO' ,
  `tipo` VARCHAR(255) NOT NULL ,
  `activo` TINYINT NOT NULL DEFAULT 1 ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`fechas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`fechas` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`fechas` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `fecha` DATETIME NOT NULL ,
  `tipo` VARCHAR(255) NOT NULL ,
  `ano` INT NOT NULL ,
  `monto` FLOAT NULL ,
  `observaciones` TEXT NULL ,
  `mes` INT NOT NULL ,
  `dia` INT NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`bitacora`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`bitacora` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`bitacora` (
  `id` INT NOT NULL ,
  `usuario_cedula` VARCHAR(20) NOT NULL ,
  `fecha_hora` DATETIME NOT NULL ,
  `descripcion` TEXT NOT NULL ,
  `ip` VARCHAR(20) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`auxiliar`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`auxiliar` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`auxiliar` (
  `usuario_cedula` VARCHAR(20) NOT NULL ,
  PRIMARY KEY (`usuario_cedula`) ,
  INDEX `usuario_cedula_idx` (`usuario_cedula` ASC) ,
  CONSTRAINT `auxiliar_usuario_cedula`
    FOREIGN KEY (`usuario_cedula` )
    REFERENCES `coworker`.`usuario` (`cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`director`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`director` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`director` (
  `usuario_cedula` VARCHAR(20) NOT NULL ,
  PRIMARY KEY (`usuario_cedula`) ,
  INDEX `usuario_cedula_idx` (`usuario_cedula` ASC) ,
  CONSTRAINT `director_usuario_cedula`
    FOREIGN KEY (`usuario_cedula` )
    REFERENCES `coworker`.`usuario` (`cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`supervisor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`supervisor` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`supervisor` (
  `usuario_cedula` VARCHAR(20) NOT NULL ,
  PRIMARY KEY (`usuario_cedula`) ,
  INDEX `usuario_cedula_idx` (`usuario_cedula` ASC) ,
  CONSTRAINT `supervisor_usuario_cedula`
    FOREIGN KEY (`usuario_cedula` )
    REFERENCES `coworker`.`usuario` (`cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`administrador`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`administrador` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`administrador` (
  `usuario_cedula` VARCHAR(20) NOT NULL ,
  PRIMARY KEY (`usuario_cedula`) ,
  INDEX `usuario_cedula_idx` (`usuario_cedula` ASC) ,
  CONSTRAINT `administrador_usuario_cedula`
    FOREIGN KEY (`usuario_cedula` )
    REFERENCES `coworker`.`usuario` (`cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`contribuyente_auxiliar`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`contribuyente_auxiliar` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`contribuyente_auxiliar` (
  `auxiliar_cedula` VARCHAR(20) NOT NULL ,
  `contribuyente_id` INT NOT NULL ,
  PRIMARY KEY (`auxiliar_cedula`, `contribuyente_id`) ,
  INDEX `auxiliar_cedula_idx` (`auxiliar_cedula` ASC) ,
  INDEX `contribuyente_auxiliar_id` (`contribuyente_id` ASC) ,
  CONSTRAINT `contribuyente_auxiliar_cedula`
    FOREIGN KEY (`auxiliar_cedula` )
    REFERENCES `coworker`.`auxiliar` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `contribuyente_auxiliar_id`
    FOREIGN KEY (`contribuyente_id` )
    REFERENCES `coworker`.`contribuyente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`iva_mensual`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`iva_mensual` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`iva_mensual` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `contribuyente_id` INT NOT NULL ,
  `mes` INT NOT NULL ,
  `ano` INT NOT NULL ,
  `fecha_llegada` DATETIME NOT NULL ,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Inicio' ,
  `observaciones` TEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`id`, `contribuyente_id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  INDEX `contribuyente_id_idx` (`contribuyente_id` ASC) ,
  CONSTRAINT `iva_mensual_contribuyente_id`
    FOREIGN KEY (`contribuyente_id` )
    REFERENCES `coworker`.`contribuyente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`procesada_iva`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`procesada_iva` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`procesada_iva` (
  `iva_mensual_id` INT NOT NULL ,
  `auxiliar_cedula` VARCHAR(20) NOT NULL ,
  `fecha_procesada` DATETIME NOT NULL ,
  PRIMARY KEY (`iva_mensual_id`, `auxiliar_cedula`) ,
  INDEX `iva_mensual_id_idx` (`iva_mensual_id` ASC) ,
  INDEX `auxiliar_cedula_idx` (`auxiliar_cedula` ASC) ,
  CONSTRAINT `procesada_iva_mensual_id`
    FOREIGN KEY (`iva_mensual_id` )
    REFERENCES `coworker`.`iva_mensual` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `procesada_iva_auxiliar_cedula`
    FOREIGN KEY (`auxiliar_cedula` )
    REFERENCES `coworker`.`auxiliar` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`declarada_iva`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`declarada_iva` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`declarada_iva` (
  `iva_mensual_id` INT NOT NULL ,
  `auxiliar_cedula` VARCHAR(20) NOT NULL ,
  `fecha_declarada` DATETIME NOT NULL ,
  `numero_declaracion` VARCHAR(255) NOT NULL ,
  `monto_a_pagar` FLOAT NOT NULL ,
  PRIMARY KEY (`iva_mensual_id`, `auxiliar_cedula`) ,
  INDEX `iva_mensual_id_idx` (`iva_mensual_id` ASC) ,
  INDEX `auxiliar_cedula_idx` (`auxiliar_cedula` ASC) ,
  CONSTRAINT `declarada_iva_mensual_id`
    FOREIGN KEY (`iva_mensual_id` )
    REFERENCES `coworker`.`iva_mensual` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `declarada_iva_auxiliar_cedula`
    FOREIGN KEY (`auxiliar_cedula` )
    REFERENCES `coworker`.`auxiliar` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`carpeta_iva`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`carpeta_iva` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`carpeta_iva` (
  `iva_mensual_id` INT NOT NULL ,
  `auxiliar_cedula` VARCHAR(20) NOT NULL ,
  `fecha_creada` DATETIME NOT NULL ,
  `fecha_elaborada` DATETIME NOT NULL ,
  `fecha_contabilizacion_comprobantes` DATETIME NOT NULL ,
  PRIMARY KEY (`iva_mensual_id`, `auxiliar_cedula`) ,
  INDEX `iva_mensual_id_idx` (`iva_mensual_id` ASC) ,
  INDEX `auxiliar_cedula_idx` (`auxiliar_cedula` ASC) ,
  CONSTRAINT `carpeta_iva_mensual_id`
    FOREIGN KEY (`iva_mensual_id` )
    REFERENCES `coworker`.`iva_mensual` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `carpeta_auxiliar_cedula`
    FOREIGN KEY (`auxiliar_cedula` )
    REFERENCES `coworker`.`auxiliar` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`retenciones_iva`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`retenciones_iva` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`retenciones_iva` (
  `iva_mensual_id` INT NOT NULL ,
  `auxiliar_cedula` VARCHAR(20) NOT NULL ,
  `quincena` INT NOT NULL ,
  `fecha_declaracion` DATETIME NOT NULL ,
  `numero_declaracion` VARCHAR(255) NOT NULL ,
  `monto_a_pagar` FLOAT NOT NULL ,
  PRIMARY KEY (`iva_mensual_id`, `auxiliar_cedula`) ,
  INDEX `iva_mensual_id_idx` (`iva_mensual_id` ASC) ,
  INDEX `auxiliar_cedula_idx` (`auxiliar_cedula` ASC) ,
  CONSTRAINT `retenciones_iva_mensual_id`
    FOREIGN KEY (`iva_mensual_id` )
    REFERENCES `coworker`.`iva_mensual` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `retenciones_iva_auxiliar_cedula`
    FOREIGN KEY (`auxiliar_cedula` )
    REFERENCES `coworker`.`auxiliar` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`retenciones_islr`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`retenciones_islr` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`retenciones_islr` (
  `iva_mensual_id` INT NOT NULL ,
  `auxiliar_cedula` VARCHAR(20) NOT NULL ,
  `fecha_declaracion` DATETIME NOT NULL ,
  `numero_declaracion` VARCHAR(255) NOT NULL ,
  `monto_a_pagar` FLOAT NOT NULL ,
  PRIMARY KEY (`iva_mensual_id`, `auxiliar_cedula`) ,
  INDEX `iva_mensual_id_idx` (`iva_mensual_id` ASC) ,
  INDEX `auxiliar_cedula_idx` (`auxiliar_cedula` ASC) ,
  CONSTRAINT `retenciones_islr_iva_mensual_id`
    FOREIGN KEY (`iva_mensual_id` )
    REFERENCES `coworker`.`iva_mensual` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `retenciones_islr_auxiliar_cedula`
    FOREIGN KEY (`auxiliar_cedula` )
    REFERENCES `coworker`.`auxiliar` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`patente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`patente` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`patente` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `contribuyente_id` INT NOT NULL ,
  `status` VARCHAR(20) NOT NULL ,
  `patentecol` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`, `contribuyente_id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  INDEX `contribuyente_id_idx` (`contribuyente_id` ASC) ,
  CONSTRAINT `patente_contribuyente_id`
    FOREIGN KEY (`contribuyente_id` )
    REFERENCES `coworker`.`contribuyente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`patente_mes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`patente_mes` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`patente_mes` (
  `patente_id` INT NOT NULL ,
  `auxiliar_cedula` VARCHAR(20) NOT NULL ,
  `mes` INT NOT NULL ,
  `fecha` DATETIME NOT NULL ,
  `monto` FLOAT NOT NULL ,
  `numero_declaracion` DATETIME NOT NULL ,
  `patente_mescol` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`patente_id`, `auxiliar_cedula`) ,
  INDEX `auxiliar_cedula_idx` (`auxiliar_cedula` ASC) ,
  INDEX `patente_id_idx` (`patente_id` ASC) ,
  CONSTRAINT `patente_mes_auxiliar_cedula`
    FOREIGN KEY (`auxiliar_cedula` )
    REFERENCES `coworker`.`auxiliar` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `factura_iva_patente_id`
    FOREIGN KEY (`patente_id` )
    REFERENCES `coworker`.`patente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`patente_ano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`patente_ano` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`patente_ano` (
  `patente_id` INT NOT NULL ,
  `auxiliar_cedula` VARCHAR(20) NOT NULL ,
  `tipo` VARCHAR(20) NOT NULL ,
  `fecha` DATETIME NOT NULL ,
  `monto` FLOAT NOT NULL ,
  `numero_declaracion` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`patente_id`, `auxiliar_cedula`) ,
  INDEX `patente_id_idx` (`patente_id` ASC) ,
  INDEX `auxiliar_cedula_idx` (`auxiliar_cedula` ASC) ,
  CONSTRAINT `patente_ano_patente_id`
    FOREIGN KEY (`patente_id` )
    REFERENCES `coworker`.`patente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `patente_ano_auxiliar_cedula`
    FOREIGN KEY (`auxiliar_cedula` )
    REFERENCES `coworker`.`auxiliar` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`islr`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`islr` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`islr` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `contribuyente_id` INT NOT NULL ,
  `ano` INT NOT NULL ,
  `estado` VARCHAR(255) NOT NULL DEFAULT 'NO' ,
  `observaciones` TEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`id`, `contribuyente_id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  INDEX `contribuyente_id_idx` (`contribuyente_id` ASC) ,
  CONSTRAINT `islr_contribuyente_id`
    FOREIGN KEY (`contribuyente_id` )
    REFERENCES `coworker`.`contribuyente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`desarrollo_islr`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`desarrollo_islr` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`desarrollo_islr` (
  `islr_id` INT NOT NULL ,
  `auxiliar_cedula` VARCHAR(20) NOT NULL ,
  `fecha_inicio` DATETIME NULL DEFAULT NULL ,
  `fecha_culminacion` DATETIME NULL DEFAULT NULL ,
  `fecha_revision` DATETIME NULL DEFAULT NULL ,
  `observaciones` TEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`islr_id`, `auxiliar_cedula`) ,
  INDEX `auxiliar_cedula_idx` (`auxiliar_cedula` ASC) ,
  INDEX `islr_id_idx` (`islr_id` ASC) ,
  CONSTRAINT `desarrollo_islr_auxiliar_cedula`
    FOREIGN KEY (`auxiliar_cedula` )
    REFERENCES `coworker`.`auxiliar` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `desarrollo_islr_id`
    FOREIGN KEY (`islr_id` )
    REFERENCES `coworker`.`islr` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`declarada_islr`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`declarada_islr` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`declarada_islr` (
  `islr_id` INT NOT NULL ,
  `auxiliar_cedula` VARCHAR(20) NOT NULL ,
  `fecha_declarada` DATETIME NOT NULL ,
  `numero_declaracion` VARCHAR(255) NOT NULL ,
  `monto_a_pagar` FLOAT NOT NULL ,
  `tipo` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`islr_id`, `auxiliar_cedula`) ,
  INDEX `auxiliar_cedula_idx` (`auxiliar_cedula` ASC) ,
  INDEX `islr_id_idx` (`islr_id` ASC) ,
  CONSTRAINT `declarada_islr_auxiliar_cedula`
    FOREIGN KEY (`auxiliar_cedula` )
    REFERENCES `coworker`.`auxiliar` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `declarada_islr_id`
    FOREIGN KEY (`islr_id` )
    REFERENCES `coworker`.`islr` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`facturacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`facturacion` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`facturacion` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `supervisor_cedula` VARCHAR(20) NOT NULL ,
  `contribuyente_id` INT NOT NULL ,
  `fecha_factura` DATETIME NOT NULL ,
  `numero_factura` VARCHAR(255) NOT NULL ,
  `concepto_factura` TEXT NOT NULL ,
  `monto_factura` FLOAT NOT NULL ,
  PRIMARY KEY (`id`, `supervisor_cedula`, `contribuyente_id`) ,
  INDEX `supervisor_cedula_idx` (`supervisor_cedula` ASC) ,
  INDEX `contribuyente_id_idx` (`contribuyente_id` ASC) ,
  CONSTRAINT `facturacion_supervisor_cedula`
    FOREIGN KEY (`supervisor_cedula` )
    REFERENCES `coworker`.`supervisor` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `facturacion_contribuyente_id`
    FOREIGN KEY (`contribuyente_id` )
    REFERENCES `coworker`.`contribuyente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`factura_iva`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`factura_iva` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`factura_iva` (
  `facturacion_id` INT NOT NULL ,
  `iva_mensual_id` INT NOT NULL ,
  `contribuyente_id` INT NOT NULL ,
  PRIMARY KEY (`facturacion_id`, `iva_mensual_id`, `contribuyente_id`) ,
  INDEX `iva_mensual_id_idx` (`iva_mensual_id` ASC) ,
  INDEX `contribuyente_id_idx` (`contribuyente_id` ASC) ,
  INDEX `facturacion_id_idx` (`facturacion_id` ASC) ,
  CONSTRAINT `factura_iva_mensual_id`
    FOREIGN KEY (`iva_mensual_id` )
    REFERENCES `coworker`.`iva_mensual` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `factura_iva_contribuyente_id`
    FOREIGN KEY (`contribuyente_id` )
    REFERENCES `coworker`.`contribuyente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `factura_iva_facturacion_id`
    FOREIGN KEY (`facturacion_id` )
    REFERENCES `coworker`.`facturacion` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`factura_islr`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`factura_islr` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`factura_islr` (
  `facturacion_id` INT NOT NULL ,
  `islr_id` INT NOT NULL ,
  `contribuyente_id` INT NOT NULL ,
  PRIMARY KEY (`facturacion_id`) ,
  INDEX `facturacion_id_idx` (`facturacion_id` ASC) ,
  INDEX `islr_id_idx` (`islr_id` ASC) ,
  INDEX `contribuyente_id_idx` (`contribuyente_id` ASC) ,
  CONSTRAINT `factura_islr_facturacion_id`
    FOREIGN KEY (`facturacion_id` )
    REFERENCES `coworker`.`facturacion` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `factura_islr_islr_id`
    FOREIGN KEY (`islr_id` )
    REFERENCES `coworker`.`islr` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `factura_islr_contribuyente_id`
    FOREIGN KEY (`contribuyente_id` )
    REFERENCES `coworker`.`contribuyente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`cobranza`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`cobranza` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`cobranza` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `supervisor_cedula` VARCHAR(20) NOT NULL ,
  `facturacion_id` INT NOT NULL ,
  `forma_pago` VARCHAR(255) NULL DEFAULT NULL ,
  `status` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`, `supervisor_cedula`, `facturacion_id`) ,
  INDEX `supervisor_cedula_idx` (`supervisor_cedula` ASC) ,
  INDEX `facturacion_id_idx` (`id` ASC) ,
  CONSTRAINT `cobranza_supervisor_cedula`
    FOREIGN KEY (`supervisor_cedula` )
    REFERENCES `coworker`.`supervisor` (`usuario_cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cobranza_facturacion_id`
    FOREIGN KEY (`id` )
    REFERENCES `coworker`.`facturacion` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`cobranza_deposito`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`cobranza_deposito` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`cobranza_deposito` (
  `cobranza_id` INT NOT NULL ,
  `numero_deposito` VARCHAR(255) NOT NULL ,
  `beneficiario` VARCHAR(255) NOT NULL ,
  `banco_destino` VARCHAR(255) NOT NULL ,
  `monto` FLOAT NOT NULL ,
  `fecha` DATETIME NOT NULL ,
  `usuario_cedula` VARCHAR(20) NOT NULL ,
  PRIMARY KEY (`cobranza_id`, `usuario_cedula`) ,
  INDEX `facturacion_id_idx` (`cobranza_id` ASC) ,
  INDEX `usuario_cedula_idx` (`usuario_cedula` ASC) ,
  CONSTRAINT `deposito_cobranza_id`
    FOREIGN KEY (`cobranza_id` )
    REFERENCES `coworker`.`cobranza` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `deposito_usuario_cedula`
    FOREIGN KEY (`usuario_cedula` )
    REFERENCES `coworker`.`usuario` (`cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`cobranza_cheque`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`cobranza_cheque` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`cobranza_cheque` (
  `cobranza_id` INT NOT NULL ,
  `usuario_cedula` VARCHAR(20) NOT NULL ,
  `numero_cheque` VARCHAR(255) NOT NULL ,
  `beneficiario` VARCHAR(255) NOT NULL ,
  `banco_destino` VARCHAR(255) NOT NULL ,
  `banco_origen` VARCHAR(255) NOT NULL ,
  `monto` FLOAT NOT NULL ,
  `fecha` DATETIME NOT NULL ,
  PRIMARY KEY (`cobranza_id`, `usuario_cedula`) ,
  INDEX `facturacion_id_idx` (`cobranza_id` ASC) ,
  INDEX `usuario_cedula_idx` (`usuario_cedula` ASC) ,
  CONSTRAINT `cheque_cobranza_id`
    FOREIGN KEY (`cobranza_id` )
    REFERENCES `coworker`.`cobranza` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cheque_usuario_cedula`
    FOREIGN KEY (`usuario_cedula` )
    REFERENCES `coworker`.`usuario` (`cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `coworker`.`cobranza_efectivo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `coworker`.`cobranza_efectivo` ;

CREATE  TABLE IF NOT EXISTS `coworker`.`cobranza_efectivo` (
  `cobranza_id` INT NOT NULL ,
  `usuario_cedula` VARCHAR(20) NOT NULL ,
  `monto` FLOAT NOT NULL ,
  `fecha` DATETIME NOT NULL ,
  PRIMARY KEY (`cobranza_id`, `usuario_cedula`) ,
  INDEX `cobranza_id_idx` (`cobranza_id` ASC) ,
  INDEX `usuario_cedula_idx` (`usuario_cedula` ASC) ,
  CONSTRAINT `efectivo_cobranza_id`
    FOREIGN KEY (`cobranza_id` )
    REFERENCES `coworker`.`cobranza` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `efectivo_usuario_cedula`
    FOREIGN KEY (`usuario_cedula` )
    REFERENCES `coworker`.`usuario` (`cedula` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
