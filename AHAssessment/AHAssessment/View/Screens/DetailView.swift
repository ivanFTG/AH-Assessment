import SwiftUI

struct DetailView: View {
    @State var viewModel: DetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                imageView()

                if viewModel.isLoading {
                    briefView()
                        .redacted(reason: .placeholder)

                    moreInfoView()
                        .redacted(reason: .placeholder)
                } else {
                    briefView()

                    moreInfoView()
                }
            }
            .padding()
        }
        .animation(.easeInOut, value: viewModel.image)
        .animation(.easeInOut, value: viewModel.isLoading)
        .background(Color.appCellBackground)
    }

    private func imageView() -> some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ZStack {
                    Color.appBackground

                    ProgressView()
                        .foregroundStyle(Color.appSecondary)
                        .scaleEffect(2)
                }
            }
        }
        .frame(height: 320)
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.appSecondary.opacity(0.15), lineWidth: 1)
        )
        .shadow(radius: 3, y: 2)
    }

    private func briefView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            let detail = viewModel.detailItem
            Text(detail.briefTitle)
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal)
                .padding(.top)

            labelsRow(title: "Brief Subtitle:", text: detail.briefSubtitle)
                .padding(.horizontal)

            labelsRow(title: "Brief Description:", text: detail.briefDescription)
                .padding(.horizontal)

            labelsRow(title: "Date:", text: detail.date)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.appBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.appSecondary.opacity(0.12), lineWidth: 1)
        )
        .shadow(radius: 3, y: 2)
    }

    private func moreInfoView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            let detail = viewModel.detailItem
            Text("More information")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal)
                .padding(.top)

            if let dimensions = detail.dimensions {
                labelsRow(title: "Dimensions:", text: dimensions)
                    .padding(.horizontal)
            }

            if let location = detail.location {
                labelsRow(title: "Location: ", text: location)
                    .padding(.horizontal)
            }

            if let description = detail.description {
                labelsRow(title: "Description:", text: description)
                    .padding(.horizontal)
                    .padding(.bottom)
            }

            if detail.dimensions == nil, detail.location == nil, detail.description == nil {
                Text("We could not find any more information.")
                    .font(.body)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.appBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.appSecondary.opacity(0.12), lineWidth: 1)
        )
        .shadow(radius: 3, y: 2)
    }

    func labelsRow(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color.appTextPrimary)

            Text(text)
                .font(.body)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DetailView(viewModel: DetailViewModel(idUrl: "https://id.rijksmuseum.nl/200321046"))
}
