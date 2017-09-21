
&НаСервере
Процедура СохранитьФайлНаСервере()
Запрос = Новый Запрос;
Запрос.УстановитьПараметр("ДатаВывоза",Объект.ДатаВывоза);
Запрос.Текст = "ВЫБРАТЬ
|	НакладныеОбразцы.Разрешение,
|	СУММА(НакладныеОбразцы.Списание) КАК Списание,
|	НакладныеОбразцы.Ссылка.Номер,
|	НакладныеОбразцы.Разрешение.Номер,
|	НакладныеОбразцы.Ссылка.ДатаВывоза
|ИЗ
|	Документ.Накладные.Образцы КАК НакладныеОбразцы
|ГДЕ
|	НакладныеОбразцы.Ссылка.Проведен
|	И НакладныеОбразцы.Ссылка.ДатаВывоза = &ДатаВывоза
|
|СГРУППИРОВАТЬ ПО
|	НакладныеОбразцы.Разрешение,
|	НакладныеОбразцы.Ссылка.Номер,
|	НакладныеОбразцы.Разрешение.Номер,
|	НакладныеОбразцы.Ссылка.ДатаВывоза";

РезультатЗапроса = Запрос.Выполнить();
Выборка = РезультатЗапроса.Выбрать();

Попытка
	Эксель = Новый COMОбъект ("Excel.Application"); 
Исключение
	Сообщить(ОписаниеОшибки()); 
	Возврат;
КонецПопытки; 
Книга = Эксель.WorkBooks.Add();
Лист = Книга.WorkSheets(1);
Лист.Name = "Общий";
НомерСтроки=1;
Лист.Cells(НомерСтроки, 1).Value = "№ Накладной";
Лист.Cells(НомерСтроки, 2).Value = "№ Разрешения";
Лист.Cells(НомерСтроки, 3).Value = "Разрешения";
Лист.Cells(НомерСтроки, 4).Value = "Итого пробирок, шт";

Пока Выборка.Следующий() Цикл
НомерСтроки = НомерСтроки+1;
Лист.Cells(НомерСтроки, 1).Value = Выборка.Номер;
Лист.Cells(НомерСтроки, 2).Value = Выборка.РазрешениеНомер;
Лист.Cells(НомерСтроки, 3).Value = "РАЗРЕШЕНИЕ МЗ РФ № " +Выборка.РазрешениеНомер+" ОТ "+Формат(Выборка.Разрешение.issued, "ДФ=dd.MM.yy");
Лист.Cells(НомерСтроки, 4).Value = Выборка.Списание;
	
	
	
КонецЦикла;

ПутьКФайлу = "\\rumows12\Файлы Разрешений\Выгрузка От "+Формат(ТекущаяДата(),"ДФ=dd.MM.yy")+" "+ Формат(ТекущаяДата(),"ДФ=чч.мм")+".xlsx";
Попытка
	Книга.SaveAs(ПутьКФайлу); 
Исключение
	Сообщить(ОписаниеОшибки()+" Файл не сохранен!"); 
КонецПопытки;

Эксель.Application.Quit();

КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайл(Команда)
	СохранитьФайлНаСервере();
КонецПроцедуры
