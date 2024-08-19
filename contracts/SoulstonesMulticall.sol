// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Soulstones.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";

contract SoulstonesMulticall {
    Soulstones soulstones;

    constructor(Soulstones _soulstones) {
        soulstones = _soulstones;
    }

    struct TransferObject {
        uint256 tokenId;
        address recipient;
    }

    function multicallTransfer(TransferObject[] calldata transfers) public {
        for (uint256 i; i < transfers.length; i++) {
            soulstones.safeTransferFrom(msg.sender, transfers[i].recipient, transfers[i].tokenId);
        }
    }
}
