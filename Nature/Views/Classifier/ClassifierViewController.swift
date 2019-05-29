//
//  ClassifierViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 26/05/2019.
//  Copyright © 2019 Oliver Kulpakko. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

@available(iOS 11.0, *)
class ClassifierViewController: BaseViewController {

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "classifier.title".localized
		noticeLabel.text = "classifier.notice".localized

		collectionView.register(UINib(nibName: "ClassifyResultCell", bundle: nil), forCellWithReuseIdentifier: "ClassifyResultCell")
	}

	// MARK: BaseViewController

	override func setupViews() {
		super.setupViews()

		setToolbarItems([
			UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(toCamera))
			], animated: false)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.setToolbarHidden(false, animated: true)
	}

	override func updateTheme() {
		super.updateTheme()

		view.backgroundColor = Theme.current.viewBackgroundColor
	}

	override func reloadData() {
		super.reloadData()
	}

	// MARK: Image Classification
	
	lazy var classificationRequest: VNCoreMLRequest = {
		do {
			let model = try VNCoreMLModel(for: MushroomsFI().model)

			let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
				self?.processClassifications(for: request, error: error)
			})
			request.imageCropAndScaleOption = .centerCrop
			return request
		} catch {
			fatalError("Failed to load Vision ML model: \(error)")
		}
	}()

	func updateClassifications(for image: UIImage) {
		let orientation = CGImagePropertyOrientation(image.imageOrientation)
		guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }

		DispatchQueue.global(qos: .userInitiated).async {
			let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
			do {
				try handler.perform([self.classificationRequest])
			} catch {
				print("Failed to perform classification.\n\(error.localizedDescription)")
			}
		}
	}

	func processClassifications(for request: VNRequest, error: Error?) {
		DispatchQueue.main.async {
			guard let classifications = request.results as? [VNClassificationObservation] else {
				self.presentError(error)
				return
			}

			self.results = classifications.compactMap { classification in
				guard let item = self.items.first(where: { $0.scientificName == classification.identifier }) else {
					return nil
				}

				return ClassifyResult(item: item, certainty: Double(classification.confidence))
			}

			self.collectionView.reloadData()
		}
	}

	// MARK: Camera

	@objc func toCamera() {
		guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
			presentPhotoPicker(sourceType: .photoLibrary)
			return
		}

		let photoSourcePicker = UIAlertController()
		let takePhoto = UIAlertAction(title: "classifier.import.camera".localized, style: .default) { [unowned self] _ in
			self.presentPhotoPicker(sourceType: .camera)
		}
		let choosePhoto = UIAlertAction(title: "classifier.import.library".localized, style: .default) { [unowned self] _ in
			self.presentPhotoPicker(sourceType: .photoLibrary)
		}

		photoSourcePicker.addAction(takePhoto)
		photoSourcePicker.addAction(choosePhoto)
		photoSourcePicker.addCancelAction()

		present(photoSourcePicker, animated: true)
	}

	func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = sourceType
		present(picker, animated: true)
	}

	// MARK: Initializers

	init(items: [Item], category: Category) {
		self.items = items
		self.category = category

		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Stored Properties

	let items: [Item]
	let category: Category

	var results = [ClassifyResult]()

	struct ClassifyResult {
		let item: Item
		let certainty: Double
	}

	// MARK: IBOutlets

	@IBOutlet var backgroundImageView: UIImageView!
	@IBOutlet var backgroundVisualEffectView: UIVisualEffectView!

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var collectionView: UICollectionView!
	
	@IBOutlet var noticeLabel: UILabel!
}

@available(iOS 11.0, *)
extension ClassifierViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true)

		let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

		imageView.image = image
		backgroundImageView.image = image

		updateClassifications(for: image)
	}
}

@available(iOS 11.0, *)
extension ClassifierViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return min(5, results.count)
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassifyResultCell", for: indexPath) as! ClassifyResultCell

		let result = results[indexPath.row]

		cell.setup(item: result.item, certainty: result.certainty)

		cell.layer.cornerRadius = 8
		cell.clipsToBounds = true

		return cell
	}
}

@available(iOS 11.0, *)
extension ClassifierViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let viewController = ItemViewController(item: results[indexPath.row].item)
		navigationController?.pushViewController(viewController, animated: true)
	}
}

@available(iOS 11.0, *)
extension ClassifierViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.bounds.size.height * 0.75, height: collectionView.bounds.size.height)
	}
}
