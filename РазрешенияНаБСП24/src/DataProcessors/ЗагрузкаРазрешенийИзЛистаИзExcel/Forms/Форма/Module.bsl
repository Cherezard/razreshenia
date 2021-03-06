
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогФыбораФайла								=	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);	
	ДиалогФыбораФайла.Фильтр						=	"Файл данных (*.xls, *.xlsx)|*.xls; *.xlsx";
	ДиалогФыбораФайла.Заголовок						=	"Выберите файл";
	ДиалогФыбораФайла.ПредварительныйПросмотр		=	Ложь;
	ДиалогФыбораФайла.ИндексФильтра					=	0;
	ДиалогФыбораФайла.ПолноеИмяФайла				=	Объект.ИмяФайла;
	ДиалогФыбораФайла.ПроверятьСуществованиеФайла	=	Истина;
	
	Если ДиалогФыбораФайла.Выбрать() Тогда
		Объект.ИмяФайла = ДиалогФыбораФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если ЗначениеЗаполнено(Объект.ИмяФайла) И Объект.НомерЛиста <> 0 Тогда
		Если ТипЗагрузки = 0 Тогда
			ЗагрузитьРазрешения();
		ИначеЕсли ТипЗагрузки = 1 Тогда
			ЗагрузитьОстаткиОбразцов()			
		КонецЕсли; 
		Сообщить("Загрузка завершена");
	Иначе
		Сообщить("Проверьте заполнение полей на форме");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРазрешения()
	
	ФайлEXCEL = Объект.ИмяФайла;
	НомерЛиста = Новый Структура ("НомерЛиста", Объект.НомерЛиста);
	МодульОбъекта = РеквизитФормыВЗначение("Объект");
	МодульОбъекта.ЗагрузитьРазрешения(ФайлEXCEL, НомерЛиста);
	
КонецПроцедуры 

&НаСервере
Процедура ЗагрузитьОстаткиОбразцов()
	
	ФайлEXCEL = Объект.ИмяФайла;
	НомерЛиста = Новый Структура ("НомерЛиста", Объект.НомерЛиста);
	МодульОбъекта = РеквизитФормыВЗначение("Объект");
	МодульОбъекта.ЗагрузитьОстаткиОбразцов(ФайлEXCEL, НомерЛиста);
	
КонецПроцедуры 