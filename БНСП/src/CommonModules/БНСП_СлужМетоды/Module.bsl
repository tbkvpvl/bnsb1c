
#Область СлужебныйПрограммныйИнтерфейс

#Область РаботаСоСтроками

Функция СтрокаНайтиИВыделитьОформлениемСлужебная(Строка, Подстрока, ШрифтНайденнойПодстроки = Неопределено,
		ЦветТекстаНайденнойПодстроки = Неопределено, ЦветФонаНайденнойПодстроки = Неопределено,
		СтрокаСлеваОтНайденнойПодстроки = Неопределено, СтрокаСправаОтНайденнойПодстроки = Неопределено,
		КоличествоНайденныхВхожденийПодстроки = Неопределено,
		КоличествоНайденныхУникальныхВхожденийПодстроки = Неопределено, ДлинаСтроки = Неопределено)
	
	СтрокаНРег = НРег(Строка);
	ПодстрокаЭтоМассив = ТипЗнч(Подстрока) = Тип("Массив");
	
	
	
	НайденнаяСтрока = Неопределено;
	
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

