# News App - Flutter

## Features

**News List**: Display top headlines from News API
**Category Filtering**: Filter news by Business, Entertainment, General, Health
**Search**: Search news articles with API or local search (offline)
**Article Details**: View full article details with image, title, source, author, and description
**Pull to Refresh**: Refresh news list by pulling down
**Offline Support**: Local search when no internet connection
**Loading States**: Shimmer loading animation
**Error Handling**: Graceful error handling with retry option

## Architecture

This app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
    core/
    constants/       
    di/             
    error/          
        network/       
    data/
    datasources/    
    models/         
        repositories/   
    domain/
    entities/       
    repositories/   
        usecases/       
    presentation/
        bloc/           
        pages/               
        widgets/        
```


###  Install Dependencies

```bash
cd flutter_news_app
flutter pub get
```

###  Run the App

```bash
flutter run
```

## Dependencies

`flutter_bloc` 
`equatable` 
`dio` 
`connectivity_plus`
`get_it`
`cached_network_image`
`shimmer` 
`google_fonts`
`dartz`

## Design

Navy blue (#1B365D) primary color
Light gray (#F5F7FA) background
Card-based article layout
Rounded corners and subtle shadows
Smooth animations and transitions

