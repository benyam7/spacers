// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

enum WinStatus {
    PENDING,
    LOST,
    WON
}
enum WinType {
    ETH,
    NFT,
    NOT_DETERMINED
}
struct NFT {
    string urlIPFS;
    Spacer spacer;
}
struct ETH {
    uint256 amount;
    uint8 decimals;
}

struct Spacer {
    address id;
    string feelingEmoji;
    string countryEmoji;
    string date; // Thur, Aug 08, 2022 at 2:00 PM UTC
    string status; // TODO: till i resolve the issue of callin it in hardhat
    string winType;
}