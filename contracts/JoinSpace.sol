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

    //  RELATED with user joinin comunity of spacers for firstime
    function joinSpace(Spacer memory _spacer) public {
        spacers.push(_spacer);
        totalSpacers += 1;
        updateCountryToSpacers(_spacer.countryEmoji);
        console.log(
            "%s has joined the space! reacted with emoji: %s from %s.",
            _spacer.id,
            _spacer.feelingEmoji,
            _spacer.countryEmoji
        );
        console.log(
            "Btw, here is your status of wining NFT or ETH is ===> %s, and your win type is ===> %s",
            getWinStatusString(_spacer.status),
            getWinTypeString(_spacer.winType)
        );
    }

    function getTotalSpacers() public view returns (uint256) {
        console.log("We have %d total spacers!", totalSpacers);
        return totalSpacers;
    }

    function updateCountryToSpacers(string memory _country) private {
        countryToSpacerCount[_country] += 1;
    }

    // RELATED: wit sending spacer prize (below)
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
        // send user ETH token if won
        console.log("sending user %s eth", _id);
    }

    // RELATED wit choosing a winner (and below)
    function random() private view returns (uint) {
        // sha3 and now have been deprecated
        return
            uint(
                keccak256(abi.encodePacked(block.difficulty, block.timestamp))
            );
        // convert hash to integer
    }

    function decidePrizeType() private view returns (WinType) {
        // randomly decide user to win NFT or Token in (ETH)
        uint256 value = random() % 100;
        if (value == 7) {
            return WinType.NFT; // i am tryin to make NFTs a scares, so there will be a higher demand. I think it makes sense.
        } else {
            return WinType.ETH;
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
        if (decidePrizeType() == WinType.ETH) {
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

    // TODO: find better way to do this
    function getWinTypeString(
        WinType _winType // it's not view bcz it is not readin from blockchain
    ) private pure returns (string memory) {
        if (_winType == WinType.NFT) {
            return "NFT";
        } else if (_winType == WinType.ETH) {
            return "ETH";
        } else {
            return "Not determined!";
        }
    }

    function getWinStatusString(
        WinStatus _winStatus // it's not view bcz it is not readin from blockchain
    ) private pure returns (string memory) {
        if (_winStatus == WinStatus.PENDING) {
            return "PENDING";
        } else if (_winStatus == WinStatus.WON) {
            return "WON";
        } else {
            return "LOST";
        }
    }
}
