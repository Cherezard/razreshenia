////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с почтовыми сообщениями".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Проверка учетной записи электронной почты.
//
// См. описание процедуры РаботаСПочтовымиСообщениямиСлужебный.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты.
//
Процедура ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, СообщениеОбОшибке, ДополнительноеСообщение) Экспорт
	
	РаботаСПочтовымиСообщениямиСлужебный.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, СообщениеОбОшибке, ДополнительноеСообщение);
	
КонецПроцедуры

// Возвращает Истина, если текущему пользователю доступна по меньшей мере одна учетная запись для отправки.
Функция ЕстьДоступныеУчетныеЗаписиДляОтправки() Экспорт
	Возврат РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина).Количество() > 0;
КонецФункции

// Проверяет возможность добавления пользователем новых учетных записей.
Функция ДоступноПравоДобавленияУчетныхЗаписей() Экспорт 
	Возврат ПравоДоступа("Добавление", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты);
КонецФункции

Функция УчетнаяЗаписьНастроена(УчетнаяЗапись) Экспорт
	Возврат РаботаСПочтовымиСообщениями.УчетнаяЗаписьНастроена(УчетнаяЗапись, Ложь, Ложь);
КонецФункции
	
#КонецОбласти
