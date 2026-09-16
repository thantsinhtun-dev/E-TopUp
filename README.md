# Mobile Top Up

A SwiftUI mobile top-up app for Myanmar telecom operators (MPT, ATOM, Mytel, MECtel, U9).

## Features

- Auto operator detection from phone number prefix (offline)
- Top-up, data, voice, and combo plans per operator
- Recharge with animated result screen (success / pending / failed)
- Transaction history with search, filters, and sorting
- SwiftData local persistence
- MVVM architecture, Poppins typography, dark mode support

## Project Structure

```
iOSCodeTestKBZ/
├── iOSCodeTestKBZApp.swift     App entry, container setup
├── AppState.swift              Composition root
├── ContentView.swift           Root tab view
├── CommonUI/                   Shared components
├── Extensions/                 Fonts, constants
├── Features/
│   ├── TopUp/
│   │   ├── TopUpScreen.swift
│   │   ├── ViewModels/
│   │   ├── Views/              Plan section, result screen
│   │   └── Cells/              Plan card
│   └── History/
│       ├── HistoryScreen.swift
│       ├── ViewModels/
│       ├── Views/              Filter sheet, detail screen
│       └── Cells/              Transaction row
├── Models/                     SwiftData model, packages, enums, filters
├── Resources/                  Fonts, assets, launch storyboard
└── Services/                   Service protocol, local impl, detection
```

## Requirements

- Xcode 26+
- iOS 26.5+

## Run

Open `iOSCodeTestKBZ.xcodeproj` and press **Cmd+R**. No setup or API keys needed.
