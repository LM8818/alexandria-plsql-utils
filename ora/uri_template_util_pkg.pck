create or replace package uri_template_util_pkg
as
 
  /* Purpose: пакет handles URI templates Remarks: see http://tools.ietf.org/html/rfc6570 Who Date описание ------ ---------- -------------------------------- MBR 30.07.2012 Created */
 
  type t_dictionary is table of varchar2(4000) index by varchar2(255);
 
  -- expand URI based on template
  /**
  Разворачивает URI шаблон с подстановкой значений
  @param p_template - URI шаблон с плейсхолдерами {name}
  @param p_values - массив значений для подстановки
  */
  function expand (p_template in varchar2,
                   p_values in t_str_array) return varchar2;
 
  -- matches actual URI with list of templates
  /**
  Сопоставляет URI с списком шаблонов и возвращает подходящий шаблон
  @param p_uri - URI для сопоставления
  @param p_templates - массив шаблонов для проверки
  */
  function match (p_uri in varchar2,
                  p_templates in t_str_array) return varchar2;
 
  -- get actual names and values
  /**
  Извлекает имена и значения из URI на основе шаблона
  @param p_template - URI шаблон с плейсхолдерами
  @param p_uri - фактический URI для парсинга
  */
  function parse (p_template in varchar2,
                  p_uri in varchar2) return t_dictionary;
 
 
end uri_template_util_pkg;
/


create or replace package body uri_template_util_pkg
as
 
  /* Purpose: пакет handles URI templates Remarks: Who Date описание ------ ---------- -------------------------------- MBR 30.07.2012 Created */
 
 
function expand (p_template in varchar2,
                 p_values in t_str_array) return varchar2
as
  l_returnvalue string_util_pkg.t_max_db_varchar2;
begin
 
  /* Purpose: expand URI based on template Remarks: Who Date описание ------ ---------- -------------------------------- MBR 30.07.2012 Created */
  
  l_returnvalue := p_template;
  
  if p_values.count > 0 then
    for i in p_values.first .. p_values.last loop
      l_returnvalue := regexp_replace (l_returnvalue, regexp_util_pkg.g_exp_curly_brackets, p_values(i), 1, 1);
    end loop;
  end if;
 
  return l_returnvalue;
 
end expand;
 
 
function match (p_uri in varchar2,
                p_templates in t_str_array) return varchar2
as
  l_template    string_util_pkg.t_max_db_varchar2;
  l_returnvalue string_util_pkg.t_max_db_varchar2;
begin
 
  /* Purpose: matches actual URI with list of templates Remarks: Who Date описание ------ ---------- -------------------------------- MBR 30.07.2012 Created */
  
  if p_templates.count > 0 then
  
    for i in p_templates.first .. p_templates.last loop
    
      l_template := regexp_replace(p_templates(i), regexp_util_pkg.g_exp_curly_brackets, '(.*)');
      
      if regexp_substr(p_uri, l_template) = p_uri then
        l_returnvalue := p_templates(i);
        exit;
      end if;
    
    end loop;
  
  end if;
 
  return l_returnvalue;
 
end match;
 
 
function parse (p_template in varchar2,
                p_uri in varchar2) return t_dictionary
as
  l_template    string_util_pkg.t_max_db_varchar2;
  l_from        pls_integer;
  l_to          pls_integer;
  l_value       string_util_pkg.t_max_db_varchar2;
  l_returnvalue t_dictionary;
begin
 
  /* Purpose: get actual names and values Remarks: Who Date описание ------ ---------- -------------------------------- MBR 30.07.2012 Created */
  
  l_template := p_template;
  
  for l_rec in (select column_value as key_name from table(regexp_util_pkg.match (l_template, regexp_util_pkg.g_exp_curly_brackets))) loop

    l_from := instr(l_template, l_rec.key_name);
    l_to := instr(p_uri, '/', l_from + 1);
    if l_to = 0 then
      l_to := length(p_uri) + 1;
    end if;
    
    l_value := substr(p_uri, l_from, l_to - l_from);
    l_template := replace(l_template, l_rec.key_name, l_value);
    
    l_returnvalue(substr(l_rec.key_name, 2, length(l_rec.key_name) - 2)) := l_value;
  
  end loop;  
 
  return l_returnvalue;
 
end parse;
 
end uri_template_util_pkg;
/
 


