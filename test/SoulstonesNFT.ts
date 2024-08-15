import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { makeMerkleTree } from "../utils/merkletree";
import { makeUsers } from "../utils/data";

describe("SoulstonesNFT Testing", function () {
  async function deployOneYearLockFixture() {
    const users = await makeUsers();
    const merkleTreeData = await makeMerkleTree();
    const { root } = merkleTreeData;

    const SoulstonesNFT = await ethers.getContractFactory("Soulstones");
    const soulstonesNFT = await SoulstonesNFT.deploy(root);

    await soulstonesNFT.toggleSale("2"); // enum 2 = LIVE

    return { soulstonesNFT, merkleTreeData, users };
  }

  describe("Deployment", function () {
    it("Should return correct name and symbol", async function () {
      const { soulstonesNFT } = await loadFixture(deployOneYearLockFixture);

      expect(await soulstonesNFT.name()).to.equal("Soulstones");
      expect(await soulstonesNFT.symbol()).to.equal("STONE");
    });
  });

  describe("Minting", function () {
    it("Should allow whitelisted users to mint", async function () {
      const { soulstonesNFT, merkleTreeData, users } = await loadFixture(deployOneYearLockFixture);

      await soulstonesNFT.connect(users.alice).mint(merkleTreeData.proofs[1], { value: ethers.parseEther("0.01") });
      const aliceBalance = await soulstonesNFT.balanceOf(await users.alice.getAddress());
      expect(aliceBalance).to.equal(1);

      await soulstonesNFT.connect(users.bob).mint(merkleTreeData.proofs[2], { value: ethers.parseEther("0.01") });
      const bobBalance = await soulstonesNFT.balanceOf(await users.bob.getAddress());
      expect(bobBalance).to.equal(1);
    });

    it("Should revert when non-whitelisted users try to mint", async function () {
      const { soulstonesNFT, merkleTreeData, users } = await loadFixture(deployOneYearLockFixture);

      try {
        await soulstonesNFT.connect(users.david).mint(merkleTreeData.proofs[3], { value: ethers.parseEther("0.01") });
      } catch (error: any) {
        expect(error.message).to.contains("You're not allowed here");
      }
    });

    it.only("Sale should move to done when minted out", async function () {
      const { soulstonesNFT, merkleTreeData, users } = await loadFixture(deployOneYearLockFixture);

      // Perform presale
      await soulstonesNFT.toggleSale("1");
      await soulstonesNFT.presaleMint(8);
      const presaleBalance = await soulstonesNFT.balanceOf(await users.owner.getAddress());
      expect(presaleBalance).to.equal(8);

      // Activate main sale
      await soulstonesNFT.toggleSale("2");

      await soulstonesNFT.connect(users.alice).mint(merkleTreeData.proofs[1], { value: ethers.parseEther("0.01") });
      const aliceBalance = await soulstonesNFT.balanceOf(await users.alice.getAddress());
      expect(aliceBalance).to.equal(1);

      await soulstonesNFT.connect(users.bob).mint(merkleTreeData.proofs[2], { value: ethers.parseEther("0.01") });
      const bobBalance = await soulstonesNFT.balanceOf(await users.bob.getAddress());
      expect(bobBalance).to.equal(1);

      const total = await soulstonesNFT.tokenSupply();
      expect(total).to.equal(10);

      expect(await soulstonesNFT.saleState()).to.equal("4");
    });
  });
});
