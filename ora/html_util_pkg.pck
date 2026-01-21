CREATE OR REPLACE package html_util_pkg
as

  /* Purpose: пакет contains HTML utilities Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 03.12.2009 Created */
  
  -- replace normal line breaks with html line breaks
  /**
  Заменяет обычные переводы строк на HTML теги <br>
  @param p_html - HTML текст для обработки
  */
  function get_html_with_line_breaks (p_html in varchar2) return varchar2;
  
  -- make URLs in text into hyperlinks
  /**
  Преобразует URL в тексте в HTML гиперссылки
  @param p_text - текст для поиска URL
  @param p_class - CSS класс для ссылок
  */
  function add_hyperlinks (p_text in varchar2,
                           p_class in varchar2 := null) return varchar2;
  
  -- make URLs in text into hyperlinks
  /**
  Преобразует URL в CLOB тексте в HTML гиперссылки
  @param p_text - CLOB текст для поиска URL
  @param p_class - CSS класс для ссылок
  */
  function add_hyperlinks (p_text in clob,
                           p_class in varchar2 := null) return clob;

end html_util_pkg;
/

CREATE OR REPLACE package body html_util_pkg
as

  /* Purpose: пакет contains HTML utilities Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 03.12.2009 Created */


/**
Функция get_html_with_line_breaks
@param p_html - параметр типа varchar2
*/
function get_html_with_line_breaks (p_html in varchar2) return varchar2
as
  l_returnvalue string_util_pkg.t_max_pl_varchar2;
begin
 
  /* Purpose: replace normal line breaks with html line breaks Remarks: Who Date описание ------ ---------- -------------------------------- MBR 10.01.2009 Created */
  
  l_returnvalue := replace(p_html, chr(10), '<br>');
 
  return l_returnvalue;
 
end get_html_with_line_breaks;


function add_hyperlinks (p_text in varchar2,
                         p_class in varchar2 := null) return varchar2
as
  l_returnvalue string_util_pkg.t_max_pl_varchar2;
begin

  /* Purpose: make URLs in text into hyperlinks Remarks: Who Date описание ------ ---------- -------------------------------- MBR 23.01.2011 Created */
  
  l_returnvalue := regexp_replace(p_text, 'http://([[:alnum:]|.]+)', '<a href="http://\1" class="' || p_class || '">\1</a>');
  
  return l_returnvalue;

end add_hyperlinks;
  

function add_hyperlinks (p_text in clob,
                         p_class in varchar2 := null) return clob
as
  l_returnvalue clob;
begin

  /* Purpose: make URLs in text into hyperlinks Remarks: Who Date описание ------ ---------- -------------------------------- MBR 23.01.2011 Created */
  
  l_returnvalue := regexp_replace(p_text, 'http://([[:alnum:]|.]+)', '<a href="http://\1" class="' || p_class || '">\1</a>');
  
  return l_returnvalue;

end add_hyperlinks;


end html_util_pkg;
/
