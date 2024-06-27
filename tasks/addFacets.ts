import { task } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";

task("addFacets", "Adds facets and selectors to the FugaziDiamond contract")
  .addParam("diamondAddress", "The address of the FugaziDiamond contract")
  .setAction(async (taskArgs, hre: HardhatRuntimeEnvironment) => {
    const { diamondAddress } = taskArgs;
    const { ethers } = hre;
    const [signer] = await ethers.getSigners();

    const fugaziDiamondAbi = [
      "function addFacet((address facet, bytes4 selector)[] memory _facetAndSelectors) external",
    ];

    const fugaziDiamond = new ethers.Contract(
      diamondAddress,
      fugaziDiamondAbi,
      signer,
    );

    const facetsAndSelectors = [
      {
        facet: "0xff41f7aD0380D2F39158940dE4f32ED73421937A",
        selectors: ["a6462d0a", "e94af36e"],
      },
      {
        facet: "0xbc64a453F54E40AaFEC04e83D8419610C608c2F2",
        selectors: ["46727639", "2ef61c21"],
      },
    ];

    const facetAndSelectorsArray = facetsAndSelectors.flatMap(
      ({ facet, selectors }) =>
        selectors.map((selector) => ({
          facet,
          selector: `0x${selector}`,
        })),
    );

    const tx = await fugaziDiamond.addFacet(facetAndSelectorsArray);
    await tx.wait();

    console.log("Facets and selectors added successfully!");
  });

export default {};
