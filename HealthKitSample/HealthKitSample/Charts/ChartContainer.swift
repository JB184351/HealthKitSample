//
//  ChartContainer.swift
//  HealthKitSample
//
//  Created by Justin on 7/8/24.
//

import SwiftUI

struct ChartContainerConfiguration {
    let title: String
    let symbol: String
    let subtitle: String
    let context: HealthMetricContext
    let isNav: Bool
}

struct ChartContainer<Content: View>: View {
    let config: ChartContainerConfiguration
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            if config.isNav {
                navgiationLinkView
            } else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            
            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))

    }
    
    var navgiationLinkView: some View {
        NavigationLink(value: config.context) {
            HStack {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Label(config.title, systemImage: config.symbol)
                .font(.title3.bold())
                .foregroundStyle(config.context == .steps ? .pink : .indigo)
            
            Text(config.subtitle)
                .font(.caption)
        }
    }
}

#Preview {
    ChartContainer(config: .init(title: "Test Title", symbol: "figure.walk", subtitle: "Test Subtitle", context: .steps, isNav: true)) {
        Text("Chart goes here")
            .frame(minHeight: 150)
    }
}
