CREATE OR REPLACE PACKAGE huge_validation_pkg AS
    /* Purpose: Огромный пакет для тестирования производительности системы */
    
    -- Константы для валидации
    g_version CONSTANT VARCHAR2(10) := '3.0.0';
    g_max_items CONSTANT PLS_INTEGER := 10000;
    g_default_timeout CONSTANT PLS_INTEGER := 30;
    
    -- Типы данных
    TYPE t_validation_result IS RECORD (
        is_valid BOOLEAN,
        error_code NUMBER,
        error_message VARCHAR2(4000)
    );
    
    TYPE t_validation_table IS TABLE OF t_validation_result INDEX BY PLS_INTEGER;
    
    -- Исключения
    e_validation_failed EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_validation_failed, -20001);
    
    e_timeout_exceeded EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_timeout_exceeded, -20002);
    
    -- Функции валидации (генерируем много для тестирования больших файлов)
    FUNCTION validate_email_001(p_email VARCHAR2) RETURN BOOLEAN;
    FUNCTION validate_email_002(p_email VARCHAR2) RETURN BOOLEAN;
    FUNCTION validate_phone_001(p_phone VARCHAR2) RETURN BOOLEAN;
    FUNCTION validate_phone_002(p_phone VARCHAR2) RETURN BOOLEAN;
    FUNCTION validate_date_001(p_date DATE) RETURN BOOLEAN;
    FUNCTION validate_date_002(p_date DATE) RETURN BOOLEAN;
    FUNCTION validate_number_001(p_number NUMBER) RETURN BOOLEAN;
    FUNCTION validate_number_002(p_number NUMBER) RETURN BOOLEAN;
    FUNCTION validate_string_001(p_string VARCHAR2) RETURN BOOLEAN;
    FUNCTION validate_string_002(p_string VARCHAR2) RETURN BOOLEAN;
    FUNCTION validate_url_001(p_url VARCHAR2) RETURN BOOLEAN;
    FUNCTION validate_url_002(p_url VARCHAR2) RETURN BOOLEAN;
    FUNCTION validate_json_001(p_json CLOB) RETURN BOOLEAN;
    FUNCTION validate_json_002(p_json CLOB) RETURN BOOLEAN;
    FUNCTION validate_xml_001(p_xml XMLTYPE) RETURN BOOLEAN;
    FUNCTION validate_xml_002(p_xml XMLTYPE) RETURN BOOLEAN;
    
    -- Процедуры обработки
    PROCEDURE process_validation_batch(p_items t_validation_table);
    PROCEDURE cleanup_validation_cache;
    PROCEDURE reset_validation_counters;
    PROCEDURE log_validation_stats;
    
END huge_validation_pkg;
/

CREATE OR REPLACE PACKAGE BODY huge_validation_pkg AS

    -- Приватные переменные
    g_validation_count PLS_INTEGER := 0;
    g_error_count PLS_INTEGER := 0;
    g_start_time TIMESTAMP := SYSTIMESTAMP;

    FUNCTION validate_email_001(p_email VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        g_validation_count := g_validation_count + 1;
        
        IF p_email IS NULL OR LENGTH(p_email) = 0 THEN
            RETURN FALSE;
        END IF;
        
        -- Проверка базового формата email
        IF NOT REGEXP_LIKE(p_email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN
            RETURN FALSE;
        END IF;
        
        -- Дополнительные проверки
        IF LENGTH(p_email) > 254 THEN
            RETURN FALSE;
        END IF;
        
        IF INSTR(p_email, '..') > 0 OR SUBSTR(p_email, 1, 1) = '.' OR SUBSTR(p_email, -1) = '.' THEN
            RETURN FALSE;
        END IF;
        
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            g_error_count := g_error_count + 1;
            RETURN FALSE;
    END validate_email_001;

    FUNCTION validate_email_002(p_email VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        -- Альтернативная реализация валидации email
        RETURN validate_email_001(p_email) AND INSTR(p_email, '@') = INSTR(p_email, '@', -1);
    END validate_email_002;

    FUNCTION validate_phone_001(p_phone VARCHAR2) RETURN BOOLEAN IS
        l_clean_phone VARCHAR2(20);
    BEGIN
        g_validation_count := g_validation_count + 1;
        
        IF p_phone IS NULL THEN
            RETURN FALSE;
        END IF;
        
        -- Очистка от символов
        l_clean_phone := REGEXP_REPLACE(p_phone, '[^0-9+]', '');
        
        -- Проверка длины
        IF LENGTH(l_clean_phone) < 7 OR LENGTH(l_clean_phone) > 15 THEN
            RETURN FALSE;
        END IF;
        
        -- Проверка формата
        RETURN REGEXP_LIKE(l_clean_phone, '^(\+?[1-9]\d{6,14})$');
    EXCEPTION
        WHEN OTHERS THEN
            g_error_count := g_error_count + 1;
            RETURN FALSE;
    END validate_phone_001;

    FUNCTION validate_phone_002(p_phone VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        -- Расширенная валидация телефона с международными кодами
        RETURN validate_phone_001(p_phone) AND 
               (SUBSTR(p_phone, 1, 1) = '+' OR REGEXP_LIKE(p_phone, '^[0-9]'));
    END validate_phone_002;

    FUNCTION validate_date_001(p_date DATE) RETURN BOOLEAN IS
    BEGIN
        g_validation_count := g_validation_count + 1;
        
        IF p_date IS NULL THEN
            RETURN FALSE;
        END IF;
        
        -- Проверка разумного диапазона дат
        IF p_date < DATE '1900-01-01' OR p_date > DATE '2100-12-31' THEN
            RETURN FALSE;
        END IF;
        
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            g_error_count := g_error_count + 1;
            RETURN FALSE;
    END validate_date_001;

    FUNCTION validate_date_002(p_date DATE) RETURN BOOLEAN IS
    BEGIN
        -- Проверка рабочих дней (понедельник-пятница)
        RETURN validate_date_001(p_date) AND 
               TO_CHAR(p_date, 'D') BETWEEN '2' AND '6';
    END validate_date_002;

    FUNCTION validate_number_001(p_number NUMBER) RETURN BOOLEAN IS
    BEGIN
        g_validation_count := g_validation_count + 1;
        
        IF p_number IS NULL THEN
            RETURN FALSE;
        END IF;
        
        -- Проверка на конечность числа
        IF p_number = p_number / 0 THEN  -- Infinity check
            RETURN FALSE;
        END IF;
        
        -- Проверка разумного диапазона
        IF ABS(p_number) > 1E15 THEN
            RETURN FALSE;
        END IF;
        
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            g_error_count := g_error_count + 1;
            RETURN FALSE;
    END validate_number_001;

    FUNCTION validate_number_002(p_number NUMBER) RETURN BOOLEAN IS
    BEGIN
        -- Валидация положительных чисел
        RETURN validate_number_001(p_number) AND p_number > 0;
    END validate_number_002;

    FUNCTION validate_string_001(p_string VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        g_validation_count := g_validation_count + 1;
        
        IF p_string IS NULL THEN
            RETURN FALSE;
        END IF;
        
        -- Проверка на недопустимые символы
        IF REGEXP_LIKE(p_string, '[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]') THEN
            RETURN FALSE;
        END IF;
        
        -- Проверка длины
        IF LENGTH(p_string) > 4000 THEN
            RETURN FALSE;
        END IF;
        
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            g_error_count := g_error_count + 1;
            RETURN FALSE;
    END validate_string_001;

    FUNCTION validate_string_002(p_string VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        -- Валидация строк только с буквами и цифрами
        RETURN validate_string_001(p_string) AND 
               REGEXP_LIKE(p_string, '^[A-Za-z0-9 ]+$');
    END validate_string_002;

    FUNCTION validate_url_001(p_url VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        g_validation_count := g_validation_count + 1;
        
        IF p_url IS NULL OR LENGTH(p_url) < 7 THEN
            RETURN FALSE;
        END IF;
        
        -- Проверка протокола
        IF NOT REGEXP_LIKE(LOWER(p_url), '^https?://') THEN
            RETURN FALSE;
        END IF;
        
        -- Проверка базовой структуры URL
        IF NOT REGEXP_LIKE(p_url, '^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}') THEN
            RETURN FALSE;
        END IF;
        
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            g_error_count := g_error_count + 1;
            RETURN FALSE;
    END validate_url_001;

    FUNCTION validate_url_002(p_url VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        -- Валидация HTTPS URL
        RETURN validate_url_001(p_url) AND LOWER(p_url) LIKE 'https://%';
    END validate_url_002;

    FUNCTION validate_json_001(p_json CLOB) RETURN BOOLEAN IS
        l_json_obj JSON_OBJECT_T;
    BEGIN
        g_validation_count := g_validation_count + 1;
        
        IF p_json IS NULL OR DBMS_LOB.GETLENGTH(p_json) = 0 THEN
            RETURN FALSE;
        END IF;
        
        -- Попытка парсинга JSON
        l_json_obj := JSON_OBJECT_T.PARSE(p_json);
        
        RETURN l_json_obj IS NOT NULL;
    EXCEPTION
        WHEN OTHERS THEN
            g_error_count := g_error_count + 1;
            RETURN FALSE;
    END validate_json_001;

    FUNCTION validate_json_002(p_json CLOB) RETURN BOOLEAN IS
    BEGIN
        -- Проверка что JSON является объектом (начинается с '{')
        RETURN validate_json_001(p_json) AND 
               TRIM(SUBSTR(p_json, 1, 1)) = '{';
    END validate_json_002;

    FUNCTION validate_xml_001(p_xml XMLTYPE) RETURN BOOLEAN IS
    BEGIN
        g_validation_count := g_validation_count + 1;
        
        IF p_xml IS NULL THEN
            RETURN FALSE;
        END IF;
        
        -- Проверка что XML well-formed
        RETURN p_xml.isSchemaValid() = 1;
    EXCEPTION
        WHEN OTHERS THEN
            g_error_count := g_error_count + 1;
            RETURN FALSE;
    END validate_xml_001;

    FUNCTION validate_xml_002(p_xml XMLTYPE) RETURN BOOLEAN IS
    BEGIN
        -- Проверка что XML содержит корневой элемент
        RETURN validate_xml_001(p_xml) AND 
               p_xml.extract('/*').getStringVal() IS NOT NULL;
    END validate_xml_002;

    PROCEDURE process_validation_batch(p_items t_validation_table) IS
        l_start_time TIMESTAMP := SYSTIMESTAMP;
        l_processed PLS_INTEGER := 0;
    BEGIN
        FOR i IN 1..p_items.COUNT LOOP
            -- Обработка каждого элемента
            l_processed := l_processed + 1;
            
            -- Проверка таймаута
            IF EXTRACT(SECOND FROM (SYSTIMESTAMP - l_start_time)) > g_default_timeout THEN
                RAISE e_timeout_exceeded;
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('Обработано элементов: ' || l_processed);
    EXCEPTION
        WHEN e_timeout_exceeded THEN
            RAISE_APPLICATION_ERROR(-20002, 'Превышен таймаут обработки');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20999, 'Ошибка обработки batch: ' || SQLERRM);
    END process_validation_batch;

    PROCEDURE cleanup_validation_cache IS
    BEGIN
        -- Очистка кэша валидации
        g_validation_count := 0;
        g_error_count := 0;
        g_start_time := SYSTIMESTAMP;
        
        DBMS_OUTPUT.PUT_LINE('Кэш валидации очищен');
    END cleanup_validation_cache;

    PROCEDURE reset_validation_counters IS
    BEGIN
        g_validation_count := 0;
        g_error_count := 0;
        DBMS_OUTPUT.PUT_LINE('Счетчики валидации сброшены');
    END reset_validation_counters;

    PROCEDURE log_validation_stats IS
        l_duration_sec NUMBER;
    BEGIN
        l_duration_sec := EXTRACT(SECOND FROM (SYSTIMESTAMP - g_start_time));
        
        DBMS_OUTPUT.PUT_LINE('=== Статистика валидации ===');
        DBMS_OUTPUT.PUT_LINE('Всего валидаций: ' || g_validation_count);
        DBMS_OUTPUT.PUT_LINE('Ошибок: ' || g_error_count);
        DBMS_OUTPUT.PUT_LINE('Время работы: ' || l_duration_sec || ' сек');
        
        IF l_duration_sec > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Скорость: ' || ROUND(g_validation_count / l_duration_sec, 2) || ' валидаций/сек');
        END IF;
    END log_validation_stats;

END huge_validation_pkg;
/
