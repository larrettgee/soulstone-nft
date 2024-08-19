// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";

contract SoulstonesBitMap is ERC721, Ownable {
    bytes32 public rootHash;
    SaleState public saleState;
    uint256 public tokenSupply = 0;
    uint256 private immutable TOKEN_LIMIT = 10;
    BitMaps.BitMap private _bitmap;

    enum SaleState {
        INACTIVE,
        PRESALE,
        LIVE,
        PAUSED,
        DONE
    }

    constructor(bytes32 _rootHash) ERC721("Soulstones", "STONE") Ownable(msg.sender) {
        rootHash = _rootHash;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://api.soulstone.io/nft/";
    }

    function toggleSale(SaleState _saleState) public onlyOwner {
        require(saleState != SaleState.DONE, "Sale is finished, can't change now.");
        saleState = _saleState;
    }

    // Minting function for owner
    function presaleMint(uint256 _amount) public validPresaleMint onlyOwner {
        for (uint256 i; i < _amount; ) {
            _safeMint(msg.sender, tokenSupply++);
            i++;
        }
    }

    //Minting Function for Public
    function mint(bytes32[] calldata proof) public payable validMint {
        require(checkIsWhitelisted(proof), "You're not allowed here.");

        if (tokenSupply + 1 == TOKEN_LIMIT) {
            saleState = SaleState.DONE;
        }
        BitMaps.set(_bitmap, uint160(msg.sender));
        _safeMint(msg.sender, tokenSupply++);
    }

    function checkIsWhitelisted(bytes32[] calldata proof) private view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        return MerkleProof.verify(proof, rootHash, leaf);
    }

    function withdraw(address[] calldata _to, uint256[] calldata _amounts) public onlyOwner {
        for (uint256 i; i < _amounts.length; i++) {
            (bool sent, ) = _to[i].call{value: _amounts[i]}("");
            require(sent, "Failed to send Ether");
        }
    }

    /*
        Useful Modifiers
    */

    modifier validMint() {
        require(!BitMaps.get(_bitmap, uint160(msg.sender)), "Sorry, bud. You already minted!");
        require(tokenSupply < TOKEN_LIMIT, "Over the limit!");
        require(saleState == SaleState.LIVE, "Sale is not active");
        require(msg.value == 0.01 ether, "Are you poor?");
        _;
    }

    modifier validPresaleMint() {
        require(saleState == SaleState.PRESALE, "Sale is not active");
        _;
    }
}
