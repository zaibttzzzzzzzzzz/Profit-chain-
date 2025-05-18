const hre = require("hardhat");

async function main() {
  const ProfitChain = await hre.ethers.getContractFactory("ProfitChain");
  const profitChain = await ProfitChain.deploy();

  await profitChain.deployed();
  console.log("Contract deployed to:", profitChain.address); // Polygon Address yahan ayega
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
