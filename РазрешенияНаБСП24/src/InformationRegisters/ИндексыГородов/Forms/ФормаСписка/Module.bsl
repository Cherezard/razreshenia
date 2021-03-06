#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьГородаИзФайла(Команда)
	
#Если ВебКлиент Тогда
		
	Если Не ПодключитьРасширениеРаботыСФайлами() Тогда
		УстановитьРасширениеРаботыСФайлами();
		Если Не ПодключитьРасширениеРаботыСФайлами() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
#КонецЕсли

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Фильтр = "CSV File (*.csv)|*.csv";
	
	Оповещение = Новый ОписаниеОповещения("ВыборФайлаОкончание", ЭтаФорма);	
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыборФайлаОкончание(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	
	Попытка
		ТекстовыйДокумент.Прочитать(ВыбранныеФайлы[0]);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	ПараметрыПроцедуры 	= Новый Структура("ТекстовыйДокумент", ТекстовыйДокумент);
	ПараметрыВыполнения = ДлительныеОперацииВызовСервераРазрешения1C.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка индексов городов'");
	
	ДлительныеОперацииКлиентРазрешения1C.ВыполнитьВФонеИОжидатьЗавершение(
		"РегистрыСведений.ИндексыГородов.ЗагрузитьГородаИзФайлаДлительнаяОперация",
		ПараметрыПроцедуры,
		ПараметрыВыполнения,
		ЭтотОбъект,
		"ЗагрузитьГородаИзФайлаЗавершение");
			
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьГородаИзФайлаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
