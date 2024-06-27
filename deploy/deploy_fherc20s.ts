import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import chalk from "chalk";

const hre = require("hardhat");

const func: DeployFunction = async function () {
  const { fhenixjs, ethers } = hre;
  const { deploy } = hre.deployments;
  const [signer] = await ethers.getSigners();

  const name = "Name"; // Replace with your token name
  const symbol = "SYM"; // Replace with your token symbol

  console.log(`Deploying FHERC20 with name: ${name} and symbol: ${symbol}`);

  const fherc20 = await deploy("FHERC20", {
    from: signer.address,
    args: [name, symbol],
    log: true,
  });

  console.log(`FHERC20 deployed at address: ${fherc20.address}`);
};

export default func;
func.id = "deploy_fherc20s";
func.tags = ["FHERC20"];
