// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Trade{

    struct NFT{
        uint256 price;
        address owner;
    }
    mapping (uint256=>NFT)  NFTOwner;
    mapping (uint256=>NFT)  NFTList;
    function setOwner(uint256 tokenId, uint256 price, address owner) public payable {
        require(NFTOwner[tokenId].owner == address(0), "This NFT already has an owner");
        if(NFTOwner[tokenId].owner != address(0)){
            revert();
        }
        NFT memory t;
        t.price = price;
        t.owner = owner;
        NFTOwner[tokenId] = t;
    }

    function list(uint256 tokenId, uint256 price) public payable {
        require(msg.sender == NFTOwner[tokenId].owner,"You are not the owner");
        NFT memory t = NFT(price, msg.sender);
        NFTList[tokenId] = t;
    }

    function revoke(uint256 tokenId, uint256 price, address owner) public payable {
        require(msg.sender == NFTOwner[tokenId].owner,"You are not the owner");
        NFT memory t = NFT(price, owner);
        delete NFTList[tokenId];
    }

    function update(uint256 tokenId, uint256 price) public payable {
        require(msg.sender == NFTOwner[tokenId].owner,"You are not the owner");
        NFTList[tokenId].price = price;
    }  
    function purchase(uint256 tokenId, uint256 price) public payable {
        NFT memory nftForSale = NFTList[tokenId];
        require(msg.sender != nftForSale.owner,"You can not buy your NFT");
        require(price == nftForSale.price, string(abi.encodePacked("Incorrect Price: ", uint2str(nftForSale.price), " expected, ", uint2str(msg.value), " provided")));


        payable(nftForSale.owner).transfer(price);

        NFTOwner[tokenId].owner = msg.sender;
        delete NFTList[tokenId];       
    }        
    function getMsgSender() public view returns (address){
        return msg.sender;
    }
    function getNFTList(uint256 id) public view returns(uint256 tokenId, uint256 price, address owner){
        NFT memory nft = NFTList[id];
        return (id, nft.price, nft.owner);
    }
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}