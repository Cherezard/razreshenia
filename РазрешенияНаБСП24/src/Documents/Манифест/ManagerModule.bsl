
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//  Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//           где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы,
//           связанного с реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
		
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	//Реестр экспресс грузов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьРеестрЭкспрессГрузов";
	КомандаПечати.Идентификатор = "РеестрЭкспрессГрузов";
	КомандаПечати.Представление = НСтр("ru = 'Реестр экспресс грузов'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	//Акт перевеса груза
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктПеревесаГруза";
	КомандаПечати.Представление = НСтр("ru = 'Акт перевеса груза'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной
//                                                            параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной
//                                            параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктПеревесаГруза") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "АктПеревесаГруза", НСтр("ru = 'Акт перевеса груза'"), СформироватьПечатнуюФормуАктПеревесаГруза(МассивОбъектов, ОбъектыПечати));
		
	КонецЕсли;

КонецПроцедуры

// Функция получает данные для формирования печатной формы "Счет на оплату"
//
// Параметры:
//	ПараметрыПечати - Структура
//	МассивОбъектов - Массив - Массив ссылок на документы, по которым необходимо получить данные
//
// Возвращаемое значение:
//	Структура - Структура с полями: "РезультатПоШапке", "РезультатПоЭтапамОплаты", "РезультатПоТабличнойЧасти"
//
Функция ПолучитьДанныеДляПечатнойФормыРеестрЭкспрессГрузов(ПараметрыПечати, МассивОбъектов) Экспорт
	
	Возврат ДанныеДляПечатныхФормРеестрЭкспрессГрузов(ПараметрыПечати, МассивОбъектов);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПечатныхФормРеестрЭкспрессГрузов(ПараметрыПечати, МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());    
	Запрос.Текст = "ВЫБРАТЬ
	               |	Манифест.Ссылка КАК ДокументСсылка,
	               |	Манифест.Номер,
	               |	Манифест.Дата,
	               |	Манифест.НомерРеестра,
	               |	Манифест.ПодробноеОписаниеОбразцов,
	               |	ВЫБОР
	               |		КОГДА Манифест.КоличествоМест = 0
	               |			ТОГДА """"
	               |		ИНАЧЕ ""МЕСТ:""
	               |	КОНЕЦ КАК ЗаголовокМест,
	               |	ВЫБОР
	               |		КОГДА Манифест.КоличествоМест = 0
	               |			ТОГДА """"
	               |		ИНАЧЕ Манифест.КоличествоМест
	               |	КОНЕЦ КАК КоличествоМест,
	               |	ТаможенныеПосты.НаименованиеПолное КАК ТаможенныйПост,
	               |	ТаможенныеПосты.Код КАК КодПоста,
	               |	ТаможенныеПосты.КодЭкспрессГруза,
	               |	ФизическиеЛица.Наименование КАК СотрудникТаможни,
	               |	ФизическиеЛица.СерияДокумента КАК СерияПаспорта,
	               |	ФизическиеЛица.НомерДокумента КАК НомерПаспорта,
	               |	ФизическиеЛица.ДатаВыдачиДокумента КАК ДатаВыдачиПаспорта,
	               |	Доверенности.Наименование КАК ДоверенностьСотрудникаТаможни
	               |ИЗ
	               |	Документ.Манифест КАК Манифест
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	               |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Доверенности КАК Доверенности
	               |			ПО ФизическиеЛица.Ссылка = Доверенности.Владелец
	               |		ПО Манифест.СотрудникТаможни = ФизическиеЛица.Ссылка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТаможенныеПосты КАК ТаможенныеПосты
	               |		ПО Манифест.ТаможенныйПост = ТаможенныеПосты.Ссылка
	               |ГДЕ
	               |	Манифест.Ссылка В(&МассивОбъектов)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДокументСсылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МанифестОтправления.Ссылка КАК ДокументСсылка,
	               |	МанифестОтправления.Накладная КАК Накладная,
	               |	МанифестОтправления.Накладная.Номер КАК ИндивНомерНакладной,
	               |	МанифестОтправления.Грузоотправитель,
	               |	МанифестОтправления.Грузополучатель,
	               |	МанифестОтправления.Количество КАК КоличествоГруза,
	               |	МанифестОтправления.ВесБрутто,
	               |	МанифестОтправления.ВесНетто,
	               |	МанифестОтправления.ФактурнаяСтоимость,
	               |	МанифестОтправления.ТаможеннаяСтоимость,
	               |	МанифестОтправления.Валюта.Представление КАК Валюта
	               |ИЗ
	               |	Документ.Манифест.Отправления КАК МанифестОтправления
	               |ГДЕ
	               |	МанифестОтправления.Ссылка В(&МассивОбъектов)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДокументСсылка,
	               |	МанифестОтправления.НомерСтроки,
	               |	Накладная
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МанифестОтправления.Ссылка КАК ДокументСсылка,
	               |	НакладныеОбразцы.Ссылка КАК Накладная,
	               |	ВЫБОР
	               |		КОГДА МанифестОтправления.Ссылка.ПодробноеОписаниеОбразцов
	               |			ТОГДА НакладныеОбразцы.Образец
	               |		ИНАЧЕ ""Биообразцы в рамках клинических исследований""
	               |	КОНЕЦ КАК Образец,
	               |	НакладныеОбразцы.Разрешение,
	               |	СУММА(НакладныеОбразцы.Списание) КАК Списание,
	               |	СУММА(ОстаткиПоКвотеОстатки.КоличествоОстаток) КАК КоличествоОстаток
	               |ИЗ
	               |	Документ.Манифест.Отправления КАК МанифестОтправления
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Накладные.Образцы КАК НакладныеОбразцы
	               |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОстаткиПоКвоте.Остатки(&Период, ) КАК ОстаткиПоКвотеОстатки
	               |			ПО НакладныеОбразцы.Образец = ОстаткиПоКвотеОстатки.Образец
	               |				И НакладныеОбразцы.ТипОбразца = ОстаткиПоКвотеОстатки.ТипОбразца
	               |				И НакладныеОбразцы.Разрешение = ОстаткиПоКвотеОстатки.Разрешение
	               |		ПО МанифестОтправления.Накладная = НакладныеОбразцы.Ссылка
	               |ГДЕ
	               |	МанифестОтправления.Ссылка В(&МассивОбъектов)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	НакладныеОбразцы.Ссылка,
	               |	НакладныеОбразцы.Разрешение,
	               |	МанифестОтправления.Ссылка,
	               |	ВЫБОР
	               |		КОГДА МанифестОтправления.Ссылка.ПодробноеОписаниеОбразцов
	               |			ТОГДА НакладныеОбразцы.Образец
	               |		ИНАЧЕ ""Биообразцы в рамках клинических исследований""
	               |	КОНЕЦ
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДокументСсылка,
	               |	Накладная";

	ПакетРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	СтруктураДанныхДляПечати = Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке", ПакетРезультатовЗапроса[0]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоОтправления", ПакетРезультатовЗапроса[1]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти", ПакетРезультатовЗапроса[2]);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

Функция СформироватьПечатнуюФормуАктПеревесаГруза(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
		
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	//Формат
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ТолькоПросмотр = Истина;

	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Манифест_ПФ_MXL_АктПеревесаГруза";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Манифест.ПФ_MXL_АктПеревесаГруза");
	ОбластьЛоготип	= Макет.ПолучитьОбласть("Логотип");
	ОбластьШапка	= Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока	= Макет.ПолучитьОбласть("СтрокаТаблицы");
	ОбластьПодвал	= Макет.ПолучитьОбласть("Подвал");
	
	ПервыйДокумент = Истина;
	Для каждого СтрокаМассива Из МассивОбъектов Цикл
	
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Вывод логотипа.
		ТабличныйДокумент.Вывести(ОбластьЛоготип);
		
		// Вывод шапки.
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		// Вывод строк.
		ТаблицаОтправления = СтрокаМассива.Отправления;
		НомерСтроки	= 0;

		Для каждого СтрокаОтправление Из ТаблицаОтправления Цикл
		
			НомерСтроки = НомерСтроки + 1;
			ОбластьСтрока.Параметры.Заполнить(СтрокаОтправление); 
			ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
			ОбластьСтрока.Параметры.НомерНакладной = СокрЛП(СтрокаОтправление.Накладная.Номер);
			ОбластьСтрока.Параметры.НакладнаяСсылка = СтрокаОтправление.Накладная; 
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
		КонецЦикла; 
		
		// Вывод подписей.
		Если ЗначениеЗаполнено(СтрокаМассива.ПервыйПодписант) Тогда
			ОбластьПодвал.Параметры.ПервыйПодписант = СтрокаМассива.ПервыйПодписант; 
		Иначе
			ОбластьПодвал.Параметры.ПервыйПодписант = "Родин А."; 
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаМассива.ВторойПодписант) Тогда
			ОбластьПодвал.Параметры.ВторойПодписант = СтрокаМассива.ВторойПодписант; 
		Иначе
			ОбластьПодвал.Параметры.ВторойПодписант = "Иванов А."; 
		КонецЕсли;
		ТабличныйДокумент.Вывести(ОбластьПодвал);
				
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, СтрокаМассива);

	КонецЦикла;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли
 
#Область ОбновлениеИнформационнойБазы

Процедура ПерезаполнитьВалютуВДокументах() Экспорт
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	Манифест.Ссылка
	//               |ИЗ
	//               |	Документ.Манифест КАК Манифест";
	//			   
	//Выборка = Запрос.Выполнить().Выбрать();
	//
	//Пока Выборка.Следующий() Цикл

	//	ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();

	//	Для каждого СтрокаТаблицы Из ДокументОбъект.Отправления Цикл
	//		
	//		  СтрокаТаблицы.Валюта = Справочники.Валюты.НайтиПоКоду(СокрЛП(СтрокаТаблицы.УдалитьКодВылюты), Истина);			
	//	
	//	КонецЦикла; 
	//	
	//	ДокументОбъект.Записать();
	//	
	//КонецЦикла; 
		
КонецПроцедуры

Процедура ПерезаполнитьКоличествоМестВДокументе() Экспорт

	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	Манифест.Ссылка
	//	|ИЗ
	//	|	Документ.Манифест КАК Манифест";
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//
	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

	//	ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект(); 
	//	Если ТипЗнч(ДокументОбъект.КоличествоМест) = Тип("Строка") Тогда
	//		Попытка
	//			ДокументОбъект.КоличествоМест = Число(ДокументОбъект.КоличествоМест);
	//			ДокументОбъект.Записать();
	//		Исключение
	//		КонецПопытки; 
	//	КонецЕсли; 
	//	
	//КонецЦикла;

КонецПроцедуры

#КонецОбласти  