// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
contract MyNFT is Initializable ,ERC721Upgradeable ,OwnableUpgradeable ,UUPSUpgradeable{ 
    
    // constructor() {
    //     _disableInitializers();
    // }
    uint256 counter;
    string URI;

    function initializeNft() initializer public {
    __ERC721_init("MyNFT","MNFT");
    __Ownable_init();
    __UUPSUpgradeable_init();

    }

    function safeMint(address _addy) public onlyOwner {
        _safeMint(_addy,counter);
        unchecked {
            ++counter;
        }

    }


    function _baseURI() internal view override returns (string memory) {
        return URI;
    }

    function setBaseUri(string memory _URI) external onlyOwner{
        URI = _URI;
    }



    function _authorizeUpgrade(address newImplementation) internal  override{}



    

}
