const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  let accountBalance = await deployer.getBalance();

  console.log("Deploying contract with account: ", deployer.address);
  console.log("Account balance: ", accountBalance.toString());

  const joinSpaceContractFactory = await hre.ethers.getContractFactory(
    "JoinSpace"
  );
  const joinSpaceContract = await joinSpaceContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.001"),
  });

  await joinSpaceContract.deployed();
  accountBalance = await deployer.getBalance();
  console.log(
    "Account balance after deployment, just to demo that we fund our smart contract from our own wallet: ",
    accountBalance.toString()
  );

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
