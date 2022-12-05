// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken is ERC721, AccessControl {
    using Counters for Counters.Counter;

    enum AnimalType{ MOUSE, CAT, DOG }

   //AnimalType animalType;
   //FreshJuiceSize constant defaultChoice = FreshJuiceSize.MEDIUM;
//Num
   uint256 mouseNumCurrently;
   uint256 catNumCurrently;
   uint256 dogNumCurrently;

   uint256 totalSupply;

   mapping(address => uint256) public lookingForTokenId;
   

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MyToken", "MTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _tokenIdCounter.increment();
    }




//MINT

    function mintMouse() public {
        safeMintAnimal(0);
        mouseNumCurrently ++;
    }

    function mintCat() public {
        safeMintAnimal(10000);
        catNumCurrently ++;
    }

    function mintDog() public {
        safeMintAnimal(20000);
        dogNumCurrently++;
    }

    

    function safeMintAnimal(uint256 _tokenId) internal {
        require(balanceOf(msg.sender) == 0, "alredy have your animal");
        require(_tokenIdCounter.current() <= 10000,"max 10000");
        uint256 tokenId = _tokenIdCounter.current() + _tokenId;
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        totalSupply ++;
        lookingForTokenId[msg.sender] = tokenId;
    }
    function safeMint() internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        totalSupply ++;
        lookingForTokenId[msg.sender] = tokenId;
    }

    function safeMintByTokenId(uint tokenId) internal {
        _safeMint(msg.sender, tokenId);
        lookingForTokenId[msg.sender] = tokenId;
    }

    function burn(uint256 tokenId) internal{
        _burn(tokenId);
        lookingForTokenId[msg.sender] = 0;
    }
//game

    function changeMouse() public {
        _changeMouse();
    }

    function changeCat() public {
        _changeCat();
    }

    function changeDog() public {
        _changeDog();
    }

    function _changeMouse() internal {
        uint tokenId = lookingForTokenId[msg.sender];
        require(tokenId > 0,"didnt have NFT");
        require(tokenId > 10000,"alredy mouse");
        require(ownerOf(tokenId) == msg.sender,"not owner");

        mouseNumCurrently ++;

        burn(tokenId);

        if(tokenId <= 20000) {
            tokenId = tokenId - 10000;
            safeMintByTokenId(tokenId);
            catNumCurrently --;
        }
        else {
            tokenId = tokenId - 20000;
            safeMintByTokenId(tokenId);
            dogNumCurrently --;

        }


    }

    function _changeCat() internal {
        
        uint tokenId = lookingForTokenId[msg.sender];
        require(tokenId > 0,"didnt have NFT");
        require(tokenId <= 10000 || tokenId > 20000,"alredy cat");
        require(ownerOf(tokenId) == msg.sender,"not owner");

        catNumCurrently ++;

        burn(tokenId);

        if(tokenId <= 10000) {
            tokenId = tokenId + 10000;
            safeMintByTokenId(tokenId);
            mouseNumCurrently --;
        }
        else {
            tokenId = tokenId - 10000;
            safeMintByTokenId(tokenId);
            dogNumCurrently --;

        }


    }

    function _changeDog() internal {
        uint tokenId = lookingForTokenId[msg.sender];
        require(tokenId > 0,"didnt have NFT");
        require(tokenId <= 20000,"alredy dog");
        require(ownerOf(tokenId) == msg.sender,"not owner");

        dogNumCurrently ++;

        burn(tokenId);

        if(tokenId <= 10000) {
            tokenId = tokenId + 20000;
            safeMintByTokenId(tokenId);
            mouseNumCurrently --;
        }
        else {
            tokenId = tokenId + 10000;
            safeMintByTokenId(tokenId);
            catNumCurrently --;

        }


    }

    


//metadata
    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
