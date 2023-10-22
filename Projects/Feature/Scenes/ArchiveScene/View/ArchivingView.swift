//
//  ArchivingView.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import Core

struct ArchivingView: View {
  @Query var likeArtist: [LikeArtist]
  @Query var concertInfo: [ArchivedConcertInfo]
  @ObservedObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext

  var body: some View {
    VStack(alignment: .leading) {
      Button("Test\(concertInfo.count)") { testAddConcertCode() }
      Button("DeleteALL") { testDeleteConcertAllData() }
      archivingArtistView
      blockView
    }
    .padding()
    .edgesIgnoringSafeArea(.bottom)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) { Text("아카이빙").font(.title) }
    }
    .onAppear { dataManager.modelContext = modelContext }
  }

  private var archivingArtistView: some View {
    ScrollView(.horizontal) {
      HStack {
        if likeArtist.count == 0 { emptyLikeCell }
        if likeArtist.count > 1 { seeAllCell }
        likedArtistCell
      }
    }
    .scrollIndicators(.hidden)
    .disabled(likeArtist.isEmpty)
  }

  private var seeAllCell: some View {
    NavigationLink {
      SeeAllArtist()
    } label: {
      VStack {
        RoundedRectangle(cornerRadius: 20)
          .foregroundStyle(.black)
          .frameForCell()
          .overlay {
            Text("All")
              .foregroundStyle(.white)
          }
        Text("전체보기")
          .foregroundStyle(.black)
      }
    }
  }

  private var emptyLikeCell: some View {
      VStack {
        RoundedRectangle(cornerRadius: 20)
          .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
          .frameForCell()
          .overlay {
            Image(systemName: "heart")
          }
        Text("좋아요한 아티스트")
          .font(.system(size: 12))
      }
  }

  private var likedArtistCell: some View {
    ForEach(likeArtist) { item in
      VStack {
        NavigationLink {

        } label: {
          ArchiveArtistCell(artistUrl: URL(string: item.artistInfo.imageUrl)!, isNewUpdate: false)
        }
        Text("\(item.artistInfo.name)")
      }
    }
  }

  private var blockView: some View {
    Group {
      if concertInfo.isEmpty {
        blockIsEmptyView
      } else {
        ArchivingConcertBlockView()
      }
    }
  }

  private var blockIsEmptyView: some View {
    VStack {
      Image(systemName: "bookmark")
        .font(.largeTitle)
      Text("찜한 공연이 없어요")
        .font(.system(size: 16))
        .fontWeight(.semibold)
      Text("내가 좋아하는 아티스트의 공연을 찜하고\n세트리스트를 확인해보세요")
        .multilineTextAlignment(.center)
        .font(.system(size: 13))
    }
  }
}

#Preview {
  ArchivingView()
    .modelContainer(for: LikeArtist.self, inMemory: false)
    .modelContainer(for: ArchivedConcertInfo.self, inMemory: false)
}

// MARK: - TestCode 적발시 삭제 요망
extension ArchivingView {
  func testAddConcertCode() {
    let random = Int.random(in: 10...23)
    dataManager.addArchivedConcertInfo(SaveArtistInfo(name: "Sibal", country: "NorthKorea", alias: "123", mbid: "123", gid: 123, imageUrl: "https://newsimg.sedaily.com/2019/10/11/1VPHATB1H9_1.jpg", songList: []),
                                       SaveSetlist(setlistId: "123", date: "20-10-20\(random)", venue: "Seoul", title: "DummyTitle"))
  }

  func testDeleteConcertAllData() {
    do {
      try modelContext.delete(model: ArchivedConcertInfo.self)
    } catch {
      print("Failed to delete students.")
    }
  }
}
