// SPDX-License-Identifier: MIT

// Only allow compiler versions from 0.7.0 to (not including) 0.9.0
pragma solidity >=0.7.0 <0.9.0;

contract Barbershop {

    // State variables
    address public owner;
    bool shopIsOpen;
    mapping (address => uint) buzzStock;
    mapping (address => uint) lineupStock;
    mapping (address => uint) fadeStock;
    mapping (address => uint) fadeandtrimStock;
    mapping (address => uint) scissor;

    // On creation...
    constructor () {
        // Set the owner as the contract's deployer
        owner = msg.sender;

        // How much each haircut costs
        buzzStock[address(this)]  = 1000;
        lineupStock[address(this)]   = 1000;
        fadeStock[address(this)]  = 1000;
        fadeandtrimStock[address(this)] = 1000;
        scissor[address(this)]    = 0;

        // The shop is initially closed
        shopIsOpen = true;
    }

    // Function to compare two strings
    function compareStrings(string memory a, string memory b) private pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked(b)));
    }

    // Let the owner restock the shop
    function restock(uint amount, string memory haircutType) public {
        // Only the owner can restock!
        require(msg.sender == owner, "Only the owner can restock the machine!");

        // Refill the stock based on the type passed in
        if (compareStrings(haircutType, "buzz")) {
            buzzStock[address(this)] += amount;
        } else if (compareStrings(haircutType, "lineup")) {
            lineupStock[address(this)] += amount;
        } else if (compareStrings(haircutType, "fade")) {
            fadeStock[address(this)] += amount;
        } else if (compareStrings(haircutType, "fadeandtrim")) {
            fadeandtrimStock[address(this)] += amount;
        } else if (compareStrings(haircutType, "all")) {
            buzzStock[address(this)] += amount;
            lineupStock[address(this)] += amount;
            fadeStock[address(this)] += amount;
            fadeandtrimStock[address(this)] += amount;
        }
    }

    // Let the owner open and close the shop
    function openOrCloseShop() public returns (string memory) {
        if (shopIsOpen) {
            shopIsOpen = false;
            return "Shop is now closed.";
        } else {
            shopIsOpen = true;
            return "Shop is now open.";
        }
    }

    // Request a haircut
    function purchase(uint amount, string memory haircutType) public payable {
        require(shopIsOpen == true, "The shop is closed and you may not buy flowers.");
        require(msg.value >= amount * 1 ether, "You must pay at least 1 ETH per flower arrangement!");

        // Sell a flower arrangement based on type asked
        if (compareStrings(haircutType, "buzz")) {
            buzzStock[address(this)] -= amount;
            buzzStock[msg.sender] += amount;
        } else if (compareStrings(flowerType, "lineup")) {
            lineupStock[address(this)] -= amount;
            lineupStock[msg.sender] += amount;
        } else if (compareStrings(flowerType, "fade")) {
            fadedStock[address(this)] -= amount;
            fadeStock[msg.sender] += amount;
        } else if (compareStrings(flowerType, "fadeandtrim")) {
            fadeandtrimStock[address(this)] -= amount;
            fadedandtrimStock[msg.sender] += amount;
        } else if (compareStrings(flowerType, "scissor")) {
            buzzStock[address(this)] -= amount;
            lineupStock[address(this)] -= amount;
            fadeStock[address(this)] -= amount;
            fadeandtrimStock[address(this)] -= amount;

            scissor[msg.sender] += amount;
        }
    }

    // See how many haircut options there is
    function getStock(string memory haircutType) public view returns (uint) {
        // How many haircut options there are
        if (compareStrings(haircutType, "buzz")) {
            return tulipStock[address(this)];
        } else if (compareStrings(haircutType, "lineup")) {
            return roseStock[address(this)];
        } else if (compareStrings(haircutType, "fade")) {
            return peonyStock[address(this)];
        } else if (compareStrings(haircutType, "fadeandtrim")) {
            return orchidStock[address(this)];
        } else {
            return 0;
        }
    }
}
