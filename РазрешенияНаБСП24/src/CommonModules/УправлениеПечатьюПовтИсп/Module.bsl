////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция КомандыПечатиФормы(ИмяФормы, СписокОбъектов = Неопределено) Экспорт
	ОбъектыПечати = Неопределено;
	Если СписокОбъектов <> Неопределено Тогда
		ОбъектыПечати = Новый Массив;
		Для Каждого ИмяОбъекта Из ОбщегоНазначения.ЗначениеИзСтрокиXML(СписокОбъектов) Цикл
			ОбъектыПечати.Добавить(Метаданные.НайтиПоПолномуИмени(ИмяОбъекта));
		КонецЦикла;
	КонецЕсли;
	Возврат УправлениеПечатью.КомандыПечатиФормы(ИмяФормы, ОбъектыПечати);
КонецФункции

#КонецОбласти


