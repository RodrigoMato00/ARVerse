// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";

contract TokenFraction is ERC1155 {
    struct Rental {
        bool rentable;
        address lord;
        address renter;
        uint256 expiresAt;
    };

    mapping (uint256 => Rental) public rentalAddress;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _n_fractions,
        uint256 _value
    ) ERC20(_name, _symbol) {}

    function mint(address to) public onlyOwner {
        _tokenCounter.increment();
        requiere(_tokenCounter.current() <= n_fractions);
        _tokenFractionId = _tokenCounter.current();
        _safeMint(to, _tokenFractionId);
    }

    event Rented(
        uint256 indexed _tokenFractionId,
        address indexed _lord,
        address indexed _renter,
        uint256 expiresAt
    );

    event FinishRent(
        uint256 indexed _tokenFractionId,
        address indexed _lord,
        address indexed _renter,
        uint256 expiresAt
    );

    function rentOut(
        uint256 tokenId,
        address renter,
        uint256 expiresAt,
        uint256 ammount) external {
            require(_rentable == true);
            require(block.timestamp < block.timestamp + expiresAt);
            require(ammount >= _value);
            require(msg.sender.balance > ammount);
            
            _rentalAddress[tokenId] = renter;      
    }

    function getRenter(uint256 tokenId) public view onlyOwner returns(address){
        return _rentalAddress[tokenId];
    }
}

contract FNFT is ERC721, Ownable {
    uint256 _tokenCounter;
    mapping(uint256 => address) FntfAddress;

    constructor() ERC721("Fractional Token", "FNFT") {}

    function mint(address wallet_to, uint256 n_fractions) public onlyOwner {
        _tokenCounter++;
        _mint(address(this), _tokenCounter);

        FntfAddress[_tokenCounter] = address(
            new TokenFraction(
                "Fractionalized Token from NFT",
                string(abi.encodePacked("FTOK", _tokenCounter)),
                //`FTOK${_tokenCounter}`,
                wallet_to,
                n_fractions
            )
        );
    }

    function getFractionAddress(uint256 tokenId) public view returns(address) {
        return(FntfAddress[tokenId]);
    }
}