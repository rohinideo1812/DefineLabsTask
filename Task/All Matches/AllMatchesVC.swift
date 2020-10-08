//
//  AllMatchesVC.swift
//  Task
//
//  Created by Rohini Deo on 07/10/20.
//  Copyright © 2020 Taxgenie. All rights reserved.
//

import UIKit

class AllMatchesVC: UIViewController {
    
    //Mark:IBOutlets:
    @IBOutlet weak var tableView: UITableView!
    
    //Mark:Properties:
    var slideMenuVC:SideMenuVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideMenuVC = SideMenuVC()
        self.sideMenuController()?.sideMenu?.delegate = self
        
        //Mark:Register tableview cell
        self.tableView.register(UINib(nibName:"TableViewCell", bundle: nil), forCellReuseIdentifier:"TableViewCell")
        
        if Values.didFetchedDataFromAPI{
            let savedData = DataBaseHelper.shareInstance.getAllData()
            for index in 0..<Values.details.count{
                Values.details[index].isSelected = false
            }
            for index in 0..<Values.details.count{
                for eachData in 0..<savedData.count{
                    if Values.details[index].venuDetail.id == savedData[eachData].id{
                        Values.details[index].isSelected = true
                        break
                    }
                }
            }
            self.tableView.reloadData()
        }else{
            self.getData()
        }
    }
     
    @IBAction func menuBtnPressed(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    func getData(){
        let url = URL(string: "https://api.foursquare.com/v2/venues/search?ll=40.7484,-73.9857&oauth_token=NPKYZ3WZ1VYMNAZ2FLX1WLECAWSMUVOQZOIDBN53F3LVZBPQ&v=20180616")
        URLSession.shared.dataTask(with: url!){ (data,response,error) in
            do{
                if error == nil{
                    let arrData = try JSONDecoder().decode(AllMatchesModel.self, from: data!)
                    DispatchQueue.main.async {
                        for eachVenueDetail in arrData.response.venues{
                            let eachItem = MatchedItem(venuDetail: eachVenueDetail, isSelected: false)
                            Values.details.append(eachItem)
                        }
                        self.tableView.reloadData()
                    }
                    Values.didFetchedDataFromAPI = true
                }
            }catch(let error){
                print(error.localizedDescription)
            }
        }.resume()
    }
}

extension AllMatchesVC : UITableViewDelegate,UITableViewDataSource,ENSideMenuDelegate{
    func sideMenuWillOpen() {
        
    }
    
    func sideMenuWillClose() {
        
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    func sideMenuDidOpen() {
        
    }
    
    func sideMenuDidClose() {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.name.text = Values.details[indexPath.row].venuDetail.name
        cell.id.text = Values.details[indexPath.row].venuDetail.id
        cell.address.text = Values.details[indexPath.row].venuDetail.location.address
        cell.contact.text = Values.details[indexPath.row].venuDetail.contact.phone
        cell.country.text = Values.details[indexPath.row].venuDetail.location.country
        cell.saveBtn.tag = indexPath.row
        if Values.details[indexPath.row].isSelected{
            cell.saveBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            cell.saveBtn.setImage(UIImage(systemName: "star"), for: .normal)
        }
        cell.saveBtn.addTarget(self, action: #selector(self.handleSavebtn(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Values.details.count
    }
    
    @objc func handleSavebtn(_ sender:UIButton) {
        if !Values.details[sender.tag].isSelected{
            Values.details[sender.tag].isSelected = true
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            DataBaseHelper.shareInstance.saveMatchData(details:Values.details[sender.tag].venuDetail)
        }
    }
}

//{
//  "meta": {
//    "code": 200,
//    "requestId": "5f7ee760cf0cb93038a2a3dc"
//  },
//  "notifications": [
//    {
//      "type": "notificationTray",
//      "item": {
//        "unreadCount": 0
//      }
//    }
//  ],
//  "response": {
//    "venues": [
//      {
//        "id": "43695300f964a5208c291fe3",
//        "name": "Empire State Building",
//        "contact": {
//          "phone": "+12127363100",
//          "formattedPhone": "+1 212-736-3100",
//          "twitter": "empirestatebldg",
//          "instagram": "empirestatebldg",
//          "facebook": "153817204635459",
//          "facebookUsername": "empirestatebuilding",
//          "facebookName": "Empire State Building"
//        },
//        "location": {
//          "address": "350 5th Ave",
//          "crossStreet": "btwn 33rd & 34th St",
//          "lat": 40.7485995507123,
//          "lng": -73.98580648682452,
//          "distance": 23,
//          "postalCode": "10118",
//          "cc": "US",
//          "neighborhood": "Midtown Manhattan, New York, NY",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave (btwn 33rd & 34th St)",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d130941735",
//            "name": "Building",
//            "pluralName": "Buildings",
//            "shortName": "Building",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": true,
//        "stats": {
//          "tipCount": 1165,
//          "usersCount": 140263,
//          "checkinsCount": 202571
//        },
//        "url": "https://www.esbnyc.com",
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "venuePage": {
//          "id": "64514349"
//        },
//        "storeId": "",
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "4bcca12bb6c49c7422169491",
//        "name": "86th Floor Observation Deck",
//        "contact": {
//          "phone": "+12127363100",
//          "formattedPhone": "+1 212-736-3100"
//        },
//        "location": {
//          "address": "350 5th Ave",
//          "crossStreet": "btwn 33rd & 34th Sts",
//          "lat": 40.74844544481811,
//          "lng": -73.98568124187432,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74844544481811,
//              "lng": -73.98568124187432
//            }
//          ],
//          "distance": 5,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave (btwn 33rd & 34th Sts)",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d165941735",
//            "name": "Scenic Lookout",
//            "pluralName": "Scenic Lookouts",
//            "shortName": "Scenic Lookout",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/parks_outdoors/sceniclookout_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": true,
//        "stats": {
//          "tipCount": 242,
//          "usersCount": 21815,
//          "checkinsCount": 23733
//        },
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "venuePage": {
//          "id": "64514350"
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "5af44f23bcbf7a002ce0a18a",
//        "name": "Workday",
//        "contact": {},
//        "location": {
//          "address": "350 5th Ave",
//          "lat": 40.748333,
//          "lng": -73.985577,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748333,
//              "lng": -73.985577
//            }
//          ],
//          "distance": 12,
//          "postalCode": "10001",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave",
//            "New York, NY 10001",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 12,
//          "checkinsCount": 69
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "5820b92252addb0cc786c053",
//        "name": "Expedia - New York City Office",
//        "contact": {},
//        "location": {
//          "address": "350 5th Ave",
//          "lat": 40.748452,
//          "lng": -73.985595,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748452,
//              "lng": -73.985595
//            }
//          ],
//          "distance": 10,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 15,
//          "checkinsCount": 52
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "59a44ba0e97dfb37208faf41",
//        "name": "JCDecaux, NA",
//        "contact": {},
//        "location": {
//          "address": "350 Fifth Avenue, 73rd floor",
//          "lat": 40.74847232935598,
//          "lng": -73.98566846513467,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74847232935598,
//              "lng": -73.98566846513467
//            }
//          ],
//          "distance": 8,
//          "postalCode": "10001",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 Fifth Avenue, 73rd floor",
//            "New York, NY 10001",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 21,
//          "checkinsCount": 452
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "4d5ebecd1ee8721e6a189621",
//        "name": "Turkish Airlines",
//        "contact": {},
//        "location": {
//          "address": "350 5th Ave",
//          "crossStreet": "34th St.",
//          "lat": 40.7484311,
//          "lng": -73.98535061999999,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.7484311,
//              "lng": -73.98535061999999
//            }
//          ],
//          "distance": 29,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave (34th St.)",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d1f6931735",
//            "name": "General Travel",
//            "pluralName": "General Travel",
//            "shortName": "Travel",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/travel/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 1,
//          "usersCount": 39,
//          "checkinsCount": 51
//        },
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "4c446539dcd61b8d673c7b56",
//        "name": "LinkedIn New York",
//        "contact": {
//          "twitter": "linkedin"
//        },
//        "location": {
//          "address": "350 5th Ave",
//          "lat": 40.74825603958361,
//          "lng": -73.98575162136814,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74825603958361,
//              "lng": -73.98575162136814
//            },
//            {
//              "label": "entrance",
//              "lat": 40.74802,
//              "lng": -73.985086
//            }
//          ],
//          "distance": 16,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d125941735",
//            "name": "Tech Startup",
//            "pluralName": "Tech Startups",
//            "shortName": "Tech Startup",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/shops/technology_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 8,
//          "usersCount": 1837,
//          "checkinsCount": 12090
//        },
//        "url": "http://linkedin.com",
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "52a0a34b498ee648116ba4a8",
//        "name": "Shutterstock",
//        "contact": {
//          "twitter": "shutterstock"
//        },
//        "location": {
//          "address": "350 5th Ave",
//          "crossStreet": "33rd Street",
//          "lat": 40.74839196047307,
//          "lng": -73.98577779151145,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74839196047307,
//              "lng": -73.98577779151145
//            }
//          ],
//          "distance": 6,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave (33rd Street)",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d125941735",
//            "name": "Tech Startup",
//            "pluralName": "Tech Startups",
//            "shortName": "Tech Startup",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/shops/technology_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 3,
//          "usersCount": 1024,
//          "checkinsCount": 5113
//        },
//        "url": "http://www.shutterstock.com",
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "59b86568805e3f17ec052bb5",
//        "name": "Fluent City",
//        "contact": {},
//        "location": {
//          "address": "350 5th Ave Fl 63",
//          "crossStreet": "34th St",
//          "lat": 40.748406,
//          "lng": -73.985317,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748406,
//              "lng": -73.985317
//            }
//          ],
//          "distance": 32,
//          "postalCode": "10001",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave Fl 63 (34th St)",
//            "New York, NY 10001",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "52e81612bcbc57f1066b7a48",
//            "name": "Language School",
//            "pluralName": "Language Schools",
//            "shortName": "Language School",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/education/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 16,
//          "checkinsCount": 56
//        },
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "4bc76f760050b71387b1b83b",
//        "name": "Serenity Salon",
//        "contact": {},
//        "location": {
//          "crossStreet": "18 W 33rd Street",
//          "lat": 40.748412112467456,
//          "lng": -73.98618657631924,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748412112467456,
//              "lng": -73.98618657631924
//            }
//          ],
//          "distance": 41,
//          "postalCode": "10001",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "New York, NY 10001",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d110951735",
//            "name": "Salon / Barbershop",
//            "pluralName": "Salons / Barbershops",
//            "shortName": "Salon / Barbershop",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/shops/salon_barber_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 7,
//          "usersCount": 83,
//          "checkinsCount": 181
//        },
//        "allowMenuUrlEdit": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "5b9fe4ce898bdc0039d193c3",
//        "name": "Kaltex america",
//        "contact": {},
//        "location": {
//          "address": "350 5th Ave",
//          "lat": 40.748433,
//          "lng": -73.985592,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748433,
//              "lng": -73.985592
//            }
//          ],
//          "distance": 9,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 2,
//          "checkinsCount": 31
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "526358c611d23dd75d37a264",
//        "name": "Obsevation Deck 102nd Floor",
//        "contact": {},
//        "location": {
//          "lat": 40.74829891044554,
//          "lng": -73.98576631338501,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74829891044554,
//              "lng": -73.98576631338501
//            }
//          ],
//          "distance": 12,
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "New York, NY",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d130941735",
//            "name": "Building",
//            "pluralName": "Buildings",
//            "shortName": "Building",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 6,
//          "checkinsCount": 12
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "564df2a2498e8842ff80dd81",
//        "name": "AppDynamics",
//        "contact": {},
//        "location": {
//          "address": "350 5th Ave Ste 4720",
//          "crossStreet": "Fifth Avenue And 34th Street",
//          "lat": 40.7487184780448,
//          "lng": -73.98566301021633,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.7487184780448,
//              "lng": -73.98566301021633
//            }
//          ],
//          "distance": 35,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave Ste 4720 (Fifth Avenue And 34th Street)",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d125941735",
//            "name": "Tech Startup",
//            "pluralName": "Tech Startups",
//            "shortName": "Tech Startup",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/shops/technology_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 3,
//          "checkinsCount": 3
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "5c1a0efbdd8442002c42caa8",
//        "name": "StrawberryFrog",
//        "contact": {
//          "phone": "+12123660500",
//          "formattedPhone": "+1 212-366-0500",
//          "twitter": "frogism"
//        },
//        "location": {
//          "address": "350 5th Ave Ste 4800",
//          "lat": 40.74845991454198,
//          "lng": -73.98567795753479,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74845991454198,
//              "lng": -73.98567795753479
//            }
//          ],
//          "distance": 6,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave Ste 4800",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "56aa371be4b08b9a8d573517",
//            "name": "Business Center",
//            "pluralName": "Business Centers",
//            "shortName": "Business Center",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 4,
//          "checkinsCount": 5
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "4bdb1f573904a59372dd489e",
//        "name": "Columbia OmniCorp",
//        "contact": {
//          "phone": "+12122796161",
//          "formattedPhone": "+1 212-279-6161"
//        },
//        "location": {
//          "address": "14 W 33rd St",
//          "crossStreet": "at 5th Ave",
//          "lat": 40.748139,
//          "lng": -73.986151,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748139,
//              "lng": -73.986151
//            },
//            {
//              "label": "entrance",
//              "lat": 40.748076,
//              "lng": -73.985995
//            }
//          ],
//          "distance": 47,
//          "postalCode": "10001",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "14 W 33rd St (at 5th Ave)",
//            "New York, NY 10001",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d121951735",
//            "name": "Paper / Office Supplies Store",
//            "pluralName": "Paper / Office Supplies Stores",
//            "shortName": "Office Supplies",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/shops/papergoods_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 2,
//          "usersCount": 157,
//          "checkinsCount": 226
//        },
//        "allowMenuUrlEdit": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "4c16346582a3c9b66fe4fff8",
//        "name": "Acronym Media Inc",
//        "contact": {
//          "phone": "+12126917051",
//          "formattedPhone": "+1 212-691-7051",
//          "twitter": "acronym_media"
//        },
//        "location": {
//          "address": "350 5th Ave Ste 6520",
//          "lat": 40.748245026644696,
//          "lng": -73.98565373145598,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748245026644696,
//              "lng": -73.98565373145598
//            },
//            {
//              "label": "entrance",
//              "lat": 40.74802,
//              "lng": -73.985086
//            }
//          ],
//          "distance": 17,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave Ste 6520",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 7,
//          "usersCount": 44,
//          "checkinsCount": 1376
//        },
//        "url": "http://www.acronym.com",
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "4b4b7979f964a520249d26e3",
//        "name": "The King's College",
//        "contact": {
//          "phone": "+12126597200",
//          "formattedPhone": "+1 212-659-7200"
//        },
//        "location": {
//          "address": "350 5th Ave Ste 1500",
//          "crossStreet": "at 33rd St.",
//          "lat": 40.74837050671544,
//          "lng": -73.98568868637085,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74837050671544,
//              "lng": -73.98568868637085
//            },
//            {
//              "label": "entrance",
//              "lat": 40.74802,
//              "lng": -73.985086
//            }
//          ],
//          "distance": 3,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave Ste 1500 (at 33rd St.)",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d198941735",
//            "name": "College Academic Building",
//            "pluralName": "College Academic Buildings",
//            "shortName": "Academic Building",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/education/academicbuilding_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 4,
//          "usersCount": 73,
//          "checkinsCount": 710
//        },
//        "url": "http://www.tkc.edu",
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "4b8ff78af964a520e16c33e3",
//        "name": "Taylor Global",
//        "contact": {
//          "twitter": "taylorstrategy"
//        },
//        "location": {
//          "address": "350 5th Ave",
//          "crossStreet": "btw 34th & 33rd St",
//          "lat": 40.74833713031071,
//          "lng": -73.98565857545593,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74833713031071,
//              "lng": -73.98565857545593
//            },
//            {
//              "label": "entrance",
//              "lat": 40.74802,
//              "lng": -73.985086
//            }
//          ],
//          "distance": 7,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave (btw 34th & 33rd St)",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 5,
//          "usersCount": 158,
//          "checkinsCount": 2743
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "5a0c675ff193c03e09629866",
//        "name": "Palo Alto Networks",
//        "contact": {},
//        "location": {
//          "lat": 40.748244,
//          "lng": -73.985891,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748244,
//              "lng": -73.985891
//            }
//          ],
//          "distance": 23,
//          "postalCode": "10001",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "New York, NY 10001",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "52f2ab2ebcbc57f1066b8b36",
//            "name": "IT Services",
//            "pluralName": "IT Services",
//            "shortName": "IT Services",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/shops/technology_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 7,
//          "checkinsCount": 11
//        },
//        "allowMenuUrlEdit": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "5d4c4af1d659fd00084b68fb",
//        "name": "a: AnswerLab",
//        "contact": {},
//        "location": {
//          "address": "350 5th Ave Ste 3900",
//          "crossStreet": "33rd & 34th Sts.",
//          "lat": 40.748274,
//          "lng": -73.985443,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748274,
//              "lng": -73.985443
//            }
//          ],
//          "distance": 25,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave Ste 3900 (33rd & 34th Sts.)",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "58daa1558bbb0b01f18ec1b2",
//            "name": "Research Station",
//            "pluralName": "Research Stations",
//            "shortName": "Research Station",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 6,
//          "checkinsCount": 7
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "5b05b0b12a7ab6003979c3e3",
//        "name": "Vanguard Construction and Development",
//        "contact": {},
//        "location": {
//          "lat": 40.748302,
//          "lng": -73.98555,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748302,
//              "lng": -73.98555
//            }
//          ],
//          "distance": 16,
//          "postalCode": "10001",
//          "cc": "US",
//          "neighborhood": "Koreatown",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "New York, NY 10001",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "5454144b498ec1f095bff2f2",
//            "name": "Construction & Landscaping",
//            "pluralName": "Construction & Landscaping",
//            "shortName": "Construction",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/shops/realestate_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 1,
//          "checkinsCount": 5
//        },
//        "allowMenuUrlEdit": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "5984759a1fa7635deb4d3106",
//        "name": "ZS Associates",
//        "contact": {},
//        "location": {
//          "address": "350 5th Ave #5100",
//          "lat": 40.748327,
//          "lng": -73.98561,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748327,
//              "lng": -73.98561
//            }
//          ],
//          "distance": 11,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave #5100",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 7,
//          "checkinsCount": 21
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "5ac6127add70c52ec37235a8",
//        "name": "Nexstar Digital, Llc",
//        "contact": {},
//        "location": {
//          "lat": 40.748394614211435,
//          "lng": -73.98566182103924,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748394614211435,
//              "lng": -73.98566182103924
//            }
//          ],
//          "distance": 3,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "56aa371be4b08b9a8d573517",
//            "name": "Business Center",
//            "pluralName": "Business Centers",
//            "shortName": "Business Center",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 3,
//          "checkinsCount": 125
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "58dbddbf0acb6a4d626e4476",
//        "name": "CHOPT",
//        "contact": {
//          "phone": "+12129679380",
//          "formattedPhone": "+1 212-967-9380",
//          "twitter": "chopt",
//          "instagram": "choptsalad",
//          "facebook": "17440921489",
//          "facebookUsername": "choptsalad",
//          "facebookName": "Chopt Creative Salad Co."
//        },
//        "location": {
//          "address": "350 5th Ave",
//          "crossStreet": "at E 33rd St",
//          "lat": 40.748252293405834,
//          "lng": -73.98571435525511,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748252293405834,
//              "lng": -73.98571435525511
//            }
//          ],
//          "distance": 16,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave (at E 33rd St)",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d1bd941735",
//            "name": "Salad Place",
//            "pluralName": "Salad Places",
//            "shortName": "Salad",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/food/salad_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": true,
//        "stats": {
//          "tipCount": 3,
//          "usersCount": 444,
//          "checkinsCount": 1686
//        },
//        "url": "http://choptsalad.com",
//        "menu": {
//          "type": "Menu",
//          "label": "Menu",
//          "anchor": "View Menu",
//          "url": "https://www.choptsalad.com/menu/",
//          "mobileUrl": "https://www.choptsalad.com/menu/",
//          "externalUrl": "https://www.choptsalad.com/menu/"
//        },
//        "allowMenuUrlEdit": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [
//          {
//            "id": "564bbe7d498e38a2ff3a056f"
//          }
//        ],
//        "hasPerk": false
//      },
//      {
//        "id": "4d8cc7ed12d52c0f985c5434",
//        "name": "Kaplan International English",
//        "contact": {
//          "phone": "+16462850300",
//          "formattedPhone": "+1 646-285-0300",
//          "twitter": "kaplanintl"
//        },
//        "location": {
//          "address": "350 5th Ave Ste 6308",
//          "lat": 40.74830875964988,
//          "lng": -73.98582262081166,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74830875964988,
//              "lng": -73.98582262081166
//            }
//          ],
//          "distance": 14,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "350 5th Ave Ste 6308",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "52e81612bcbc57f1066b7a48",
//            "name": "Language School",
//            "pluralName": "Language Schools",
//            "shortName": "Language School",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/education/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": true,
//        "stats": {
//          "tipCount": 5,
//          "usersCount": 538,
//          "checkinsCount": 2920
//        },
//        "url": "https://www.kaplaninternational.com/united-states/new-york/empire-state-english-school",
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "4db03c244df03036e8b7c344",
//        "name": "SE Quad Taylor Strategy",
//        "contact": {},
//        "location": {
//          "lat": 40.748566,
//          "lng": -73.985626,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748566,
//              "lng": -73.985626
//            }
//          ],
//          "distance": 19,
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "New York, NY",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 1,
//          "usersCount": 3,
//          "checkinsCount": 19
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "4bfc51561be376b0847bf8b4",
//        "name": "Greater New York Council Offices Of the Boy Scouts of America",
//        "contact": {},
//        "location": {
//          "lat": 40.748494532734206,
//          "lng": -73.98622543790685,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748494532734206,
//              "lng": -73.98622543790685
//            }
//          ],
//          "distance": 45,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 26,
//          "checkinsCount": 80
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "542ae46d498ed8ce5e1d33ad",
//        "name": "Krux Arctics",
//        "contact": {},
//        "location": {
//          "address": "Surrounded By Icebergs",
//          "lat": 40.74854284473398,
//          "lng": -73.98561135861114,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74854284473398,
//              "lng": -73.98561135861114
//            }
//          ],
//          "distance": 17,
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "Surrounded By Icebergs",
//            "New York, NY",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d125941735",
//            "name": "Tech Startup",
//            "pluralName": "Tech Startups",
//            "shortName": "Tech Startup",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/shops/technology_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 1,
//          "checkinsCount": 5
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "504f871de4b02fe73133c926",
//        "name": "Noven Pharmaceuticals Inc.",
//        "contact": {},
//        "location": {
//          "address": "Empire State Building",
//          "lat": 40.74849591194516,
//          "lng": -73.98576057432156,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.74849591194516,
//              "lng": -73.98576057432156
//            },
//            {
//              "label": "entrance",
//              "lat": 40.74802,
//              "lng": -73.985086
//            }
//          ],
//          "distance": 11,
//          "postalCode": "10118",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "Empire State Building",
//            "New York, NY 10118",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 6,
//          "checkinsCount": 16
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      },
//      {
//        "id": "58dd33090319b84bcbaf8f23",
//        "name": "Moses Ziegelman & Kornfeld",
//        "contact": {},
//        "location": {
//          "lat": 40.748352,
//          "lng": -73.985591,
//          "labeledLatLngs": [
//            {
//              "label": "display",
//              "lat": 40.748352,
//              "lng": -73.985591
//            }
//          ],
//          "distance": 10,
//          "postalCode": "10001",
//          "cc": "US",
//          "city": "New York",
//          "state": "NY",
//          "country": "United States",
//          "formattedAddress": [
//            "New York, NY 10001",
//            "United States"
//          ]
//        },
//        "categories": [
//          {
//            "id": "4bf58dd8d48988d124941735",
//            "name": "Office",
//            "pluralName": "Offices",
//            "shortName": "Office",
//            "icon": {
//              "prefix": "https://ss3.4sqi.net/img/categories_v2/building/default_",
//              "suffix": ".png"
//            },
//            "primary": true
//          }
//        ],
//        "verified": false,
//        "stats": {
//          "tipCount": 0,
//          "usersCount": 3,
//          "checkinsCount": 7
//        },
//        "venueRatingBlacklisted": true,
//        "beenHere": {
//          "lastCheckinExpiredAt": 0
//        },
//        "hereNow": {
//          "count": 0,
//          "summary": "Nobody here",
//          "groups": []
//        },
//        "referralId": "v-1602152288",
//        "venueChains": [],
//        "hasPerk": false
//      }
//    ],
//    "confident": false
//  }
//}
