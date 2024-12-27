
import  SwiftUI

struct QuoteView: View {
    let quote: Quote
    @State private var isFavorite: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(quote.text)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            Text(quote.reference)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 30) {
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                
                Button(action: shareQuote) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .padding()
    }
    
    private func shareQuote() {
        let shareText = "\(quote.text)\n- \(quote.reference)"
        let av = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}
