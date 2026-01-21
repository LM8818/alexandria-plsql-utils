create or replace package google_translate_pkg
as

  /* Purpose: PL/SQL wrapper пакет for Google Translate API Remarks: see http://code.google.com/apis/ajaxlanguage/documentation/ Who Date описание ------ ---------- ------------------------------------- MBR 25.12.2009 Created */

  -- http://code.google.com/apis/ajaxlanguage/documentation/reference.html#LangNameArray
  g_lang_AFRIKAANS               constant varchar2(5) := 'af';
  g_lang_ALBANIAN                constant varchar2(5) := 'sq';
  g_lang_AMHARIC                 constant varchar2(5) := 'am';
  g_lang_ARABIC                  constant varchar2(5) := 'ar';
  g_lang_ARMENIAN                constant varchar2(5) := 'hy';
  g_lang_AZERBAIJANI             constant varchar2(5) := 'az';
  g_lang_BASQUE                  constant varchar2(5) := 'eu';
  g_lang_BELARUSIAN              constant varchar2(5) := 'be';
  g_lang_BENGALI                 constant varchar2(5) := 'bn';
  g_lang_BIHARI                  constant varchar2(5) := 'bh';
  g_lang_BULGARIAN               constant varchar2(5) := 'bg';
  g_lang_BURMESE                 constant varchar2(5) := 'my';
  g_lang_CATALAN                 constant varchar2(5) := 'ca';
  g_lang_CHEROKEE                constant varchar2(5) := 'chr';
  g_lang_CHINESE                 constant varchar2(5) := 'zh';
  g_lang_CHINESE_SIMPLIFIED      constant varchar2(5) := 'zh-CN';
  g_lang_CHINESE_TRADITIONAL     constant varchar2(5) := 'zh-TW';
  g_lang_CROATIAN                constant varchar2(5) := 'hr';
  g_lang_CZECH                   constant varchar2(5) := 'cs';
  g_lang_DANISH                  constant varchar2(5) := 'da';
  g_lang_DHIVEHI                 constant varchar2(5) := 'dv';
  g_lang_DUTCH                   constant varchar2(5) := 'nl';  
  g_lang_ENGLISH                 constant varchar2(5) := 'en';
  g_lang_ESPERANTO               constant varchar2(5) := 'eo';
  g_lang_ESTONIAN                constant varchar2(5) := 'et';
  g_lang_FILIPINO                constant varchar2(5) := 'tl';
  g_lang_FINNISH                 constant varchar2(5) := 'fi';
  g_lang_FRENCH                  constant varchar2(5) := 'fr';
  g_lang_GALICIAN                constant varchar2(5) := 'gl';
  g_lang_GEORGIAN                constant varchar2(5) := 'ka';
  g_lang_GERMAN                  constant varchar2(5) := 'de';
  g_lang_GREEK                   constant varchar2(5) := 'el';
  g_lang_GUARANI                 constant varchar2(5) := 'gn';
  g_lang_GUJARATI                constant varchar2(5) := 'gu';
  g_lang_HEBREW                  constant varchar2(5) := 'iw';
  g_lang_HINDI                   constant varchar2(5) := 'hi';
  g_lang_HUNGARIAN               constant varchar2(5) := 'hu';
  g_lang_ICELANDIC               constant varchar2(5) := 'is';
  g_lang_INDONESIAN              constant varchar2(5) := 'id';
  g_lang_INUKTITUT               constant varchar2(5) := 'iu';
  g_lang_IRISH                   constant varchar2(5) := 'ga';
  g_lang_ITALIAN                 constant varchar2(5) := 'it';
  g_lang_JAPANESE                constant varchar2(5) := 'ja';
  g_lang_KANNADA                 constant varchar2(5) := 'kn';
  g_lang_KAZAKH                  constant varchar2(5) := 'kk';
  g_lang_KHMER                   constant varchar2(5) := 'km';
  g_lang_KOREAN                  constant varchar2(5) := 'ko';
  g_lang_KURDISH                 constant varchar2(5) := 'ku';
  g_lang_KYRGYZ                  constant varchar2(5) := 'ky';
  g_lang_LAOTHIAN                constant varchar2(5) := 'lo';
  g_lang_LATVIAN                 constant varchar2(5) := 'lv';
  g_lang_LITHUANIAN              constant varchar2(5) := 'lt';
  g_lang_MACEDONIAN              constant varchar2(5) := 'mk';
  g_lang_MALAY                   constant varchar2(5) := 'ms';
  g_lang_MALAYALAM               constant varchar2(5) := 'ml';
  g_lang_MALTESE                 constant varchar2(5) := 'mt';
  g_lang_MARATHI                 constant varchar2(5) := 'mr';
  g_lang_MONGOLIAN               constant varchar2(5) := 'mn';
  g_lang_NEPALI                  constant varchar2(5) := 'ne';
  g_lang_NORWEGIAN               constant varchar2(5) := 'no';
  g_lang_ORIYA                   constant varchar2(5) := 'or';
  g_lang_PASHTO                  constant varchar2(5) := 'ps';
  g_lang_PERSIAN                 constant varchar2(5) := 'fa';
  g_lang_POLISH                  constant varchar2(5) := 'pl';
  g_lang_PORTUGUESE              constant varchar2(5) := 'pt-PT';
  g_lang_PUNJABI                 constant varchar2(5) := 'pa';
  g_lang_ROMANIAN                constant varchar2(5) := 'ro';
  g_lang_RUSSIAN                 constant varchar2(5) := 'ru';
  g_lang_SANSKRIT                constant varchar2(5) := 'sa';
  g_lang_SERBIAN                 constant varchar2(5) := 'sr';
  g_lang_SINDHI                  constant varchar2(5) := 'sd';
  g_lang_SINHALESE               constant varchar2(5) := 'si';
  g_lang_SLOVAK                  constant varchar2(5) := 'sk';
  g_lang_SLOVENIAN               constant varchar2(5) := 'sl';
  g_lang_SPANISH                 constant varchar2(5) := 'es';
  g_lang_SWAHILI                 constant varchar2(5) := 'sw';
  g_lang_SWEDISH                 constant varchar2(5) := 'sv';
  g_lang_TAJIK                   constant varchar2(5) := 'tg';
  g_lang_TAMIL                   constant varchar2(5) := 'ta';
  g_lang_TAGALOG                 constant varchar2(5) := 'tl';
  g_lang_TELUGU                  constant varchar2(5) := 'te';
  g_lang_THAI                    constant varchar2(5) := 'th';
  g_lang_TIBETAN                 constant varchar2(5) := 'bo';
  g_lang_TURKISH                 constant varchar2(5) := 'tr';
  g_lang_UKRAINIAN               constant varchar2(5) := 'uk';
  g_lang_URDU                    constant varchar2(5) := 'ur';
  g_lang_UZBEK                   constant varchar2(5) := 'uz';
  g_lang_UIGHUR                  constant varchar2(5) := 'ug';
  g_lang_VIETNAMESE              constant varchar2(5) := 'vi';
  g_lang_WELSH                   constant varchar2(5) := 'cy';
  g_lang_YIDDISH                 constant varchar2(5) := 'yi';
  g_lang_UNKNOWN                 constant varchar2(5) := '';


  -- translate a piece of text
  function translate_text (p_text in varchar2,
                           p_to_lang in varchar2,
                           p_from_lang in varchar2 := null,
                           p_use_cache in varchar2 := 'YES') return varchar2;

  -- detect language code for text
/**
Функция detect_lang
@param p_text - параметр типа varchar2
*/
  function detect_lang (p_text in varchar2) return varchar2;
  
  -- get number of texts in cache
  function get_translation_cache_count return number;
  
  -- clear translation cache
  procedure clear_translation_cache;

end google_translate_pkg;
/


create or replace package body google_translate_pkg
as

  /* Purpose: PL/SQL wrapper пакет for Google Translate API Remarks: see http://code.google.com/apis/ajaxlanguage/documentation/ Who Date описание ------ ---------- ------------------------------------- MBR 25.12.2009 Created */

  m_http_referrer                constant varchar2(255) := 'your-domain-name-or-website-here'; -- insert your domain/website here (required by Google's terms of use)
  m_api_key                      constant varchar2(255) := null; -- insert your Google API Key here (optional but recommended)

  m_service_url                  constant varchar2(255) := 'http://ajax.googleapis.com/ajax/services/language/';
  m_service_version              constant varchar2(10)  := '1.0';
  
  m_max_text_size                constant pls_integer   := 500; -- can be increased up towards 32k, the cache name size (below) must be increased accordingly 
  
  type t_translation_cache is table of varchar2(32000) index by varchar2(550);
  
  m_translation_cache            t_translation_cache;
  m_cache_id_separator           constant varchar2(1) := '|';


procedure add_to_cache (p_from_text in varchar2,
                        p_from_lang in varchar2,
                        p_to_text in varchar2,
                        p_to_lang in varchar2)
as
begin

  /* Purpose: add translation to cache Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 25.12.2009 Created */

  m_translation_cache (p_from_lang || m_cache_id_separator || p_to_lang || m_cache_id_separator || replace(substr(p_from_text,1,m_max_text_size), m_cache_id_separator, '')) := p_to_text;

end add_to_cache;
  

function get_from_cache (p_text in varchar2,
                         p_from_lang in varchar2,
                         p_to_lang in varchar2) return varchar2
as
  l_returnvalue varchar2(32000);
begin

  /* Purpose: get translation from cache Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 25.12.2009 Created */

  begin
    l_returnvalue := m_translation_cache (p_from_lang || m_cache_id_separator || p_to_lang || m_cache_id_separator || replace(substr(p_text,1,m_max_text_size), m_cache_id_separator, ''));
  exception
    when no_data_found then
      l_returnvalue := null;
  end;
  
  return l_returnvalue;

end get_from_cache;


function get_clob_from_http_post (p_url in varchar2,
                                  p_values in varchar2) return clob
as
  l_request     utl_http.req;
  l_response    utl_http.resp;
  l_buffer      varchar2(32767);
  l_returnvalue clob := ' ';
begin

  /* Purpose: do a HTTP POST and get results back in a CLOB Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 25.12.2009 Created */

  l_request := utl_http.begin_request (p_url, 'POST', utl_http.http_version_1_1);

  utl_http.set_header (l_request, 'Referer', m_http_referrer); -- note that the actual header name is misspelled in the HTTP protocol
  utl_http.set_header (l_request, 'Content-Type', 'application/x-www-form-urlencoded');
  utl_http.set_header (l_request, 'Content-Length', to_char(length(p_values)));
  utl_http.write_text (l_request, p_values);
  
  l_response := utl_http.get_response (l_request);
  
  if l_response.status_code = utl_http.http_ok then
  
    begin
      loop
        utl_http.read_text (l_response, l_buffer);
        dbms_lob.writeappend (l_returnvalue, length(l_buffer), l_buffer);
      end loop;
    exception
      when utl_http.end_of_body then
        null;
    end;
    
  end if;
  
  utl_http.end_response (l_response);

  return l_returnvalue;

end get_clob_from_http_post;


function translate_text (p_text in varchar2,
                         p_to_lang in varchar2,
                         p_from_lang in varchar2 := null,
                         p_use_cache in varchar2 := 'YES') return varchar2
as
  l_values      varchar2(2000);
  l_response    clob;
  l_start_pos   pls_integer;
  l_end_pos     pls_integer;
  l_returnvalue varchar2(32000) := null;
begin

  /* Purpose: translate a piece of text Remarks: if the "from" language is left blank, Google Translate will attempt to autodetect the language Who Date описание ------ ---------- ------------------------------------- MBR 25.12.2009 Created MBR 25.12.2009 Added cache for translations */

  if trim(p_text) is not null then

    if p_use_cache = 'YES' then
      l_returnvalue := get_from_cache (p_text, p_from_lang, p_to_lang);
    end if;

    if l_returnvalue is null then
    
      l_values := 'v=' || m_service_version || '&q=' || utl_url.escape (substr(p_text,1,m_max_text_size), false, 'UTF8') || '&langpair=' || p_from_lang || '|' || p_to_lang;
      
      if m_api_key is not null then
        l_values := l_values || '&key=' || m_api_key;
      end if;
      
      l_response := get_clob_from_http_post (m_service_url || 'translate', l_values);
      
      if l_response is not null then

        l_start_pos := instr(l_response, '{"translatedText":"');
        l_start_pos := l_start_pos + 19;
        l_end_pos := instr(l_response, '"', l_start_pos);
        
        l_returnvalue := substr(l_response, l_start_pos, l_end_pos - l_start_pos);
        
        if (p_use_cache = 'YES') and (l_returnvalue is not null) then
          add_to_cache (p_text, p_from_lang, l_returnvalue, p_to_lang);
        end if;
        
      end if;

    end if;
    
  end if;
  
  return l_returnvalue;

end translate_text;


/**
Функция detect_lang
@param p_text - параметр типа varchar2
*/
function detect_lang (p_text in varchar2) return varchar2
as
  l_url         varchar2(2000);
  l_response    clob;
  l_start_pos   pls_integer;
  l_end_pos     pls_integer;
  l_returnvalue varchar2(255);
begin

  /* Purpose: detect language code for text Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 25.12.2009 Created */

  if trim(p_text) is not null then
  
    l_url := m_service_url || 'detect?v=' || m_service_version || '&q=' || utl_url.escape (substr(p_text,1,m_max_text_size), false, 'UTF8');
        
    if m_api_key is not null then
      l_url := l_url || '&key=' || m_api_key;
    end if;
    
    l_response := httpuritype(l_url).getclob();

    l_start_pos := instr(l_response, '{"language":"');
    l_start_pos := l_start_pos + 13;
    l_end_pos := instr(l_response, '",', l_start_pos);
    
    l_returnvalue := substr(l_response, l_start_pos, l_end_pos - l_start_pos);
    
  end if;
  
  return l_returnvalue;

end detect_lang;


function get_translation_cache_count return number
as
  l_returnvalue number;
begin

  /* Purpose: get number of texts in cache Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 25.12.2009 Created */

  l_returnvalue := m_translation_cache.count;
  
  return l_returnvalue;

end get_translation_cache_count;


procedure clear_translation_cache
as
begin

  /* Purpose: clear translation cache Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 25.12.2009 Created */
  
  m_translation_cache.delete;

end clear_translation_cache;


end google_translate_pkg;
/

