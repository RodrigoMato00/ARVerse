// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract ARVNFTContract is ERC721, ERC721Enumerable, Ownable {
    uint256 public _tokenCounter;
    address private _royaltiesReciever;
    uint256 public constant _royaltiesPercentage = 5;
    event Mint(uint256 tokenId, address recipient);
    constructor(address royaltiesReviever) ERC721("ARVerse NFT", "ARVNFT") {
        _royaltiesReciever = royaltiesReviever;
    }
    /*
        To be implemented for METADATA
        function _baseUri() internal override returns (string memory) {
            return "METADATA STORAGE URL";
        }
        function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage)
            returns (string memory) {
                return super.tokenURI(tokenId);
        }
    */
    function _beforeTokenTransfer(address from, address to, uint256 amount)
    internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, amount);
    }
    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable)
    returns (bool) {
        return interfaceId == type(IERC721).interfaceId ||
        super.supportsInterface(interfaceId);
    }
    function mint() public onlyOwner returns(uint256)
    {
        _tokenCounter++;
        _mint(msg.sender, _tokenCounter);
        return(_tokenCounter);
    }
    /* getters */
    function getRoyaltiesReceiver() external view returns(address) {
        return _royaltiesReciever;
    }
    /* setters */
    function setRoyaltiesReceiver(address newReciever)
    external onlyOwner {
        require(newReciever != _royaltiesReciever); // dev: Same address
        _royaltiesReciever = newReciever;
    }
    /* Called on sale or rent to determine royalties amount */
    function royaltyInfo(uint256 value) external view
    returns (address _royaltiesReceiver, uint256 royaltyAmount) {
        uint256 royalties = (value * _royaltiesPercentage) / 100;
        return (_royaltiesReciever, royalties);
    }
}