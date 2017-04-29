//
//  ItunesAPIClient.swift
//  ItunesAPISearch
//
//  Created by James Rochabrun on 4/29/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

class ItunesAPIClient {
    
    let downloader = JSONDownloader()
    
    typealias ArtistsCompletionHandler = ([Artist], ItunesError?) -> ()
    func searchForArtists(withTerm term: String, completion: @escaping ArtistsCompletionHandler) {
        
        let endpoint = Itunes.search(term: term, media: .music(entity: .musicArtist, attribute: .artistTerm))
        performRequest(with: endpoint) { (results, error) in
            
            guard let results = results else {
                completion([], error)
                return
            }
            let artists = results.flatMap{ Artist(json: $0) }
            completion(artists, nil)
        }
    }
    
    typealias ArtistCompletionHandler = (Artist?, ItunesError?) -> ()
    func lookUpArtist(withID id: Int, completion: @escaping ArtistCompletionHandler) {
        
        let endpoint = Itunes.lookUP(id: id, entity: MusicEntity.album)
        performRequest(with: endpoint) { (results, error) in
            
            guard let results = results else {
                completion(nil, error)
                return
            }
            guard let artistInfo = results.first else {
                completion(nil, .jsonParsingFailure(message: "Results does not contain artist info"))
                return
            }
            guard let artist = Artist(json: artistInfo) else {
                completion(nil, .jsonParsingFailure(message: "Could not parse artist info"))
                return
            }
            let albumResults = results[1..<results.count] //0 index shows artits info, 1 and beyound album info
            let albums = albumResults.flatMap{ Album(json: $0) }
            artist.albums = albums
            completion(artist, nil)
            
        }
    }
    
    typealias AlbumCompletion = (Album?, ItunesError?) -> ()
    func lookUpAlbum(withID id: Int, completion: @escaping AlbumCompletion)  {
        
        let endpoint = Itunes.lookUP(id: id, entity: MusicEntity.song)
        performRequest(with: endpoint) { (results, error) in
            guard let results = results else {
                completion(nil, error)
                return
            }
            guard let albumInfo = results.first else {
                completion(nil, .jsonParsingFailure(message: "results does not contain album info"))
                return
            }
            guard let album = Album(json: albumInfo) else {
                completion(nil, .jsonParsingFailure(message: "could not parse album info"))
                return
            }
            let songResults = results[1..<results.count]
            let songs = songResults.flatMap{ Song(json: $0) }
            album.songs = songs
            completion(album, nil)
        }
    }
}

//MARK: - HELPER METHODS
extension ItunesAPIClient {
    
    typealias Results = [[String: Any]]
    typealias RequestCompletion = (Results?, ItunesError?) -> ()
    
    func performRequest(with endpoint: Endpoint, completion: @escaping RequestCompletion) {
        let task = downloader.jsonTask(with: endpoint.request) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                guard let results = json["results"] as? [[String: Any]] else {
                    completion(nil, .jsonParsingFailure(message:"json does not contain results"))
                    return
                }
                completion(results, nil)
            }
        }
        task.resume()
    }
}










