
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Клиентские и серверные процедуры и функции общего назначения:
// - для работы со строками;
// - для работы с деревом значений и деревом формы;
// 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// TODO:
//	- у каждой функции писать версию платформы, начиная с которой ее можно использовать
//	- у каждой функции создать ее описание
//	
//	- ДеревоЗначенийСтрокаУстановитьЗначениеПометки():
//		- если выяснилось, что у родителя значение пометки равно 2, то
//			нет смысла дальше проверять, нужно просто ставить всем остальным родителям 2 (или ЛОЖЬ, если это Не ТриСостояния)

#Область ПрограммныйИнтерфейс

#Область РаботаСТипомЧисло

Функция ЧислоВЧислоHEX(Число) Экспорт
	ВремЧисло = Число;
	Результат = "";
	Пока ВремЧисло <> 0 Цикл
		Результат = Сред("0123456789ABCDEF", ВремЧисло % 16 + 1, 1) + Результат;
		ВремЧисло = Цел(ВремЧисло / 16);
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ЧислоHEXВЧисло(ЧислоHEX) Экспорт
	ВремЧислоHEX = ВРег(ЧислоHEX);
	Длина = СтрДлина(ВремЧислоHEX);
	Результат = 0;
	Для НомерСимвола = 1 По Длина Цикл
		Позиция = СтрНайти("0123456789ABCDEF", Сред(ВремЧислоHEX, НомерСимвола, 1));
		Результат = Результат + (Позиция - 1) * Pow(16, Длина - НомерСимвола);
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ЧислоHEXВЦвет(ЧислоHEX) Экспорт
	R = ЧислоHEXВЧисло(Лев(ЧислоHEX, 2));
	G = ЧислоHEXВЧисло(Сред(ЧислоHEX, 3, 2));
	B = ЧислоHEXВЧисло(Сред(ЧислоHEX, 5, 2));
	Результат = Новый Цвет(R, G, B);
	Возврат Результат;
КонецФункции

Функция ЧислоВРимскоеЧисло(Число) Экспорт
	
	Если Число < 1
		И Число > 3999 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЧислоСтрокой = Формат(Число, "ЧЦ=4; ЧВН=; ЧГ=");
	
	Числа = СтрРазделить(
		" M MM MMM; C CC CCC CD D DC DCC DCCC CM; X XX XXX XL L LX LXX LXXX XC; I II III IV V VI VII VIII IX", ";");
	
	РимскоеЧисло = "";
	
	Для Индекс = 0 По 3 Цикл
		РимскоеЧисло = РимскоеЧисло + СтрРазделить(Числа[Индекс], " ")[Число(Сред(ЧислоСтрокой, Индекс + 1, 1))];
	КонецЦикла;
	
	Возврат РимскоеЧисло;
	
КонецФункции

#КонецОбласти

#Область РаботаСТипомСтрока

Функция ИзвлечьИзСтрокиЧислоHEX(Строка) Экспорт
	Результат = "";
	СтрокаВРег = ВРег(Строка);
	Для НомерСимвола = 1 По СтрДлина(Строка) Цикл
		Символ = Сред(СтрокаВРег, НомерСимвола, 1);
		Если "0" <= Символ И Символ <= "9" Или "A" <= Символ И Символ <= "F" Тогда
			Результат = Результат + Символ;
		КонецЕсли; 
	КонецЦикла;
	Для НомерСимвола = 1 По 6 - СтрДлина(Результат) Цикл
		Результат = Результат + "0";
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция СтрокаНайтиИВыделитьОформлением(Строка, Подстрока, НечеткийПоиск = Ложь,
		Знач ШрифтНайденнойПодстроки = Неопределено, Знач ЦветТекстаНайденнойПодстроки = Неопределено,
		Знач ЦветФонаНайденнойПодстроки = Неопределено, СтрокаСлеваОтНайденнойПодстроки = Неопределено,
		СтрокаСправаОтНайденнойПодстроки = Неопределено, КоличествоНайденныхВхожденийПодстроки = Неопределено,
		КоличествоНайденныхУникальныхВхожденийПодстроки = Неопределено,
		ПозицияПервогоВхожденияПодстроки = Неопределено) Экспорт
	
	ПодстрокаЭтоМассив = ТипЗнч(Подстрока) = Тип("Массив");
	Если Не ПодстрокаЭтоМассив Тогда
		ИскомыеПодстроки = Новый Массив;
		ИскомыеПодстроки.Добавить(Подстрока);
		ИскомыеПодстрокиВГраница = 0;
	Иначе
		ИскомыеПодстроки = Подстрока;
		ИскомыеПодстрокиВГраница = ИскомыеПодстроки.ВГраница();
	КонецЕсли;
	
	СтрокаНРег = НРег(Строка);
	ЧастиРезультирующейСтрокиПозиции = Новый СписокЗначений;
	
	ВремКоличествоНайденныхВхожденийПодстроки = 0;
	ВремКоличествоНайденныхУникальныхВхожденийПодстроки = 0;
	
	Если ШрифтНайденнойПодстроки = Неопределено Тогда
		ШрифтНайденнойПодстроки = Новый Шрифт(, , Истина);
	КонецЕсли;
	Если ЦветТекстаНайденнойПодстроки = Неопределено Тогда
		ЦветТекстаНайденнойПодстроки = БНСП_ОбщМетодыКлиентСерверПовтИсп.ПолучитьЦветСтиляЦветАкцента();
	КонецЕсли;
	
	СтрокаДлина = СтрДлина(Строка);
	//ВремПозицияПервогоВхожденияПодстроки = СтрокаДлина;
	
	Для ИскомаяПодстрокаИндекс = 0 По ИскомыеПодстрокиВГраница Цикл
		
		ИскомаяПодстрока = ИскомыеПодстроки[ИскомаяПодстрокаИндекс];
		ИскомаяПодстрокаНРег = НРег(ИскомаяПодстрока);
		ИскомаяПодстрокаПозиция = СтрНайти(СтрокаНРег, ИскомаяПодстрокаНРег);
		
		//ВремПозицияПервогоВхожденияПодстроки = ИскомаяПодстрокаПозиция;
		
		Если ИскомаяПодстрокаПозиция = 0 Тогда
			Если НечеткийПоиск Тогда
				Продолжить;
			КонецЕсли;
			Возврат Неопределено;
		КонецЕсли;
		
		ВремКоличествоНайденныхУникальныхВхожденийПодстроки = ВремКоличествоНайденныхУникальныхВхожденийПодстроки + 1;
		
		ИскомаяПодстрокаДлина = СтрДлина(ИскомаяПодстрока);
		СтрокаЧастьБезПодстрокиПозиция = 1;
		
		Пока ИскомаяПодстрокаПозиция > 0 Цикл
			ВремКоличествоНайденныхВхожденийПодстроки = ВремКоличествоНайденныхВхожденийПодстроки + 1;
			
			// для чего это условие Если?
			Если СтрокаЧастьБезПодстрокиПозиция <= ИскомаяПодстрокаПозиция Тогда
				СтрокаЧастьБезПодстрокиДлина = ИскомаяПодстрокаПозиция - СтрокаЧастьБезПодстрокиПозиция;
				СтрокаЧастьБезПодстроки = Сред(Строка, СтрокаЧастьБезПодстрокиПозиция, СтрокаЧастьБезПодстрокиДлина);
				ЧастиРезультирующейСтрокиПозиции.Добавить(СтрокаЧастьБезПодстрокиПозиция, СтрокаЧастьБезПодстроки);
			КонецЕсли;
			
			ИскомаяПодстрокаВСтроке = Сред(Строка, ИскомаяПодстрокаПозиция, ИскомаяПодстрокаДлина);
			ИскомаяПодстрокаВСтрокеФорматированная = Новый ФорматированнаяСтрока(ИскомаяПодстрокаВСтроке,
				ШрифтНайденнойПодстроки, ЦветТекстаНайденнойПодстроки, ЦветФонаНайденнойПодстроки);
			Если СтрокаСлеваОтНайденнойПодстроки <> Неопределено Тогда
				ИскомаяПодстрокаВСтрокеФорматированная = Новый ФорматированнаяСтрока(
					СтрокаСлеваОтНайденнойПодстроки, ИскомаяПодстрокаВСтрокеФорматированная);
			КонецЕсли;
			Если СтрокаСправаОтНайденнойПодстроки <> Неопределено Тогда
				ИскомаяПодстрокаВСтрокеФорматированная = Новый ФорматированнаяСтрока(
					ИскомаяПодстрокаВСтрокеФорматированная, СтрокаСправаОтНайденнойПодстроки);
			КонецЕсли;
			
			ЧастиРезультирующейСтрокиПозиции.Добавить(ИскомаяПодстрокаПозиция, ИскомаяПодстрокаВСтрокеФорматированная);
			
			СтрокаЧастьБезПодстрокиПозиция = ИскомаяПодстрокаПозиция + ИскомаяПодстрокаДлина;
			Если СтрокаЧастьБезПодстрокиПозиция > СтрокаДлина Тогда
				Прервать;
			КонецЕсли;
			
			ИскомаяПодстрокаПозиция = СтрНайти(СтрокаНРег, ИскомаяПодстрокаНРег, , СтрокаЧастьБезПодстрокиПозиция);
		КонецЦикла;
		
		Если СтрокаЧастьБезПодстрокиПозиция <= СтрокаДлина Тогда
			СтрокаЧастьБезПодстроки = Сред(Строка, СтрокаЧастьБезПодстрокиПозиция);
			ЧастиРезультирующейСтрокиПозиции.Добавить(СтрокаЧастьБезПодстрокиПозиция, СтрокаЧастьБезПодстроки);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВремКоличествоНайденныхУникальныхВхожденийПодстроки = 0 Тогда
		Возврат Неопределено;
	ИначеЕсли ВремКоличествоНайденныхУникальныхВхожденийПодстроки > 1 Тогда
		ЧастиРезультирующейСтрокиПозиции.СортироватьПоЗначению();
	КонецЕсли;
	
	//ПозицияПервогоВхождения = 0;
	
	//Если ЧастиРезультирующейСтрокиПозиции[1].Значение = 1
	
	ЧастиРезультирующейСтроки = Новый Массив;
	Для Каждого ИскомаяПодстрокаПозицииЭлемент Из ЧастиРезультирующейСтрокиПозиции Цикл
		ЧастиРезультирующейСтроки.Добавить(ИскомаяПодстрокаПозицииЭлемент.Представление);
	КонецЦикла;
	
	//ДлинаСтроки = СтрокаДлина;
	КоличествоНайденныхВхожденийПодстроки = ВремКоличествоНайденныхВхожденийПодстроки;
	КоличествоНайденныхУникальныхВхожденийПодстроки = ВремКоличествоНайденныхУникальныхВхожденийПодстроки;
	//ПозицияПервогоВхожденияПодстроки = ВремПозицияПервогоВхожденияПодстроки;
	
	РезультирующаяСтрока = Новый ФорматированнаяСтрока(ЧастиРезультирующейСтроки);
	Возврат РезультирующаяСтрока;
	
КонецФункции

Функция ДобавитьЛидирующиеСимволы(Строка, Длина, Символ) Экспорт
	Результат = "";
	КолДобавляемыхЛидирующихСимволов = Длина - СтрДлина(Строка);
	Для НомерЛидирующегоСимвола = 1 По КолДобавляемыхЛидирующихСимволов Цикл
		Результат = Символ + Результат;
	КонецЦикла;
	Возврат Результат; 
КонецФункции

#КонецОбласти

#Область РаботаСТипомДеревоЗначений

Процедура ДеревоЗначенийУстановитьЗначениеПометки(ДеревоЗначений, ИмяРеквизитаПометки, ЗначениеПометки) Экспорт
	
	ЭтоДеревоФормы = Тип(ДеревоЗначений) = Тип("ДанныеФормыДерево");
	
	Если ЭтоДеревоФормы Тогда
		ДеревоЗначенийСтроки = ДеревоЗначений.ПолучитьЭлементы();
	Иначе
		ДеревоЗначенийСтроки = ДеревоЗначений.Строки;
	КонецЕсли;
	
	Для Каждого ДеревоЗначенийСтрока Из ДеревоЗначенийСтроки Цикл
		
		ДеревоЗначенийСтрока[ИмяРеквизитаПометки] = ЗначениеПометки;
		
		ДеревоЗначенийСтрокаУстановитьЗначениеПометкиПодчиненнымСтрокам(
			ДеревоЗначенийСтрока, ЭтоДеревоФормы, ИмяРеквизитаПометки, ЗначениеПометки);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СтрокаДереваЗначенийУстановитьПрименитьЗначениеПометки(
		СтрокаДереваЗначений, ИмяРеквизитаПометки, ЗначениеПометки = Неопределено) Экспорт
	
	ЭтоДеревоФормы = Тип(СтрокаДереваЗначений) = Тип("ДанныеФормыЭлементДерева");
	
	Если ЗначениеПометки <> Неопределено Тогда
		СтрокаДереваЗначенийПометка = СтрокаДереваЗначений;
	Иначе
		СтрокаДереваЗначенийПометка = СтрокаДереваЗначений[ИмяРеквизитаПометки];
	КонецЕсли;
	
	ДеревоЗначенийСтрокаУстановитьЗначениеПометки(
		СтрокаДереваЗначений, ЭтоДеревоФормы, ИмяРеквизитаПометки, СтрокаДереваЗначенийПометка);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСТипомЦвет

Функция АбсолютныйЦвет(Знач Цвет) Экспорт
	ФД = Новый ФорматированныйДокумент;
	ФД.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(" ", , Цвет));
	ТекстHTML = "";
	ФД.ПолучитьHTML(ТекстHTML, Неопределено);
	ЧислоHEXПозиция = СтрНайти(ТекстHTML, "#") + 1;
	ЧислоHEX = Сред(ТекстHTML, ЧислоHEXПозиция, 6);
	АбсЦвет = ЧислоHEXВЦвет(ЧислоHEX);
	Возврат АбсЦвет;
КонецФункции

Функция ЦветВЧислоHEX(Цвет) Экспорт
	Результат = ДобавитьЛидирующиеСимволы(ЧислоВЧислоHEX(Цвет.Красный), 2, "0")
	+ ДобавитьЛидирующиеСимволы(ЧислоВЧислоHEX(Цвет.Зеленый), 2, "0")
	+ ДобавитьЛидирующиеСимволы(ЧислоВЧислоHEX(Цвет.Синий), 2, "0");
	Возврат Результат;
КонецФункции

Процедура ЦветВПараметрыЦветаCMYK(ЦветRGB, C = 0, M = 0, Y = 0, K = 0) Экспорт
	R = ЦветRGB.Красный;
	G = ЦветRGB.Зеленый;
	B = ЦветRGB.Синий;
	K_ = 1 - Макс(R, G, B) / 255;
	Если K_ = 1 Тогда
		C = 0;
		M = 0;
		Y = 0;
	Иначе
		C = Окр((1 - R / 255 - K_) / (1 - K_) * 100);
		M = Окр((1 - G / 255 - K_) / (1 - K_) * 100);
		Y = Окр((1 - B / 255 - K_) / (1 - K_) * 100);
	КонецЕсли;
	K = Окр(K_ * 100);
КонецПроцедуры

Процедура ЦветВПараметрыЦветаHSV(ЦветRGB, H = 0, S = 0, V = 0) Экспорт
	R_ = ЦветRGB.Красный;
	G_ = ЦветRGB.Зеленый;
	B_ = ЦветRGB.Синий;
	Cmax = Макс(R_, G_, B_);
	Cmin = Мин(R_, G_, B_);
	d = Cmax - Cmin;
	Если d = 0 Тогда
		H_ = 0;
	ИначеЕсли Cmax = R_ Тогда
		H_ = 60 * ((G_ - B_) / d % 6);
	ИначеЕсли Cmax = G_ Тогда
		H_ = 60 * ((B_ - R_) / d + 2);
	Иначе
		H_ = 60 * ((R_ - G_) / d + 4);
	КонецЕсли;
	H = ?(H_ < 0, H_ + 360, H_);
	S = ?(Cmax = 0, 0, d / Cmax) * 100;
	V = Cmax / 255 * 100;
КонецПроцедуры

Процедура ЦветВПараметрыЦветаHSL(ЦветRGB, H = 0, S = 0, L = 0) Экспорт
	R_ = ЦветRGB.Красный / 255;
	G_ = ЦветRGB.Зеленый / 255;
	B_ = ЦветRGB.Синий / 255;
	Cmax = Макс(R_, G_, B_);
	Cmin = Мин(R_, G_, B_);
	d = Cmax - Cmin;
	Если d = 0 Тогда
		H_ = 0;
	ИначеЕсли Cmax = R_ Тогда
		H_ = 60 * ((G_ - B_) / d % 6);
	ИначеЕсли Cmax = G_ Тогда
		H_ = 60 * ((B_ - R_) / d + 2);
	Иначе
		H_ = 60 * ((R_ - G_) / d + 4);
	КонецЕсли;
	H = ?(H_ < 0, H_ + 360, H_);
	L_ = (Cmax + Cmin) / 2;
	p = 2 * L_ - 1;
	p = Макс(p, - p);
	dp = (1 - p);
	S = ?(dp = 0, 0, d / dp) * 100;
	L = L_ * 100;
КонецПроцедуры

Функция ПараметрыЦветаCMYKВЦвет(C, M, Y, K) Экспорт
	R = Окр(255 * (1 - C / 100) * (1 - K / 100));
	G = Окр(255 * (1 - M / 100) * (1 - K / 100));
	B = Окр(255 * (1 - Y / 100) * (1 - K / 100));
	Результат = Новый Цвет(R, G, B);
	Возврат Результат;
КонецФункции

Функция ПараметрыЦветаHSVВЦвет(H, S, V) Экспорт
	S_ = S / 100;
	V_ = V / 100;
	C = V_ * S_;
	p = H / 60 % 2 - 1;
	p = Макс(p, - p);
	X = C * (1 - p);
	m = V_ - C;
	R_ = 0;
	G_ = 0;
	B_ = 0;
	Если 0 <= H И H < 60 Тогда
		R_ = C;
		G_ = X;
	ИначеЕсли 60 <= H И H < 120 Тогда
		R_ = X;
		G_ = C;
	ИначеЕсли 120 <= H И H < 180 Тогда
		G_ = C;
		B_ = X;
	ИначеЕсли 180 <= H И H < 240 Тогда
		G_ = X;
		B_ = C;
	ИначеЕсли 240 <= H И H < 300 Тогда
		R_ = X;
		B_ = C;
	ИначеЕсли 300 <= H И H < 360 Тогда
		R_ = C;
		B_ = X;
	КонецЕсли;
	R = Окр((R_ + m) * 255);
	G = Окр((G_ + m) * 255);
	B = Окр((B_ + m) * 255);
	ЦветRGB = Новый Цвет(R, G, B);
	Возврат ЦветRGB;
КонецФункции

Функция ПараметрыЦветаHSLВЦвет(H, S, L) Экспорт
	S_ = S / 100;
	L_ = L / 100;
	p1 = 2 * L_ - 1;
	p1 = Макс(p1, - p1);
	C = (1 - p1) * S_;
	p2 = H / 60 % 2 - 1;
	p2 = Макс(p2, - p2);
	X = C * (1 - p2);
	m = L_ - C / 2;
	R_ = 0;
	G_ = 0;
	B_ = 0;
	Если 0 <= H И H < 60 Тогда
		R_ = C;
		G_ = X;
	ИначеЕсли 60 <= H И H < 120 Тогда
		R_ = X;
		G_ = C;
	ИначеЕсли 120 <= H И H < 180 Тогда
		G_ = C;
		B_ = X;
	ИначеЕсли 180 <= H И H < 240 Тогда
		G_ = X;
		B_ = C;
	ИначеЕсли 240 <= H И H < 300 Тогда
		R_ = X;
		B_ = C;
	ИначеЕсли 300 <= H И H < 360 Тогда
		R_ = C;
		B_ = X;
	КонецЕсли;
	R = Окр((R_ + m) * 255);
	G = Окр((G_ + m) * 255);
	B = Окр((B_ + m) * 255);
	ЦветRGB = Новый Цвет(R, G, B);
	Возврат ЦветRGB;
КонецФункции

Функция ИзменитьОтносительнуюЯркостьЦвета(Цвет, Знач ПроцентОтличия = 100) Экспорт
	ПроцентОтличия = Мин(Макс(ПроцентОтличия, 0), 100);
	//ПерспективнаяЯркость = (0.299 * Цвет.Красный + 0.587 * Цвет.Зеленый + 0.114 * Цвет.Синий) / 255;
	ПерспективнаяЯркость = (Цвет.Красный * 0.2126 + Цвет.Зеленый * 0.7152 + Цвет.Синий * 0.0722) / 255;
	Если ПерспективнаяЯркость > 0.5 Тогда
		Сдвиг = 1 - ПроцентОтличия / 100;
		R = Окр(Цвет.Красный * Сдвиг);
		G = Окр(Цвет.Зеленый * Сдвиг);
		B = Окр(Цвет.Синий * Сдвиг);
	Иначе
		Сдвиг = ПроцентОтличия / 100;
		R = Мин(Окр((Цвет.Красный + 255) * Сдвиг), 255);
		G = Мин(Окр((Цвет.Зеленый + 255) * Сдвиг), 255);
		B = Мин(Окр((Цвет.Синий + 255) * Сдвиг), 255)
	КонецЕсли;
	НовыйЦвет = Новый Цвет(R, G, B);
	Возврат НовыйЦвет;
КонецФункции

#КонецОбласти

Процедура Пауза(Знач КоличествоМиллисекунд) Экспорт
	Если КоличествоМиллисекунд > 0 Тогда
		ДатаДо = ТекущаяУниверсальнаяДатаВМиллисекундах();
		Пока Истина Цикл
			Если ТекущаяУниверсальнаяДатаВМиллисекундах() - ДатаДо >= КоличествоМиллисекунд Тогда
				Возврат;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСТипомДеревоЗначений

Процедура ДеревоЗначенийСтрокаУстановитьЗначениеПометки(
		ДеревоЗначенийСтрока, ЭтоДеревоФормы, ИмяРеквизитаПометки, ЗначениеПометки)
	
	ДеревоЗначенийСтрока[ИмяРеквизитаПометки] = ЗначениеПометки;
	ДеревоЗначенийСтрокаПометка = ДеревоЗначенийСтрока[ИмяРеквизитаПометки];
	
	ТриСостояния = ТипЗнч(ДеревоЗначенийСтрокаПометка) = Тип("Число");
	
	Если ЭтоДеревоФормы Тогда
		ДеревоЗначенийСтрокаРодитель = ДеревоЗначенийСтрока.ПолучитьРодителя();
	Иначе
		ДеревоЗначенийСтрокаРодитель = ДеревоЗначенийСтрока.Родитель;
	КонецЕсли;
	
	Пока ДеревоЗначенийСтрокаРодитель <> Неопределено Цикл
		
		ДеревоЗначенийСтрокаРодительПометка = ДеревоЗначенийСтрокаПометка;
		
		Для Каждого ДеревоЗначенийСтрокаРодительСтрока Из ДеревоЗначенийСтрокаРодитель.ПолучитьЭлементы() Цикл
			
			Если ДеревоЗначенийСтрокаРодительСтрока[ИмяРеквизитаПометки] = ДеревоЗначенийСтрокаПометка Тогда
				Продолжить;
			КонецЕсли;
				
			ДеревоЗначенийСтрокаРодительПометка = ?(ТриСостояния, 2, Ложь);
			
			Прервать;
			
		КонецЦикла;
		
		ДеревоЗначенийСтрокаРодитель[ИмяРеквизитаПометки] = ДеревоЗначенийСтрокаРодительПометка;
		
		Если ЭтоДеревоФормы Тогда
			ДеревоЗначенийСтрокаРодитель = ДеревоЗначенийСтрокаРодитель.ПолучитьРодителя();
		Иначе
			ДеревоЗначенийСтрокаРодитель = ДеревоЗначенийСтрокаРодитель.Родитель;
		КонецЕсли;
		
	КонецЦикла;
	
	ДеревоЗначенийСтрокаУстановитьЗначениеПометкиПодчиненнымСтрокам(
		ДеревоЗначенийСтрока, ЭтоДеревоФормы, ИмяРеквизитаПометки, ЗначениеПометки);
	
КонецПроцедуры

Процедура ДеревоЗначенийСтрокаУстановитьЗначениеПометкиПодчиненнымСтрокам(
		ДеревоЗначенийСтрока, ЭтоДеревоФормы, ИмяРеквизитаПометки, ЗначениеПометки)
		
	Если ЭтоДеревоФормы Тогда
		ДеревоЗначенийСтрокаСтроки = ДеревоЗначенийСтрока.ПолучитьЭлементы();
	Иначе
		ДеревоЗначенийСтрокаСтроки = ДеревоЗначенийСтрока.Строки;
	КонецЕсли;
	
	Для Каждого ДеревоЗначенийСтрокаСтрока Из ДеревоЗначенийСтрокаСтроки Цикл
		
		ДеревоЗначенийСтрокаСтрока[ИмяРеквизитаПометки] = ЗначениеПометки;
		
		ДеревоЗначенийСтрокаУстановитьЗначениеПометкиПодчиненнымСтрокам(
			ДеревоЗначенийСтрокаСтрока, ЭтоДеревоФормы, ИмяРеквизитаПометки, ЗначениеПометки)
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти



















