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
    WinStatus status;
    WinType winType;
}
