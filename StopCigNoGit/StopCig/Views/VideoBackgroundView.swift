//
//  VideoBackgroundView.swift
//  StopCig
//
//  Created by Hook on 24/07/2024.
//

import SwiftUI
import AVKit
// En résumé, VideoBackgroundView est une vue personnalisée qui utilise AVKit pour lire une vidéo en boucle en arrière-plan. Elle configure un AVPlayerLayer pour afficher la vidéo et utilise AVPlayerLooper pour la lecture en boucle.

class VideoBackgroundView: UIView {
  
    private var playerLayer = AVPlayerLayer()     // Variable qui sert a afficher le contenu video d'un AVPlayer
    private var playerLooper: AVPlayerLooper?    // Variable qui sert a lire en boucle un element video
    private var player = AVQueuePlayer()        // Variable qui sert a creer une queue pour lire plusieurs elements a la suite
  
    init(videoName: String){
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: videoName, ofType: "mp4")!)    // Creer un URL a partir du chemin vers la video
        let asset = AVAsset(url: url)                                                              // Crée un objet AVAsset qui représente le média à partir de l'URL fournie. AVAsset est une classe qui encapsule les informations sur le média, comme les pistes vidéo et audio.
        let item = AVPlayerItem(asset: asset)                                                     // Crée un objet AVPlayerItem à partir de l'AVAsset. AVPlayerItem représente un élément de lecture que le AVPlayer peut lire.

        super.init(frame: .zero)                                                              // initialise la vue de base avant d'ajouter des configurations spécifiques.
        
        playerLayer.player = player                                                        // Associe le AVPlayer à playerLayer, ce qui permet à playerLayer d'afficher le contenu vidéo lu par player.
        playerLayer.videoGravity = .resizeAspectFill                                      // Définit la manière dont la vidéo est redimensionnée pour remplir la couche. .resizeAspectFill signifie que la vidéo sera redimensionnée pour remplir la couche tout en conservant son ratio d'aspect, ce qui peut entraîner un recadrage.
        layer.addSublayer(playerLayer)                                                   // Ajoute playerLayer en tant que sous-couche de la vue principale (layer). Cela permet à playerLayer de rendre la vidéo à l'écran.
        playerLooper = AVPlayerLooper(player: player, templateItem: item)               // Crée un AVPlayerLooper qui permet de lire en boucle l'élément vidéo (item) en utilisant le AVQueuePlayer (player). AVPlayerLooper gère automatiquement la répétition de la vidéo.
        player.play()                                                                  // Démarre la lecture de la vidéo.
        
        addObservers()                                                                // Ajoute des observateurs pour gérer les événements de lecture de la vidéo.
    }
    
    // Désactive l'initialisation via storyboard/xib (interfaces graphiques)
   // Utilisé pour éviter les erreurs si cette méthode est appelée
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // Ajuste playerLayer pour qu'il occupe toute la vue à chaque changement de taille
    override func layoutSubviews() {    // override permet de remplacer une méthode héritée par une nouvelle implémentation. layoutSubviews est une méthode de UIView qui est appelée chaque fois que la vue doit être redessinée, par exemple lorsqu'elle change de taille
        super.layoutSubviews()         // Appelle la méthode layoutSubviews de la classe parente (UIView). Cela garantit que toute la logique de disposition définie dans la classe parente est exécutée avant d'ajouter la logique spécifique à cette sous-classe.
        playerLayer.frame = bounds    // Ajuste le cadre de playerLayer pour qu'il corresponde à la taille de la vue. Cela garantit que la vidéo est toujours affichée correctement, même si la taille de la vue change. Bounds est une propriété de UIView qui représente le rectangle qui définit la taille et la position de la vue dans ses coordonnées locales.
    }
    
    
  //  Les oberservers servent en general a ecouter les evenements et a declencher des actions en fonction de ces evenements.
 // Dans ce cas, les observers sont utilisés pour mettre en pause la vidéo lorsque l'application passe en arrière-plan
// Et pour la reprendre lorsque l'application revient en premier plan.
    private func addObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        
// deinit est une méthode qui est appelée lorsqu'une instance de la classe est détruite. Dans ce cas, elle est utilisée pour supprimer les observateurs lorsqu'ils ne sont plus nécessaires.
        deinit {
            NotificationCenter.default.removeObserver(self)
        }


  // @objc est un attribut qui permet à une méthode d'être appelée par Objective-C.
 // Dans ce cas, il est utilisé pour que les méthodes appDidEnterBackground et appWillEnterForeground
// Puissent être appelées par les observateurs.
        @objc private func appDidEnterBackground() {
            player.pause()
        }

        @objc private func appWillEnterForeground() {
            player.play()
        }
    
}

//#Preview {
//    VideoBackgroundView(player: )
//}
