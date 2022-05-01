// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "VRFD20.sol";


contract GameItem is ERC721URIStorage, Pausable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //used with mapCheck in awardItem to ensure player visited NPC #1
    address addressB = 0xE83540e166F0eA8a6fE711180aA2C0D51F52AEFf ;
    interfaceVRFD20 b = interfaceVRFD20(addressB);

    constructor() ERC721("GameItem", "ITM") {}

    function awardItem(address player, string memory tokenURI)
        public
        returns (uint256)
        
    {
        require(b.mapCheck(player) == true, "Address has not visited The Oraacle"); // player vs msg.sender?
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds.increment();
        return newItemId;
    }
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
    function setAddressB(address _VRFD20) external {  //must deploy VRFD20.sol first
        addressB = _VRFD20;
    }
    //function callMapCheck() external view returns(bool) {  
        //interfaceVRFD20 b = VRFD20(addressB);
       // return b.mapCheck(msg.sender); // not quite, need _player instead msg.sender
  //  }
  
    //functions to inspect mapping of fortuneTeller.sol
    //allow for mints depending on which mapping the msg.sender belongs to
}