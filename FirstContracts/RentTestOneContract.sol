// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//import "@nomiclabs/hardhat-etherscan";
//require("@nomiclabs/hardhat-etherscan");
contract ARVerse is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
     struct Rental {
        bool isActive;
        address lord;
        address renter;
        uint256 expiresAt;
    }
    mapping(uint256 => Rental) public rental;
    event Rented(
        uint256 indexed tokenId,
        address indexed lord,
        address indexed renter,
        uint256 expiresAt
    );
    event FinishedRent(
        uint256 indexed tokenId,
        address indexed lord,
        address indexed renter,
        uint256 expiresAt
    );
    constructor() ERC721("ARVerse", "ESS") {}
    function _baseURI() internal pure override returns (string memory) {
        return "https://2819-200-124-220-19.sa.ngrok.io/api/erc721/";
    }
    function mint(address to)
        public returns (uint256)
    {
        require(_tokenIdCounter.current() < 1000);
        _tokenIdCounter.increment();
        _safeMint(to, _tokenIdCounter.current());
        return _tokenIdCounter.current();
    }
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
    function rentOut(
        address renter,
        uint256 tokenId,
        uint256 rentTime
    ) external {
        _transfer(msg.sender, renter, tokenId);
        uint256 expiresAt = block.timestamp + rentTime;
        rental[tokenId] = Rental({
            isActive: true,
            lord: msg.sender,
            renter: renter,
            expiresAt: expiresAt
        });
        emit Rented(tokenId, msg.sender, renter, expiresAt);
    }
    function finishRenting(uint256 tokenId) external {
        Rental storage _rental = rental[tokenId];
        require(
            msg.sender == _rental.renter ||
                block.timestamp >= _rental.expiresAt,
            "RentableNFT: this token is rented"
        );
        _rental.isActive = false;
        _transfer(_rental.renter, _rental.lord, tokenId);
        emit FinishedRent(
            tokenId,
            _rental.lord,
            _rental.renter,
            _rental.expiresAt
        );
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        require(!rental[tokenId].isActive, "RentableNFT: this token is rented");
        super._beforeTokenTransfer(from, to, tokenId);
    }
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}