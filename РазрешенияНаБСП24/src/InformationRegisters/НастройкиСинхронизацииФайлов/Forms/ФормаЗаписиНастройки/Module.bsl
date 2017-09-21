#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("ВладелецФайла") Тогда
		Запись.ВладелецФайла = Параметры.ВладелецФайла;
		Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
			ИнициализироватьКомпоновщик();
		КонецЕсли;
	КонецЕсли;
	
	Если МассивРеквизитовСТипомДата.Количество() = 0 Тогда
		Элементы.ДобавитьУсловиеПоДате.Доступность = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ТипВладельцаФайла") Тогда
		Запись.ТипВладельцаФайла = Параметры.ТипВладельцаФайла;
	КонецЕсли;
	
	Если Параметры.Свойство("ЭтоФайл") Тогда
		Запись.ЭтоФайл = Параметры.ЭтоФайл;
	КонецЕсли;
	
	Если Параметры.Свойство("НоваяНастройка") Тогда
		НоваяНастройка = Параметры.НоваяНастройка;
	КонецЕсли;
	
	Если Запись.ВладелецФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.УчетнаяЗапись) Тогда
		ЗаполнитьУчетнуюЗаписьСинхронизации();
	КонецЕсли;
	
	Если ТипЗнч(Запись.ВладелецФайла) <> Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
		
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Запись.ВладелецФайла));
		ОбъектСинхронизации = "ТолькоФайлыЭлемента";
		
		ИдентификаторВладельцаФайлов = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Запись.ВладелецФайла));
		ПредставлениеТипВФ = Запись.ТипВладельцаФайла.Наименование;
		ПредставлениеВладельцаДляЗаголовка = ОбщегоНазначения.ПредметСтрокой(Запись.ВладелецФайла);
		ЭлементСправочника = Запись.ВладелецФайла;
		
		СписокСуществующихНастроек.ЗагрузитьЗначения(СуществующиеОбъектыСинхронизации(ТипЗнч(Запись.ВладелецФайла)));
	
	Иначе
		
		ОбъектСинхронизации = "ВсеФайлы";
		
		СписокСуществующихНастроек.ЗагрузитьЗначения(СуществующиеОбъектыСинхронизации(ТипЗнч(Запись.ВладелецФайла.ЗначениеПустойСсылки)));
		
		ИдентификаторВладельцаФайлов = Запись.ВладелецФайла;
		ПредставлениеТипВФ = Запись.ВладелецФайла.Наименование;
		ПредставлениеВладельцаДляЗаголовка = ПредставлениеТипВФ;
		ЭлементСправочника = Запись.ВладелецФайла.ЗначениеПустойСсылки;
		
	КонецЕсли;
	
	Заголовок = НСтр("ru='Настройка синхронизации файлов:'")
		+ " " + ПредставлениеВладельцаДляЗаголовка;
		
	Элементы.ДекорацияПояснениеОтбора.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ДекорацияПояснениеОтбора.Заголовок, ПредставлениеТипВФ);
	Элементы.ОбъектСинхронизацииВсеФайлы.СписокВыбора[0].Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ОбъектСинхронизацииВсеФайлы.СписокВыбора[0].Представление, ПредставлениеТипВФ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ВладелецФайла) Тогда
		ИнициализироватьКомпоновщик();
	КонецЕсли;
	Если ТекущийОбъект.ПравилоОтбора.Получить() <> Неопределено Тогда
		Правило.ЗагрузитьНастройки(ТекущийОбъект.ПравилоОтбора.Получить());
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ОбъектСинхронизации = "ТолькоФайлыЭлемента" И Не ЗначениеЗаполнено(ЭлементСправочника) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнен объект с присоединенными файлами.'"),
			,
			"ЭлементСправочника");
	КонецЕсли;
		
	Запись.ВладелецФайла = 
		?(ОбъектСинхронизации = "ВсеФайлы", ИдентификаторВладельцаФайлов, ЭлементСправочника);
	
	КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПравилоОтбора = Правило.ПолучитьНастройки();
	
	Если ОбъектСинхронизации = "ТолькоФайлыЭлемента" Тогда
		ПравилоОтбора.Отбор.Элементы.Очистить();
		ТекущийОбъект.Наименование = "";
	КонецЕсли;
	
	ТекущийОбъект.ПравилоОтбора = Новый ХранилищеЗначения(ПравилоОтбора);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ВозвращаемоеЗначение = Новый Структура;
	
	Если ОбъектСинхронизации = "ТолькоФайлыЭлемента" Тогда
		ВозвращаемоеЗначение.Вставить("СинонимНаименованияОбъекта", ТекущийОбъект.ВладелецФайла);
	Иначе
		ВозвращаемоеЗначение.Вставить("СинонимНаименованияОбъекта", ИдентификаторВладельцаФайлов.Синоним);
	КонецЕсли;
	ВозвращаемоеЗначение.Вставить("НоваяНастройка",    НоваяНастройка);
	ВозвращаемоеЗначение.Вставить("ВладелецФайла",     ТекущийОбъект.ВладелецФайла);
	ВозвращаемоеЗначение.Вставить("ТипВладельцаФайла", ТекущийОбъект.ТипВладельцаФайла);
	ВозвращаемоеЗначение.Вставить("Синхронизировать",  ТекущийОбъект.Синхронизировать);
	ВозвращаемоеЗначение.Вставить("Наименование",      ТекущийОбъект.Наименование);
	ВозвращаемоеЗначение.Вставить("УчетнаяЗапись",     ТекущийОбъект.УчетнаяЗапись);
	ВозвращаемоеЗначение.Вставить("ЭтоФайл",           ТекущийОбъект.ЭтоФайл);
	ВозвращаемоеЗначение.Вставить("Правило",           ТекущийОбъект.ПравилоОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.НастройкиСинхронизацииФайлов.Форма.ДобавленияУсловияПоДате" Тогда
		ДобавитьВОтборИнтервалИсключение(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСинхронизацииПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФормы();
	Запись.ВладелецФайла = ИдентификаторВладельцаФайлов;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСинхронизацииФайлыЭлементаПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОповеститьОВыборе(ВозвращаемоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщик()
	
	Если Не ЗначениеЗаполнено(Запись.ВладелецФайла) Тогда
		Возврат;
	КонецЕсли;
	
	Правило.Настройки.Отбор.Элементы.Очистить();
	
	СКД = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СКД.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	
	СКД.ПоляИтога.Очистить();
	
	СКД.НаборыДанных[0].Запрос = ПолучитьТекстЗапроса();
	
	СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	
	Правило.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	Правило.Восстановить(); 
	Правило.Настройки.Структура.Очистить();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстЗапроса()
	
	МассивРеквизитовСТипомДата.Очистить();
	Если ТипЗнч(Запись.ВладелецФайла) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
		ТипОбъекта = Запись.ВладелецФайла;
	Иначе
		ТипОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Запись.ВладелецФайла));
	КонецЕсли;
	ВсеСправочники = Справочники.ТипВсеСсылки();
	ВсеДокументы = Документы.ТипВсеСсылки();
	ЕстьТипДата = Ложь;
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	" + ТипОбъекта.Имя + ".Ссылка,";
	Если ВсеСправочники.СодержитТип(ТипЗнч(ТипОбъекта.ЗначениеПустойСсылки)) Тогда
		Справочник = Метаданные.Справочники[ТипОбъекта.Имя];
		Для Каждого Реквизит Из Справочник.Реквизиты Цикл
			ТекстЗапроса = ТекстЗапроса + Символы.ПС + ТипОбъекта.Имя + "." + Реквизит.Имя + ",";
		КонецЦикла;
	ИначеЕсли
		ВсеДокументы.СодержитТип(ТипЗнч(ТипОбъекта.ЗначениеПустойСсылки)) Тогда
		Документ = Метаданные.Документы[ТипОбъекта.Имя];
		Для Каждого Реквизит Из Документ.Реквизиты Цикл
			ТекстЗапроса = ТекстЗапроса + Символы.ПС + ТипОбъекта.Имя + "." + Реквизит.Имя + ",";
			Если Реквизит.Тип = Новый ОписаниеТипов("Дата") Тогда
				МассивРеквизитовСТипомДата.Добавить(Реквизит.Имя, Реквизит.Синоним);
				ТекстЗапроса = ТекстЗапроса + Символы.ПС + "РАЗНОСТЬДАТ(" + Реквизит.Имя + ", &ТекущаяДата, ДЕНЬ) Как ДнейДоУдаленияОт" + Реквизит.Имя + ",";
				ЕстьТипДата = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Удаляем лишнюю запятую
	ТекстЗапроса= Лев(ТекстЗапроса, СтрДлина(ТекстЗапроса) - 1);
	ТекстЗапроса = ТекстЗапроса + "
	               |ИЗ
	               |	" + ТипОбъекта.ПолноеИмя+ " КАК " + ТипОбъекта.Имя;
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьУсловиеПоДате(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МассивЗначений", МассивРеквизитовСТипомДата);
	ОткрытьФорму("РегистрСведений.НастройкиСинхронизацииФайлов.Форма.ДобавленияУсловияПоДате", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтборИнтервалИсключение(ВыбранноеЗначение)
	
	ОтборПоИнтервалу = Правило.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборПоИнтервалу.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДнейДоУдаленияОт" + ВыбранноеЗначение.РеквизитСТипомДата);
	ОтборПоИнтервалу.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборПоИнтервалу.ПравоеЗначение = ВыбранноеЗначение.ИнтервалИсключение;
	ПредставлениеРеквизитаСТипомДата = МассивРеквизитовСТипомДата.НайтиПоЗначению(ВыбранноеЗначение.РеквизитСТипомДата).Представление;
	ТекстПредставления = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Очищать спустя %1 дней относительно даты (%2)'"), 
		ВыбранноеЗначение.ИнтервалИсключение, ПредставлениеРеквизитаСТипомДата);
	ОтборПоИнтервалу.Представление = ТекстПредставления;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы()
	
	СинхронизацияСправочника = ОбъектСинхронизации = "ВсеФайлы";
	
	Элементы.ПравилоСинхронизацииГруппа.Доступность = СинхронизацияСправочника;
	Элементы.ЭлементСправочника.Доступность = Не СинхронизацияСправочника;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлементСправочникаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормыВыбора = Новый Структура;
	
	ПараметрыФормыВыбора.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Ложь);
	ПараметрыФормыВыбора.Вставить("РежимВыбора", Истина);
	
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("ВыборГрупп", Истина);
	ПараметрыФормыВыбора.Вставить("ВыборГруппПользователей", Истина);
	
	ПараметрыФормыВыбора.Вставить("РасширенныйПодбор", Истина);
	ПараметрыФормыВыбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Подбор элементов настроек'"));
	
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных;
	ЭлементНастройки = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементНастройки.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементНастройки.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементНастройки.ПравоеЗначение = СписокСуществующихНастроек;
	ЭлементНастройки.Использование = Истина;
	ЭлементНастройки.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ПараметрыФормыВыбора.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	
	ОткрытьФорму(ПутьФормыВыбора(ЭлементСправочника), ПараметрыФормыВыбора, Элементы.ЭлементСправочника);
	
КонецПроцедуры

&НаСервере
Функция ПутьФормыВыбора(ВладелецФайла)
	
	ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ИдентификаторВладельцаФайлов);
	Возврат ОбъектМетаданных.ПолноеИмя() + ".ФормаВыбора";
	
КонецФункции

&НаСервере
Функция СуществующиеОбъектыСинхронизации(ТипВладельцаФайла)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиСинхронизацииФайлов.ВладелецФайла
		|ИЗ
		|	РегистрСведений.НастройкиСинхронизацииФайлов КАК НастройкиСинхронизацииФайлов
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(НастройкиСинхронизацииФайлов.ВладелецФайла) = &ТипВладельцаФайла";
	
	Запрос.УстановитьПараметр("ТипВладельцаФайла", ТипВладельцаФайла);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ВладелецФайла");
	
КонецФункции

&НаСервере
Процедура ЗаполнитьУчетнуюЗаписьСинхронизации()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетныеЗаписиСинхронизацииФайлов.Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиСинхронизацииФайлов КАК УчетныеЗаписиСинхронизацииФайлов
		|ГДЕ
		|	НЕ УчетныеЗаписиСинхронизацииФайлов.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() = 1 Тогда
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Запись.УчетнаяЗапись = ВыборкаДетальныеЗаписи.Ссылка;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти