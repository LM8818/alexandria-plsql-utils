create or replace package amazon_aws_auth_pkg
as

  /* Purpose: PL/SQL wrapper пакет for Amazon AWS authentication API Remarks: inspired by the whitepaper "Building an Amazon S3 Client with Application Express 4.0" by Jason Straub see http://jastraub.blogspot.com/2011/01/building-amazon-s3-client-with.html dependencies: owner of this пакет needs execute on dbms_crypto Who Date описание ------ ---------- ------------------------------------- MBR 09.01.2011 Created */

  -- get "Authorization" (actually authentication) header string
/**
Функция get_auth_string
@param p_string - параметр типа varchar2
*/
  function get_auth_string (p_string in varchar2) return varchar2;

  -- get signature string
/**
Функция get_signature
@param p_string - параметр типа varchar2
*/
  function get_signature (p_string in varchar2) return varchar2;

  -- get AWS access key ID
  function get_aws_id return varchar2;

  -- get date string
/**
Функция get_date_string
@param p_date - параметр типа date
*/
  function get_date_string (p_date in date := sysdate) return varchar2;

  -- get epoch (number of seconds since January 1, 1970)
/**
Функция get_epoch
@param p_date - параметр типа date
*/
  function get_epoch (p_date in date) return number;

  -- set AWS access key id
/**
Процедура set_aws_id
@param p_aws_id - параметр типа varchar2
*/
  procedure set_aws_id (p_aws_id in varchar2);

  -- set AWS secret key
/**
Процедура set_aws_key
@param p_aws_key - параметр типа varchar2
*/
  procedure set_aws_key (p_aws_key in varchar2);

  -- set GMT offset
/**
Процедура set_gmt_offset
@param p_gmt_offset - параметр типа number
*/
  procedure set_gmt_offset (p_gmt_offset in number);

  -- initialize package for use
  procedure init (p_aws_id in varchar2,
                  p_aws_key in varchar2,
                  p_gmt_offset in number := NULL);

end amazon_aws_auth_pkg;
/

create or replace package body amazon_aws_auth_pkg
as

  /* Purpose: PL/SQL wrapper пакет for Amazon AWS authentication API Remarks: inspired by the whitepaper "Building an Amazon S3 Client with Application Express 4.0" by Jason Straub see http://jastraub.blogspot.com/2011/01/building-amazon-s3-client-with.html Who Date описание ------ ---------- ------------------------------------- MBR 09.01.2011 Created */

  g_aws_id                 varchar2(20) := 'my_aws_id'; -- AWS access key ID
  g_aws_key                varchar2(40) := 'my_aws_key'; -- AWS secret key

  g_gmt_offset             number := NULL; -- your timezone GMT adjustment


/**
Функция get_auth_string
@param p_string - параметр типа varchar2
*/
function get_auth_string (p_string in varchar2) return varchar2
as
 l_returnvalue      varchar2(32000);
 l_encrypted_raw    raw (2000);             -- stores encrypted binary text
 l_decrypted_raw    raw (2000);             -- stores decrypted binary text
 l_key_bytes_raw    raw (64);               -- stores 256-bit encryption key
begin

  /* Purpose: get authentication string Remarks: see http://docs.amazonwebservices.com/AmazonS3/latest/dev/RESTAuthentication.html#ConstructingTheAuthenticationHeader Who Date описание ------ ---------- ------------------------------------- MBR 09.01.2011 Created */

  l_key_bytes_raw := utl_i18n.string_to_raw (g_aws_key,  'AL32UTF8');
  l_decrypted_raw := utl_i18n.string_to_raw (p_string, 'AL32UTF8');

  l_encrypted_raw := dbms_crypto.mac (src => l_decrypted_raw, typ => dbms_crypto.hmac_sh1, key => l_key_bytes_raw);

  l_returnvalue := utl_i18n.raw_to_char (utl_encode.base64_encode(l_encrypted_raw), 'AL32UTF8');

  l_returnvalue := 'AWS ' || g_aws_id || ':' || l_returnvalue;

  return l_returnvalue;

end get_auth_string;


/**
Функция get_signature
@param p_string - параметр типа varchar2
*/
function get_signature (p_string in varchar2) return varchar2
as

begin

  /* Purpose: get signature part of authentication string Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 09.01.2011 Created */

  return substr(get_auth_string(p_string),26);

end get_signature;


function get_aws_id return varchar2
as
begin

  /* Purpose: get AWS access key ID Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 09.01.2011 Created */

  return g_aws_id;

end get_aws_id;


/**
Функция get_date_string
@param p_date - параметр типа date
*/
function get_date_string (p_date in date := sysdate) return varchar2
as
  l_returnvalue varchar2(255);
  l_date_as_time timestamp(6);
  l_time_utc timestamp(6);
begin

  /* Purpose: get AWS access key ID Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 09.01.2011 Created */

  if g_gmt_offset is null then
    l_date_as_time := cast(p_date as timestamp);
    l_time_utc := sys_extract_utc(l_date_as_time);
    l_returnvalue := to_char(l_time_utc, 'Dy, DD Mon YYYY HH24:MI:SS', 'NLS_DATE_LANGUAGE = AMERICAN') || ' GMT';
  else
    l_returnvalue := to_char(p_date + g_gmt_offset/24, 'Dy, DD Mon YYYY HH24:MI:SS', 'NLS_DATE_LANGUAGE = AMERICAN') || ' GMT';
  end if;

  return l_returnvalue;

end get_date_string;


/**
Функция get_epoch
@param p_date - параметр типа date
*/
function get_epoch (p_date in date) return number
as
  l_returnvalue number;
begin

  /* Purpose: get epoch (number of seconds since January 1, 1970) Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 09.01.2011 Created */

  l_returnvalue := trunc((p_date - to_date('01-01-1970','MM-DD-YYYY')) * 24 * 60 * 60);

  return l_returnvalue;

end get_epoch;


/**
Процедура set_aws_id
@param p_aws_id - параметр типа varchar2
*/
procedure set_aws_id (p_aws_id in varchar2)
as
begin

  /* Purpose: set AWS access key id Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 18.01.2011 Created */

  g_aws_id := p_aws_id;


end set_aws_id;


/**
Процедура set_aws_key
@param p_aws_key - параметр типа varchar2
*/
procedure set_aws_key (p_aws_key in varchar2)
as
begin

  /* Purpose: set AWS secret key Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 18.01.2011 Created */

  g_aws_key := p_aws_key;

end set_aws_key;


/**
Процедура set_gmt_offset
@param p_gmt_offset - параметр типа number
*/
procedure set_gmt_offset (p_gmt_offset in number)
as
begin

  /* Purpose: set GMT offset Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 03.03.2011 Created */

  g_gmt_offset := p_gmt_offset;

end set_gmt_offset;


procedure init (p_aws_id in varchar2,
                p_aws_key in varchar2,
                p_gmt_offset in number := NULL)
as
begin

  /* Purpose: initialize пакет for use Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 03.03.2011 Created */

  g_aws_id := p_aws_id;
  g_aws_key := p_aws_key;
  g_gmt_offset := p_gmt_offset;

end init;

end amazon_aws_auth_pkg;
/
