create or replace package gis_util_pkg
as
 
  /* Purpose: пакет contains utility functions related to Geographical Information Systems (GIS) Remarks: Who Date описание ------ ---------- -------------------------------- MBR 06.02.2011 Created */
 
  g_radius_earth_miles           constant number := 3443.917;
  
  g_latitude_direction_north     constant varchar2(1) := 'N';
  g_latitude_direction_south     constant varchar2(1) := 'S';
  g_longitude_direction_east     constant varchar2(1) := 'E';
  g_longitude_direction_west     constant varchar2(1) := 'W';
  
  -- get ecliptic degree of position
  /**
  Вычисляет эклиптическую степень координаты с учетом направления
  @param p_degree - степень координаты
  @param p_direction - направление (N, S, E, W)
  */
  function get_ecliptic_degree (p_degree in number,
                                p_direction in varchar2) return number;                     
                     
  -- get distance between to geographic position
  /**
  Вычисляет расстояние между двумя географическими точками
  @param p_from_latitude - широта начальной точки
  @param p_from_longitude - долгота начальной точки
  @param p_to_latitude - широта конечной точки
  @param p_to_longitude - долгота конечной точки
  @param p_radius - радиус Земли в милях
  */
  function get_ecliptic_distance (p_from_latitude in number,
                                  p_from_longitude in number,
                                  p_to_latitude in number,
                                  p_to_longitude in number,
                                  p_radius in number := g_radius_earth_miles) return number;
 
end gis_util_pkg;
/

create or replace package body gis_util_pkg
as
 
  /* Purpose: пакет contains utility functions related to Geographical Information Systems (GIS) Remarks: Who Date описание ------ ---------- -------------------------------- MBR 06.02.2011 Created */
 
   g_degrees_to_radians_factor   constant number := 57.29577951;  


function get_ecliptic_degree (p_degree in number,
                              p_direction in varchar2) return number
as
  l_returnvalue number;
begin

  /* Purpose: get degrees (ecliptic) Remarks: Who Date описание ------ ---------- ------------------------------------- FDL 26.05.2008 Created */
  
  if p_direction in (g_longitude_direction_west, g_latitude_direction_south) then
    l_returnvalue := 360 - p_degree;
  else
    l_returnvalue := p_degree;
  end if;
  
  return l_returnvalue;

end get_ecliptic_degree;



function get_ecliptic_distance (p_from_latitude in number,
                                p_from_longitude in number,
                                p_to_latitude in number,
                                p_to_longitude in number,
                                p_radius in number := g_radius_earth_miles) return number
as
  l_returnvalue number;
begin

  /* Purpose: calculate distance based on latitude and longitude Remarks: see http://en.wikipedia.org/wiki/Ecliptic_coordinate_system Who Date описание ------ ---------- ------------------------------------- FDL 27.05.2008 Created */

  begin
    l_returnvalue := (p_radius * acos((sin(p_from_latitude / g_degrees_to_radians_factor) * sin(p_to_latitude / g_degrees_to_radians_factor)) +
          (cos(p_from_latitude / g_degrees_to_radians_factor) * cos(p_to_latitude /g_degrees_to_radians_factor) *
           cos(p_to_longitude / g_degrees_to_radians_factor - p_from_longitude/ g_degrees_to_radians_factor))));
  exception
    when others then
      l_returnvalue := null;
  end;
                   
  return l_returnvalue;

end get_ecliptic_distance;

 
end gis_util_pkg;
/
 


