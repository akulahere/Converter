//
//  ContentView.swift
//  Converter
//
//  Created by Dmytro Akulinin on 01.08.2022.
//

import SwiftUI

struct ContentView: View {
  @State private var input = 100.0
  @State private var inputUnit: Dimension = UnitLength.meters
  @State private var outputUnit: Dimension = UnitLength.yards
  @State var selectedUnits = 0

  let units: [UnitLength] = [.feet, .kilometers, .meters, .miles, .yards]
  let formatter: MeasurementFormatter
  let conversions = ["Distance", "Mass", "Temperature", "Time"]
  let unitTypes = [
    [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles],
    [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds],
    [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
    [UnitDuration.hours, UnitDuration.minutes, UnitDuration.seconds]
  ]
  
  @FocusState private var inputIsFocused: Bool

  init() {
    formatter = MeasurementFormatter()
    formatter.unitOptions = .providedUnit
    formatter.unitStyle = .long
  }
  
  var result: String {
    let inputMeasurement = Measurement(value: input, unit: inputUnit)
    let outputMeasurement = inputMeasurement.converted(to: outputUnit)
    return formatter.string(from: outputMeasurement)
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Amount", value: $input, format: .number)
            .keyboardType(.decimalPad)
        } header: {
          Text("Amount to convert")
        }
        .focused($inputIsFocused)

        Picker("Conversion", selection: $selectedUnits) {
          ForEach(0..<conversions.count) {
            Text(conversions[$0])
          }
        }
        
        Picker("Convert from", selection: $inputUnit) {
          ForEach(unitTypes[selectedUnits], id: \.self) {
            Text(formatter.string(from: $0).capitalized)
          }
        }
        
        Picker("Convert to", selection: $outputUnit) {
          ForEach(unitTypes[selectedUnits], id: \.self) {
            Text(formatter.string(from: $0).capitalized)
          }
        }
        
        Section {
          Text(result)
        } header: {
          Text("Result")
        }

      }
      .navigationTitle("Converter")
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          
          Button("Done") {
            inputIsFocused = false
          }
        }
      }
      .onChange(of: selectedUnits) { newSelection in
        let units = unitTypes[newSelection]
        inputUnit = units[0]
        outputUnit = units[1]
      }
    }
    
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
