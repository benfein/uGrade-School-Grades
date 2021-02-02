//
//  EditLetters.swift
//  uGrade
//
//  Created by Ben Fein on 12/6/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
import SwiftUI
struct EditLetters: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var letters: [[String]]
    @State var error = [[String]]()
    @State var str = ""
    @State var showError = false
    func isDup(input: [[String]]) -> [[String]]{
        var sorted = input
        error = [[String]]()
        sorted.sort(by: {$0[0] <= $1[0]})
        for i in 1...sorted.count-1{
            if(sorted[i-1][1] > sorted[i][0]){
                if(error.contains([sorted[i][0],sorted[i-1][1]]) == false){
                error.append([sorted[i][0],sorted[i][1]])
                }
            }
        }
        let crossReference = Dictionary(grouping: sorted, by: { $0[0] })
        let crossReferences = Dictionary(grouping: sorted, by: { $0[1] })
        let duplicates = crossReference
            .filter { $1.count > 1}
        let duplicates2 = crossReferences
            .filter { $1.count > 1}
        for i in duplicates{
            error.append(["\(i.key)","\(i.key)"])
        }
        for i in duplicates2{
            error.append(["\(i.key)","\(i.key)"])
        }
        return error
    }
    var body: some View {
        NavigationView{
        VStack{
            if #available(iOS 14.0, *) {
                List{
                    ForEach(0..<letters.count){ i in
                        Section{
                            HStack{
                                TextField("Letter", text: $letters[i][2])
                                    .font(.subheadline)
                                Spacer()
                                Text("From: ")
                                TextField("From", text: $letters[i][0])
                                    .keyboardType(.decimalPad)
                                Text("To: ")
                                TextField("To", text: $letters[i][1])
                                    .keyboardType(.decimalPad)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
            } else {
                // Fallback on earlier versions
                List{
                    ForEach(0..<letters.count){ i in
                        Section{
                            HStack{
                                TextField("Letter", text: $letters[i][2])
                                    .font(.subheadline)
                                Spacer()
                                Text("From: ")
                                TextField("From", text: $letters[i][0])
                                Text("To: ")
                                TextField("To", text: $letters[i][1])
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
        }
        }
        .navigationBarTitle("Update Letters")
        .navigationBarItems(trailing:
            HStack{
            Button(action: {
                let res = isDup(input: letters)
                if(res.count == 0){
                    let ns = UserDefaults()
                    ns.setValue(letters, forKey: "letters")
                    self.mode.wrappedValue.dismiss()
                }else{
                    str = ""
                    for i in 0...res.count-1{
                        str.append("\n")
                        if(res[i][0] == res[i][1]){
                            str.append("• You have multiple \(res[i][0]) set for your letters.")
                        } else{
                    str.append("• You have multiple values in the range \(res[i][0]) - \(res[i][1]) set for your letters.")
                    }
                    }
                    showError = true
                }
            }) {
                Text("Update")
            }.alert(isPresented: $showError) {
                Alert(title: Text("Duplicate Entries"), message: Text(str).fontWeight(.semibold), dismissButton: .default(Text("Confirm")))
            }
        })
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    }
struct EditLetters_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var demoLetters: [[String]] = [["93","100","A"], ["90","93","A-"], ["87","90", "B+"],["83","87","B"],["80","83","B-"], ["77","80", "C+"], ["71","77", "C"], ["67","71","C-"], ["63","67","D+"], ["60", "63","D-"], ["0","60","F"]]
        return EditLetters(letters: demoLetters).environment(\.managedObjectContext, context)
    }
}
