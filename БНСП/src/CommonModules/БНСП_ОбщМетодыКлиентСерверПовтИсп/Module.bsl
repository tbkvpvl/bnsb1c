
#Область ПрограммныйИнтерфейс

#Область РаботаСЦветами

Функция ПолучитьЦветСтиляЦветАкцента() Экспорт
	ФД = Новый ФорматированныйДокумент;
	ФД.УстановитьФорматированнуюСтроку(СтрНайтиИВыделитьОформлением("a", "a"));
	ТекстHTML = "";
	ФД.ПолучитьHTML(ТекстHTML, Неопределено);
	ЧислоHEXПозиция = СтрНайти(ТекстHTML, "#") + 1;
	ЧислоHEX = Сред(ТекстHTML, ЧислоHEXПозиция, 6);
	Цвет = БНСП_ОбщМетодыКлиентСервер.ЧислоHEXВЦвет(ЧислоHEX);
	Возврат Цвет;
КонецФункции

#КонецОбласти

#КонецОбласти