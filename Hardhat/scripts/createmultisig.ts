import { ethers } from "hardhat";

async function main() {
  const [Admin1, spender] = await ethers.getSigners();

  const Owners = [Admin1.address];

  console.log("this", Admin1.address);

  let amount = ethers.parseEther("0.001");

  const multisigfactory = await ethers.deployContract("MultiSigFactory", []);

  await multisigfactory.waitForDeployment();

  console.log(`Multisig deployed to ${multisigfactory.target}`);

  let receipt = await multisigfactory.createMultiSig(Owners, {
    value: ethers.parseEther("200"),
  });

  console.log((await receipt.wait())?.logs[0].args[0]);

  let newMultiSig = (await receipt.wait())?.logs[0].args[0];
  let multiSigContract = await ethers.getContractAt("IMultisig", newMultiSig);

  await multiSigContract.createTransaction(amount, spender.address);
  console.log(await multiSigContract.getTransaction(1));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
