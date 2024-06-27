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

  // deploy FugaziAccountFacet contract
  const fugaziAccountFacet = await deploy("FugaziAccountFacet", {
    from: signer.address,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });
  console.log(`FugaziAccountFacet contract: `, fugaziAccountFacet.address);

  // deploy FugaziPoolRegistryFacet contract
  const fugaziPoolRegistryFacet = await deploy("FugaziPoolRegistryFacet", {
    from: signer.address,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });
  console.log(
    `FugaziPoolRegistryFacet contract: `,
    fugaziPoolRegistryFacet.address,
  );

  // deploy FugaziPoolActionFacet contract
  const fugaziPoolActionFacet = await deploy("FugaziPoolActionFacet", {
    from: signer.address,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });
  console.log(
    `FugaziPoolActionFacet contract: `,
    fugaziPoolActionFacet.address,
  );

  // deploy FugaziViewerFacet contract
  const fugaziViewerFacet = await deploy("FugaziViewerFacet", {
    from: signer.address,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });
  console.log(`FugaziViewerFacet contract: `, fugaziViewerFacet.address);
};

export default func;
func.id = "deploy_fugazi_facets";
func.tags = ["FugaziFacets"];
