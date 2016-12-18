### Процессор, реализующий измененную ГСА №7 и ГСА №4

#### Описание

Процессор, состоящий из управляющего автомата P-типа с естественной адресацией и операционного автомата типа I. 

Реализует: 
* операцию деления двух знаковых чисел без восстановления остатка по измененной ГСА №7;
* операцию умножения двух знаковых чисел

Данный процессор является реализацией задания курсовой работы.

#### Характеристики
Общая разрядность портов:
* `D1` - 2N разрядов
* `D2` - N разрядов
* Порт результата `R` разбит на `RL` и `RH` (`low` и `high` соответственно) по N бит каждый

Разрядность портов при делении:
* `D1` - все разряды
* `D2` - все разряды
* `RL` - результат деления
* `RH` - не используется (на выходе - `Z`)

Разрядность портов при умножении:
* `D1` - используется младшая половина разрядов, старшая половина **игнорируется**!
* `D2` - все разряды
* `RL` - результат умножения, младшая часть
* `RH` - результат умножения, старшая часть

Появление результата:
* Появление результата на выходе `R` происходит в момент окончания вычислений. До этого момента на выходе висит `Z`. 