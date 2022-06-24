// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevsNFT.sol";

contract CryptoDevToken is ERC20, Ownable {
    ICryptoDevsNFT cryptoDev;
    // have to cenvert to a big number because mint function takes a big number
    uint public constant tokenPerNFT = 10 * 10**18;

    uint public constant tokenPrice = 0.001 ether;
    uint public constant maxTotalSupply = 10000 * 10**18;

    mapping(uint => bool) public tokenIdClaimed;

    constructor(address _cryptoDevNFTAddress) ERC20("CryptoDevToken", "LWCD") {
        cryptoDev = ICryptoDevsNFT(_cryptoDevNFTAddress);
    }

    function mint(uint _amount) public payable {
        uint requiredAmount = _amount * tokenPrice;
        require(msg.value >= requiredAmount, "Less ether sent ");
        // have to cenvert to a big number because mint function takes a big number
        uint amountWithDecimal = _amount * 10**18;
        require(
            totalSupply() + amountWithDecimal <= maxTotalSupply,
            "Exceeds the max total supply available"
        );
        _mint(msg.sender, amountWithDecimal);
    }

    function claim() public {
        address sender = msg.sender;
        uint balance = cryptoDev.balanceOf(sender);
        require(balance > 0, "You dont own enough NFT");

        uint amount = 0;
        //running a foor loop since we need to use toeknOfOwnerByIndex
        for (uint i = 0; i < balance; i++) {
            // get the toekn id minted by the prev nft using the built in function in erc721
            uint tokenId = cryptoDev.tokenOfOwnerByIndex(sender, i);
            if (!tokenIdClaimed[tokenId]) {
                amount += 1;
                tokenIdClaimed[tokenId] = true;
            }
        }

        require(amount > 0, "You have already claimed your tokens");
        _mint(msg.sender, amount * tokenPerNFT);
    }

    function withdraw() external onlyOwner {
        address _owner = owner();
        uint _amount = address(this).balance;
        (bool success, ) = _owner.call{value: _amount}("");
        require(success, "Failed to transfer ether");
    }

    receive() external payable {}

    fallback() external payable {}
}
