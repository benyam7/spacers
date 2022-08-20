// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Schemas.sol";

contract JoinSpace {
    uint256 totalSpacers;
    mapping(string => uint256) countryToSpacerCount;
    mapping(address => bool) hasAlreadyWonPrize;
    mapping(address => bool) hasAlreadyParticipated;
    Spacer[] spacers;

    modifier checkIfAlreadyWonPrize() {
        require(
            hasAlreadyWonPrize[msg.sender],
            "You have already won a prize. You cannot take more!"
        );
        _;
    }

    modifier checkIfAlreadyParticipated() {
        require(
            hasAlreadyParticipated[msg.sender],
            "You have already participated!"
        );
        _;
    }

    constructor() {
        console.log("Welcome to the world of spacers!");
    }

    // related with user joinin comunity of spacers for firstime
    function joinSpace(Spacer memory _spacer) public {
        spacers.push(_spacer);
        totalSpacers += 1;
        updateCountryToSpacers(_spacer.countryEmoji);

        console.log("%s has joined the space! ", _spacer.id);
        console.log("We have reached %d spacers", totalSpacers);
    }

    function getTotalSpacers() public view returns (uint256) {
        console.log("We have %d total spacers!", totalSpacers);
        return totalSpacers;
    }

    function updateCountryToSpacers(string memory _country) private {
        countryToSpacerCount[_country] += 1;
    }

    // related wit sending spacer prize (below)
    function getNFTIPFSLink() public returns (string memory) {
        // return url of IPFS for associated NFT
        console.log("some ipfs url for NFT won");
        return "some ipfs url";
    }

    function sendWinnerNFT(address _id) private {
        // send user NFT if won
        console.log("Sendin user %s NFT...", _id);
    }

    function sendWinnerToken(address _id) private {
        // send user ETH if won
        console.log("sending user %s eth", _id);
    }

    // related wit choosing a winner (and below)
    function random() private view returns (uint) {
        // sha3 and now have been deprecated
        return
            uint(
                keccak256(abi.encodePacked(block.difficulty, block.timestamp))
            );
        // convert hash to integer
    }

    function decidePrizeType() private view returns (string memory) {
        // randomly decide user to win NFT or Token in (ETH)
        uint256 value = random() % 100;
        if (value == 7) {
            return "WinType.NFT"; // i am tryin to make NFTs a scares, so there will be a higher demand. I think it makes sense.
        } else {
            return "WinType.ETH";
        }
    }

    function getARandomWinner()
        private
        checkIfAlreadyParticipated
        checkIfAlreadyWonPrize
    {
        if (spacers.length < 100) {
            // don't pick random value unless there are 100 participants.
            return;
        }
        Spacer memory winner;
        // todo get the random winner (change the logic as well :D) maybe use chainlinks VRF (which is off-chain). you shouldn't generate random
        // logic inside your smartcontract, bcz it's deterministic
        uint256 winner_index = random() % spacers.length;
        winner = spacers[winner_index];
        if (compareStrings(decidePrizeType(), "WinType.ETH")) {
            sendWinnerToken(winner.id);
        } else {
            sendWinnerNFT(winner.id);
        }
    }

    function updateHasAlreadyParticipated(address _id) private {
        hasAlreadyParticipated[_id] = true;
    }

    function updateHasAlreadyWon(address _id) private {
        hasAlreadyWonPrize[_id] = true;
    }

    function compareStrings(string memory a, string memory b)
        private
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }
}
