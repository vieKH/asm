# Anomaly Detection for Network Intrusions (UNSW-NB15)

## Описание проекта

Этот проект реализует систему обнаружения аномалий в сетевом трафике на основе датасета UNSW-NB15. Используются современные алгоритмы машинного обучения без учителя: **Isolation Forest**, **Local Outlier Factor** и **One-Class SVM**.

### Особенности проекта
- 🔧 **Production-готовый код** с модульностью, логированием и конфигурационными файлами
- 🤖 **AI-ассистенты** для планирования и разработки
- 📊 **Комплексная аналитика** с EDA и визуализацией результатов
- 🛡️ **Фокус на кибербезопасность** - специализация под сетевые атаки

## Структура проекта

```
lab1_UNSW-NB15/
├── data/                                  # Датасет (скачать отдельно)
│   ├── UNSW_NB15_training-set.csv
│   └── UNSW_NB15_testing-set.csv
├── notebooks/                             # Jupyter notebooks
│   └── anomaly_detection_unsw_nb15.ipynb  # Полный цикл анализа
├── scripts/                               # CLI инструменты
│   └── anomaly_cli.py                     # Командная строка
├── config/                                # Конфигурация
│   └── config.yaml                        # Параметры моделей и путей
├── artifacts/                             # Результаты (создается автоматически)
│   ├── models/                            # Обученные модели
│   ├── reports/                           # Отчеты и метрики
│   └── eda/                              # Результаты EDA
├── logs/                                  # Логи выполнения
├── docs/                                  # Документация (создать самостоятельно)
│   ├── planning_session.md               # Диалог планирования с AI
│   ├── architecture_decisions.md         # Архитектурные решения
│   └── ai_prompts_log.md                # Ключевые промпты
├── requirements.txt                       # Python зависимости
└── README.md                             # Этот файл
```

## Установка и настройка

### 1. Создание виртуального окружения
```bash
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# или
venv\Scripts\activate     # Windows
```

### 2. Установка зависимостей
```bash
pip install -r requirements.txt
```

## Использование

### CLI Команды

#### 1. Разведочный анализ данных (EDA)
```bash
python scripts/anomaly_cli.py eda --config config/config.yaml --sample-size 10000
```
- Создает графики распределений признаков
- Анализирует корреляции и выбросы  
- Генерирует HTML отчет
- Результаты сохраняются в `artifacts/eda/`

#### 2. Обучение модели
```bash
# Isolation Forest (рекомендуется)
python scripts/anomaly_cli.py train --config config/config.yaml --model-type isolation-forest

# Local Outlier Factor
python scripts/anomaly_cli.py train --config config/config.yaml --model-type lof

# One-Class SVM
python scripts/anomaly_cli.py train --config config/config.yaml --model-type one-class-svm
```
- Обучает выбранную модель на тренировочных данных
- Сохраняет модель в `artifacts/models/`
- Создает файл метаданных с параметрами

#### 3. Детекция аномалий
```bash
python scripts/anomaly_cli.py detect \
    --config config/config.yaml \
    --model-path artifacts/models/isolation-forest_model.joblib \
    --input-file data/UNSW_NB15_testing-set.csv \
    --output-file artifacts/predictions.csv
```
- Применяет обученную модель к новым данным
- Выводит статистику найденных аномалий
- Сохраняет результаты в CSV с anomaly scores

#### 4. Оценка качества
```bash
python scripts/anomaly_cli.py evaluate \
    --config config/config.yaml \
    --predictions-file artifacts/predictions.csv \
    --ground-truth-col label
```
- Рассчитывает метрики: Precision, Recall, F1-Score, ROC-AUC
- Создает Confusion Matrix
- Сохраняет результаты в `artifacts/reports/`

### Jupyter Notebook

Для интерактивного анализа используйте `notebooks/anomaly_detection_unsw_nb15.ipynb`:

```bash
jupyter notebook notebooks/anomaly_detection_unsw_nb15.ipynb
```

Notebook включает:
- Полный цикл EDA с визуализацией
- Сравнение трех алгоритмов anomaly detection  
- PCA визуализацию аномалий
- Консенсус анализ между моделями
- Интерпретацию результатов

## Конфигурация

Файл `config/config.yaml` содержит все настройки проекта:

### Основные секции:
- **`data`** - пути к файлам датасета
- **`features`** - группы признаков UNSW-NB15
- **`models`** - параметры алгоритмов ML
- **`training`** - настройки обучения
- **`eda`** - параметры анализа данных

### Пример настройки модели:
```yaml
models:
  isolation_forest:
    n_estimators: 200
    contamination: 0.1    # Ожидаемая доля аномалий
    max_samples: "auto"
    random_state: 42
```

## Датасет UNSW-NB15

### Характеристики
- **Размер**: ~2.5 млн записей сетевых потоков
- **Признаки**: 49 числовых и категориальных признаков
- **Классы**: Normal (0) + 9 типов атак (1)
- **Формат**: CSV с готовым разделением train/test

### Типы атак
1. **Analysis** - анализ и разведка
2. **Backdoor** - бэкдоры и трояны
3. **DoS** - атаки отказа в обслуживании
4. **Exploits** - эксплойты уязвимостей
5. **Fuzzers** - нечеткое тестирование
6. **Generic** - общие атаки
7. **Reconnaissance** - разведка сети
8. **Shellcode** - внедрение shell-кода
9. **Worms** - сетевые черви

### Ключевые признаки
- **`dur`** - длительность соединения
- **`sbytes/dbytes`** - байты source/destination
- **`spkts/dpkts`** - пакеты source/destination
- **`sttl/dttl`** - TTL source/destination
- **`sload/dload`** - нагрузка source/destination
- **`ct_*`** - контекстные счетчики соединений

## Алгоритмы

### 1. Isolation Forest 🌲
- **Принцип**: изоляция аномалий через случайные разрезы
- **Преимущества**: быстрый, масштабируемый, хорошо работает с выбросами
- **Рекомендуется для**: больших датасетов с многомерными аномалиями

### 2. Local Outlier Factor (LOF) 🎯  
- **Принцип**: плотностный анализ локального окружения
- **Преимущества**: обнаруживает локальные аномалии в кластерах
- **Рекомендуется для**: данных с неравномерной плотностью

### 3. One-Class SVM ⚙️
- **Принцип**: построение гиперплоскости вокруг нормальных данных
- **Преимущества**: теоретически обоснованный, гибкие ядра
- **Рекомендуется для**: нелинейных границ решения

## Работа с AI-ассистентами

Проект демонстрирует best practices работы с AI:

### 1. Планирование
```
Изучи датасет UNSW-NB15 для задач кибербезопасности. 
НЕ ПИШИ КОД СРАЗУ.

Создай план:
1. Какие признаки наиболее важны для детекции сетевых атак?
2. Как обрабатывать дисбаланс классов в unsupervised обучении?
3. Какие метрики лучше для оценки anomaly detection?
...
```

### 2. Итеративная разработка
- Планирование → Реализация → Ревью → Улучшение
- Документирование каждого цикла
- Богатый контекст для AI (прикрепление файлов, конфигов)

### 3. Документирование
Создайте файлы в `docs/`:
- `planning_session.md` - полный диалог планирования
- `architecture_decisions.md` - принятые решения
- `ai_prompts_log.md` - ключевые промпты и результаты

## Интерпретация результатов

### Метрики качества
- **Precision**: доля правильно найденных аномалий
- **Recall**: доля обнаруженных реальных аномалий  
- **F1-Score**: гармоническое среднее precision и recall
- **ROC-AUC**: качество ранжирования аномалий

### Пороги решения
- **Contamination**: ожидаемая доля аномалий (обычно 0.05-0.2)
- **Anomaly Score**: чем выше, тем более аномальная точка
- **Consensus**: количество моделей, считающих точку аномальной

### Анализ ошибок
- **False Positives**: нормальный трафик → аномалия (перестраховка)
- **False Negatives**: атака → нормальный (пропуск атаки)
- **Причины**: дрифт данных, новые типы атак, неоптимальные параметры

## Развитие проекта

### Краткосрочные улучшения
- [ ] Автоподбор гиперпараметров через GridSearchCV
- [ ] Ensemble методы (Voting, Stacking)
- [ ] Дополнительные алгоритмы (DBSCAN, Autoencoders)
- [ ] Интерактивные дашборды с Plotly/Streamlit

### Долгосрочные цели
- [ ] Real-time детекция на потоковых данных
- [ ] Интеграция с SIEM системами
- [ ] Федеративное обучение для распределенных сетей
- [ ] Объяснимый AI для интерпретации решений

## Лицензия и цитирование

При использовании датасета UNSW-NB15 обязательно цитируйте:

```
@article{moustafa2015unsw,
  title={UNSW-NB15: a comprehensive data set for network intrusion detection systems (UNSW-NB15 network data set)},
  author={Moustafa, Nour and Turnbull, Benjamin and Choo, Kim-Kwang Raymond},
  journal={Military Communications and Information Systems Conference (MilCIS)},
  pages={1--6},
  year={2015},
  organization={IEEE}
}
```

## Поддержка

При возникновении вопросов:
1. Проверьте логи в `logs/`
2. Убедитесь, что датасет скачан правильно
3. Проверьте соответствие versions в `requirements.txt`
4. Изучите документацию AI-процесса в `docs/`

## Авторы

Проект создан в рамках курса "Машинное обучение для задач информационной безопасности" с использованием AI-ассистентов для планирования и разработки.
