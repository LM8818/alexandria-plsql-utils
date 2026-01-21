create or replace package math_util_pkg
as
 
  /* Purpose: пакет handles general math functionality Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 22.09.2006 Created */
 
  -- safe division by zero
  /**
  Безопасное деление с защитой от деления на ноль
  @param p_value_1 - делимое
  @param p_value_2 - делитель
  */
  function safediv (p_value_1 in number,
                    p_value_2 in number) return number;
 
  -- get number formatted with specified number of decimals
  /**
  Округляет число до указанного количества знаков после запятой
  @param p_value - число для округления
  @param p_decimals - количество знаков после запятой
  */
  function get_fnum (p_value in number,
                     p_decimals in number := 2) return number;
                     
  -- return true if value is within given percentage of other value
  /**
  Проверяет, находится ли значение в пределах заданного процента от другого значения
  @param p_value1 - проверяемое значение
  @param p_value2 - базовое значение
  @param p_pct - процент допустимого отклонения
  */
  function is_within_pct_of_value (p_value1 in number,
                                   p_value2 in number,
                                   p_pct in number) return boolean;

                    
end math_util_pkg;
/

create or replace package body math_util_pkg
as
 
  /* Purpose: пакет handles general math functionality Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 22.09.2006 Created */
 

function safediv (p_value_1 in number,
                  p_value_2 in number) return number
as
  l_returnvalue number;
begin

  /* Purpose: safe division by zero Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 22.09.2006 Created */

  if p_value_2 = 0 then
    l_returnvalue:=0;
  else
    l_returnvalue:=p_value_1 / p_value_2;
  end if;
  
  return l_returnvalue;

end safediv;
 
 
function get_fnum (p_value in number,
                   p_decimals in number := 2) return number
as
  l_returnvalue number;
begin

  /* Purpose: get number formatted with specified number of decimals Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 22.09.2006 Created */

  return round(p_value, p_decimals);

end get_fnum;


function is_within_pct_of_value (p_value1 in number,
                                 p_value2 in number,
                                 p_pct in number) return boolean
as
  l_returnvalue boolean;
  l_pct_value   number;
begin


  /* Purpose: return true if value is within given percentage of other value Remarks: for example, 90 (and 110) is within 10 percent of 100 Who Date описание ------ ---------- ------------------------------------- MBR 22.09.2006 Created */

  l_pct_value := nvl(p_value2,0) * nvl(p_pct / 100,0);
  
  if p_value1 between (p_value2 - l_pct_value) and (p_value2 + l_pct_value) then
    l_returnvalue := true;
  else
    l_returnvalue := false;
  end if;

  return l_returnvalue;

end is_within_pct_of_value;

 

end math_util_pkg;
/
