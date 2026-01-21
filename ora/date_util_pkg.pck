CCREATE OR REPLACE package date_util_pkg
as
  -- Пакет для работы с датами и временем в Oracle.
  -- Поддерживает расчет периодов, количества дней, кварталов и форматирование.
  -- @purpose Пакет handles functionality related to date and time calculations and formatting
  -- @remarks Who Date описание - 19.09.2006 Created 

  
  /** Стандартный формат даты: dd.mm.yyyy */
  g_date_fmt_date                constant varchar2(30) := 'dd.mm.yyyy';
  /** Формат даты и времени до минут: dd.mm.yyyy hh24:mi */
  g_date_fmt_date_hour_min       constant varchar2(30) := 'dd.mm.yyyy hh24:mi';
  /** Полный формат даты и времени: dd.mm.yyyy hh24:mi:ss */
  g_date_fmt_date_hour_min_sec   constant varchar2(30) := 'dd.mm.yyyy hh24:mi:ss';

  g_months_in_quarter            constant number := 3;
  g_months_in_year               constant number := 12;

  type t_period_date is record (
    year           number,
    month          number,
    day            number,
    days_in_month  number,
    the_date       date
  );
  
  type t_period_date_tab is table of t_period_date;

  /**
   * Извлекает числовой год из переданной даты.
   * @param p_date - дата для извлечения года
   * @return Числовой год (например, 2024)
   */
  function get_year (p_date in date) return number;
  
  /**
   * Извлекает номер месяца из даты.
   * @param p_date - дата для извлечения месяца
   * @return Номер месяца от 1 до 12
   */
  function get_month (p_date in date) return number;
  
  /**
   * Возвращает начальную дату года на основе переданной даты (01.01.YYYY).
   * @param p_date - дата для определения целевого года
   * @return Первое число года (начало года)
   */
  function get_start_date_year (p_date in date) return date;
  
  /**
   * Возвращает начальную дату года по номеру года.
   * @param p_year - числовой номер года (например, 2026)
   * @return Первое января указанного года (01.01.YYYY)
   */
  function get_start_date_year (p_year in number) return date;

  /**
   * Возвращает конечную дату года на основе переданной даты (31.12.YYYY).
   * @param p_date - дата для определения целевого года
   * @return Последний день года (конец года)
   */
  function get_end_date_year (p_date in date) return date;
  
  /**
   * Возвращает последнюю дату года по номеру года.
   * @param p_year - номер года
   * @return 31 декабря указанного года
   */
  function get_end_date_year (p_year in number) return date;

  /**
   * Возвращает начальную дату месяца (первое число) на основе даты.
   * @param p_date - исходная дата
   * @return Первое число текущего месяца
   */
  function get_start_date_month (p_date in date) return date;
  
  /**
   * Возвращает начальную дату месяца по году и месяцу.
   * @param p_year - год
   * @param p_month - месяц
   * @return Дата первого числа указанного месяца
   */
  function get_start_date_month (p_year in number,
                                 p_month in number) return date;  
                                
  /**
   * Возвращает конечную дату месяца (последнее число) на основе даты.
   * @param p_date - исходная дата
   * @return Последнее число текущего месяца
   */
  function get_end_date_month (p_date in date) return date;
  
  /**
   * Возвращает конечную дату месяца по году и месяцу.
   * @param p_year - год
   * @param p_month - месяц
   * @return Дата последнего числа указанного месяца
   */
  function get_end_date_month (p_year in number,
                               p_month in number) return date;

  /**
   * Возвращает расчет количества дней в месяце.
   * @param p_year - год
   * @param p_month - месяц
   * @return Количество дней (28-31)
   */
  function get_days_in_month (p_year in number,
                              p_month in number) return number;

  /**
   * Выполняет расчет количества дней в периоде между двумя датами.
   * Учитывает пересечение двух временных интервалов.
   * @param p_from_date_1 - начало первого периода
   * @param p_to_date_1 - конец первого периода
   * @param p_from_date_2 - начало второго периода
   * @param p_to_date_2 - конец второго периода
   * @return Количество полных дней пересечения
   */
  function get_days_in_period (p_from_date_1 in date,
                               p_to_date_1 in date,
                               p_from_date_2 in date,
                               p_to_date_2 in date) return number;

  /**
   * Проверяет, попадает ли указанный месяц в заданный диапазон лет и месяцев.
   * @return TRUE если период внутри диапазона
   */
  function is_period_in_range (p_year in number,
                               p_month in number,
                               p_from_year in number,
                               p_from_month in number,
                               p_to_year in number,
                               p_to_month in number) return boolean;
                               
  /**
   * Определяет номер квартала года по номеру месяца.
   * @param p_month - номер месяца (1-12)
   * @return Номер квартала (1-4)
   */
  function get_quarter (p_month in number) return number;
  
  /**
   * Форматирует временной интервал (дни) в читаемую строку.
   * @param p_days - количество дней (дробное число)
   * @return Строка вида 'X days, Y hours, Z minutes'
   */
  function fmt_time (p_days in number) return varchar2;
  
  /**
   * Вычисляет разницу во времени между датами и форматирует её.
   * @param p_from_date - дата начала
   * @param p_to_date - дата окончания
   */
  function fmt_time (p_from_date in date,
                     p_to_date in date) return varchar2;
                     
  /**
   * Выполняет форматирование даты в строку dd.mm.yyyy.
   * @param p_date - дата для преобразования
   * @return Строка в формате dd.mm.yyyy
   */
  function fmt_date (p_date in date) return varchar2;

  /**
   * Форматирует дату и время в строку dd.mm.yyyy hh24:mi.
   * @param p_date - дата и время
   */
  function fmt_datetime (p_date in date) return varchar2;
  
  /**
   * Возвращает общее количество дней в году (365 или 366).
   * @param p_year - номер года
   */
  function get_days_in_year (p_year in number) return number;

  /**
   * Разворачивает месяц в таблицу дат.
   * @return Pipe-таблица с деталями каждого дня месяца
   */
  function explode_month (p_year in number,
                          p_month in number) return t_period_date_tab pipelined;

  function get_date_tab (p_calendar_string in varchar2,
                         p_from_date in date := null,
                         p_to_date in date := null) return t_date_array pipelined;

end date_util_pkg;
