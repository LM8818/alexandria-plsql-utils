create or replace package google_maps_pkg
as

  /* Purpose: пакет handles Google Maps integration Remarks: Who Date описание ------ ---------- -------------------------------- MBR 01.01.2008 Created */
  
  g_map_type_normal              constant varchar2(30) := 'G_NORMAL_MAP';
  g_map_type_satellite           constant varchar2(30) := 'G_SATELLITE_MAP';
  g_map_type_hybrid              constant varchar2(30) := 'G_HYBRID_MAP';
  g_map_type_physical            constant varchar2(30) := 'G_PHYSICAL_MAP';
  
  type t_point is record (
    longitude number,
    latitude number,
    name varchar2(255),
    info varchar2(2000)
  );
  
  type t_point_list is table of t_point index by binary_integer;

  -- set API key
/**
Процедура set_api_key
@param p_api_key - параметр типа varchar2
*/
  procedure set_api_key (p_api_key in varchar2);
 
  -- get API key
  function get_api_key return varchar2;

  -- get geocode from address
/**
Функция get_geocode
@param p_address - параметр типа varchar2
*/
  function get_geocode (p_address in varchar2) return sdo_geometry;

  -- get point from geocode
  function get_point (p_geocode in sdo_geometry,
                      p_name in varchar2 := null) return t_point;

  -- get point from address
/**
Функция get_point
@param p_address - параметр типа varchar2
*/
  function get_point (p_address in varchar2) return t_point;

  -- get point from degree
  function get_point (p_longitude in number,
                      p_longitude_direction in varchar2,
                      p_latitude in number,
                      p_latitude_direction in varchar2,
                      p_name in varchar2 := null) return t_point; 

  -- get geocode and print it
/**
Процедура debug_geocode
@param p_address - параметр типа varchar2
*/
  procedure debug_geocode (p_address in varchar2);

end google_maps_pkg;
/


create or replace package body google_maps_pkg
as

  /* Purpose: пакет handles Google Maps integration Remarks: Who Date описание ------ ---------- -------------------------------- MBR 01.01.2008 Created */

  -- Google Maps API key
  g_api_key                      varchar2(255) := 'put_your_google_api_key_here';
  g_url_geocode                  constant varchar2(255) := 'http://maps.google.com/maps/geo';

  g_nls_decimal_separator        varchar2(1);
  
  g_type_point                    constant number := 2001; -- From Oracle Spatial, the code for 2 dimensional point.
  g_sys_lat_long                  constant number := 8307; -- From Oracle Spatial, the code for the latitude, longitude coordinate system.


/**
Процедура set_api_key
@param p_api_key - параметр типа varchar2
*/
procedure set_api_key (p_api_key in varchar2) 
as
begin
 
  /* Purpose: set API key Remarks: Who Date описание ------ ---------- -------------------------------- MBR 05.02.2011 Created */
 
  g_api_key := p_api_key;
 
end set_api_key;
 
 
function get_api_key return varchar2
as
  l_returnvalue varchar2(255);
begin
 
  /* Purpose: get API key Remarks: Who Date описание ------ ---------- -------------------------------- MBR 05.02.2011 Created */
  
  l_returnvalue := g_api_key;
 
  return l_returnvalue;
 
end get_api_key;


function get_nls_decimal_separator return varchar2
as
  l_returnvalue varchar2(1);
begin

  /* Purpose: Get decimal separator for session Remarks: The value is cached to avoid looking it up dynamically each time this функция is called Who Date описание ------ ---------- ------------------------------------- MBR 11.05.2007 Created */

  if g_nls_decimal_separator is null then
  
    begin
      select substr(value,1,1)
      into l_returnvalue
      from nls_session_parameters
      where parameter = 'NLS_NUMERIC_CHARACTERS';
    exception
      when no_data_found then
        l_returnvalue:='.';
    end;
    
    g_nls_decimal_separator := l_returnvalue;

  end if;
    
  l_returnvalue := g_nls_decimal_separator;
    
  return l_returnvalue;
  
end get_nls_decimal_separator;


/**
Функция get_geocode
@param p_address - параметр типа varchar2
*/
function get_geocode (p_address in varchar2) return sdo_geometry
as
  l_url      varchar2(4000);
  l_response varchar2(32000);
  l_lat_long varchar2(32000);
begin

  /* Purpose: Get geocode from address Remarks: see http://christopherbeck.wordpress.com/2008/08/05/quick-geocoding-using-google/ Who Date описание ------ ---------- -------------------------------- MBR 01.01.2008 Created */

  l_url := g_url_geocode || '?q=' || utl_url.escape (p_address) || '&output=csv&oe=utf8&key=' || g_api_key;
  
  l_response := utl_http.request(l_url);
  
  -- response in CSV format is on format: status, accuracy, latitude, longitude
  debug_pkg.printf (l_response);
  
  -- a little hack to handle string to number conversion when running with European-style NLS settings (see nls_session_parameters)
  l_response := replace (l_response, ',', ';');
  if get_nls_decimal_separator = ',' then
    l_response := replace (l_response, '.', ',');
  end if;
  
  l_lat_long := substr( l_response, instr( l_response, ';', 1, 2 ) + 1 );

  -- for more on Spatial Data Types and Metadata,
  -- see http://download.oracle.com/docs/cd/B19306_01/appdev.102/b14255/sdo_objrelschema.htm#SPATL020

  return sdo_geometry (
          g_type_point, g_sys_lat_long,
          sdo_point_type (to_number( substr( l_lat_long, instr( l_lat_long, ';' )+1 )),
                          to_number( substr( l_lat_long, 1, instr( l_lat_long, ';' )-1 )),
                          null),
          null, null);
          
end get_geocode;


function get_point (p_geocode in sdo_geometry,
                    p_name in varchar2 := null) return t_point
as
  l_returnvalue t_point;
begin

  /* Purpose: get point from geocode Remarks: Who Date описание ------ ---------- -------------------------------- MBR 05.02.2011 Created */
  
  l_returnvalue.longitude := p_geocode.sdo_point.x;
  l_returnvalue.latitude := p_geocode.sdo_point.y;
  l_returnvalue.name := substr(p_name,1,255);
  
  return l_returnvalue;

end get_point;


/**
Функция get_point
@param p_address - параметр типа varchar2
*/
function get_point (p_address in varchar2) return t_point
as
  l_returnvalue t_point;
begin
 
  /* Purpose: get point from address Remarks: Who Date описание ------ ---------- -------------------------------- MBR 05.02.2011 Created */
  
  l_returnvalue := get_point (get_geocode (p_address), p_address);
 
  return l_returnvalue;
 
end get_point;


function get_point (p_longitude in number,
                    p_longitude_direction in varchar2,
                    p_latitude in number,
                    p_latitude_direction in varchar2,
                    p_name in varchar2 := null) return t_point
as
  l_returnvalue t_point;
begin
 
  /* Purpose: get point from degree Remarks: Who Date описание ------ ---------- -------------------------------- MBR 05.02.2011 Created */
  
  l_returnvalue.longitude := gis_util_pkg.get_ecliptic_degree (p_longitude, p_longitude_direction);
  l_returnvalue.latitude := gis_util_pkg.get_ecliptic_degree (p_latitude, p_latitude_direction);
  l_returnvalue.name := substr(p_name,1,255);
 
  return l_returnvalue;

end get_point;


/**
Процедура debug_geocode
@param p_address - параметр типа varchar2
*/
procedure debug_geocode (p_address in varchar2)
as
  l_geo sdo_geometry;
begin

  /* Purpose: get geocode and print it Remarks: Who Date описание ------ ---------- -------------------------------- MBR 01.01.2008 Created */

  l_geo := get_geocode (p_address);

  debug_pkg.printf ('x = %1, y = %2', l_geo.sdo_point.x, l_geo.sdo_point.y);

end debug_geocode;


end google_maps_pkg;
/

