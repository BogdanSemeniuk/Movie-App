//
//  MovieDetailsSupport.swift
//  Movie App
//
//  Created by Богдан Семенюк on 11.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation

private let genreManager = GenreManager()

func createGenresString(genresId: [Int]) -> String {
    return "Genres: " + genresId.map({ id in
        genreManager.getGenreName(id: id)
    }).joined(separator: ", ")
}

func createYearString(date: String) -> String {
    let year = date.prefix(4)
    return "Release year: " + year
}

func createPosterURL(path: String) -> URL? {
    let url = URL(string: "http://image.tmdb.org")
    let path = "t/p/w342/" + path
    let posterPath = URL(string: path, relativeTo: url!)
    return posterPath
}

func createBackdropURL(path: String) -> URL? {
    let url = URL(string: "http://image.tmdb.org")
    let path = "t/p/w300/" + path
    let backdropPath = URL(string: path, relativeTo: url!)
    return backdropPath
}

func createBudgetString(budget: Int?) -> String {
    guard let movieBudget = budget, movieBudget != 0 else {return ""}
    return "Budget: \(movieBudget) $"
}

func createCountriesString(countries: [Country]?) -> String {
    guard let movieCountries = countries, !movieCountries.isEmpty else {return ""}
    let countries = movieCountries.map { (country) -> String in
        return country.name
        }.joined(separator: ", ")
    return "Countries: " + countries
}

func createDirectorsString(crew: [Worker]?) -> String {
    guard let crew = crew else {return "Directors: "}
    let string = crew.filter {$0.job == "Director"}.map {$0.name}.joined(separator: ", ")
    return "Directors: " + string
}

func createActorsString(cast: [Actor]?) -> String {
    guard let cast = cast else {return "Actors: "}
    let string = cast.filter {$0.order <= 8}.map {$0.name}.joined(separator: ", ")
    return "Actors: " + string
}

