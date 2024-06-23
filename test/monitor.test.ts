import { ethers } from "hardhat";
import { expect } from "chai";

describe("MyContract", function () {
    it("should return the correct value", async function () {
        const MyContract = await ethers.getContractFactory("Monitor");
        const myContract = await MyContract.deploy();


        // Perform some actions on the contract and assert the expected results
        const result = await myContract.myFunction();
        expect(result).to.equal("Expected Value");
    });
});