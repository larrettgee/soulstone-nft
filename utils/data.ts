import { ethers } from "hardhat";
import { Inputs, Usernames, Users } from "./interfaces";

export const usernames: Usernames = ["owner", "alice", "bob", "carol", "david"];

export const makeUsers = async (): Promise<Users> => {
  const signers = await ethers.getSigners();
  return usernames.reduce((acc: Users, name: string, index: any) => {
    return {
      ...acc,
      [name]: signers[index],
    };
  }, {} as Users);
};

export const makeInputs = async (usernames: string[]): Promise<string[]> => {
  const signers = await ethers.getSigners();

  return usernames
    .filter((name: string) => !["owner", "david"].includes(name))
    .map((name) => {
      const signerIndex = usernames.indexOf(name);
      return signers[signerIndex].address;
    });
};
