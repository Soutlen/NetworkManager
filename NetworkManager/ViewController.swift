//
//  ViewController.swift
//  NetworkManager
//
//  Created by Евгений Глоба on 12/1/24.
//
import UIKit

class ViewController: UIViewController {
    //Таблица
    lazy var tableView: UITableView = {
        let table = UITableView ()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        return table
    }()
    // пояснить что это такое
    var dataSource: [CharacterResult] = []
    var locationsDataSource: [LocationResult] = []
    var episodeDataSource: [EpisodeResult] = []
    
    //работа с сетью
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.backgroundColor = .gray
        
        //констрейны для таблицы
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        obtainCharacter()
        obtainLocation()
        obtainEpisode()
    }
    
    func obtainCharacter() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return }
        
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            
            if error == nil, let parsData = data {
                do {
                    let character = try strongSelf.decoder.decode(Character.self, from: parsData)
                    strongSelf.dataSource = character.results
                    
                    DispatchQueue.main.async {
                        strongSelf.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Something whent wrong")")
            }
        }.resume()
    }
    
    func obtainLocation() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/location") else { return }
        
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            
            if error == nil, let parsData = data {
                do {
                    let location = try strongSelf.decoder.decode(LocationAPI.self, from: parsData)
                    strongSelf.locationsDataSource = location.results
                    
                    // Здесь обновляем данные в ячейках
                    DispatchQueue.main.async {
                        strongSelf.tableView.reloadData()
                    }
                    
                } catch {
                    print("Error decoding additional data: \(error.localizedDescription)")
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Something went wrong")")
            }
        }.resume()
    }
    
    func obtainEpisode() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else { return }
        
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            
            if error == nil, let parsData = data {
                do {
                    let episode = try strongSelf.decoder.decode(Episode.self, from: parsData)
                    strongSelf.episodeDataSource = episode.results
                    
                    DispatchQueue.main.async {
                        strongSelf.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding additional data: \(error.localizedDescription)")
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Something went wrong")")
            }
        }.resume()
    }
}
    
    extension ViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return min(dataSource.count, locationsDataSource.count, episodeDataSource.count)
        }
        //MARK: UITableViewDataSource
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard indexPath.row < dataSource.count,
                  indexPath.row < locationsDataSource.count,
                  indexPath.row < episodeDataSource.count else {
                return UITableViewCell()
            }
            let characteModel = dataSource[indexPath.row]
            let locationModel = locationsDataSource[indexPath.row]
            let episodeModel = episodeDataSource[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: characteModel, andLocation: locationModel, andEpisode: episodeModel)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension // динамическая высота
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100 //Оценочная высота, можно выбрать любое значение
        }
    }
    
    // MARK: CustomTableViewCell
    class CustomTableViewCell: UITableViewCell{
        
        let characterImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
        
        let titleLabelOne: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .right
            label.numberOfLines = 0 //многострочный текст
            label.font = UIFont.boldSystemFont(ofSize: 25)
            label.textColor = UIColor.white
            return label
        }()
        
        let titleLabelTwo: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .right
            label.numberOfLines = 0
            label.textColor = UIColor.lightGray
            return label
        }()
        
        let titleLabelThree: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .right
            label.numberOfLines = 0
            label.textColor = UIColor.lightGray
            return label
        }()
        
        let subTitleLabelOne: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .right
            label.numberOfLines = 0
            label.textColor = UIColor.white
            return label
        }()
        
        let subTitleLabelTwo: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .right
            label.numberOfLines = 0
            label.textColor = UIColor.white
            return label
        }()
        
        let subTitleLabelThree: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .right
            label.numberOfLines = 0
            label.textColor = UIColor.white
            return label
        }()
        //устанавливем радиусы ячейкам
        override func layoutSubviews() {
            super.layoutSubviews()
            
            self.contentView.layer.cornerRadius = 15
            self.contentView.layer.masksToBounds = true
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            // цвет фона
            contentView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            
            contentView.addSubview(characterImageView)
            contentView.addSubview(titleLabelOne)
            contentView.addSubview(titleLabelTwo)
            contentView.addSubview(titleLabelThree)
            contentView.addSubview(subTitleLabelOne)
            contentView.addSubview(subTitleLabelTwo)
            contentView.addSubview(subTitleLabelThree)
            
            //Установка констрейнов
            NSLayoutConstraint.activate([
                characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                characterImageView.widthAnchor.constraint(equalToConstant: 80),
                characterImageView.heightAnchor.constraint(equalToConstant: 80),
                characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
            
            NSLayoutConstraint.activate([
                titleLabelOne.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
                titleLabelOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                titleLabelOne.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
            ])
            
            NSLayoutConstraint.activate([
                subTitleLabelOne.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
                subTitleLabelOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                subTitleLabelOne.topAnchor.constraint(equalTo: titleLabelOne.bottomAnchor, constant: 5),
                subTitleLabelOne.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
            ])
            
            NSLayoutConstraint.activate([
                titleLabelTwo.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
                titleLabelTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                titleLabelTwo.topAnchor.constraint(equalTo: subTitleLabelOne.bottomAnchor, constant: 5),
                titleLabelTwo.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
            ])
            
            NSLayoutConstraint.activate([
                subTitleLabelTwo.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
                subTitleLabelTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                subTitleLabelTwo.topAnchor.constraint(equalTo: titleLabelTwo.bottomAnchor, constant: 5),
                subTitleLabelTwo.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
            ])
            
            NSLayoutConstraint.activate([
                titleLabelThree.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
                titleLabelThree.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                titleLabelThree.topAnchor.constraint(equalTo: subTitleLabelTwo.bottomAnchor, constant: 5),
                titleLabelThree.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
            ])
            
            NSLayoutConstraint.activate([
                subTitleLabelThree.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
                subTitleLabelThree.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                subTitleLabelThree.topAnchor.constraint(equalTo: titleLabelThree.bottomAnchor, constant: 5),
                subTitleLabelThree.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with character: CharacterResult, andLocation location: LocationResult, andEpisode episode: EpisodeResult) {
            
            characterImageView.loadImage(from: character.image)
            titleLabelOne.text = character.name
            subTitleLabelOne.text = "\(character.status) - \(character.species)"
            titleLabelTwo.text = "Last know location:"
            subTitleLabelTwo.text =  location.name
            titleLabelThree.text = "Firat seen in:"
            subTitleLabelThree.text = episode.name
        }
        
    }
    
    //Extension для загрузки ищображения из URL
    extension UIImageView {
        func loadImage(from urlString: String) {
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
