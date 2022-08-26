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

    uint256 private seed;

    event NewSpacer(address indexed id, uint256 timestamp, string countryEmoji);
    event NewWinner(address indexed id);
    modifier checkIfAlreadyWonPrize() {
        require(
            hasAlreadyWonPrize[msg.sender],
            "You have already won a prize. You cannot take more!"
        );
        _;
    }

    modifier checkIfAlreadyParticipated(address id) {
        console.log("checking participation %s", id);
        console.log(hasAlreadyParticipated[id]);
        require(
            !hasAlreadyParticipated[id],
            "You have already participated! You cannot spam the system!"
        );
        _;
    }

    constructor() payable {
        // set initial seed
        seed = (block.timestamp + block.difficulty) % 100;
        console.log("Welcome to the world of spacers!");
    }

    //  RELATED with user joinin comunity of spacers for firstime
    function joinSpace(Spacer memory _spacer)
        public
        checkIfAlreadyParticipated(_spacer.id)
    {
        spacers.push(_spacer);
        totalSpacers += 1;
        updateCountryToSpacers(_spacer.countryEmoji);
        emit NewSpacer(_spacer.id, block.timestamp, _spacer.countryEmoji);
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
        // block.difficulty tells miners how hard the block will be to mine based on the transactions in the block.
        // blocks get harder for number of reasons, but mainly they get arader when there are more transactions in the block(some miners
        // preffer easier blocks, but, these payout less)

        // block.timestamp: is just the unix timestamp that the block is being processed.
        //  block.timestamp and block.difficulty are pretty random but they could be controlled by a sophiscated attacer.
        // to add difficulty on this we're changing `seed` whenever new spacers joins the club. And we're combining the previous `seed`,
        // difficulty and timestamp. (attacker could technically game this system, if they really wanted to. it's just hard.hi)
        // generate a new seed for the next user that joins the space
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random number jenerated: %d", seed);
        updateHasAlreadyParticipated(_spacer.id);
        // if 2% chance that user wins prize
        if (seed < 2) {
            console.log("%s won!", _spacer.id);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Bro your contract has less than prize value :D"
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract");
            emit NewWinner(_spacer.id);
            updateHasAlreadyParticipated(_spacer.id);
        }
    }

    function getTotalSpacers() public view returns (uint256) {
        console.log("We have %d total spacers!", totalSpacers);
        return totalSpacers;
    }

    function getSpacersArray() public view returns (Spacer[] memory) {
        return spacers;
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
        // checkIfAlreadyParticipated
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
