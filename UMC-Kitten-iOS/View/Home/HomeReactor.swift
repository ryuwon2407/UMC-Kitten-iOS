//
//  HomeReactor.swift
//  UMC-Kitten-iOS
//
//  Created by DOYEON LEE on 2/6/24.
//

import UIKit

import ReactorKit

class HomeReactor: Reactor {
    
    let postRepository: PostRxRemoteRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = PostRxRemoteRepository(repository: postRepository)
    }
    
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case setRegisteredPets(pets: [PetModel])
        case setPopularPosts(posts: [PostModel])
        case setTodayFeeds(posts: [PostModel])
    }
    
    struct State {
        var registeredPets: [PetModel] = []
        var popularPosts: [PostModel] = []
        var todayFeeds: [PostModel] = []
    }
    
    let initialState: State = State()
}

extension HomeReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            
            // 등록된 반려동물 정보 받아오기
            let petObservable = Observable.just(Mutation.setRegisteredPets(pets: [
//                .init(name: "치즈", species: "고양이", gender: "수컷", age: 2),
//                .init(name: "고등어", species: "고양이", gender: "수컷", age: 4),
            ]))

            
            // 인기 게시글 받아오기
            let postObservable = postRepository
                .getAllPostByBoard(baordType: .boast, page: 1) // FIXME: 추후 포스트타입 수정
                .map { Mutation.setPopularPosts(posts: $0) }
                .catch { error in
                    print("Error loading popular posts:", error)
                    return Observable.empty()
                }
            
            // 오늘의 피드 받아오기
            let feedObservable = postRepository
                .getAllPostByBoard(baordType: .boast, page: 1) // FIXME: 추후 포스트타입 수정
                .map { Mutation.setTodayFeeds(posts: $0) }
                .catch { error in
                    print("Error loading popular posts:", error)
                    return Observable.empty()
                }
            
            return Observable.merge([petObservable, postObservable, feedObservable])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setRegisteredPets(pets):
            state.registeredPets = pets
            return state
        case let .setPopularPosts(posts):
            state.popularPosts = posts
            return state
        case let .setTodayFeeds(posts):
            state.todayFeeds = posts
            return state
            
        }
        
    }
}

