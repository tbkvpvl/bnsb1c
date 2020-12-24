

// TODO:
// - переписать под стандарты 1с
// - при извлечении цветов стиля некорректно использовать заранее заданные цвета, т.к. цвет того или иного стиля
//		зависит от основного стиля конфигурации
// - при извлечении цветов стиля учитывать, что состав стилей делится на стандартные и нестандартные,
//		т.к. добавленные в конфигурацию как ЭлементСтиля, их так же нужно возвращать
// - то же самое для цветов windows - возможно есть способ получать эти цвета из windows, а не из констант

//ФД = Новый ФорматированныйДокумент;
//ФД.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока("123", , , ЦветаСтиля.ЦветАкцента));
//ТекстHTML = "";
//ФД.ПолучитьHTML(ТекстHTML, Неопределено);
//Сообщить(ТекстHTML);

#Область ОписаниеОбработки
///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  Общие сведения:                                                                              //
//  Разработчик: Табаков Павел Е.                                                                //
//  Страница разработчика: https://infostart.ru/profile/1019160/                                 //
//  Страница публикации: https://infostart.ru/public/1278131/                                    //
//  Протестировано на платформе 1С версии 8.3.16.1148                                            //
//  Предназначено для использования в любой базе данных 1С.                                      //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  Цель:                                                                                        //
//  Данная обработка предназначена для демонстрации алгоритма преобразования цвета из одного     //
//  вида в другой.                                                                               //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  Возможности:                                                                                 //
//  Преобразование цвета любого вида в цвет любого другого вида при помощи следующих методов:    //
//  - ОпределитьАбсолютныйЦвет(Цвет) - преобразует переданный цвет любого вида в абсолютный      //
//    цвет;                                                                                      //
//  - НайтиWebЦвет(Цвет) - ищет переданный цвет любого вида среди набора WebЦвета;               //
//  - НайтиЦветСтиля(Цвет) - ищет переданный цвет любого вида среди набора ЦветаСтиля;           //
//  - НайтиWindowsЦвет(Цвет) - ищет переданный цвет любого вида среди набора WindowsЦвета.       //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  Описание:                                                                                    //
//  Основной принцип преобразования цветов из одного вида в другой в данной обработке            //
//  заключается в использовании методов ЗначениеВСтрокуВнутр() и ЗначениеИзСтрокиВнутр().        //
//  Так, например, внутренние значения цветов WebЦвета.Белый и WebЦвета.Черный соответственно    //
//  выглядят следующи образом:                                                                   //
//     {"#",9cd510c7-abfc-11d4-9434-004095e12fc7,2,{3,2,{143}}}                                  //
//     {"#",9cd510c7-abfc-11d4-9434-004095e12fc7,2,{3,2,{8}}}                                    //
//  Как видно, в структуре полученных данных содержится внутренний индекс цвета: 143 - для       //
//  белого цвета, и 8 - для черного цвета. Опытным путем было обнаружено, что для каждой         //
//  коллекции существует свой диапазон внутренних индексов:                                      //
//  - WebЦвета: от 1 до 146                                                                      //
//  - ЦветаСтиля: от -1 до -47 (значения цветов для некоторых индексов оказались пустыми)        //
//  - WindowsЦвета: от -2 до 28 (кроме 25)                                                       //
//  Таким образом, зная внутренний индекс цвета можно получить цвет из любого набора путем       //
//  подстановки этого индекста во внутреннюю строку, например, внутренний индекс желтого цвета   //
//  для набора WebЦвета равен 145, следовательно внутренняя строка имеет вид:                    //
//     ВнутренняяСтрока = "{""#"",9cd510c7-abfc-11d4-9434-004095e12fc7,2,{3,2,{" + 145 + "}}}";  //
//  Теперь, чтобы получить цвет набора WebЦвета необходимо воспользоваться методом               //
//  ЗначениеИзСтрокиВнутр():                                                                     //
//        ЖелтыйЦвет = ЗначениеИзСтрокиВнутр(ВнутренняяСтрока);                                  //
//  В результате в переменной "ЖелтыйЦвет" будет содержаться значение WebЦвета.Желтый.           //
//  Аналогичным образом получаются цвета для других наборов (ЦветаСтиля и WindowsЦвета).         //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////
#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолеЦветаЗагрузитьСписокВыбора(Элементы.ЦветWeb, БНСП_ОбщМетоды.ПолучитьWebЦвета());
	ПолеЦветаЗагрузитьСписокВыбора(Элементы.ЦветСтиля, БНСП_ОбщМетоды.ПолучитьЦветаСтиля());
	ПолеЦветаЗагрузитьСписокВыбора(Элементы.ЦветWindows, БНСП_ОбщМетоды.ПолучитьWindowsЦвета());
	
	АбсЦветПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЦветWebПриИзменении(Элемент)
	ЦветWebПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЦветWebРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЦветWeb = СписокВыбораРегулирование(Элемент.СписокВыбора, Направление, ЦветWeb);
	ЦветWebПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЦветСтиляПриИзменении(Элемент)
	ЦветСтиляПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЦветСтиляРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЦветСтиля = СписокВыбораРегулирование(Элемент.СписокВыбора, Направление, ЦветСтиля);
	ЦветСтиляПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЦветWindowsПриИзменении(Элемент)
	ЦветWindowsПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЦветWindowsРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЦветWindows = СписокВыбораРегулирование(Элемент.СписокВыбора, Направление, ЦветWindows);
	ЦветWindowsПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура АбсЦветПриИзменении(Элемент)
	АбсЦветПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолеЦветаЗагрузитьСписокВыбора(ПолеЦвета, МассивЦветов)
	Для Каждого Цвет Из МассивЦветов Цикл
		ПолеЦвета.СписокВыбора.Добавить(Цвет, ПолучитьПредставлениеЦветаДляСпискаВыбора(Цвет));
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПредставлениеЦветаДляСпискаВыбора(Цвет)
	АбсЦвет = БНСП_ОбщМетоды.ОпределитьАбсолютныйЦвет(Цвет);
	Возврат Новый ФорматированнаяСтрока(Новый ФорматированнаяСтрока("     ", , , АбсЦвет), "  " + Цвет);
КонецФункции

&НаСервере
Процедура ЦветWebПриИзмененииНаСервере()
	
	УстановитьАбсолютныйЦвет(ЦветWeb);
	
	ЦветСтиля = БНСП_ОбщМетоды.НайтиЦветСтиля(ЦветWeb);
	ЦветПриИзмененииНаСервере(Элементы.ЦветСтиля, ЦветСтиляТекущий, ЦветСтиля);
	ЦветСтиляТекущий = ЦветСтиля;
	
	ЦветWindows = БНСП_ОбщМетоды.НайтиWindowsЦвет(ЦветWeb);
	ЦветПриИзмененииНаСервере(Элементы.ЦветWindows, ЦветWindowsТекущий, ЦветWindows);
	ЦветWindowsТекущий = ЦветWindows;
	
	ЦветПриИзмененииНаСервере(Элементы.ЦветWeb, ЦветWebТекущий, ЦветWeb);
	ЦветWebТекущий = ЦветWeb;
	
КонецПроцедуры

&НаСервере
Процедура ЦветСтиляПриИзмененииНаСервере()
	
	УстановитьАбсолютныйЦвет(ЦветСтиля);
	
	ЦветWeb = БНСП_ОбщМетоды.НайтиWebЦвет(ЦветСтиля);
	ЦветПриИзмененииНаСервере(Элементы.ЦветWeb, ЦветWebТекущий, ЦветWeb);
	ЦветWebТекущий = ЦветWeb;
	
	ЦветWindows = БНСП_ОбщМетоды.НайтиWindowsЦвет(ЦветСтиля);
	ЦветПриИзмененииНаСервере(Элементы.ЦветWindows, ЦветWindowsТекущий, ЦветWindows);
	ЦветWindowsТекущий = ЦветWindows;
	
	ЦветПриИзмененииНаСервере(Элементы.ЦветСтиля, ЦветСтиляТекущий, ЦветСтиля);
	ЦветСтиляТекущий = ЦветСтиля;
	
КонецПроцедуры

&НаСервере
Процедура ЦветWindowsПриИзмененииНаСервере()
	
	УстановитьАбсолютныйЦвет(ЦветWindows);
	
	ЦветWeb = БНСП_ОбщМетоды.НайтиWebЦвет(ЦветWindows);
	ЦветПриИзмененииНаСервере(Элементы.ЦветWeb, ЦветWebТекущий, ЦветWeb);
	ЦветWebТекущий = ЦветWeb;
	
	ЦветСтиля = БНСП_ОбщМетоды.НайтиЦветСтиля(ЦветWindows);
	ЦветПриИзмененииНаСервере(Элементы.ЦветСтиля, ЦветСтиляТекущий, ЦветСтиля);
	ЦветСтиляТекущий = ЦветСтиля;
	
	ЦветПриИзмененииНаСервере(Элементы.ЦветWindows, ЦветWindowsТекущий, ЦветWindows);
	ЦветWindowsТекущий = ЦветWindows;
	
КонецПроцедуры

&НаКлиенте
Функция СписокВыбораРегулирование(СписокВыбора, Направление, ТекущееЗначение)
	
	ЭлементСписка = СписокВыбора.НайтиПоЗначению(ТекущееЗначение);
	
	Если ЭлементСписка = Неопределено Тогда
		ТекущийИндекс = 0;
	Иначе
		ТекущийИндекс = Макс(СписокВыбора.Индекс(ЭлементСписка), 0);
	КонецЕсли;
	
	ИндексПоследнегоЭлементаСпискаВыбора = СписокВыбора.Количество() - 1;
	НовыйИндекс = ТекущийИндекс - Направление;
	Если НовыйИндекс < 0 Тогда
		НовыйИндекс = ИндексПоследнегоЭлементаСпискаВыбора;
	ИначеЕсли НовыйИндекс > ИндексПоследнегоЭлементаСпискаВыбора Тогда
		НовыйИндекс = 0;
	КонецЕсли;
	
	НовоеЗначение = СписокВыбора[НовыйИндекс].Значение;
	Возврат НовоеЗначение;
	
КонецФункции

&НаСервере
Процедура ЦветПриИзмененииНаСервере(Элемент, ТекущийЦвет, НовыйЦвет)
	
	ТекущийЭлементСпискаВыбора = Элемент.СписокВыбора.НайтиПоЗначению(ТекущийЦвет);
	Если ТекущийЭлементСпискаВыбора <> Неопределено Тогда
		ТекущийЭлементСпискаВыбора.Представление =
			ПолучитьПредставлениеЦветаДляСпискаВыбора(ТекущийЭлементСпискаВыбора.Значение);
	КонецЕсли;
	
	НовыйТекущийЭлементСпискаВыбора = Элемент.СписокВыбора.НайтиПоЗначению(НовыйЦвет);
	Если НовыйТекущийЭлементСпискаВыбора <> Неопределено Тогда
		НовыйТекущийЭлементСпискаВыбора.Представление = СокрЛ(НовыйТекущийЭлементСпискаВыбора.Представление);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура АбсЦветПриИзмененииНаСервере()
	
	АбсЦвет = Новый Цвет(АбсЦветКрасный, АбсЦветЗеленый, АбсЦветСиний);
	УстановитьАбсолютныйЦвет(АбсЦвет);
	
	ЦветWeb = БНСП_ОбщМетоды.НайтиWebЦвет(АбсЦвет);
	ЦветПриИзмененииНаСервере(Элементы.ЦветWeb, ЦветWebТекущий, ЦветWeb);
	ЦветWebТекущий = ЦветWeb;
	
	ЦветСтиля = БНСП_ОбщМетоды.НайтиЦветСтиля(АбсЦвет);
	ЦветПриИзмененииНаСервере(Элементы.ЦветСтиля, ЦветСтиляТекущий, ЦветСтиля);
	ЦветСтиляТекущий = ЦветСтиля;
	
	ЦветWindows = БНСП_ОбщМетоды.НайтиWindowsЦвет(АбсЦвет);
	ЦветПриИзмененииНаСервере(Элементы.ЦветWindows, ЦветWindowsТекущий, ЦветWindows);
	ЦветWindowsТекущий = ЦветWindows;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьАбсолютныйЦвет(Цвет)
	
	АбсЦвет = БНСП_ОбщМетоды.ОпределитьАбсолютныйЦвет(Цвет);
	
	АбсЦветКрасный = АбсЦвет.Красный;
	АбсЦветЗеленый = АбсЦвет.Зеленый;
	АбсЦветСиний = АбсЦвет.Синий;
	
	Элементы.ОбразецЦвета.ЦветФона = АбсЦвет;
	Элементы.ОбразецЦвета.ЦветРамки =
		Новый Цвет(
			Макс(АбсЦветКрасный - 51, 0),
	        Макс(АбсЦветЗеленый - 51, 0),
			Макс(АбсЦветСиний - 51, 0));
	
КонецПроцедуры

#КонецОбласти