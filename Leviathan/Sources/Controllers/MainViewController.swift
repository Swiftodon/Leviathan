//
//  MainViewController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 27.01.23.
//  Copyright 2022 The Swiftodon Team
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SnapKit
import UIKit

class MainViewController: UITabBarController {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        let timeline = StoryboardScene.Timeline.timelineNavigationController.instantiate()
        timeline.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house")?.frame(width: 32, height: 32),
            selectedImage: UIImage(systemName: "house.fill")?.frame(width: 32, height: 32))
        timeline.tabBarItem.tag = 1

        let vc2 = UIViewController()
        vc2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "2.square"), tag: 2)
        let vc3 = UIViewController()
        vc3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "3.square"), tag: 3)
        let vc4 = UIViewController()
        vc4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "4.square"), tag: 4)
        let vc5 = UIViewController()
        vc5.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "5.square"), tag: 5)
        let vc6 = UIViewController()
        vc6.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "6.square"), tag: 6)

        self.setViewControllers([timeline, vc2, vc3, vc4], animated: true)
    }

}

