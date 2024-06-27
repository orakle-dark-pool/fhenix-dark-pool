import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import chalk from "chalk";

const hre = require("hardhat");

const func: DeployFunction = async function () {
  const { fhenixjs, ethers } = hre;
  const { deploy } = hre.deployments;
  const [signer] = await ethers.getSigners();

  // print signer address
  console.log(`Deploying from ${signer.address}`);

  if ((await ethers.provider.getBalance(signer.address)).toString() === "0") {
    if (hre.network.name === "localfhenix") {
      await fhenixjs.getFunds(signer.address);
    } else {
      console.log(
        chalk.red(
          "Please fund your account with testnet FHE from https://faucet.fhenix.zone",
        ),
      );
      return;
    }
  }

  // deploy FugaziDiamond contract
  // Changed from "Counter" to "FugaziDiamond"
  const fugaziDiamond = await deploy("FugaziDiamond", {
    // Change 1
    from: signer.address,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  // Changed logging message to reflect the new contract name
  console.log(`FugaziDiamond contract: `, fugaziDiamond.address); // Change 2
};

export default func;
// Changed func.id from "deploy_counter" to "deploy_fugaziDiamond"
func.id = "deploy_fugaziDiamond"; // Change 3
// Changed func.tags from ["Counter"] to ["FugaziDiamond"]
func.tags = ["FugaziDiamond"]; // Change 4
