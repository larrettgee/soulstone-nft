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

    function multicallGeneral(bytes32[] calldata data) external virtual returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            results[i] = Address.functionDelegateCall(address(this), bytes.concat(data[i]));
        }
        return results;
    }
}
