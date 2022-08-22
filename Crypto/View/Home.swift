//
//  Home.swift
//  Crypto
//
//  Created by Calum Haddow on 18/08/2022.
//

import SDWebImageSwiftUI
import SwiftUI


struct Home: View {
    
    @State private var currentCoin: String = "BTC"
    @Namespace private var animation
    @StateObject var appModel: AppViewModel = AppViewModel()
    
    var body: some View {
        
        VStack {
            if let coins = appModel.coins, let coin = appModel.currentCoin {
                // MARK: Sample UI
                HStack(spacing: 15) {
                    
                    AnimatedImage(url: URL(string: coin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(coin.name)
                            .font(.callout)
                        Text(coin.symbol.uppercased())
                            .font(.caption)
                            .foregroundColor(.gray)
                    } // End of Nested VStack
                    
                } // End of HStack
                .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomControl(coins: coins)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(coin.current_price.convertToCurrency())
                        .font(.largeTitle.bold())
                    
                    // MARK: Profit/Loss
                    Text("\(coin.price_change > 0 ? "+" : "")\(String(format: "%.2f", coin.price_change))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(coin.price_change < 0 ? .white : .black)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .background {
                            Capsule()
                                .fill(coin.price_change < 0 ? .red : Color("LightGreen"))
                        }
                    
                } // End of VStack
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
                GraphView(coin: coin)
                
                Controls()
            } else {
                ProgressView()
                    .tint(Color("LightGreen"))
            }
        } // End of VStack
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: Line Graph
    @ViewBuilder
    func GraphView(coin: CryptoModel) -> some View {
        GeometryReader { _ in
            LineGraph(data: coin.last_7days_price.price, profit: coin.price_change > 0)
        }
        .padding(.vertical,30)
        .padding(.bottom,20)
    }
    
    
    // MARK: Custom Segmented Control
    @ViewBuilder
    func CustomControl(coins: [CryptoModel]) -> some View {
        // SAMPLE DATA
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(coins) { coin in
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentCoin == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical,6)
                        .padding(.horizontal,10)
                        .contentShape(Rectangle())
                        .background{
                            if currentCoin == coin.symbol.uppercased() {
                                Rectangle()
                                    .fill(Color("Tab"))
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            appModel.currentCoin = coin
                            withAnimation { currentCoin = coin.symbol.uppercased()}
                        } // End of Tap Gesture
                    
                } // End of For Each
            } // End of HStack
            
        } // End of ScrollView
        .background {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color.white.opacity(0.2),lineWidth:1)
        }
        .padding(.vertical)
    
    } // End of Custom Control
 
    // MARK: Controls
    
    @ViewBuilder
    func Controls() -> some View {
        HStack(spacing: 20) {
            Button {} label: {
                Text("Sell")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white)
                    }
                
            } // End of Sell Button
            
            Button {} label: {
                Text("Buy")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color("LightGreen"))
                    }
                
            } // End of Buy Button
            
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension Double {
    
    func convertToCurrency()->String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: self)) ?? ""
    }
    
}
