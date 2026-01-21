create or replace type t_soap_envelope as object (

  /* Purpose: Object type to handle SOAP envelopes for web service calls Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 17.02.2009 Created MBR 11.05.2011 Added request start date, support for clob parameters */

  -- public properties
  service_namespace       varchar2(255),
  service_method          varchar2(4000),
  service_host            varchar2(4000),
  service_path            varchar2(4000),
  service_url             varchar2(4000),
  soap_action             varchar2(4000),
  soap_namespace          varchar2(255),
  request_start_date      date,
  envelope                clob,
  
  -- private properties
  m_parameters            clob,
  
  /**
  Конструктор SOAP конверта для веб-сервисов
  @param p_service_host - хост веб-сервиса
  @param p_service_path - путь к веб-сервису
  @param p_service_method - метод веб-сервиса
  @param p_service_namespace - пространство имен сервиса
  @param p_soap_namespace - пространство имен SOAP
  @param p_soap_action - SOAP действие
  */
  constructor function t_soap_envelope (p_service_host in varchar2,
                                        p_service_path in varchar2,
                                        p_service_method in varchar2,
                                        p_service_namespace in varchar2 := null,
                                        p_soap_namespace in varchar2 := null,
                                        p_soap_action in varchar2 := null) return self as result,
  
  /**
  Добавляет строковый параметр в SOAP запрос
  @param p_name - имя параметра
  @param p_value - значение параметра
  @param p_type - тип параметра
  */
  member procedure add_param (p_name in varchar2,
                              p_value in varchar2,
                              p_type in varchar2 := null),
                                  
  /**
  Добавляет CLOB параметр в SOAP запрос
  @param p_name - имя параметра
  @param p_value - CLOB значение параметра
  @param p_type - тип параметра
  */
  member procedure add_param_clob (p_name in varchar2,
                                   p_value in clob,
                                   p_type in varchar2 := null),

  /**
  Добавляет XML данные в SOAP запрос
  @param p_xml - XML данные для добавления
  */
  member procedure add_xml (p_xml in clob),

  /**
  Строит SOAP конверт из добавленных параметров
  */
  member procedure build_env,
  
  /**
  Выводит отладочную информацию о SOAP конверте
  */
  member procedure debug_envelope
  
  ); 
/
create or replace type body t_soap_envelope
as
  
  /* Purpose: Object type to handle SOAP envelopes for web service calls Remarks: Who Date описание ------ ---------- ------------------------------------- MBR 17.02.2009 Created */

  -- see http://thinkoracle.blogspot.com/2005/06/oop-in-plsql-yep.html
  -- see http://plsql-object-types.blogspot.com/  

  /* All methods in an object type accept an instance of that type as their first parameter. The name of this built-in параметр is SELF. Whether declared implicitly or explicitly, SELF is always the first параметр passed to a method. In member functions, if SELF is not declared, its параметр mode defaults to IN. However, in member procedures, if SELF is not declared, its параметр mode defaults to IN OUT. */

  constructor function t_soap_envelope (p_service_host in varchar2,
                                        p_service_path in varchar2,
                                        p_service_method in varchar2,
                                        p_service_namespace in varchar2 := null,
                                        p_soap_namespace in varchar2 := null,
                                        p_soap_action in varchar2 := null) return self as result
  as
  begin
    self.request_start_date := sysdate;
    self.service_host := p_service_host;
    self.service_path := p_service_path;
    self.service_method := p_service_method;
    self.service_namespace := nvl(p_service_namespace, 'xmlns="' || p_service_host || '/"');
    self.service_url := p_service_host || '/' || p_service_path;
    self.soap_namespace := nvl(p_soap_namespace, 'soap');
    self.soap_action := nvl(p_soap_action, p_service_host || '/' || p_service_method);
    self.envelope := '';
    build_env;
    return;
  end;


  member procedure add_param (p_name in varchar2,
                              p_value in varchar2,
                              p_type in varchar2 := null)
  as
  begin
    
    if p_type is null then
      m_parameters := m_parameters || chr(13) || '  <' || p_name || '>' || p_value || '</' || p_name || '>';
    else
      m_parameters := m_parameters || chr(13) || '  <' || p_name || ' xsi:type="' || p_type || '">' || p_value || '</' || p_name || '>';
    end if;
    build_env;
  
  end add_param;
  

  member procedure add_param_clob (p_name in varchar2,
                                   p_value in clob,
                                   p_type in varchar2 := null)
  as
  begin
    
    if p_type is null then
      m_parameters := m_parameters || chr(13) || '  <' || p_name || '>' || p_value || '</' || p_name || '>';
    else
      m_parameters := m_parameters || chr(13) || '  <' || p_name || ' xsi:type="' || p_type || '">' || p_value || '</' || p_name || '>';
    end if;
    build_env;
  
  end add_param_clob;


  member procedure add_xml (p_xml in clob)
  as
  begin
    
    m_parameters := m_parameters || chr(13) || p_xml;
    build_env;
  
  end add_xml;


  member procedure build_env (self in out t_soap_envelope)
  as
  begin
    
    self.envelope := '<' || self.soap_namespace || ':Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:' || self.soap_namespace || '="http://schemas.xmlsoap.org/soap/envelope/">' ||
             '<' || self.soap_namespace || ':Body>' ||
               '<' || self.service_method || ' ' || self.service_namespace || '>' ||
                   self.m_parameters || chr(13) ||
               '</' || self.service_method || '>' ||
             '</' || self.soap_namespace || ':Body>' ||
           '</' || self.soap_namespace || ':Envelope>';    
          
  end build_env;


  member procedure debug_envelope
  as
    i      pls_integer;
    l_len  pls_integer;
  begin
    
    if envelope is not null then
    
      i := 1; l_len := length(envelope);
      
      while (i <= l_len) loop
        dbms_output.put_line(substr(envelope, i, 32000));
        i := i + 32000;
      end loop;
      
    else
      dbms_output.put_line ('WARNING: The envelope is empty...');
    end if;
  
  
  end debug_envelope;

end;
/

