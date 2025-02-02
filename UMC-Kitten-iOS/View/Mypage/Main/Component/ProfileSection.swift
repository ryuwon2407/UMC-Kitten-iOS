//
//  Profile.swift
//  UMC-Kitten-iOS
//
//  Created by DOYEON LEE on 1/17/24.
//

import UIKit

class ProfileSection: BaseView {
    
    // MARK: Constant
    private let PAGE_PADDING: CGFloat = 15
    private let PET_CELL_SPACING: CGFloat = 16
    
    // MARK: UI Container
    private let myPetsScrollView: UIScrollView = .init()
    private let myPetsContainer: UIStackView = .init()
    
    // MARK: UI Component
    
    private let profileImageView: UIImageView = .init()
    let ownerNameLabel: UILabel = .init(staticText: "임시 닉네임")
    private let ownerRoleLabel: UILabel = .init(staticText: "반려인")
    
    private let myPetsInfoTitleLabel: UILabel = .init(staticText: "내 반려동물 정보")
    let managementButton: UILabel = .init(staticText: "관리")
    
    // MARK: Set Method
    
    override func setStyle() {
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        
        ownerNameLabel.setDefaultFont(size: 20, weight: .semiBold)
        
        ownerRoleLabel.setDefaultFont(size: 14)
        
        myPetsInfoTitleLabel.setDefaultFont(size: 14)
        myPetsInfoTitleLabel.textColor = .grayScale700
        
        managementButton.setDefaultFont(size: 16, weight: .semiBold)
        managementButton.textColor = .main
        
        myPetsScrollView.showsHorizontalScrollIndicator = false
        
        myPetsContainer.axis = .horizontal
        myPetsContainer.spacing = PET_CELL_SPACING
        
    }
    
    override func setHierarchy() {
        [profileImageView, ownerNameLabel, ownerRoleLabel,
         myPetsInfoTitleLabel, managementButton, myPetsScrollView]
            .forEach { addSubview($0)}
        
        [myPetsContainer]
            .forEach { myPetsScrollView.addSubview($0) }
    }
    
    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        ownerNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top).offset(8)
            $0.left.equalTo(profileImageView.snp.right).offset(12)
        }
        
        ownerRoleLabel.snp.makeConstraints {
            $0.top.equalTo(ownerNameLabel.snp.bottom)
            $0.left.equalTo(ownerNameLabel.snp.left)
        }
        
        myPetsInfoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.left.equalToSuperview()
        }
        
        managementButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.right.equalToSuperview()
        }
        
        myPetsScrollView.snp.makeConstraints {
            $0.top.equalTo(myPetsInfoTitleLabel.snp.bottom).offset(15)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(120) // MyPetCell's height is 120
            $0.bottom.equalToSuperview()
        }
        
    }
    
    func configure(
        profileImage: String,
        nickname: String,
        pets: [PetModel]
    ) {
        ImageProvider.loadImage(profileImage) { image in
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }
        ownerNameLabel.text = nickname
        configurePets(pets: pets)
    }
    
    
    private func configurePets(pets: [PetModel]) {
        // 이전 값들 지우기
        myPetsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 새 반려동물 정보 세팅
        pets.forEach {
            myPetsContainer.addArrangedSubview(
                MyPetCard(
                    petImageName: $0.image,
                    petName: $0.name,
                    petInfo: "\($0.species.krDescription)/\($0.gender.krDescription)"
                )
            )
        }
        
        // 카드 배열 속성 지정 (셀들이 디바이스 너비보다 커지면 스크롤, 작으면 가운데 정렬)
        let isCenter = (UIScreen.main.bounds.width - PAGE_PADDING * 2) > ((MyPetCard.CELL_WIDTH + PET_CELL_SPACING) * CGFloat(pets.count))
        myPetsContainer.snp.removeConstraints()
        myPetsContainer.snp.makeConstraints {
            if (isCenter) {
                $0.centerX.equalToSuperview()
            } else {
                $0.left.right.equalToSuperview()
            }
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
}
