const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const accountBalance = await deployer.getBalance();

  console.log("Deploying contract with account: ", deployer.address);
  console.log("Account balance: ", accountBalance.toString());

  const joinSpaceContractFactory = await hre.ethers.getContractFactory(
    "JoinSpace"
  );
  const joinSpaceContract = await joinSpaceContractFactory.deploy();
  await joinSpaceContract.deployed();

  console.log("JoinSpace adddress: ", joinSpaceContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
