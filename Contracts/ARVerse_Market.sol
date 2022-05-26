// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "./nft.sol";
contract ARVMarketplace is ERC721 {
    struct listOffer {
        address owner;
        uint256 token_id;
        bool sell_active;
        bool rent_active;
        uint256 sell_price;
        uint256 rent_price;
    }
    struct Rental {
        bool isActive;
        address lord;
        address renter;
        uint256 expiresAt;
    }
    event NewOffer(uint256 tokenId, address owner, bool sell_active, bool rent_active, uint256 sell_price, uint256 rent_price);
    event NewBuyOffer(uint256 tokenId, address buyer, uint256 value);
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
    address public _nftContractAddress = address(0);
    mapping(uint256 => listOffer) public activeOffers;
    mapping(uint256 => Rental) public rental;
    ERC721 token_contract;
    constructor(address tokenContractAddress) ERC721("ARVMarket", "ARVM") {
        _nftContractAddress = tokenContractAddress;
        token_contract = ERC721(_nftContractAddress);
    }
    function addListing(uint256 tokenId, bool sell_active, bool rent_active, uint256 sell_price, uint256 rent_price)
        public {
            activeOffers[tokenId] = listOffer ({owner: msg.sender,
                                                token_id: tokenId,
                                                sell_active: sell_active,
                                                rent_active: rent_active,
                                                sell_price: sell_price,
                                                rent_price: rent_price
                                        });
            token_contract.transferFrom(msg.sender, address(this), tokenId);
            emit NewOffer(tokenId, msg.sender, sell_active, rent_active, sell_price, rent_price);
        }
    function removeListing(uint256 tokenId) public
    {
        require(activeOffers[tokenId].owner == msg.sender, "Must be owner");
        require(activeOffers[tokenId].sell_active, "Must be active");
        activeOffers[tokenId].sell_active = false;
        token_contract.transferFrom(address(this), activeOffers[tokenId].owner, tokenId);
    }
    /* Buy and Rent */
    function buy(uint tokenId) public payable
    {
        require(activeOffers[tokenId].sell_active, "Must be active");
        require(msg.value >= activeOffers[tokenId].sell_price, "Must pay the price");
        activeOffers[tokenId].sell_active = false;
        (bool sent, bytes memory data) = address(activeOffers[tokenId].owner).call{value: msg.value}("");
        data;
        require(sent, "Failed to send Ether");
        token_contract.safeTransferFrom(address(this), msg.sender, tokenId);
    }
    function rentOut(address renter, uint256 tokenId, uint256 timeRent) external payable {
        require(activeOffers[tokenId].rent_active, "Must be active");
        require(msg.value >= (activeOffers[tokenId].sell_price * timeRent), "thats too low man");
        listOffer memory tmp_token = activeOffers[tokenId];
        tmp_token.rent_active = false;
        uint256 expiresAt = block.timestamp + timeRent;
        rental[tokenId] = Rental({
            isActive: true,
            lord: tmp_token.owner,
            renter: renter,
            expiresAt: expiresAt
        });
        (bool sent, bytes memory data) = address(activeOffers[tokenId].owner).call{value: msg.value}("");
        data;
        require(sent, "Failed to send Ether");
        token_contract.transferFrom(address(this), renter, tokenId);
        emit Rented(
            tokenId,
            tmp_token.owner,
            renter,
            expiresAt
        );
  }
    function finishRenting(uint256 tokenId) external {
        /* No pudimos mantener la lista de _approved intacta al momento de transferencia por mas de intentarlo
        Por lo cual... El que alquila el NFT en este momento es el unico que puede ejecutar y efectuar
        la devolucion del NFT al MarketPlace */
        Rental memory _rental = rental[tokenId];
        require(msg.sender == _rental.renter ||
                block.timestamp >= _rental.expiresAt,
                "RentableNFT: this token is rented"
            );
        _rental.isActive = false;
        activeOffers[tokenId].rent_active = true;
        //console.log("token contract transfer");
        token_contract.transferFrom(msg.sender, _rental.lord, tokenId);
        emit FinishedRent(
            tokenId,
            _rental.lord,
            _rental.renter,
            _rental.expiresAt
        );
    }
}

