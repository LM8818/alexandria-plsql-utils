create or replace package validation_util_pkg
as
 
  /* Purpose: пакет handles validations Remarks: Who Date описание ------ ---------- -------------------------------- MBR 23.10.2011 Created */
 
 
  -- returns true if value is valid email address
  /**
  Проверяет валидность email адреса
  @param p_value - email адрес для проверки
  */
  function is_valid_email (p_value in varchar2) return boolean;

  -- returns true if value is valid email address
  /**
  Проверяет валидность email адреса (альтернативная реализация)
  @param p_value - email адрес для проверки
  */
  function is_valid_email2 (p_value in varchar2) return boolean;

  -- returns true if value is valid email address list
  /**
  Проверяет валидность списка email адресов
  @param p_value - строка со списком email адресов через запятую
  */
  function is_valid_email_list (p_value in varchar2) return boolean;
 
end validation_util_pkg;
/


create or replace package body validation_util_pkg
as
 
  /* Purpose: пакет handles validations Remarks: Who Date описание ------ ---------- -------------------------------- MBR 23.10.2011 Created */


/**
Проверяет валидность email адреса
@param p_value - email адрес для проверки
*/
function is_valid_email (p_value in varchar2) return boolean
as
  l_value       varchar2(32000);
  l_returnvalue boolean;
begin
 
  /* Purpose: возвращает true if value is valid email address Remarks: Who Date описание ------ ---------- -------------------------------- MBR 23.10.2011 Created Tim N 01.04.2016 Enhancements */

  l_returnvalue := regexp_like(p_value, regexp_util_pkg.g_exp_email_addresses);

  return l_returnvalue;

end is_valid_email;


/**
Проверяет валидность email адреса (альтернативная реализация)
@param p_value - email адрес для проверки
*/
function is_valid_email2 (p_value in varchar2) return boolean
as
begin

 /* Purpose: backward compatibility only */

  return is_valid_email(p_value);

end is_valid_email2;


/**
Функция is_valid_email_list
@param p_value - параметр типа varchar2
*/
function is_valid_email_list (p_value in varchar2) return boolean
as
  l_returnvalue boolean;
begin
 
  /* Purpose: возвращает true if value is valid email address list Remarks: see http://application-express-blog.e-dba.com/?p=158 for the regular expression used Who Date описание ------ ---------- -------------------------------- MBR 23.10.2011 Created Tim N 01.04.2016 Enhancements */

  l_returnvalue := regexp_like(p_value, regexp_util_pkg.g_exp_email_address_list);

  return l_returnvalue;

end is_valid_email_list;


end validation_util_pkg;
/
 


